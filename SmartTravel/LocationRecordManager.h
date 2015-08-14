//
//  TimeManager.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/12.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kHalfHour 1800
#define kNoticeableSpeed (20.0/3.6)

@interface LocationRecordManager : NSObject

+ (LocationRecordManager*)sharedInstance;

- (void)record:(CLLocation*)location;

/**
 *  duration between oldest location record and newest location record
 *
 *  @return time inverval
 */
- (NSTimeInterval)duration;

/**
 *  distance between westest/northest location and easted/sourthest location
 *
 *  @return YES if there're more than one location record and \
 *      distance in meters will be returned in value
 */
- (BOOL)distance:(double*)value;

/**
 *  Try to shrink location records size within given duration to reduce memory occupation.
 *
 *  @param timeInterval all records should be within this duration
 *  @return whether there're records removed
 */
- (BOOL)shrinkWithinDuration:(NSTimeInterval)duration;

@end
