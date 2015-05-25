//
//  HomeViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/19.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <SWRevealViewController/SWRevealViewController.h>
#import <Geo-Utilities/CLLocation+Navigation.h>

#import "HomeViewController.h"
#import "CircleMarker.h"
#import "HotSpotListViewController.h"
#import "WarningView.h"
#import "HotSpotDetailView.h"
#import "AnimatedGMSMarker.h"

#import "DBReasonAdapter.h"
#import "DBLocationAdapter.h"
#import "DateUtility.h"

#import "MarkerManager.h"
#import "DBManager.h"
#import "AppSettingManager.h"
#import "AppLocationManager.h"

static CGFloat kWarningViewHeightProportion = 0.3;
static CGFloat kHotSpotDetailViewHeightProportion = 0.3;
static CGFloat kHotSpotZoonRadius = 300.0;

@interface HomeViewController ()
<
    SWRevealViewControllerDelegate,
    CLLocationManagerDelegate,
    HotSpotListViewControllerMapDelegate,
    GMSMapViewDelegate
>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hotspotListButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@property (strong, nonatomic) CircleMarker* locationMarker;
@property (strong, nonatomic) MarkerManager* markerManager;

@property (copy, nonatomic)   CLLocation *recentLocation;
@property (strong, nonatomic) CLLocation* defaultLocation;
@property (assign, nonatomic) CLLocationDirection direction;

@property (assign, nonatomic) BOOL locationDidEverUpdate;

@property (strong, nonatomic) DBLocationAdapter* locationAdapter;

// Indicating that user is in navigating mode or not.
//
// On:
//  1) Default user is in
//  2) Whatever the mode is, when user is approaching a hotspot, go into navigating mode
//  3) User hide the hotspot detail view manually.
//
// Off:
//  1) Gesture on map detected, e.g., pan, pinch which indicate that user want to view the map.
//  2) User click on one of the hotspots listed on the left side view and hotspot detail view popup.

@property (assign, nonatomic) BOOL isNavigating;

@property (strong, nonatomic) WarningView *warningView;
@property (strong, nonatomic) HotSpotDetailView* hotSpotDetailView;

// Speech
@property (strong, nonatomic) AVSpeechSynthesizer* avSpeechSynthesizer;
@property (strong, nonatomic) AVSpeechSynthesisVoice* avSpeechSynthesisVoice;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize views
    [self setupNavigationBar];
    [self setupSideBarMenu];
    [self setupMap];
    [self setupWarning];
    [self setupHotSpotDetail];
    [self setupAV];
    
    // Initialize DB adapter and set delegate
    self.locationAdapter = [[DBLocationAdapter alloc] init];
    [[AppLocationManager sharedInstance] setDelegate:self];
    
    // Set default mode
    [self setNavigationMode:YES];
}

- (void)setupWarning
{
    self.warningView = [[[NSBundle mainBundle] loadNibNamed:@"WarningView" owner:self options:nil] firstObject];
    [self.view addSubview:self.warningView ];
    
    self.warningView.frame = CGRectMake(self.view.frame.origin.x,
                                        self.view.frame.origin.y + self.navigationController.navigationBar.frame.size.height,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height * kWarningViewHeightProportion);
    
    self.warningView.hidden = YES;
}

- (void)setupHotSpotDetail
{
    self.hotSpotDetailView = [[[NSBundle mainBundle] loadNibNamed:@"HotSpotDetailView" owner:self options:nil] firstObject];
    [self.view addSubview:self.hotSpotDetailView];
    
    self.hotSpotDetailView.frame = CGRectMake(self.view.frame.origin.x,
                                              self.view.frame.origin.y + self.view.frame.size.height * (1- kHotSpotDetailViewHeightProportion),
                                              self.view.frame.size.width,
                                              self.view.frame.size.height * kHotSpotDetailViewHeightProportion);
    
    self.hotSpotDetailView.hidden = YES;
}

- (void)setupMap
{
    self.locationDidEverUpdate = NO;
    
    // Set default location to Edmonton
    self.defaultLocation = [[CLLocation alloc] initWithLatitude:53.5501400  longitude:-113.4687100];
    self.recentLocation = [self.defaultLocation copy];
    
    // Show default location on map
    self.mapView.camera = [GMSCameraPosition cameraWithLatitude:self.defaultLocation.coordinate.latitude
                                                      longitude:self.defaultLocation.coordinate.longitude
                                                           zoom:12.0];
    
    // Draw marker on map to represent all hotspots except shool zones
    self.markerManager = [[MarkerManager alloc] init];
    [self.markerManager drawMarkers:self.mapView];
    
    // Set up GPSMapViewDelegate
    self.mapView.delegate = self;
    
    // Enable locate me
    self.mapView.myLocationEnabled = YES;
}

- (void) setupNavigationBar
{
    //setup navigation
    UIImage* image = [UIImage imageNamed:@"smartTravel"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = imageView;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void) setupSideBarMenu
{
    if (self.revealViewController != nil) {
        self.hotspotListButton.target = self.revealViewController;
        self.hotspotListButton.action = @selector(revealToggle:);
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        self.settingsButton.target = self.revealViewController;
        self.settingsButton.action = @selector(rightRevealToggle:);
        
        self.revealViewController.rearViewRevealWidth = 300;
        self.revealViewController.rightViewRevealWidth = 300;
        
        self.revealViewController.delegate = self;
    }
}

- (void)setNavigationMode:(BOOL)on
{
    if (on)
    {
        self.isNavigating = YES;
        self.warningView.hidden = !self.locationDidEverUpdate;
    }
    else
    {
        self.isNavigating = NO;
        self.warningView.hidden = YES;
    }
}

- (void)setupAV
{
    self.avSpeechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    self.avSpeechSynthesisVoice = [AVSpeechSynthesisVoice voiceWithLanguage:nil];
}

#pragma mark - Button Action

- (IBAction)zoomIn:(id)sender
{
    GMSCameraUpdate *zoomIn = [GMSCameraUpdate zoomIn];
    [self.mapView animateWithCameraUpdate:zoomIn];
}

- (IBAction)zoomOut:(id)sender
{
    GMSCameraUpdate *zoomOut = [GMSCameraUpdate zoomOut];
    [self.mapView animateWithCameraUpdate:zoomOut];
}

- (IBAction)locateMe:(id)sender
{
    if (self.mapView.myLocation)
    {
        [self.mapView animateToLocation:self.mapView.myLocation.coordinate];
    }
    else
    {
        [self.mapView animateToLocation:self.defaultLocation.coordinate];
    }
    self.isNavigating = YES;
}

#pragma mark - SWRevealViewController Delegate
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position != FrontViewPositionLeft) {
        self.mapView.userInteractionEnabled = NO;
        
        HotSpotListViewController* hotSpotListVC = (HotSpotListViewController*)revealController.rearViewController;
        if (hotSpotListVC)
        {
            hotSpotListVC.mapDelegate = self;
        }
    }
    else {
        self.mapView.userInteractionEnabled = YES;
        
        HotSpotListViewController* hotSpotListVC = (HotSpotListViewController*)revealController.rearViewController;
        if (hotSpotListVC)
        {
            hotSpotListVC.mapDelegate = nil;
        }
    }
}

#pragma mark - Location Manager Delegate

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [[AppLocationManager sharedInstance] startUpdatingHeading];
        [[AppLocationManager sharedInstance] startUpdatingLocation];
    }
}

- (void)didApproachHotSpot:(NSDictionary *)hotSpot
{
    static NSDate* lastReportDate = nil;
    
    NSString* locCode = [hotSpot objectForKey:@"Loc_code"];
    
    // Determine if we should report. The period should be longer than 10s
    NSDate* now = [NSDate date];
    BOOL shouldReport = NO;
    if (lastReportDate)
    {
        NSTimeInterval secondsInterval= [now timeIntervalSinceDate:lastReportDate];
        if (secondsInterval > 10)
        {
            shouldReport = YES;
        }
    }
    else
    {
        shouldReport = YES;
    }
    
    // Dont' repeat the warning in short time
    if (shouldReport)
    {
        NSString* locationName = [[NSString alloc] init];
        int reasonId = 0;
        int total = 0;
        int warningPriority = 0;
        if ([self.locationAdapter getLocationName:&locationName
                                         reasonId:&reasonId
                                            total:&total
                                  warningPriority:&warningPriority
                                        ofLocCode:locCode])
        {
            [self.warningView updateLocation:locationName
                                        rank:[NSNumber numberWithInt:warningPriority]
                                       count:[NSNumber numberWithInt:total]
                                    distance:nil];
            
            // Speak out the warning message
            if ([[AppSettingManager sharedInstance] getIsWarningVoice])
            {
                NSString* warningMessage = [[[DBReasonAdapter alloc] init] getWarningMessage:reasonId];
                AVSpeechUtterance* utterance = [[AVSpeechUtterance alloc] initWithString:warningMessage];
                utterance.rate *= 0.5;
                [self.avSpeechSynthesizer speakUtterance:utterance];
                
                // Breath the marker
                [self.markerManager breathingMarker:locCode];
            }
            
            // Remember last report date
            lastReportDate = [now copy];
        }
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.locationDidEverUpdate = YES;
    
    CLLocation* lastLocation = self.recentLocation;
    self.recentLocation = locations.lastObject;
    self.direction = [lastLocation kv_bearingOnRhumbLineToCoordinate:self.recentLocation.coordinate];
    
    // Check if satisfy warning pop up conditions
    LocationDirection* locationDirection = [[LocationDirection alloc] initWithCLLocationDirection:self.direction];
    Direction direction = locationDirection.direction;
    
    // Get warning data list
    NSArray* reasonIds = [[[DBReasonAdapter alloc] init] getReasonIDsOfDate:[NSDate date]];
    if (reasonIds.count > 0)
    {
        NSDictionary* hotSpot = [self.locationAdapter getLocationReasonAtLatitude:self.recentLocation.coordinate.latitude
                                                                        longitude:self.recentLocation.coordinate.longitude
                                                                      ofReasonIds:reasonIds
                                                                      inDirection:direction
                                                                     withinRadius:kHotSpotZoonRadius];
        
        // Pop up warning view if there're warnings.
        if (hotSpot)
        {
            // Show warning and hide hotspot detail
            self.warningView.hidden = NO;
            self.hotSpotDetailView.hidden = YES;
            [self didApproachHotSpot:hotSpot];
            self.isNavigating = YES;
        }
        else
        {
            self.warningView.hidden = YES;
            [self.warningView updateLocation:nil rank:nil count:nil distance:nil];
            
            [self.markerManager breathingMarker:nil];
        }
    }
    
    // Only update camera of map if in navigation mode.
    if (self.isNavigating)
    {
        if (self.locationMarker == nil)
        {
            self.locationMarker = [CircleMarker markerWithPosition:self.recentLocation.coordinate];
            [self.locationMarker loadImages];
            self.locationMarker.map = self.mapView;
        }
        else
        {
            self.locationMarker.position = self.recentLocation.coordinate;
        }
        
        GMSCameraUpdate *newTarget = [GMSCameraUpdate setTarget:self.recentLocation.coordinate];
        [self.mapView animateWithCameraUpdate:newTarget];
    }
}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <HotSpotListViewControllerMapDelegate> methods

- (void)hotSpotTableViewCellDidSelect:(HotSpot*)hotSpot
{
    [self setNavigationMode:NO];
    
    NSAssert(hotSpot, @"The cell user selected has no hot spot info");
    
    // Hide HotSpotListView
    [self.revealViewController revealToggle:self];
    
    // Zoom to hot spot location
    double latitude = [hotSpot.latitude doubleValue];
    double longtitude = [hotSpot.longtitude doubleValue];
    GMSCameraPosition* targetPos = [GMSCameraPosition cameraWithLatitude:latitude
                                                               longitude:longtitude
                                                                    zoom:16.0];
    self.mapView.camera = targetPos;

    
    // Show hot spot details
    self.hotSpotDetailView.hidden = NO;

    NSArray* hotSpotDetails = [[DBManager sharedInstance] getHotSpotDetailsByLocationCode:hotSpot.locCode];
    [self.hotSpotDetailView reload:@[hotSpot.location, hotSpotDetails]];
}

#pragma mark - GMSMapViewDelegate methods

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if (gesture)
    {
        [self setNavigationMode:NO];
    }
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    [self setNavigationMode:NO];
    
    // Zoom to hot spot location
    double latitude = marker.position.latitude;
    double longtitude = marker.position.longitude;
    GMSCameraPosition* targetPos = [GMSCameraPosition cameraWithLatitude:latitude
                                                               longitude:longtitude
                                                                    zoom:16.0];
    self.mapView.camera = targetPos;
    
    // Show hot spot details
    self.hotSpotDetailView.hidden = NO;
    
    AnimatedGMSMarker* animatedGMSMarker = (AnimatedGMSMarker*)marker;
    if (animatedGMSMarker)
    {
        NSArray* hotSpotDetails = [[DBManager sharedInstance] getHotSpotDetailsByLocationCode:animatedGMSMarker.locCode];
        [self.hotSpotDetailView reload:@[animatedGMSMarker.locationName, hotSpotDetails]];
    }
    
    return YES;
}

@end
