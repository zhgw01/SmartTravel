//
//  HotSpot.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/10/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HotSpotTypeIntersection,
    HotSpotTypeMidStreet,
    HotSpotTypeMidAvenue,
    HotSpotTypeSchoolZone,
    HotSpotTypeCnt
} HotSpotType;

@interface HotSpot : NSObject

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSNumber *count;
@property (nonatomic, copy) NSNumber *rank;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longtitude;

- (instancetype)initWithLocation:(NSString*)location
                           count:(int)count
                            rank:(int)rank
                        latitude:(double)latitude
                      longtitude:(double)longtitude;

+ (NSString*)toString:(HotSpotType)type;

@end