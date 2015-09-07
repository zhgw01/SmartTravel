//
//  LocationVoicePromptInfo.m
//  SmartTravel
//
//  Created by chenpold on 9/7/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "LocationVoicePromptInfo.h"

@implementation LocationVoicePromptInfo

- (instancetype)init
{
    if (self = [super init])
    {
        self.locationCode = @"";
        self.windowStartTime = [[NSDate date] timeIntervalSince1970] - kMaxWindowDuration;
        self.lastTime = self.windowStartTime;
        self.count = 0;
    }
    return self;
}

- (BOOL)exceedWindow:(NSDate*)now
{
    return ([now timeIntervalSince1970] - self.windowStartTime) > kMaxWindowDuration;
}

@end
