//
//  MarkerManagerFactory.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/27.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "CollisionMarkerManager.h"
#import "SchoolMarkerManager.h"
#import "MarkerManager.h"
#import "MarkerManagerFactory.h"

@implementation MarkerManagerFactory

+ (MarkerManager*)createMarkerManager:(HotSpotType)type
{
    MarkerManager *markerManager = nil;
    switch (type) {
        case HotSpotTypeAllExceptSchoolZone:
            markerManager = [[CollisionMarkerManager alloc] init];
            break;
        case HotSpotTypeSchoolZone:
            markerManager = [[SchoolMarkerManager alloc] init];
            break;
        default:
            break;
    }
    return markerManager;
}

@end
