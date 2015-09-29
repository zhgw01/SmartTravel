//
//  AnimatedGMSMarker.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/23.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//
#import "HotSpot.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AnimatedGMSMarker : GMSMarker

@property (copy, nonatomic) NSString* locationCode;
@property (copy, nonatomic) NSString* locationName;
@property (assign, nonatomic) HotSpotType hotSpotType;

-(void)setAnimation:(NSString*)name
          forFrames:(NSArray*)frames;

-(void)stopAnimation:(NSString*)staticImageName;

@end
