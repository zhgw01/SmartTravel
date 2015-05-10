//
//  HotSpot.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/10/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HotSpotTypeCollision,
    HotSpotTypeVRU,
    HotSpotTypeCnt
} HotSpotType;

@interface HotSpot : NSObject

@property (nonatomic, assign) HotSpotType type;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *locationCode;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSNumber *count;
@property (nonatomic, copy) NSNumber *rank;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longtitude;

- (instancetype)initWithType:(HotSpotType)type
                         tag:(NSString*)tag
                locationCode:(NSString*)locationCode
                    location:(NSString*)location
                       count:(NSNumber*)count
                        rank:(NSNumber*)rank
                    latitude:(NSNumber*)latitude
                  longtitude:(NSNumber*)longtitude;

@end