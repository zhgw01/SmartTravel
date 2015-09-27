//
//  ShapeManager.h
//  SmartTravel
//
//  Created by chenpold on 9/19/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
#import <Foundation/Foundation.h>

@interface ShapeManager : NSObject

@property (nonatomic, assign) CGFloat defaultStrokeWidth;

@property (nonatomic, strong) GMSStrokeStyle *defaultStrokeStyle;

@property (nonatomic, strong) NSArray *shapes;

- (void)drawShapesOnMapView:(GMSMapView*)mapView;

- (void)eraseShapesOnMapAndReleaseShapes:(BOOL)releaseShapes;

@end
