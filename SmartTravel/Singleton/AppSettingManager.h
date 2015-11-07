//
//  AppSettingManager.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/23.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kRunCount;
extern NSString * const kIsWarningVoice;
extern NSString * const kIsAutoCheckUpdate;
extern NSString * const kShowNoInterfereUI;

@interface AppSettingManager : NSObject

+(AppSettingManager *)sharedInstance;

-(NSInteger)getRunCount;
-(void)setRunCount:(NSInteger)count;

-(BOOL)getIsWarningVoice;
-(void)setIsWarningVoice:(BOOL)flag;

-(BOOL)getIsAutoCheckUpdate;
-(void)setIsAutoCheckUpdate:(BOOL)flag;

-(BOOL)getShowNoInterfereUI;
-(void)setShowNoInterfereUI:(BOOL)flag;

@end
