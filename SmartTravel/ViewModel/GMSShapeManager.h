//
//  GMSShapeManager.h
//  SmartTravel
//
//  Created by chenpold on 9/19/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
#import <Foundation/Foundation.h>

@interface GMSShapeManager : NSObject

- (void)drawSegments:(NSArray*)segments
               onMap:(GMSMapView*)map;

- (void)removeAllSegmentsOnMap:(GMSMapView*)map;

@end
