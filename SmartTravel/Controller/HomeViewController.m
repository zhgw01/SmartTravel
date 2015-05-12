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
#import "WarningView.h"
#import "MarkerManager.h"
#import "Collision.h"
#import "VRU.h"

// For debug and test only
#ifdef DEBUG
#import "DBDateAdapter.h"
#endif

@interface HomeViewController ()<SWRevealViewControllerDelegate, CLLocationManagerDelegate, HotSpotListViewControllerMapDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hotspotListButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CircleMarker* locationMarker;
@property (assign, nonatomic) BOOL zoomToCurrent;
@property (strong, nonatomic) MarkerManager* markerManager;

@property (strong, nonatomic) WarningView *warningView;
@property (copy, nonatomic)   CLLocation *recentLocation;
@property (strong, nonatomic) CLLocation* defaultLocation;
@property (assign, nonatomic) CLLocationDirection direction;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupSideBarMenu];
    [self setupMap];
    [self setupWarning];
    [self zoomToEdmonton];
    
    self.zoomToCurrent = NO;
    self.markerManager = [[MarkerManager alloc] init];
    
    self.recentLocation = nil;
    // Set default location to Edmonton
    self.defaultLocation = [[CLLocation alloc] initWithLatitude:53.5501400  longitude:-113.4687100];
}

- (void)setupWarning
{
    self.warningView = [[[NSBundle mainBundle] loadNibNamed:@"WarningView" owner:self options:nil] firstObject];
    [self.view addSubview:self.warningView ];
    
    self.warningView.frame = CGRectMake(self.view.frame.origin.x,
                                        self.view.frame.origin.y + self.navigationController.navigationBar.frame.size.height,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height * 0.3);
    
    self.warningView.hidden = YES;
}

- (void) setupMap
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self requestLocationAuthorization];
}

- (void) zoomToEdmonton
{
    // Zoom to Edmonton
    GMSCameraPosition* edmontonPosition = [GMSCameraPosition cameraWithLatitude:self.defaultLocation.coordinate.latitude
                                                                      longitude:self.defaultLocation.coordinate.longitude
                                                                           zoom:12.0];
    self.mapView.camera = edmontonPosition;
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
    
    // Comment out following codes to test warning view
    self.warningView.hidden = !self.warningView.hidden;
}

- (IBAction)zoomOut:(id)sender
{
    GMSCameraUpdate *zoomOut = [GMSCameraUpdate zoomOut];
    [self.mapView animateWithCameraUpdate:zoomOut];
}

- (IBAction)locateMe:(id)sender {
#ifdef DEBUG
//    NSDateComponents* com = [[NSDateComponents alloc] init];
//    [com setDay:9];
//    [com setMonth:5];
//    [com setYear:2015];
//    
//    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDate* date = [cal dateFromComponents:com];
    NSDate* date = [NSDate date];
    
    DBDateAdapter* dbDate = [[DBDateAdapter alloc] initWith:date];
    NSLog(dbDate.isWeekDay ? @"Today is weekday" : @"Today is NOT weekday");
    NSLog(dbDate.isSchoolDay ? @"Today is school day" : @"Today is NOT school day");
#else
    if (!self.mapView.myLocationEnabled) {
        [self requestLocationAuthorization];
    }
    
    self.zoomToCurrent = YES;
#endif
    
}

- (void) requestLocationAuthorization {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
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
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //self.mapView.myLocationEnabled = YES;
        [self.locationManager startUpdatingLocation];
        [self.markerManager drawMarkers:self.mapView];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* lastLocation = self.recentLocation;
    self.recentLocation = locations.lastObject;
    self.direction = [lastLocation kv_bearingOnRhumbLineToCoordinate:self.recentLocation.coordinate];
    
    if (self.locationMarker == nil) {
        self.locationMarker = [CircleMarker markerWithPosition:self.recentLocation.coordinate];
        //self.locationMarker.icon = [UIImage imageNamed:@"icon_currentlocation"];
        [self.locationMarker loadImages];
        self.locationMarker.map = self.mapView;
    } else {
        self.locationMarker.position = self.recentLocation.coordinate;
    }
    
    NSLog(@"Heading: %f", self.recentLocation.course);
    
    if (self.zoomToCurrent) {
        GMSCameraUpdate *newTarget = [GMSCameraUpdate setTarget:self.recentLocation.coordinate];
        [self.mapView animateWithCameraUpdate:newTarget];
        
        self.zoomToCurrent = NO;
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
    CLLocation* targetLoc = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
    
    // Update warning view
    if (!self.warningView.hidden)
    {
        double distance = (self.recentLocation) ?
        [self.recentLocation distanceFromLocation:targetLoc] :
        [self.defaultLocation distanceFromLocation:targetLoc];
        
        NSAssert(hotSpot.type != HotSpotTypeCnt, @"Unsupported hot spot info");
        WarningType warningType = (hotSpot.type == HotSpotTypeCollision) ? CollisionWarningType : VRUWarningType;
        
        [self.warningView updateType:warningType
                            location:hotSpot.location
                                rank:hotSpot.rank
                               count:hotSpot.count
                            distance:[NSNumber numberWithDouble:distance]];
    }
}

@end
