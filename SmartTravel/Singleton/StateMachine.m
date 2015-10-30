//
//  StateMachine.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/7.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "StateMachine.h"

// Notification name of status has been changed
NSString * const kStatusHasBeenChanged = @"kStatusHasBeenChanged";

@implementation StateMachine

+(StateMachine *)sharedInstance
{
    static StateMachine *sharedSingleton = nil;
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
        [self reset];
    }
    return self;
}

- (void)reset
{
    self.status = kStateActive;
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusHasBeenChanged
                                                        object:nil
                                                      userInfo:@{@"status" : @(self.status)}];
}

- (void)eventHappend:(StateMachineEvent)event
{
    StateMachineState preStatus = self.status;
    switch (self.status) {
        case kStateClose:
            [self eventHappendWhenEngineOnCloseStatus:event];
            break;
        case kStateActive:
            [self eventHappendWhenEngineOnActiveStatus:event];
            break;
        case kStateInactive:
            [self eventHappendWhenEngineOnInactiveStatus:event];
            break;
        case kStateUnKnown:
        default:
            [self eventHappendWhenEngineOnUnKnownStatus:event];
            break;
    }
    if (preStatus != self.status)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kStatusHasBeenChanged
                                                            object:nil
                                                          userInfo:@{@"status" : @(self.status)}];
    }
}

- (void)ignoreEvent:(StateMachineEvent)event
{
    NSLog(@"event %@ ignored under status %@",
          [StateMachine eventToString:event],
          [StateMachine statusToString:self.status]);
}

- (void)eventHappendWhenEngineOnCloseStatus:(StateMachineEvent)event
{
    switch (event) {
        case kEventUserDisable:
            [self ignoreEvent:event];
            break;
        case kEventUserUse:
            self.status = kStateActive;
            break;
        case kEventUserStay:
            [self ignoreEvent:event];
            break;
        case kEventUserMove:
            [self ignoreEvent:event];
            break;
        case kEventUnKnown:
        default:
            NSAssert(NO, @"State machine can't answer unknown event");
            [self reset];
            break;
    }
}

- (void)eventHappendWhenEngineOnActiveStatus:(StateMachineEvent)event
{
    switch (event) {
        case kEventUserDisable:
            [self ignoreEvent:event];
            break;
        case kEventUserUse:
            [self ignoreEvent:event];
            break;
        case kEventUserStay:
            self.status = kStateInactive;
            break;
        case kEventUserMove:
            [self ignoreEvent:event];
            break;
        case kEventUnKnown:
        default:
            NSAssert(NO, @"State machien can't answer unknown event");
            [self reset];
            break;
    }
}

- (void)eventHappendWhenEngineOnInactiveStatus:(StateMachineEvent)event
{
    switch (event) {
        case kEventUserDisable:
            [self ignoreEvent:event];
            break;
        case kEventUserUse:
            self.status = kStateActive;
            break;
        case kEventUserStay:
            [self ignoreEvent:event];
            break;
        case kEventUserMove:
            self.status = kStateActive;
            break;
        case kEventUnKnown:
        default:
            NSAssert(NO, @"State machine can't answer unknown event");
            [self reset];
            break;
    }
}

- (void)eventHappendWhenEngineOnUnKnownStatus:(StateMachineEvent)event
{
    NSAssert(NO, @"State machine is on unknown status");
    [self reset];
}

#pragma mark - Utilties
+ (NSString*)statusToString:(StateMachineState)status
{
    switch (status) {
        case kStateActive:
            return @"active status";
        case kStateClose:
            return @"close status";
        case kStateInactive:
            return @"inactive status";
        case kStateUnKnown:
        default:
            return @"unknown status";
    }
    return nil;
}

+ (NSString*)eventToString:(StateMachineEvent)event
{
    switch (event) {
        case kEventUserDisable:
            return @"kEventUserDisable";
        case kEventUserUse:
            return @"kEventUserUse";
        case kEventUserStay:
            return @"kEventUserStay";
        case kEventUserMove:
            return @"kEventUserMove";
        case kEventUnKnown:
        default:
            return @"kEventUnKnown";
    }
    return nil;
}

@end
