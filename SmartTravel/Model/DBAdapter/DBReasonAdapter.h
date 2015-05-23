//
//  DBReasonAdapter.h
//  SmartTravel
//
//  Created by chenpold on 5/14/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBReasonAdapter : NSObject

- (NSArray*)getReasonIDsOfDate:(NSDate*)date;

/**
 *  Get warning message of given reason id
 *
 *  @param reasonId reason id of int
 *
 *  @return warning message of NSString*
 */
- (NSString*)getWarningMessage:(int)reasonId;

@end
