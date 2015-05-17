//
//  DateUtility.h
//  SmartTravel
//
//  Created by chenpold on 5/17/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtility : NSObject

+ (BOOL)isDateWeekday:(NSDate*)date;

+ (BOOL)isDateMatched:(NSDate*)date
                month:(NSString*)monthStr
            startTime:(NSString*)startTimeStr
              endTime:(NSString*)endTimeStr;

// Return date string of format "yyyy-MM-dd"
+ (NSString*)getDateString:(NSDate*)date;

@end
