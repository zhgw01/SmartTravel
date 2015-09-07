//
//  LocationVoicePromptInfo.h
//  SmartTravel
//
//  Created by chenpold on 9/7/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMaxWindowDuration (6000)
#define kMaxPromptCount (3)

@interface LocationVoicePromptInfo : NSObject

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

- (BOOL)exceedWindow:(NSDate*)now;

@end
