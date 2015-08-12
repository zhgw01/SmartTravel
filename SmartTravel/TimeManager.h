//
//  TimeManager.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/12.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManager : NSObject

+ (TimeManager*)sharedInstance;

- (void)reset;
- (NSTimeInterval)timeIntervalFromBenchmark;

@end
