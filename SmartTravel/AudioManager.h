//
//  AudioManager.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/7.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

+ (AudioManager*)sharedInstance;
- (void)speekText:(NSString*)text;
- (void)speekFromFile:(NSString*)audioPath;
- (BOOL)isSlient:(float)lowBoundary;

@end
