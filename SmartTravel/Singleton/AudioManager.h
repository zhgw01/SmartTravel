//
//  AudioManager.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/7.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

@property (assign, nonatomic) BOOL isPlaying;

+ (AudioManager*)sharedInstance;

- (void)speekFromFile:(NSString*)audioPath;

@end
