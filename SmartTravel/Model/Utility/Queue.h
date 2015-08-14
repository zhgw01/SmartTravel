//
//  Queue.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/14.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject

/**
 *  element enqueue
 *
 *  @param obj element
 */
- (void)enqueue:(id)obj;

/**
 *  element dequeue
 *
 *  @return element
 */
- (id)dequeue;

/**
 *  get head element in queue
 *
 *  @return element at head
 */
- (id)getHead;

/**
 *  get tail element in queue
 *
 *  @return element at tail
 */
- (id)getTail;

/**
 *  clear all elements in queue
 */
- (void)clear;

/**
 *  get queue length
 *
 *  @return length of queue
 */
- (NSUInteger)length;

/**
 *  get element of index
 *
 *  @param index
 *
 *  @return element
 */
- (id)get:(NSUInteger)index;

@end
