//
//  ResourceManager.m
//  SmartTravel
//
//  Created by ChenPengyu on 15/6/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "ResourceManager.h"
#import "DBManager.h"
#import "DBConstants.h"
#import "DBVersionAdapter.h"

static NSString * const kURLOfCollisionLocation = @"http://101.231.116.154:8080/STRESTWeb/collisionLocation/jsonOfList";
static NSString * const kURLOfLocationReason = @"http://101.231.116.154:8080/STRESTWeb/locationReason/jsonOfList";
static NSString * const kURLOfWMDayType = @"http://101.231.116.154:8080/STRESTWeb/wmDayType/jsonOfList";
static NSString * const kURLOfWMReasonCondition = @"http://101.231.116.154:8080/STRESTWeb/wmReasonCondition/jsonOfList";
static NSString * const kURLOfNewVersion = @"http://101.231.116.154:8080/STRESTWeb/newVersion/json";

@implementation ResourceManager

+(ResourceManager *)sharedInstance
{
    static ResourceManager *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

+ (BOOL)copyResourceFromAppBundle:(NSString*)oldFileName
        toUserDocumentWithNewName:(NSString*)newFileName
                          withExt:(NSString*)ext
                   forceOverwrite:(BOOL)forceOverwrite
{
    NSString* sourcePath = [[NSBundle mainBundle] pathForResource:oldFileName ofType:ext];
    
    // Return NO if source not exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:sourcePath])
    {
        return NO;
    }
    
    NSString* userDocumentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* targetPath = [[userDocumentDir stringByAppendingPathComponent:newFileName] stringByAppendingPathExtension:ext];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath])
    {
        if (!forceOverwrite)
        {
            return YES;
        }
        // Remove target if it exists and forceOverwrite is YES
        if (forceOverwrite)
        {
            NSError* error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:targetPath error:&error];
            if (error)
            {
                return NO;
            }
        }
    }
    
    NSError* error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:targetPath error:&error];
    return !error;
}

+ (BOOL)updateOnline
{
    BOOL hasNewerVersion = NO;
    
    NSString* latestVersion = [[ResourceManager fetchJSONDataFromURL:kURLOfNewVersion] valueForKey:@"version"];
    NSString* currentVersion = [[[DBVersionAdapter alloc] init] getLatestVersion];
    if (latestVersion &&
        currentVersion &&
        NSOrderedDescending == [latestVersion compare:currentVersion])
    {
        hasNewerVersion = YES;
    }
    
    return YES;
    // TODO: implement

    if (!hasNewerVersion)
    {
        return NO;
    }
    
    if (![ResourceManager updateCollisionLocationTable])
    {
        return NO;
    }
    
    if (![ResourceManager updateWMDayTypeTable])
    {
        return NO;
    }
    
    if (![ResourceManager updateWMReasonConditionTable])
    {
        return NO;
    }
    
    if (![ResourceManager updateWMDayTypeTable])
    {
        return NO;
    }
    
    return YES;
}

+ (id)fetchJSONDataFromURL:(NSString*)urlStr
{
    NSError* error = nil;
    NSURL* url = [NSURL URLWithString:urlStr];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:nil
                                                     error:&error];
    if (error)
    {
        NSLog(@"Error %@ occurred during updateCollisionLocationTable", [error localizedDescription]);
        return nil;
    }
    
    id res = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingAllowFragments
                                               error:&error];
    if (error)
    {
        NSLog(@"Error %@ occurred during updateCollisionLocationTable", [error localizedDescription]);
        return nil;
    }
    
    return res;
}

+ (BOOL)updateCollisionLocationTable
{
    NSArray* res = [ResourceManager fetchJSONDataFromURL:kURLOfCollisionLocation];
    if (!res || res.count == 0)
    {
        return NO;
    }
    
    if (![DBManager deleteFromTable:MAIN_DB_TBL_COLLISION_LOCATION])
    {
        return NO;
    }
    NSString* insertSQLSmt = [DBManager makeInsertSmtForTable:MAIN_DB_TBL_COLLISION_LOCATION];
    
    return YES;
}

+ (BOOL)updateWMDayTypeTable
{
    NSArray* res = [ResourceManager fetchJSONDataFromURL:kURLOfWMDayType];
    if (!res || res.count == 0)
    {
        return NO;
    }
    
    if (![DBManager deleteFromTable:MAIN_DB_TBL_WM_DAYTYPE])
    {
        return NO;
    }
    
    NSString* insertSQLSmt = [DBManager makeInsertSmtForTable:MAIN_DB_TBL_WM_DAYTYPE];

    return YES;
}

+ (BOOL)updateLocationReasonTable
{
    NSArray* res = [ResourceManager fetchJSONDataFromURL:kURLOfLocationReason];
    if (!res || res.count == 0)
    {
        return NO;
    }
    
    if (![DBManager deleteFromTable:MAIN_DB_TBL_LOCATION_REASON])
    {
        return NO;
    }
    
    NSString* insertSQLSmt = [DBManager makeInsertSmtForTable:MAIN_DB_TBL_LOCATION_REASON];

    return YES;
}

+ (BOOL)updateWMReasonConditionTable
{
    NSArray* res = [ResourceManager fetchJSONDataFromURL:kURLOfWMReasonCondition];
    if (!res || res.count == 0)
    {
        return NO;
    }
    
    if (![DBManager deleteFromTable:MAIN_DB_TBL_WM_REASON_CONDITION])
    {
        return NO;
    }
    
    NSString* insertSQLSmt = [DBManager makeInsertSmtForTable:MAIN_DB_TBL_WM_REASON_CONDITION];
    
    return YES;
}

@end
