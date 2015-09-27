//
//  ShapeManager.m
//  SmartTravel
//
//  Created by chenpold on 9/19/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//
#import "LocationCoordinate.h"
#import "ShapeManager.h"

@implementation ShapeManager

- (instancetype)init
{
    if (self = [super init])
    {
        self.defaultStrokeWidth = 2.f;
        self.defaultStrokeStyle = [GMSStrokeStyle solidColor:[UIColor redColor]];
    }
    return self;
}

- (NSArray*)createShapes
{
    // Override by sub class
    return nil;
}

- (void)drawShapesOnMapView:(GMSMapView*)mapView
{
    // Override by sub class
}

- (void)eraseShapesOnMapAndReleaseShapes:(BOOL)releaseShapes
{
    // Override by sub class
}

@end
