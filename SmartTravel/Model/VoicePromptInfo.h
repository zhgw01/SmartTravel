//
//  VoicePromptInfo.h
//  SmartTravel
//
//  Created by chenpold on 9/7/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMaxSubWindowDuration (5)
#define kMaxWindowDuration (600)
#define kMaxPromptCount (2)

@interface VoicePromptInfo : NSObject

/**
 *  code of location
 */
@property (copy, nonatomic) NSString *locationCode;

/**
 *  no more than kMaxPromptCount prompts during kMaxWindowDuration
 */
@property (assign, nonatomic) NSTimeInterval windowStartTime;

/**
 *  last time when voice prompt
 */
@property (assign, nonatomic) NSTimeInterval lastTime;

/**
 *  prompt count
 */
@property (assign, nonatomic) int count;

/**
 *  can show warning view if YES
 */
@property (assign, nonatomic) BOOL canShowWarningView;

- (BOOL)exceedWindow:(NSTimeInterval)timeIntervalSince1970;

- (BOOL)exceedSubWindow:(NSTimeInterval)timeIntervalSince1970;

@end
