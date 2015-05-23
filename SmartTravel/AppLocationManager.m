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

-(instancetype)init
{
    if (self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

-(void)requestWhenInUserAuthorization
{
    [self.locationManager requestWhenInUseAuthorization];
}

-(void)setDelegate:(id<CLLocationManagerDelegate>)delegate
{
    self.locationManager.delegate = delegate;
}

-(void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

-(void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

-(void)startUpdatingHeading
{
    [self.locationManager startUpdatingHeading];
}

-(void)stopUpdatingHeading
{
    [self.locationManager stopUpdatingHeading];
}

@end
