//
//  ShapeManagerFactory.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/27.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "CollisionShapeManager.h"
#import "SchoolShapeManager.h"
#import "ShapeManagerFactory.h"

@implementation ShapeManagerFactory

+ (ShapeManager*)createShapeManager:(HotSpotType)hotSpotType
{
    ShapeManager *shapeManager = nil;
    switch (hotSpotType) {
        case HotSpotTypeSchoolZone:
            shapeManager = [[SchoolShapeManager alloc] init];
            break;
        case HotSpotTypeAllExceptSchoolZone:
            shapeManager = [[CollisionShapeManager alloc] init];
        default:
            break;
    }
    return shapeManager;
}

@end
