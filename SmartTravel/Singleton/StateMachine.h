//
//  StateMachine.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/7.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kStatusHasBeenChanged;

typedef enum {
    kStateClose       = 0,
    kStateActive      = 1,
    kStateInactive    = 2,
    kStateUnKnown     = 3
} StateMachineState;

typedef enum {
    kEventUserDisable      = 0,// 语音提示从开启转变为关闭的条件为:用户在设置菜单中手动关闭此功能。
    kEventUserUse          = 1,// 语音提示从关闭自动转变为开启的条件为:用户再次使用app。
    kEventUserStay         = 2,// 激活态转变为非激活态的条件为:用户是否在某地点半径100米范围内停留超过30分钟。
    kEventUserMove         = 3,// 非激活态转变为激活态的条件为:用户再次使用app或者速度大于20公里每小时。
    kEventUserResignActive = 4,// 语音提示从开启自动转变为关闭的条件为:用户暂停app。
    kEventUnKnown          = 5
} StateMachineEvent;

@interface StateMachine : NSObject

+(StateMachine *)sharedInstance;

@property (assign, nonatomic) StateMachineState status;

- (void)eventHappend:(StateMachineEvent)event;

@end
