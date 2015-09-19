//
//  VoicePromptInfo.m
//  SmartTravel
//
//  Created by chenpold on 9/7/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "VoicePromptInfo.h"

@implementation VoicePromptInfo

- (instancetype)init
{
    if (self = [super init])
    {
        self.canShowWarningView = NO;
        self.locationCode       = @"";
        self.windowStartTime    = [[NSDate date] timeIntervalSince1970] - kMaxWindowDuration;
        self.lastTime           = self.windowStartTime;
        self.lastDistance       = MAXFLOAT;
        self.count              = 0;
    }
    return self;
}

- (BOOL)exceedWindow:(NSTimeInterval)timeIntervalSince1970
{
    return (timeIntervalSince1970 - self.windowStartTime) > kMaxWindowDuration;
}

- (BOOL)exceedSubWindow:(NSTimeInterval)timeIntervalSince1970;
{
    return (timeIntervalSince1970 - self.lastTime) > kMaxSubWindowDuration;
}

@end
