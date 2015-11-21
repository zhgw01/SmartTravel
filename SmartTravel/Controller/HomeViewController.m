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

#import "LayerManager.h"
#import "Marker.h"
#import "CollisionMarkerManager.h"
#import "SchoolMarkerManager.h"
#import "LocationCoordinate.h"
#import "WarningView.h"
#import "ReasonInfo.h"

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
#import "VoicePromptInfo.h"

#import "Flurry.h"
#import "STConstants.h"

#import "DirectionUtility.h"

static CGFloat kWarningViewHeightProportion = 0.3;
static CGFloat kHotSpotDetailViewHeightProportion = 0.3;
static CGFloat kHotSpotZoonRadius = 150.0;
static CGFloat kHotSpotEarlyWarningInterval = 10.0;

static CGFloat kZoomLevelToShowShoolZones = 13.0;

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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backHomeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *categoriesButton;

@property (strong, nonatomic) LayerManager *layerManager;

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
@property (assign, nonatomic) BOOL            locationDidEverUpdate;
@property (copy, nonatomic  ) CLLocation      *recentLocation;
@property (strong, nonatomic) VoicePromptInfo *voicePromptInfo;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationDidEverUpdate = NO;
    self.voicePromptInfo = [[VoicePromptInfo alloc] init];
    
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
                                             selector:@selector(mapModeChanged:)
                                                 name:kMapModeChanged
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hotspotCellDidSelect:)
                                                 name:kNotificatonNameHotSpotSelected
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.appLocationManager setDelegate:nil];
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
    
    // Draw marker on map to represent all hotspots except shools
    self.layerManager = [[LayerManager alloc] init];
    [self.layerManager switchToLayer:self.type
                           onMapView:self.mapView];
    
    // Set up GPSMapViewDelegate
    self.mapView.delegate = self;
    
    // Enable locate me
    self.mapView.myLocationEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.type == HotSpotTypeSchoolLocation)
    {
        self.categoriesButton.enabled = NO;
    }
    else
    {
        self.categoriesButton.enabled = YES;
    }
}

- (IBAction)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupSideBarMenu
{
    if (self.revealViewController)
    {
        self.categoriesButton.target = self.revealViewController;
        self.categoriesButton.action = @selector(rightRevealToggle:);
        
        self.revealViewController.rightViewRevealWidth = 280;
        self.revealViewController.delegate = self;
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

#pragma mark - Map Button Action

- (IBAction)zoomIn:(id)sender
{
    if (self.mapView.camera.zoom >= kZoomLevelToShowShoolZones)
    {
        [self.layerManager showShapesOnMapView:self.mapView];
    }
    
    GMSCameraUpdate *zoomIn = [GMSCameraUpdate zoomIn];
    [self.mapView animateWithCameraUpdate:zoomIn];
    [[MapModeManager sharedInstance] eventHappened:kMapModeUserGesture];
}

- (IBAction)zoomOut:(id)sender
{
    if (self.mapView.camera.zoom < kZoomLevelToShowShoolZones)
    {
        [self.layerManager hideShapes];
    }
    
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
                          atDistance:(double)distance
{
    if ([AudioManager sharedInstance].isPlaying)
    {
        return NO;
    }
    
    NSTimeInterval nowTimeStamp = [date timeIntervalSince1970];
    if ([locCode isEqualToString:self.voicePromptInfo.locationCode])
    {
        if ([self.voicePromptInfo exceedWindow:nowTimeStamp])
        {
            self.voicePromptInfo.canShowWarningView = YES;
            self.voicePromptInfo.count              = 1;
            self.voicePromptInfo.windowStartTime    = nowTimeStamp;
            self.voicePromptInfo.lastTime           = nowTimeStamp;
            return YES;
        }
        else
        {
            if (![self.voicePromptInfo exceedSubWindow:nowTimeStamp])
            {
                return NO;
            }
            
            if (self.voicePromptInfo.count >= kMaxPromptCount)
            {
                return NO;
            }
            
            self.voicePromptInfo.count              += 1;
            self.voicePromptInfo.canShowWarningView = self.voicePromptInfo.count < kMaxPromptCount;
            self.voicePromptInfo.lastTime           = nowTimeStamp;
            return YES;
        }
    }
    else
    {
        self.voicePromptInfo.canShowWarningView = YES;
        self.voicePromptInfo.locationCode       = locCode;
        self.voicePromptInfo.count              = 1;
        self.voicePromptInfo.windowStartTime    = nowTimeStamp;
        self.voicePromptInfo.lastTime           = nowTimeStamp;
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
    if ([self.layerManager.markerManager isKindOfClass:[CollisionMarkerManager class]])
    {
        CollisionMarkerManager *collisionMarkerManager = (CollisionMarkerManager*)(self.layerManager.markerManager);
        [collisionMarkerManager breath:locCode];
    }
}

- (void)hotSpotDidGetWithLocationCode:(NSString*)code
                          andReasonId:(int)reasonId
                          andLatitude:(double)latitude
                         andLongitude:(double)longitude
                              andName:(NSString*)name
                     visualCompletion:(void(^)(double /*distance*/, NSString */*locationName*/, NSString */*warningReason*/))vc
                    hearingCompletion:(void(^)(int /*reasonId*/, NSString */*locationCode*/, NSString */*warningMessage*/))hc;
{
    // Show warning and hide hotspot detail
    [[MapModeManager sharedInstance] eventHappened:kMapModeUserApproachHotSpot];
    
    ReasonInfo* reasonIfo = [[[DBReasonAdapter alloc] init] getReasonInfo:reasonId];
    
    CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude
                                                      longitude:longitude];
    double dis = [location distanceFromLocation:self.recentLocation];
    
    // Hearing action need be done when dangerous location found
    if ([self shouldReportWarningOfLocCode:code
                                    onDate:[NSDate date]
                                atDistance:dis])
    {
        hc(reasonId, code, reasonIfo.warningMessage);
    }
    
    // Visual action need be done when dangerous location found
    if (self.voicePromptInfo.canShowWarningView)
    {
        vc(dis, name, reasonIfo.reason);
    }
    else
    {
        [self resetWarningView];
    }
}

- (void)resetWarningView
{
    self.warningView.hidden = YES;
    [self.warningView updateLocation:nil
                              reason:nil
                            distance:nil];
}

- (void)hotSpotDidNotGet
{
    [self resetWarningView];
    
    // Breath the marker
    if ([self.layerManager.markerManager isKindOfClass:[CollisionMarkerManager class]])
    {
        CollisionMarkerManager *collisionMarkerManager = (CollisionMarkerManager*)(self.layerManager.markerManager);
        [collisionMarkerManager stopBreath];
    }
}

- (void)updateCamera:(CLLocation*)location
{
    GMSCameraUpdate *newTarget = [GMSCameraUpdate setTarget:location.coordinate];
    [self.mapView animateWithCameraUpdate:newTarget];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
#ifdef DEBUG
    // Print log if in background and still has been receiving location update signals
    if (appState == UIApplicationStateInactive || appState == UIApplicationStateBackground)
    {
        CLLocation *loc = [locations lastObject];
        NSLog(@"Location update: %lf", loc.speed);
    }
#endif
    
    // Whatever status, should
    // 1) Update recent location
    CLLocation* lastLocation = [self.recentLocation copy];
    self.recentLocation = locations.lastObject;
    
    // 2) Mark if the located has been updated
    if (!self.locationDidEverUpdate)
    {
        self.locationDidEverUpdate = YES;
#ifndef DEBUG        
        // Tricky code to control UI whether to show
        // test data of Shanghai
        BOOL showTestDataOfShanghai = (self.recentLocation.coordinate.longitude > 0);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTestDataOfShanghai"
                                                            object:nil
                                                          userInfo:@{@"ShowTestDataOfShanghai": @(showTestDataOfShanghai)}];
#endif
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
        
        if (appState != UIApplicationStateInactive && appState != UIApplicationStateBackground)
        {
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
    }
    
    CLLocationDirection accurateDir = [lastLocation kv_bearingOnRhumbLineToCoordinate:self.recentLocation.coordinate];
    
    NSArray* hotspots = [self getHotSpotAtLocation:self.recentLocation
                                         withDirection:accurateDir];
    
    BOOL anyFound = NO;
    for (NSDictionary *hotSpot in hotspots)
    {
        NSString *code = [hotSpot objectForKey:@"Loc_code"];
        int reasonId = [[hotSpot objectForKey:@"Reason_id"] intValue];
        NSString *name = [[NSString alloc] init];
        double latitude = 0;
        double longitude = 0;
        
        if ([self.locationAdapter getLocationName:&name
                                         latitude:&latitude
                                        longitude:&longitude
                                        ofLocCode:code])
        {
            CLLocationCoordinate2D targetCoor = {
                .latitude = latitude,
                .longitude = longitude
            };
            
            if ([DirectionUtility isLocation:self.recentLocation.coordinate
                           approachingTarget:targetCoor
                               withDirection:accurateDir])
            {
                [self hotSpotDidGetWithLocationCode:code
                                        andReasonId:reasonId
                                        andLatitude:latitude
                                       andLongitude:longitude
                                            andName:name
                                   visualCompletion:^(double dis, NSString *locationName, NSString *warningReason)
                    {
                        if (appState != UIApplicationStateInactive && appState != UIApplicationStateBackground)
                        {
                            // Show warning view
                            self.warningView.hidden = NO;
                            
                            // Update warning view in time
                            [self.warningView updateLocation:locationName
                                                      reason:warningReason
                                                    distance:@(dis)];
                        }
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
                                [Flurry logEvent:kFlurryEventNoVoicePromptForDisabled
                                  withParameters:@{
                                                   @"reason id" : @(reasonId),
                                                   @"location code" : locationCode
                                                   }];
                            }
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
                ];
                
                anyFound = YES;
                break;
            }
            else
            {
                [Flurry logEvent:kFlurryEventCurrentLocationIsNotInMiddle
                  withParameters:@{
                                   @"reason id" : @(reasonId),
                                   @"location code" : code,
                                   @"location name": name,
                                   @"current latitude": @(self.recentLocation.coordinate.latitude),
                                   @"current longitude": @(self.recentLocation.coordinate.longitude),
                                   @"target latitude": @(targetCoor.latitude),
                                   @"target longitude": @(targetCoor.longitude)
                                   }];
            }
        }
    }
    
    if (!anyFound)
    {
        if (appState != UIApplicationStateInactive && appState != UIApplicationStateBackground)
        {
            [self hotSpotDidNotGet];
        }
    }
    
    // Only update camera of map if in navigation mode.
    if ([MapModeManager sharedInstance].isNavigationOn)
    {
        if (appState != UIApplicationStateInactive && appState != UIApplicationStateBackground)
        {
            [self updateCamera:self.recentLocation];
        }
    }
}

- (NSArray*)getHotSpotAtLocation:(CLLocation*)currentLocation
                   withDirection:(CLLocationDirection)accurateDir
{
    Direction direction = [DirectionUtility fromCLLocationDirection:accurateDir];
    
    // Filter out reasons
    NSArray* reasonIds = [[[DBReasonAdapter alloc] init] getReasonIDsOfDate:[NSDate date]];
    if (reasonIds.count == 0)
    {
        return nil;
    }
    
    // Filter out hot spot
    CGFloat hotSpotZoonRadius = kHotSpotZoonRadius;
    if (currentLocation.speed > 0)
    {
        hotSpotZoonRadius = currentLocation.speed * kHotSpotEarlyWarningInterval;
    }

    // Get loc codes
    NSArray* locCodes = [self.locationAdapter getLocCodesInRange:hotSpotZoonRadius
                                                      atLatitude:currentLocation.coordinate.latitude
                                                       longitude:currentLocation.coordinate.longitude];
    if (locCodes.count == 0)
    {
        return nil;
    }
    
    NSArray *hotspots = [self.locationAdapter getLocationsOfReasonIds:reasonIds
                                                          inDirection:direction
                                                  withinLocationCodes:locCodes];

    return hotspots;
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
    if (hotSpot.type == HotSpotTypeSchoolLocation)
    {
        [self.layerManager switchToLayer:HotSpotTypeSchoolLocation
                               onMapView:self.mapView];
        hotSpotDetails = @[];
    }
    else
    {
        [self.layerManager switchToLayer:HotSpotTypeAllExceptSchool
                               onMapView:self.mapView];
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
    if ([marker isKindOfClass:[Marker class]])
    {
        Marker* animatedGMSMarker = (Marker*)marker;
        if (animatedGMSMarker)
        {
            if (animatedGMSMarker.hotSpotType == HotSpotTypeSchoolLocation)
            {
                [self.hotSpotDetailView configWithType:HotSpotTypeSchoolLocation
                                               andData:@{
                                                         @"name":animatedGMSMarker.locationName,
                                                      @"details":@[]
                                                         }];
            }
            else if (animatedGMSMarker.hotSpotType != HotSpotTypeCnt)
            {
                NSArray* hotSpotDetails = [self.dbManager getHotSpotDetailsByLocationCode:animatedGMSMarker.locationCode];
                [self.hotSpotDetailView configWithType:HotSpotTypeAllExceptSchool
                                               andData:@{
                                                         @"name":animatedGMSMarker.locationName,
                                                      @"details":hotSpotDetails
                                                         }];
            }
            else
            {
                NSLog(@"User did select unsupported marker type");
            }
        }
    }
    
    return YES;
}

@end
