//
//  AnimatedGMSMarker.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/23.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface AnimatedGMSMarker : GMSMarker

@property (strong, nonatomic) NSString* animationBaseName;

-(void)setAnimation:(NSString*)name
          forFrames:(NSArray*)frames;

-(void)stopAnimation:(NSString*)staticImageName;

@end
