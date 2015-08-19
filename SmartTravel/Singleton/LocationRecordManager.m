//
//  TimeManager.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/12.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "LocationRecordManager.h"
#import "LocationRecord.h"
#import "Queue.h"

@interface LocationRecordManager ()

@property (strong, nonatomic) Queue *locationRecordQueue;

@end

@implementation LocationRecordManager

+ (LocationRecordManager*)sharedInstance
{
    static LocationRecordManager* instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[LocationRecordManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.locationRecordQueue = [[Queue alloc] init];
    }
    return self;
}

- (void)record:(CLLocation*)location
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    LocationRecord *locationRecord = [[LocationRecord alloc] initWithTimeStamp:timeStamp
                                                                   andLocation:location];
    [self.locationRecordQueue enqueue:locationRecord];
}

- (NSTimeInterval)duration
{
    if (self.locationRecordQueue.length < 2)
    {
        return 0;
    }
    
    LocationRecord *oldest = [self.locationRecordQueue getHead];
    LocationRecord *newest = [self.locationRecordQueue getTail];
    
    return (newest.timeStamp - oldest.timeStamp);
}

- (BOOL)distance:(double*)value
{
    if (self.locationRecordQueue.length < 2)
    {
        return NO;
    }
    
    double minLon, minLat, maxLon, maxLat;
    LocationRecord *lr = [self.locationRecordQueue get:0];
    minLon = maxLon = lr.location.coordinate.longitude;
    minLat = maxLat = lr.location.coordinate.latitude;
    
    for (NSUInteger idx = 1; idx < self.locationRecordQueue.length; ++idx)
    {
        LocationRecord *cur = [self.locationRecordQueue get:idx];
        double curLon = cur.location.coordinate.longitude;
        double curLat = cur.location.coordinate.latitude;
        if (curLon < minLon) minLon = curLon;
        if (curLon > maxLon) maxLon = curLon;
        if (curLat < minLat) minLat = curLat;
        if (curLat > maxLat) maxLat = curLat;
    }
    
    CLLocation *leftUp = [[CLLocation alloc] initWithLatitude:minLat longitude:minLon];
    CLLocation *rightDown = [[CLLocation alloc] initWithLatitude:maxLat longitude:maxLon];
    
    *value = [leftUp distanceFromLocation:rightDown];
    return YES;
}

- (BOOL)shrinkWithinDuration:(NSTimeInterval)duration
{
    if ([self duration] <= duration)
    {
        return NO;
    }

    NSUInteger lengthBeforeShrink = [self.locationRecordQueue length];
    if (lengthBeforeShrink <= 2)
    {
        return NO;
    }
    
    LocationRecord *newest = [self.locationRecordQueue getTail];
    NSTimeInterval newestTimeStamp = newest.timeStamp;

    LocationRecord *oldest = [self.locationRecordQueue getHead];
    while ((newestTimeStamp - oldest.timeStamp) > duration &&
           self.locationRecordQueue.length > 2)
    {
        // Try to dequeue oldest record
        oldest = [self.locationRecordQueue dequeue];
        
        LocationRecord *nextOldest = [self.locationRecordQueue getHead];
        // If next oldest record failes to satisfy duration requirement,
        // put back the oldest record and stop.
        if (!nextOldest ||
            (newestTimeStamp - nextOldest.timeStamp) <= duration)
        {
            [self.locationRecordQueue enqueue:oldest];
            break;
        }

        // Update oldest record
        oldest = nextOldest;
    }
    
    return [self.locationRecordQueue length] < lengthBeforeShrink;
}

- (void)reset
{
    [self.locationRecordQueue clear];
}

@end
