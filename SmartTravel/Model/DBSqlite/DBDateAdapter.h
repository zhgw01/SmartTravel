//
//  DBDateAdapter.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/12/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBDateAdapter : NSObject

- (instancetype)initWith:(NSDate*)date;

@property (assign, readonly) BOOL isWeekDay;
//@property (assign, readonly) BOOL isWeekEnd;
@property (assign, readonly) BOOL isSchoolDay;


@end
