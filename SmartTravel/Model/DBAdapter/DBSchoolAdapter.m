//
//  DBSchoolAdapter.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/26.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import <FMDB/FMDB.h>
#import "DBSchoolAdapter.h"
#import "DBManager.h"
#import "DBConstants.h"

NSString * const kColId = @"id";
NSString * const kColLongitude = @"longitude";
NSString * const kColLatitude = @"latitude";
NSString * const kColSzSegments = @"sz_segments";

@implementation DBSchoolAdapter

- (NSArray*)selectAllSchools
{    
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfMainDB]];
    if ([db open])
    {
        NSString *selectSmt = [NSString stringWithFormat:@"SELECT %@, %@, %@, %@ FROM %@", kColId, kColLongitude, kColLatitude, kColSzSegments, MAIN_DB_TBL_SCHOOL];
        
        FMResultSet* resultSet = [db executeQuery:selectSmt];
        NSError* error = nil;
        while([resultSet nextWithError:&error])
        {
            NSDictionary *dic = @{
                                  kColId: [resultSet objectForColumnName:kColId],
                                  kColLongitude : [resultSet objectForColumnName:kColLongitude],
                                  kColLatitude : [resultSet objectForColumnName:kColLatitude],
                                  kColSzSegments : [resultSet objectForColumnName:kColSzSegments]
                                  };
            [res addObject:dic];
        }
        [resultSet close];
        
        if (![db close])
        {
            NSAssert(NO, @"Close db failed");
        }
    }
    
    return [res copy];
}

@end
