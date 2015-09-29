//
//  AnimatedGMSMarker.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/23.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "AnimatedGMSMarker.h"

@interface AnimatedGMSMarker ()

@property (copy, nonatomic) NSString* animationBaseName;
@property (assign, nonatomic) int currentFrame;
@property (strong, nonatomic) NSArray* frameArray;
@property (strong, nonatomic) NSTimer* timer;

@end

@implementation AnimatedGMSMarker

-(void)setAnimation:(NSString *)name
          forFrames:(NSArray *)frames
{
    self.frameArray = frames;
    self.currentFrame = 0;
    self.animationBaseName = name;
    self.icon = [self getImage:self.animationBaseName ofIndex:self.currentFrame];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/15.0f
                                                  target:self
                                                selector:@selector(onRefreshTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)stopAnimation:(NSString*)staticImageName
{
    [self.timer invalidate];
    self.timer = nil;
    self.currentFrame = 0;
    
    self.icon = [UIImage imageNamed:staticImageName];
}

-(void)onRefreshTimer:(NSTimer*)timer
{
    self.icon = [self getImage:self.animationBaseName ofIndex:self.currentFrame];
    self.currentFrame += 1;
    if (self.currentFrame >= self.frameArray.count)
    {
        self.currentFrame = 0;
    }
}

-(UIImage*)getImage:(NSString*)baseName
            ofIndex:(int)idx
{
    NSString* frame = self.frameArray[idx];
    NSString* imageName = [NSString stringWithFormat:@"%@%@", baseName, frame];
    return [UIImage imageNamed:imageName];
}

@end
