//
//  AppLocationManager.m
//  SmartTravel
//
//  Created by ChenPengyu on 15/5/23.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <CoreLocation/CLLocationManager.h>
#import "AppLocationManager.h"

@interface AppLocationManager ()

@property (assign, nonatomic, readwrite) BOOL updatingLocationEnabled;
@property (assign, nonatomic, readwrite) BOOL updatingHeadingEnabled;
@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation AppLocationManager

+(AppLocationManager *)sharedInstance
{
    static AppLocationManager *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

+(CLAuthorizationStatus)authorizationStatus
{
    return [CLLocationManager authorizationStatus];
}

-(instancetype)init
{
    if (self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.updatingLocationEnabled = NO;
        self.updatingHeadingEnabled = NO;
    }
    return self;
}

-(void)requestAlwaysAuthorization
{
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
        
    if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
    {
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
}

-(void)setDelegate:(id<CLLocationManagerDelegate>)delegate
{
    self.locationManager.delegate = delegate;
}

-(void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
    self.updatingLocationEnabled = YES;
}

-(void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
    self.updatingLocationEnabled = NO;
}

-(void)startUpdatingHeading
{
    [self.locationManager startUpdatingHeading];
    self.updatingHeadingEnabled = YES;
}

-(void)stopUpdatingHeading
{
    [self.locationManager stopUpdatingHeading];
    self.updatingHeadingEnabled = NO;
}

@end
