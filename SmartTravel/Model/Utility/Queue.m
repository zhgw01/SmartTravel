//
//  Queue.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/14.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "Queue.h"

@interface Queue ()

@property (strong, nonatomic) NSMutableArray *container;

@end

@implementation Queue

- (instancetype)init
{
    if (self = [super init])
    {
        self.container = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)enqueue:(id)obj
{
    [self.container addObject:obj];
}

- (id)dequeue
{
    if (self.container.count == 0)
    {
        return nil;
    }
    
    id res = [[self.container objectAtIndex:0] copy];
    [self.container removeObjectAtIndex:0];
    return res;
}

- (id)getHead
{
    if (self.container.count == 0)
    {
        return nil;
    }
    
    return [[self.container objectAtIndex:0] copy];
}

- (id)getTail
{
    if (self.container.count == 0)
    {
        return nil;
    }
    
    return [[self.container objectAtIndex:(self.container.count - 1)] copy];
}

- (void)clear
{
    [self.container removeAllObjects];
}

- (NSUInteger)length
{
    return self.container.count;
}

- (id)get:(NSUInteger)index
{
    return [self.container objectAtIndex:index];
}

@end
