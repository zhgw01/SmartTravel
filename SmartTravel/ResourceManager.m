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

@interface ResourceManager ()

@property (strong, nonatomic) NSDictionary * reasonIDToAudioFile;

@end

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

- (instancetype)init
{
    if (self = [super init])
    {
        self.reasonIDToAudioFile = @{
            @1: @"Morning rush hour",
            @2: @"Morning rush hour",
            @3: @"afternoon rush hour",
            @4: @"afternoon rush hour",
            @5: @"weekend early morning",
            @6: @"weekend early morning",
            @7: @"Pedestrians",
            @8: @"Pedestrians",
            @9: @"Cyclist",
            @10: @"Cyclist",
            @11: @"Motorcyclist",
            @12: @"Motorcyclist",
            @13: @"increase the gap",
            @14: @"increase the gap",
            @15: @"", // TODO: Customer will provide it
            @16: @"Red-light running",
            @17: @"Stop sign violation",
            @18: @"Improper lane change",
            @19: @"Improper lane change",
            @20: @"Ran off road",
            @21: @"attention high risk collision area",
            @22: @"attention high risk collision area",
            @23: @"School zone"
        };
    }
    return self;
}

- (NSString*)getAudioFilePathByReasonID:(NSNumber*)reasonId
{
    NSString* fileName = [self.reasonIDToAudioFile objectForKey:reasonId];
    return [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4a"];
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
    
//#ifdef DEBUG
//    hasNewerVersion = YES;
//#endif

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
    
    if (![ResourceManager updateNewVersionTable])
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
    
    return [DBManager insertJSON:res intoTable:MAIN_DB_TBL_COLLISION_LOCATION];
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
    
    return [DBManager insertJSON:res intoTable:MAIN_DB_TBL_WM_DAYTYPE];
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
    
    return [DBManager insertJSON:res intoTable:MAIN_DB_TBL_LOCATION_REASON];
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
    
    return [DBManager insertJSON:res intoTable:MAIN_DB_TBL_WM_REASON_CONDITION];
}

+ (BOOL)updateNewVersionTable
{
    NSDictionary* res = [ResourceManager fetchJSONDataFromURL:kURLOfNewVersion];
    if (!res)
    {
        return NO;
    }
    
    if (![DBManager deleteFromTable:MAIN_DB_TBL_NEW_VERSION])
    {
        return NO;
    }
    
    return [DBManager insertJSON:res intoTable:MAIN_DB_TBL_NEW_VERSION];
}

@end
