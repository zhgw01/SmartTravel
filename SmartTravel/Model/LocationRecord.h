//
//  LocationRecord.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/14.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationRecord : NSObject<NSCopying>

@property (assign, nonatomic) NSTimeInterval timeStamp;

@property (copy, nonatomic) CLLocation *location;

- (instancetype)initWithTimeStamp:(NSTimeInterval)timeStamp
                      andLocation:(CLLocation*)location;

@end