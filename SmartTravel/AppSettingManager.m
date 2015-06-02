//
//  AppSettingManager.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/23.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "AppSettingManager.h"

static NSString * const kRunCount = @"run-count";
static NSString * const kIsWarningVoice = @"is-warning-voice";
static NSString * const kIsAutoCheckUpdate = @"is-auto-check-update";

@implementation AppSettingManager

+ (AppSettingManager *)sharedInstance
{
    static AppSettingManager *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

-(NSInteger)getRunCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kRunCount];
}

-(void)setRunCount:(NSInteger)count
{
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:kRunCount];
}

-(BOOL)getIsWarningVoice
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsWarningVoice];
}

-(void)setIsWarningVoice:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:kIsWarningVoice];
}

-(BOOL)getIsAutoCheckUpdate
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsAutoCheckUpdate];
}

-(void)setIsAutoCheckUpdate:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:kIsAutoCheckUpdate];
}

@end
