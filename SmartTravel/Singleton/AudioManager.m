//
//  AudioManager.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/7.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "AudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioManager () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *avAudioPlayer;

@end

@implementation AudioManager

+ (AudioManager*)sharedInstance
{
    static dispatch_once_t token;
    static AudioManager *instance;
    dispatch_once(&token, ^{
        instance = [[AudioManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.isPlaying = NO;
    }
    return self;
}

- (void)speekFromFile:(NSString*)audioPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioPath])
    {
        NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
        NSError *error = nil;
        
        self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
        self.avAudioPlayer.delegate = self;

        if (!error)
        {
            if (![self.avAudioPlayer prepareToPlay])
            {
                NSLog(@"%@", @"self.avAudioPlayer prepareToPlay failed");
            }
            [self.avAudioPlayer setVolume:1.0];
            [self.avAudioPlayer setNumberOfLoops:0];
            if ([self.avAudioPlayer play])
            {
                self.isPlaying = YES;
            }
            else
            {
                self.isPlaying = NO;
                NSLog(@"%@", @"self.avAudioPlay play failed");
            }
        }
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.isPlaying = NO;
}

@end
