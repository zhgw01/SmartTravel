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

- (NSArray*)getWarningMessageAndReasonOfId:(int)reasonId;

@end
