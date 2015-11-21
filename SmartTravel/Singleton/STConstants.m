//
//  STConstants.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/31.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "STConstants.h"

#pragma mark - Flurry event names

NSString * const kFlurryEventHotspotIgnored = @"Hotspot ignored without matched directions or associated reasons";
NSString * const kFlurryEventReasonNotMatchForInvalidMonthOrStartAndEndTime = @"Reason not match for invalidate month or start/end time";
NSString * const kFlurryEventNoVoicePromptForInActiveStatus = @"Voice not speak out for inactive status";
NSString * const kFlurryEventNoVoicePromptForDisabled = @"Voice not speak out for user turn it off";
NSString * const kFluryyEventNewDataVersionFound = @"New data version found";
NSString * const kFlurryEventCurrentLocationIsNotInMiddle = @"Current location is not in middle";
NSString * const kFlurryEventHotspotIngoredForLowerPriority = @"Hotspot ingored for lower priority";

#pragma mark - Keys of constants in constant.plist
NSString * const kConstantPlist = @"constant";
NSString * const kConstantPlistKeyOfServerBase = @"ServerBase";
NSString * const kConstantPlistKeyOfServerBaseDev = @"ServerBaseDev";
NSString * const kConstantPlistKeyOfReasonCategory = @"ReasonCategory";
