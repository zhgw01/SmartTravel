//
//  HomeViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/19.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
#import <SWRevealViewController/SWRevealViewController.h>
#import <Geo-Utilities/CLLocation+Navigation.h>

#import "HomeViewController.h"
#import "DataUpdateVC.h"
#import "ReasonListVC.h"
#import "HotspotListVC.h"
#import "NoInterfereVC.h"

#import "MarkerManager.h"
#import "AnimatedGMSMarker.h"

#import "WarningView.h"

#import "HotSpotDetailView.h"

#import "DBReasonAdapter.h"
#import "DBLocationAdapter.h"
#import "ResourceManager.h"
#import "DateUtility.h"

#import "AppSettingManager.h"
#import "AppLocationManager.h"
#import "LocationRecordManager.h"
#import "AudioManager.h"
#import "MapModeManager.h"
#import "DBManager.h"

#import "StateMachine.h"
#import "LocationVoicePromptInfo.h"

#import "Flurry.h"
#import "STConstants.h"

static CGFloat kWarningViewHeightProportion = 0.3;
static CGFloat kHotSpotDetailViewHeightProportion = 0.3;
#ifndef NDEBUG
static CGFloat kHotSpotZoonRadius = 1500.0;
#else
static CGFloat kHotSpotZoonRadius = 150.0;
#endif
static CGFloat kHotSpotEarlyWarningInterval = 10.0;

// Default location is Edmonton, CA
static double kDefaultLat = 53.5501400;
static double kDefaultLon = -113.4687100;

#ifdef DEBUG
#define kGeoUpdatingActiveInterval   10
#define kGeoUpdatingInActiveInterval 50
#else
#define kGeoUpdatingActiveInterval   60
#define kGeoUpdatingInActiveInterval 300
#endif

@interface HomeViewController ()
<
    SWRevealViewControllerDelegate,
    GMSMapViewDelegate,
    CLLocationManagerDelegate
>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hotspotListButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@property (strong, nonatomic) MarkerManager *markerManager;

@property (strong, nonatomic) DBLocationAdapter *locationAdapter;
@property (weak, nonatomic) DBManager *dbManager;
@property (weak, nonatomic) AppLocationManager *appLocationManager;

@property (strong, nonatomic) NSTimer *startTimer;
@property (strong, nonatomic) NSTimer *stopTimer;

@property (strong, nonatomic) WarningView *warningView;
@property (strong, nonatomic) HotSpotDetailView* hotSpotDetailView;
@property (strong, nonatomic) NoInterfereVC *noInterfereVC;
@property (assign, atomic) BOOL noInterfereVCShowed;

// Location related properties
@property (assign, nonatomic) BOOL       locationDidEverUpdate;

@property (copy, nonatomic) CLLocation *recentLocation;

@property (strong, nonatomic) LocationVoicePromptInfo *locationVoicePromptInfo;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationDidEverUpdate = NO;
    self.locationVoicePromptInfo = [[LocationVoicePromptInfo alloc] init];
    
    // Initialize views
    [self setupSideBarMenu];
    [self setupMap:[[CLLocation alloc] initWithLatitude:kDefaultLat
                                              longitude:kDefaultLon]];
    [self setupWarning];
    [self setupHotSpotDetail];
    
    self.noInterfereVC = [[NoInterfereVC alloc] init];
    self.noInterfereVCShowed = NO;
    
    // Initialize DB adapter and set delegate
    self.locationAdapter = [[DBLocationAdapter alloc] init];
    
    self.appLocationManager = [AppLocationManager sharedInstance];
    [self.appLocationManager setDelegate:self];
    
    self.dbManager = [DBManager sharedInstance];
    
    // Register notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusHasBeenChanged:)
                                                 name:kStatusHasBeenChanged
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newerDataFound)
                                                 name:@"NNNewerDataFound"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mapModeChanged:)
                                                 name:kMapModeChanged
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hotspotCellDidSelect:)
                                                 name:kNotificatonNameHotSpotSelected
                                               object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"Smart Travel";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.appLocationManager setDelegate:nil];
}

- (void)newerDataFound
{
    DataUpdateVC *dataUpdateVC =[[DataUpdateVC alloc] init];
    [self.navigationController presentViewController:dataUpdateVC animated:NO completion:nil];
}

- (void)invalidateTimers
{
    if (self.startTimer)
    {
        if ([self.startTimer isValid])
        {
            [self.startTimer invalidate];
        }
        self.startTimer = nil;
    }
    
    if (self.stopTimer)
    {
        if ([self.stopTimer isValid])
        {
            [self.stopTimer invalidate];
        }
        self.stopTimer = nil;
    }
}

- (void)stopGeoUpdating
{
    if (self.appLocationManager.updatingLocationEnabled)
    {
        [self.appLocationManager stopUpdatingLocation];
    }
    
    if (self.appLocationManager.updatingHeadingEnabled)
    {
        [self.appLocationManager stopUpdatingHeading];
    }
}

- (void)startGeoUpdating
{
    if (!self.appLocationManager.updatingLocationEnabled)
    {
        [self.appLocationManager startUpdatingLocation];
    }
    
    if (!self.appLocationManager.updatingHeadingEnabled)
    {
        [self.appLocationManager startUpdatingHeading];
    }
}

- (void)startGeoUpdatingTemporarily
{
    [self startGeoUpdating];
    self.stopTimer = [NSTimer scheduledTimerWithTimeInterval:kGeoUpdatingActiveInterval
                                                      target:self
                                                    selector:@selector(stopGeoUpdatingTemporarily)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void)stopGeoUpdatingTemporarily
{
    [self stopGeoUpdating];
    self.startTimer = [NSTimer scheduledTimerWithTimeInterval:kGeoUpdatingInActiveInterval
                                                       target:self
                                                     selector:@selector(startGeoUpdatingTemporarily)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)statusHasBeenChanged:(id)sender
{
    NSNumber *statusNumber = [[sender userInfo] objectForKey:@"status"];
    switch ([statusNumber unsignedIntegerValue])
    {
        case kStateActive:
        {
            NSLog(@"State has been changed to \"active\"");

            [[AppSettingManager sharedInstance] setShowNoInterfereUI:YES];
            
            [self invalidateTimers];
            [self startGeoUpdating];
        }
            break;
        case kStateClose:
        {
            NSLog(@"State has been changed to \"close\"");

            // TODO:
        }
            break;
        case kStateInactive:
        {
            NSLog(@"State has been changed to \"inactive\"");

            [self invalidateTimers];
            [self stopGeoUpdatingTemporarily];
        }
            break;
        case kStateUnKnown:
        default:
        {
            NSLog(@"State has been changed to \"unknown\"");
        }
            break;
    }
}

- (void)mapModeChanged:(id)sender
{
    BOOL isNavigationOn = [[[sender userInfo] valueForKey:@"isNavigationOn"] boolValue];
    if (isNavigationOn)
    {
        self.hotSpotDetailView.hidden = YES;
    }
    else
    {
        self.warningView.hidden = YES;
    }
}

#pragma mark - Setup other views in viewDidLoad
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

- (void)setupMap:(CLLocation*)defaultLocation
{
    // Show default location on map
    self.mapView.camera = [GMSCameraPosition cameraWithLatitude:defaultLocation.coordinate.latitude
                                                      longitude:defaultLocation.coordinate.longitude
                                                           zoom:12.0];
    
    // Draw marker on map to represent all hotspots except shool zones
    self.markerManager = [[MarkerManager alloc] init];
    [self.markerManager drawMarkers:self.mapView];
    
    // Set up GPSMapViewDelegate
    self.mapView.delegate = self;
    
    // Enable locate me
    self.mapView.myLocationEnabled = YES;
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

#pragma mark - Map Button Action

- (IBAction)zoomIn:(id)sender
{
    GMSCameraUpdate *zoomIn = [GMSCameraUpdate zoomIn];
    [self.mapView animateWithCameraUpdate:zoomIn];
    [[MapModeManager sharedInstance] eventHappened:kMapModeUserGesture];
}

- (IBAction)zoomOut:(id)sender
{
    GMSCameraUpdate *zoomOut = [GMSCameraUpdate zoomOut];
    [self.mapView animateWithCameraUpdate:zoomOut];
    [[MapModeManager sharedInstance] eventHappened:kMapModeUserGesture];
}

- (IBAction)locateMe:(id)sender
{
    CLLocation *location = self.mapView.myLocation;
    if (!location)
    {
        location = [[CLLocation alloc] initWithLatitude:kDefaultLat longitude:kDefaultLon];
    }
    [self.mapView animateToLocation:location.coordinate];
    
    [[MapModeManager sharedInstance] eventHappened:kMapModeUserClickLocateMe];
}

#pragma mark - SWRevealViewController Delegate
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position != FrontViewPositionLeft) {
        self.mapView.userInteractionEnabled = NO;
    }
    else {
        self.mapView.userInteractionEnabled = YES;
    }
}

#pragma mark - Location Manager Delegate

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self.appLocationManager startUpdatingHeading];
        [self.appLocationManager startUpdatingLocation];
    }
}

- (BOOL)shouldReportWarningOfLocCode:(NSString*)locCode
                              onDate:(NSDate*)date
{
    NSTimeInterval nowTimeStamp = [date timeIntervalSince1970];
    if ([locCode isEqualToString:self.locationVoicePromptInfo.locationCode])
    {
        if ([self.locationVoicePromptInfo exceedWindow:nowTimeStamp])
        {
            self.locationVoicePromptInfo.count = 1;
            self.locationVoicePromptInfo.windowStartTime = nowTimeStamp;
            self.locationVoicePromptInfo.lastTime = nowTimeStamp;
            return YES;
        }
        else
        {
            if (![self.locationVoicePromptInfo exceedSubWindow:nowTimeStamp])
            {
                return NO;
            }
            
            if (self.locationVoicePromptInfo.count >= kMaxPromptCount)
            {
                return NO;
            }
            
            self.locationVoicePromptInfo.count += 1;
            self.locationVoicePromptInfo.lastTime = nowTimeStamp;
            return YES;
        }
    }
    else
    {
        self.locationVoicePromptInfo.locationCode = locCode;
        self.locationVoicePromptInfo.count = 1;
        self.locationVoicePromptInfo.windowStartTime = nowTimeStamp;
        self.locationVoicePromptInfo.lastTime = nowTimeStamp;
        return YES;
    }
}

- (void)speakOutWarningMessage:(NSString *)warningMessage
                       locCode:(NSString *)locCode
                      reasonID:(NSNumber *)reasonId
{
    NSString *audioPath = [[ResourceManager sharedInstance] getAudioFilePathByReasonID:reasonId];
    [[AudioManager sharedInstance] speekFromFile:audioPath];

    // Breath the marker
    [self.markerManager breathingMarker:locCode];
}

- (void)hotSpotDidGet:(NSDictionary *)hotSpot
     visualCompletion:(void(^)(double /*distance*/, NSString */*locationName*/, NSString */*warningReason*/))vc
    hearingCompletion:(void(^)(int /*reasonId*/, NSString */*locationCode*/, NSString */*warningMessage*/))hc;
{
    // Show warning and hide hotspot detail
    
    [[MapModeManager sharedInstance] eventHappened:kMapModeUserApproachHotSpot];

    // Get details of dangerous location
    NSString *locationCode = [hotSpot objectForKey:@"Loc_code"];
    NSString *locationName = [[NSString alloc] init];
    int reasonId = 0;
    double latitude = 0;
    double longitude = 0;
    
    if ([self.locationAdapter getLocationName:&locationName
                                     reasonId:&reasonId
                                     latitude:&latitude
                                    longitude:&longitude
                                    ofLocCode:locationCode])
    {
        NSArray* warningMessageAndReason = [[[DBReasonAdapter alloc] init]
                                            getWarningMessageAndReasonOfId:reasonId];
        
        // Visual action need be done when dangerous location found
        CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude
                                                          longitude:longitude];
        double dis = [location distanceFromLocation:self.recentLocation];
        vc(dis, locationName, [warningMessageAndReason objectAtIndex:1]);
        
        // Hearing action need be done when dangerous location found
        if ([self shouldReportWarningOfLocCode:locationCode
                                        onDate:[NSDate date]])
        {
            hc(reasonId, locationCode, [warningMessageAndReason objectAtIndex:0]);
        }
    }
}

- (void)hotSpotDidNotGet
{
    self.warningView.hidden = YES;
    [self.warningView updateLocation:nil reason:nil distance:nil];
    
    [self.markerManager breathingMarker:nil];
}

- (void)updateCamera:(CLLocation*)location
{
    GMSCameraUpdate *newTarget = [GMSCameraUpdate setTarget:location.coordinate];
    [self.mapView animateWithCameraUpdate:newTarget];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // Whatever status, should
    // 1) Update recent location
    CLLocation* lastLocation = [self.recentLocation copy];
    self.recentLocation = locations.lastObject;
    
    // 2) Mark if the located has been updated
    if (!self.locationDidEverUpdate)
    {
        self.locationDidEverUpdate = YES;
        
        // Tricky code to control UI whether to show
        // test data of Shanghai
        BOOL showTestDataOfShanghai = (self.recentLocation.coordinate.longitude > 0);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTestDataOfShanghai"
                                                            object:nil
                                                          userInfo:@{@"ShowTestDataOfShanghai": @(showTestDataOfShanghai)}];
    }
    
    LocationRecordManager* locationRecordManager = [LocationRecordManager sharedInstance];
    // 3) If user speed is slower than 20 / 3.6 m/s, need to verify
    // if user stay within 100 meters for more than 30 minutes.
    if (self.recentLocation.speed < kNoticeableSpeed)
    {
        [locationRecordManager record:self.recentLocation];

        if ([locationRecordManager duration] > kHalfHour)
        {
            double distance = 0;
            if ([locationRecordManager distance:&distance])
            {
                if (distance < 100)
                {
                    [[StateMachine sharedInstance] eventHappend:kEventUserStay];
                }
            }
        }
    }
    else
    {
        [locationRecordManager reset];
        [locationRecordManager record:self.recentLocation];
        
        [[StateMachine sharedInstance] eventHappend:kEventUserMove];
        
        if (!self.noInterfereVCShowed)
        {
            if ([StateMachine sharedInstance].status == kStateActive)
            {
                if ([AppSettingManager sharedInstance].getShowNoInterfereUI)
                {
                    [self.navigationController pushViewController:self.noInterfereVC animated:NO];
                    self.noInterfereVCShowed = YES;
                }
            }
        }
    }

    NSDictionary* hotSpot = [self getApproachingHotSpot:lastLocation
                                        currentLocation:self.recentLocation];
    if (hotSpot)
    {
        [self hotSpotDidGet:hotSpot
           visualCompletion:^(double dis, NSString *locationName, NSString *warningReason)
            {
                // Show warning view
                self.warningView.hidden = NO;
                
                // Update warning view in time
                [self.warningView updateLocation:locationName
                                          reason:warningReason
                                        distance:@(dis)];
            }
          hearingCompletion:^(int reasonId, NSString *locationCode, NSString* warningMessage)
            {
                // Only speak out the warning message in active status
                // and it's enabled.
                if ([StateMachine sharedInstance].status == kStateActive)
                {
                    if ([[AppSettingManager sharedInstance] getIsWarningVoice])
                    {
                        [self speakOutWarningMessage:warningMessage
                                         locCode:locationCode
                                        reasonID:@(reasonId)];
                        NSLog(@"Voice prompt at loc code %@ of reason %d", locationCode, reasonId);
                    }
                    else
                    {
                        [Flurry logEvent:kFlurryEventNoVoicePromptForInActiveStatus
                          withParameters:@{
                                           @"reason id" : @(reasonId),
                                           @"location code" : locationCode
                                           }];
                    }
                }
                else
                {
                    [Flurry logEvent:kFlurryEventReasonNotMatchForInvalidMonthOrStartAndEndTime
                      withParameters:@{
                                       @"reason id" : @(reasonId),
                                       @"location code" : locationCode
                                       }];
                }
            }
        ];
    }
    else
    {
        [self hotSpotDidNotGet];
    }
    
    // Only update camera of map if in navigation mode.
    if ([MapModeManager sharedInstance].isNavigationOn)
    {
        [self updateCamera:self.recentLocation];
    }
}

- (NSDictionary*)getApproachingHotSpot:(CLLocation*)lastLocation
                        currentLocation:(CLLocation*)curLocation
{
    // Compute direction
    CLLocationDirection accurateDir = [lastLocation kv_bearingOnRhumbLineToCoordinate:curLocation.coordinate];
    Direction direction = [[LocationDirection alloc] initWithCLLocationDirection:accurateDir].direction;
    
    // Filter out reasons
    NSArray* reasonIds = [[[DBReasonAdapter alloc] init] getReasonIDsOfDate:[NSDate date]];
    if (reasonIds.count == 0)
    {
        return nil;
    }
    
    // Filter out hot spot
    CGFloat hotSpotZoonRadius = kHotSpotZoonRadius;
    if (lastLocation.speed > 0)
    {
        hotSpotZoonRadius = lastLocation.speed * kHotSpotEarlyWarningInterval;
    }
    NSDictionary *hotSpot = [self.locationAdapter getLocationReasonAtLatitude:curLocation.coordinate.latitude
                                                                    longitude:curLocation.coordinate.longitude
                                                                  ofReasonIds:reasonIds
                                                                  inDirection:direction
                                                                 withinRadius:hotSpotZoonRadius];
    
    return hotSpot;
}

- (void)hotspotCellDidSelect:(id)data
{
    HotSpot *hotSpot = [[data userInfo] objectForKey:@"HotSpot"];
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
    
    [[MapModeManager sharedInstance] eventHappened:kMapModeUserClickHotSpot];

    NSArray* hotSpotDetails = nil;
    if (hotSpot.type == HotSpotTypeSchoolZone)
    {
        hotSpotDetails = @[];
    }
    else
    {
        hotSpotDetails = [self.dbManager getHotSpotDetailsByLocationCode:hotSpot.locCode];
    }
    [self.hotSpotDetailView configWithType:hotSpot.type
                                   andData:@{
                                             @"name" : hotSpot.location,
                                             @"details": hotSpotDetails
                                            }];
}

#pragma mark - GMSMapViewDelegate methods

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if (gesture)
    {
        [[MapModeManager sharedInstance] eventHappened:kMapModeUserGesture];
    }
}

-(BOOL)mapView:(GMSMapView *)mapView
  didTapMarker:(GMSMarker *)marker
{
    [[MapModeManager sharedInstance] eventHappened:kMapModeUserTapMarker];
    
    // Zoom to hot spot location
    double latitude = marker.position.latitude;
    double longtitude = marker.position.longitude;
    GMSCameraPosition* targetPos = [GMSCameraPosition cameraWithLatitude:latitude
                                                               longitude:longtitude
                                                                    zoom:16.0];
    self.mapView.camera = targetPos;
    
    // Show hot spot details
    self.hotSpotDetailView.hidden = NO;
    
    // Refresh hot spot detail
    AnimatedGMSMarker* animatedGMSMarker = (AnimatedGMSMarker*)marker;
    if (animatedGMSMarker)
    {
        NSArray* hotSpotDetails = [self.dbManager getHotSpotDetailsByLocationCode:animatedGMSMarker.locCode];
        // School zone has no marker
        [self.hotSpotDetailView configWithType:HotSpotTypeAllExceptSchoolZone
                                       andData:@{
                                                 @"name":animatedGMSMarker.locationName,
                                              @"details":hotSpotDetails
                                                 }];
    }
    
    return YES;
}

@end
