//
//  VoicePromptEngine.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/7.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "VoicePromptEngine.h"

// Notification name of voice prompt status has been changed
NSString * const kNNVPStatusHasBeenChanged = @"kNNVPStatusHasBeenChanged";

@implementation VoicePromptEngine

+(VoicePromptEngine *)sharedInstance
{
    static VoicePromptEngine *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.status = kVoicePromptStatusActive;
    }
    return self;
}

- (void)reset
{
    self.status = kVoicePromptStatusActive;
    [self postStatus];
}

- (void)postStatus
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNNVPStatusHasBeenChanged
                                                        object:nil
                                                      userInfo:@{@"status" : @(self.status)}];
}

- (void)eventHappend:(VoicePromptEvent)event
{
    switch (self.status) {
        case kVoicePromptStatusClose:
            [self eventHappendWhenEngineOnCloseStatus:event];
            break;
        case kVoicePromptStatusActive:
            [self eventHappendWhenEngineOnUnActiveStatus:event];
            break;
        case kVoicePromptStatusUnActive:
            [self eventHappendWhenEngineOnUnActiveStatus:event];
            break;
        case kVoicePromptStatusUnKnown:
        default:
            [self eventHappendWhenEngineOnUnKnownStatus:event];
            break;
    }
}

- (void)ignoreEvent:(VoicePromptEvent)event
{
    NSLog(@"event %@ ignore under status %@",
          [VoicePromptEngine eventToString:event],
          [VoicePromptEngine statusToString:self.status]);
}

- (void)eventHappendWhenEngineOnCloseStatus:(VoicePromptEvent)event
{
    switch (event) {
        case kVoicePromptEventUserCloseInSetting:
            [self ignoreEvent:event];
            break;
        case kVoicePromptEventUserUseAppAgain:
            self.status = kVoicePromptStatusActive;
            [self postStatus];
            break;
        case kVoicePromptEventUserStayStatic:
            [self ignoreEvent:event];
            break;
        case kVoicePromptEventUserReachSpeed:
            [self ignoreEvent:event];
            break;
        case kVoicePromptEventUnKnown:
        default:
            NSAssert(NO, @"Voice prompt engine can't be response to unknown event");
            [self reset];
            break;
    }
}

- (void)eventHappendWhenEngineOnActiveStatus:(VoicePromptEvent)event
{
    switch (event) {
        case kVoicePromptEventUserCloseInSetting:
            [self ignoreEvent:event];
            break;
        case kVoicePromptEventUserUseAppAgain:
            [self ignoreEvent:event];
            break;
        case kVoicePromptEventUserStayStatic:
            self.status = kVoicePromptStatusUnActive;
            [self postStatus];
            break;
        case kVoicePromptEventUserReachSpeed:
            [self ignoreEvent:event];
            break;
        case kVoicePromptEventUnKnown:
        default:
            NSAssert(NO, @"Voice prompt engine can't be response to unknown event");
            [self reset];
            break;
    }
}

- (void)eventHappendWhenEngineOnUnActiveStatus:(VoicePromptEvent)event
{
    switch (event) {
        case kVoicePromptEventUserCloseInSetting:
            [self ignoreEvent:event];
            break;
        case kVoicePromptEventUserUseAppAgain:
            self.status = kVoicePromptStatusActive;
            [self postStatus];
            break;
        case kVoicePromptEventUserStayStatic:
            [self ignoreEvent:event];
            break;
        case kVoicePromptEventUserReachSpeed:
            self.status = kVoicePromptStatusActive;
            [self postStatus];
            break;
        case kVoicePromptEventUnKnown:
        default:
            NSAssert(NO, @"Voice prompt engine can't be response to unknown event");
            [self reset];
            break;
    }
}

- (void)eventHappendWhenEngineOnUnKnownStatus:(VoicePromptEvent)event
{
    NSAssert(NO, @"Voice prompt engine is on unknown status");
    [self reset];
}

#pragma mark - Utilties
+ (NSString*)statusToString:(VoicePromptStatus)status
{
    switch (status) {
        case kVoicePromptStatusActive:
            return @"active status";
        case kVoicePromptStatusClose:
            return @"close status";
        case kVoicePromptStatusUnActive:
            return @"un active status";
        case kVoicePromptStatusUnKnown:
        default:
            return @"unknown status";
    }
    return nil;
}

+ (NSString*)eventToString:(VoicePromptEvent)event
{
    switch (event) {
        case kVoicePromptEventUserCloseInSetting:
            return @"UserCloseInSetting";
        case kVoicePromptEventUserUseAppAgain:
            return @"UserUseAppAgain";
        case kVoicePromptEventUserStayStatic:
            return @"UserStayStatic";
        case kVoicePromptEventUserReachSpeed:
            return @"UserReachSpeed";
        case kVoicePromptEventUnKnown:
        default:
            return @"unknown event";
    }
    return nil;
}

@end
