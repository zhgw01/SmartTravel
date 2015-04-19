//
//  TermUsage.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/19.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "TermUsage.h"

@implementation TermUsage

#define TermOfUsageKey @"TermOfUsage"

+ (BOOL) agree
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:TermOfUsageKey];
}

+ (void) setAgree:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:TermOfUsageKey];
}

@end
