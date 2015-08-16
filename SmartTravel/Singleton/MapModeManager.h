//
//  MapModeManager.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/14.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kMapModeChanged;

typedef enum {
   kMapModeUserApproachHotSpot   = -3,
   kMapModeUserHideHotSpotDetail = -2,
   kMapModeUserClickLocateMe     = -1,
   // Above are navigation trigger events
   // Under are view trigger events
   kMapModeUserGesture           = 1,
   kMapModeUserTapMarker         = 2,
   kMapModeUserClickHotSpot      = 3,
   kMapModeEventUnKnown          = 0
} kMapModeChangeEvent;

@interface MapModeManager : NSObject

+ (MapModeManager*)sharedInstance;

/**
 *  YES navigation mode; NO map mode
 */
@property (assign, nonatomic, readonly) BOOL isNavigationOn;

- (void)eventHappened:(kMapModeChangeEvent)event;

@end
