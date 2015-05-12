//
//  DBDateAdapter.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/12/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "DBDateAdapter.h"
#import "DBManager.h"

static NSString * const kWeekdayColumn = @"Weekday";
static NSString * const kSchooldayColumn = @"School_day";

@interface DBDateAdapter()

@property (assign, readwrite) BOOL isWeekDay;
@property (assign, readwrite) BOOL isSchoolDay;

@end

@implementation DBDateAdapter

- (instancetype)initWith:(NSDate*)date
{
    if (self = [super init])
    {
        BOOL foundInDb = NO;
        
        FMDatabase* db = [[DBManager sharedInstance] mainDb];
        if (date && [db open])
        {
            NSString* smt = [self constructSmt:date];
            FMResultSet* resultSet = [db executeQuery:smt];
            NSError* error = nil;
            if ([resultSet nextWithError:&error])
            {
                if (!error)
                {
                    self.isWeekDay = [resultSet boolForColumn:kWeekdayColumn];
                    self.isSchoolDay = [resultSet boolForColumn:kSchooldayColumn];
                    foundInDb = YES;
                }
            }
            
            [db close];
        }

        // iOS routine to judge if the date is week day
        if (!foundInDb)
        {
            self.isWeekDay = [self isDateWeekday:date];
            // NOTE: If the date is not found in db, assume it's NOT school day by default.
            self.isSchoolDay = NO;
        }
    }
    return self;
}

- (NSString*)constructSmt:(NSDate*)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString* dateStr = [dateFormat stringFromDate:date];
    return [NSString stringWithFormat:@"select %@, %@ from %@ where Date='%@'", kWeekdayColumn, kSchooldayColumn,  MAIN_DB_TBL_WM_DAYTYPE, dateStr];
}

- (BOOL)isDateWeekday:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
    NSDateComponents* components = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    NSUInteger weekdayOfDate = [components weekday];
    
    if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
