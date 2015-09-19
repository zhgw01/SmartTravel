//
//  MarkerManager.h
//  SmartTravel
//
//  Created by Gongwei on 15/5/5.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//
#import "HotSpot.h"
#import "Marker.h"
#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MarkerManager : NSObject

- (instancetype)initWithType:(HotSpotType)type;

- (void)detachGMSMapView;
- (void)attachGMSMapView:(GMSMapView*)mapView;

- (void)breath:(NSString*)locationCode;
- (void)stopBreath;

- (void)changeType:(HotSpotType)type
       withMapView:(GMSMapView*)mapView;

@end
