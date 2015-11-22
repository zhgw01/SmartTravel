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
NSString * const kColSchoolName = @"school_name";

@implementation DBSchoolAdapter

- (NSArray*)selectAllSchools
{    
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfDB:DB_NAME_MAIN]];
    if ([db open])
    {
        NSString *selectSmt = [NSString stringWithFormat:@"SELECT %@, %@, %@, %@, %@ FROM %@", kColId, kColLongitude, kColLatitude, kColSzSegments, kColSchoolName, TBL_SCHOOL];
        
        FMResultSet* resultSet = [db executeQuery:selectSmt];
        NSError* error = nil;
        while([resultSet nextWithError:&error])
        {
            NSDictionary *dic = @{
                                  kColId: [resultSet objectForColumnName:kColId],
                                  kColLongitude : [resultSet objectForColumnName:kColLongitude],
                                  kColLatitude : [resultSet objectForColumnName:kColLatitude],
                                  kColSzSegments : [resultSet objectForColumnName:kColSzSegments],
                                  kColSchoolName : [resultSet objectForColumnName:kColSchoolName]
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

- (NSArray*)selectAllSchoolsOrderByName
{
    NSArray *unordered = [self selectAllSchools];
    return [unordered sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *school1Name = [obj1 valueForKey:kColSchoolName];
        NSString *school2Name = [obj2 valueForKey:kColSchoolName];
        return [school1Name compare:school2Name options:NSLiteralSearch];
    }];
}

@end
