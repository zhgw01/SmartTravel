//
//  CircleMarker.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "CircleMarker.h"

@interface CircleMarker ()


@end

@implementation CircleMarker


- (void) loadImages
{
    NSUInteger imageNumber = 8;
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:imageNumber];
    
    for (NSUInteger i = 1; i <= imageNumber; ++i) {
        NSString* imageName = [NSString stringWithFormat:@"loading-%lu", (unsigned long)i];
        UIImage* image = [UIImage imageNamed:imageName];
        [imageArray addObject:image];
    }
    
    self.icon = [UIImage animatedImageWithImages:imageArray duration:1];
}


@end
