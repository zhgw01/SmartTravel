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
#import "HotSpotListViewController.h"
#import "WarningView.h"
#import "MarkerManager.h"

@interface HomeViewController ()<SWRevealViewControllerDelegate, CLLocationManagerDelegate, HotSpotListViewControllerMapDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hotspotListButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CircleMarker* locationMarker;
@property (assign, nonatomic) BOOL zoomToCurrent;
@property (strong, nonatomic) MarkerManager* markerManager;

@property (strong, nonatomic) WarningView *warningView;

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
    GMSCameraPosition* edmontonPosition = [GMSCameraPosition cameraWithLatitude:53.5501400 longitude:-113.4687100 zoom:12.0];
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

- (IBAction)zoomOut:(id)sender {
    GMSCameraUpdate *zoomOut = [GMSCameraUpdate zoomOut];
    [self.mapView animateWithCameraUpdate:zoomOut];
    
    // Comment out following codes to test warning view
    [self.warningView updateType:VRUWarningType
                        location:@"locate test string"
                            rank:[NSNumber numberWithInt:2]
                           count:[NSNumber numberWithInt:10]
                        distance:[NSNumber numberWithFloat:300.5]];

}
- (IBAction)locateMe:(id)sender {
    
    if (!self.mapView.myLocationEnabled) {
        [self requestLocationAuthorization];
    }
    
    self.zoomToCurrent = YES;
    
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
    CLLocation* location = locations.lastObject;
    if (self.locationMarker == nil) {
        self.locationMarker = [CircleMarker markerWithPosition:location.coordinate];
        //self.locationMarker.icon = [UIImage imageNamed:@"icon_currentlocation"];
        [self.locationMarker loadImages];
        self.locationMarker.map = self.mapView;
    } else {
        self.locationMarker.position = location.coordinate;
    }
    
    if (self.zoomToCurrent) {
        GMSCameraUpdate *newTarget = [GMSCameraUpdate setTarget:location.coordinate];
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

- (void)hotSpotTableViewCellDidSelectWithLatitude:(NSNumber*)latitude
                                     andLongitude:(NSNumber*)longitude
{
    // Hide HotSpotListView
    [self.revealViewController revealToggle:self];

    if (latitude == nil || longitude == nil)
    {
        // Zoom to default location if input is not valid
        [self zoomToEdmonton];
    }
    else
    {
        // Zoom to hot spot location
        GMSCameraPosition* targetPos = [GMSCameraPosition cameraWithLatitude:[latitude doubleValue]
                                                                   longitude:[longitude doubleValue]
                                                                        zoom:16.0];
        self.mapView.camera = targetPos;
    }
}

@end
