//
//  MapModeManager.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/14.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "MapModeManager.h"

@interface MapModeManager ()

@property (assign, nonatomic, readwrite) BOOL isNavigationOn;

@end

@implementation MapModeManager

+ (MapModeManager*)sharedInstance
{
    static MapModeManager *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[MapModeManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.isNavigationOn = YES;
    }
    return self;
}

- (void)eventHappened:(kMapModeChangeEvent)event
{
    if (event == kMapModeUserApproachHotSpot ||
        event == kMapModeUserHideHotSpotDetail ||
        event == kMapModeUserClickLocateMe)
    {
        self.isNavigationOn = YES;
    }
    else if (event == kMapModeUserGesture ||
             event == kMapModeUserTapMarker ||
             event == kMapModeUserClickHotSpot)
    {
        self.isNavigationOn = NO;
    }
    else
    {
        NSLog(@"Unkown map mode change event");
    }
}

@end
