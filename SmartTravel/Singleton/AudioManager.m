//
//  AudioManager.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/7.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "AudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioManager ()

@property (strong, nonatomic) AVSpeechSynthesizer *avSpeechSynthesizer;
@property (strong, nonatomic) AVSpeechSynthesisVoice *avSpeechSynthesisVoice;
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
        self.avSpeechSynthesizer = [[AVSpeechSynthesizer alloc] init];
        self.avAudioPlayer = [[AVAudioPlayer alloc] init];
    }
    return self;
}

- (void)speekText:(NSString*)text
{
    AVSpeechUtterance *avSpeechUtterance = [[AVSpeechUtterance alloc] initWithString:text];
    avSpeechUtterance.rate = 0.6;
    [self.avSpeechSynthesizer speakUtterance:avSpeechUtterance];
}

- (void)speekFromFile:(NSString*)audioPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioPath])
    {
        NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
        NSError *error = nil;
        
        if ([self.avAudioPlayer isPlaying])
        {
            [self.avAudioPlayer stop];
        }
        
        self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
        
        if (!error)
        {
            [self.avAudioPlayer prepareToPlay];
            [self.avAudioPlayer setVolume:1.0];
            [self.avAudioPlayer setNumberOfLoops:0];
            [self.avAudioPlayer play];
        }
    }
}

- (BOOL)isSlient:(float)lowBoundary
{
    return self.avAudioPlayer.volume < lowBoundary ;
}

@end
