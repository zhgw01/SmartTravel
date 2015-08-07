//
//  VoicePromptEngine.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/7.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kNNVPStatusHasBeenChanged;

typedef enum {
    kVoicePromptStatusClose       = 0,
    kVoicePromptStatusActive      = 1,
    kVoicePromptStatusUnActive    = 2,
    kVoicePromptStatusUnKnown     = 3
} VoicePromptStatus;

typedef enum {
    kVoicePromptEventUserCloseInSetting = 0,   // 语音提示从开启转变为关闭的条件为:用户在设置菜单中手动关闭此功能。
    kVoicePromptEventUserUseAppAgain    = 1,   // 语音提示从关闭自动转变为开启的条件为:用户再次使用 app。
    kVoicePromptEventUserStayStatic     = 2,   // 激活态转变为非激活态的条件为:用户是否在某地点半径 100 米范围内停留超过 30 分钟。
    kVoicePromptEventUserReachSpeed     = 3,    // 非激活态转变为激活态的条件为:用户再次使用 app 或者速度大于 20 公里每小 时。
    kVoicePromptEventUnKnown            = 4
} VoicePromptEvent;

@interface VoicePromptEngine : NSObject

+(VoicePromptEngine *)sharedInstance;

@property (assign, nonatomic) VoicePromptStatus status;

- (void)eventHappend:(VoicePromptEvent)event;

@end
