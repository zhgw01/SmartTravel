//
//  TimeManager.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/12.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "TimeManager.h"

@interface TimeManager ()

@property (strong, nonatomic) NSDate* benchmark;

@end

@implementation TimeManager

+ (TimeManager*)sharedInstance
{
    static TimeManager* instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[TimeManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.benchmark = [NSDate date];
    }
    return self;
}

- (void)reset
{
    self.benchmark = [NSDate date];
}

- (NSTimeInterval)timeIntervalFromBenchmark
{
    return [[NSDate date] timeIntervalSinceDate:self.benchmark];
}

@end
