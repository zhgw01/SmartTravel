//
//  AppSettingManager.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/23.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettingManager : NSObject

+(AppSettingManager *)sharedInstance;

-(NSInteger)getRunCount;
-(void)setRunCount:(NSInteger)count;

-(BOOL)getIsWarningVoice;
-(void)setIsWarningVoice:(BOOL)flag;

-(BOOL)getIsAutoCheckUpdate;
-(void)setIsAutoCheckUpdate:(BOOL)flag;

@end
