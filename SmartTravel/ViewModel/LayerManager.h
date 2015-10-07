//
//  LayerManager.h
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/27.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "HotSpot.h"
#import "MarkerManager.h"
#import "ShapeManager.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Foundation/Foundation.h>

@interface LayerManager : NSObject

@property (nonatomic, assign) HotSpotType    hotSpotType;
@property (nonatomic, strong) MarkerManager  *markerManager;
@property (nonatomic, strong) ShapeManager   *shapeManager;

- (BOOL)switchToLayer:(HotSpotType)hotSpotType
            onMapView:(GMSMapView*)mapView;

- (void)showShapesOnMapView:(GMSMapView*)mapView;

- (void)hideShapes;

@end
