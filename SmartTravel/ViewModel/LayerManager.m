//
//  LayerManager.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/27.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "MarkerManagerFactory.h"
#import "LayerManager.h"

@implementation LayerManager

- (instancetype)init
{
    if (self = [super init])
    {
        self.hotSpotType = HotSpotTypeCnt;
    }
    return self;
}

- (BOOL)switchToLayer:(HotSpotType)hotSpotType
            onMapView:(GMSMapView*)mapView
{
    // Only support HotSpotTypeAllExceptSchoolZone and HotSpotTypeAllExceptSchoolZone
    if (hotSpotType != HotSpotTypeAllExceptSchoolZone &&
        hotSpotType != HotSpotTypeSchoolZone)
    {
        return NO;
    }
    
    if (self.hotSpotType == hotSpotType)
    {
        return NO;
    }
    
    [self.markerManager enable:NO
                     onMapView:mapView];
    
    self.markerManager = [MarkerManagerFactory createMarkerManager:hotSpotType];

    [self.markerManager enable:YES
                     onMapView:mapView];
    
    self.hotSpotType = hotSpotType;

    return YES;
}

@end
