//
//  MarkerManager.h
//  SmartTravel
//
//  Created by Gongwei on 15/5/5.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//
#import "HotSpot.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Foundation/Foundation.h>

@interface MarkerManager : NSObject

@property (nonatomic, strong) NSArray *markers;

- (void)drawMarkersOnMapView:(GMSMapView*)mapView;

- (void)eraseMarkersOnMapAndReleaseMarkers:(BOOL)releaeMarkers;

@end
