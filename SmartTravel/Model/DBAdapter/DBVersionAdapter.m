//
//  DBVersionAdapter.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/12/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "DBConstants.h"
#import "DBManager.h"
#import "DBVersionAdapter.h"

static NSString * const kVersionColumn = @"Version";

@interface DBVersionAdapter()

@end

@implementation DBVersionAdapter

-(NSString*)getLatestVersion
{
    NSString* latestVersion = nil;
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfDB:DB_NAME_MAIN]];
    if ([db open])
    {
        NSString* smt = [self constructSmt];
        FMResultSet* resultSet = [db executeQuery:smt];
        NSError* error = nil;
        if ([resultSet nextWithError:&error] && !error)
        {
            latestVersion = [resultSet stringForColumn:kVersionColumn];
        }
        [resultSet close];
        
        if (![db close])
        {
            NSAssert(NO, @"Close db failed");
        }
    }
    return latestVersion;
}

- (NSString*)constructSmt
{
    return [NSString stringWithFormat:@"select %@ from %@ order by %@ desc limit 1", kVersionColumn, MAIN_DB_TBL_NEW_VERSION, kVersionColumn];
}

@end
