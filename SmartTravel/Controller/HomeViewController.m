//
//  HomeViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/19.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "HomeViewController.h"
#import "CircleMarker.h"
#import <GoogleMaps/GoogleMaps.h>
#import <SWRevealViewController/SWRevealViewController.h>
#import <Geo-Utilities/CLLocation+Navigation.h>
#import "HotSpotListViewController.h"
#import "MarkerManager.h"
#import "DBManager.h"
#import "DBLocationReasonAdapter.h"
#import "DBReasonAdapter.h"
#import "DateUtility.h"

#import "WarningView.h"
#import "HotSpotDetailView.h"

static CGFloat kWarningViewHeightProportion = 0.3;
static CGFloat kHotSpotDetailViewHeightProportion = 0.3;

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

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CircleMarker* locationMarker;
@property (strong, nonatomic) MarkerManager* markerManager;

@property (copy, nonatomic)   CLLocation *recentLocation;
@property (strong, nonatomic) CLLocation* defaultLocation;
@property (assign, nonatomic) CLLocationDirection direction;

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

#ifdef DEBUG
@property (strong, nonatomic) WarningView *warningView;
@property (strong, nonatomic) HotSpotDetailView* hotSpotDetailView;
#endif

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupSideBarMenu];
    [self setupMap];
#ifdef DEBUG
    [self setupWarning];
    [self setupHotSpotDetail];
#endif
    
    self.isNavigating = NO;
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

- (void) setupMap
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self requestLocationAuthorization];
    
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
}

- (void) setupNavigationBar
{
    //setup navigation
    self.title = @"Smart Travel";
    
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

#pragma mark - Button Action

- (IBAction)zoomIn:(id)sender {
    GMSCameraUpdate *zoomIn = [GMSCameraUpdate zoomIn];
    [self.mapView animateWithCameraUpdate:zoomIn];
    
#ifdef DEBUG
    self.warningView.hidden = !self.warningView.hidden;
#endif
}

- (IBAction)zoomOut:(id)sender
{
    GMSCameraUpdate *zoomOut = [GMSCameraUpdate zoomOut];
    [self.mapView animateWithCameraUpdate:zoomOut];
#ifdef DEBUG
    self.hotSpotDetailView.hidden = !self.hotSpotDetailView.hidden;
#endif
}

- (IBAction)locateMe:(id)sender
{
    self.mapView.myLocationEnabled = YES;
    GMSCameraUpdate* cameraUpdate = nil;
    if (self.mapView.myLocation)
    {
        cameraUpdate = [GMSCameraUpdate setTarget:self.mapView.myLocation.coordinate];
    }
    else
    {
        cameraUpdate = [GMSCameraUpdate setTarget:self.defaultLocation.coordinate];
    }
    [self.mapView animateWithCameraUpdate:cameraUpdate];
}

- (void) requestLocationAuthorization
{
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
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
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* lastLocation = self.recentLocation;
    self.recentLocation = locations.lastObject;
    self.direction = [lastLocation kv_bearingOnRhumbLineToCoordinate:self.recentLocation.coordinate];

    // TODO: Add navigation mode
    if (self.locationMarker == nil)
    {
        self.locationMarker = [CircleMarker markerWithPosition:self.recentLocation.coordinate];
        //self.locationMarker.icon = [UIImage imageNamed:@"icon_currentlocation"];
        [self.locationMarker loadImages];
        self.locationMarker.map = self.mapView;
    }
    else
    {
        self.locationMarker.position = self.recentLocation.coordinate;
    }
    
    GMSCameraUpdate *newTarget = [GMSCameraUpdate setTarget:self.recentLocation.coordinate];
    [self.mapView animateWithCameraUpdate:newTarget];
    
#ifdef DEBUG
    Direction direction = ALL;
    double radius = 1000;
#else
    LocationDirection* locationDirection = [[LocationDirection alloc] initWithCLLocationDirection:self.direction];
    Direction direction = locationDirection.direction;
    double radius = 100;
#endif
    
    // Get warning data list
    NSArray* reasonIds = [[[DBReasonAdapter alloc] init] getReasonIDsOfDate:[NSDate date]];
    if (reasonIds.count > 0)
    {
        NSArray* warnings = [[[DBLocationReasonAdapter alloc] init] getLocationReasonsAtLatitude:self.recentLocation.coordinate.latitude
                                                                                       longitude:self.recentLocation.coordinate.longitude
                                                                                     ofReasonIds:reasonIds
                                                                                     inDirection:direction
                                                                                    withinRadius:radius];
        DBManager* dbManager = [DBManager sharedInstance];
        for (NSDictionary* waringData in warnings)
        {
            NSString* locCode = [waringData objectForKey:@"Loc_code"];
            NSArray* details = [dbManager getHotSpotDetailsByLocationCode:locCode];
            
            for(NSDictionary* detail in details)
            {
                NSString* travelDirection = [detail valueForKey:@"Travel_direction"];
                NSString* reason = [details valueForKey:@"Reason"];
                NSNumber* total = [details valueForKey:@"Total"];
                NSLog(@"Travel direction is %@", travelDirection);
                NSLog(@"Reason is %@", reason);
                NSLog(@"Total is %d", [total intValue]);
            }
        }
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
//    CLLocation* targetLoc = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
//        double distance = (self.recentLocation) ?
//        [self.recentLocation distanceFromLocation:targetLoc] :
//        [self.defaultLocation distanceFromLocation:targetLoc];
//        
//        [self.warningView updateLocation:hotSpot.location
//                                    rank:hotSpot.rank
//                                   count:hotSpot.count
//                                distance:[NSNumber numberWithDouble:distance]];
    
    self.hotSpotDetailView.hidden = NO;

    NSArray* hotSpotDetails = [[DBManager sharedInstance] getHotSpotDetailsByLocationCode:hotSpot.locCode];
    [self.hotSpotDetailView reload:hotSpotDetails];
}

@end
