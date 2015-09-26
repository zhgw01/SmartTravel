//
//  LocationCoordinate.h
//  SmartTravel
//
//  Created by chenpold on 9/19/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationCoordinate : NSObject<NSCopying>

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

- (instancetype)initWithLatitude:(double)latitude
                    andLongitude:(double)logitude;

- (id)copyWithZone:(NSZone *)zone;

+ (NSArray*)parseSegmentsFromString:(NSString*)string;

@end
