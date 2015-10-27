//
//  DBDateAdapter.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/12/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "DBDayTypeAdapter.h"
#import "DBConstants.h"
#import "DBManager.h"
#import "DateUtility.h"

static NSString * const kWeekdayColumn = @"Weekday";
static NSString * const kWeekendColumn = @"Weekend";
static NSString * const kSchooldayColumn = @"School_day";
static NSString * const kDateColumn = @"Date";

@interface DBDayTypeAdapter()

@property (assign, readwrite) BOOL isWeekDay;
@property (assign, readwrite) BOOL isWeekEnd;
@property (assign, readwrite) BOOL isSchoolDay;

@end

@implementation DBDayTypeAdapter

- (instancetype)initWith:(NSDate*)date
{
    if (self = [super init])
    {
        BOOL foundInDb = NO;
        
        FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfDB:DB_NAME_MAIN]];
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
                    self.isWeekEnd = [resultSet boolForColumn:kWeekendColumn];
                    self.isSchoolDay = [resultSet boolForColumn:kSchooldayColumn];
                    foundInDb = YES;
                }
            }
            [resultSet close];
            
            if (![db close])
            {
                NSAssert(NO, @"Close db failed");
            }
        }

        // iOS routine to judge if the date is week day
        if (!foundInDb)
        {
            self.isWeekDay = [DateUtility isDateWeekday:date];
            self.isWeekEnd = !self.isWeekDay;
            // NOTE: If the date is not found in db, assume isSchoolDay is the same with isWeekDay by default.
            self.isSchoolDay = self.isWeekDay;
        }
    }
    return self;
}

- (NSString*)constructSmt:(NSDate*)date
{    
    NSString* dateStr = [DateUtility getDateString:date];
    return [NSString stringWithFormat:@"select %@, %@, %@ from %@ where %@='%@'", kWeekdayColumn, kWeekendColumn, kSchooldayColumn, MAIN_DB_TBL_WM_DAYTYPE, kDateColumn, dateStr];
}

@end
