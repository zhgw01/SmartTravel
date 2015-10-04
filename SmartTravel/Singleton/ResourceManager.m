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
#import "STConstants.h"

NSString * const kNotificationNameVersionHasBeenUpdated = @"kNotificationNameVersionHasBeenUpdated";

static NSString * const kURLOfCollisionLocation = @"collisionLocation/jsonOfList";
static NSString * const kURLOfLocationReason    = @"locationReason/jsonOfList";
static NSString * const kURLOfWMDayType         = @"wmDayType/jsonOfList";
static NSString * const kURLOfWMReasonCondition = @"wmReasonCondition/jsonOfList";
static NSString * const kURLOfNewVersion        = @"newVersion/json";
static NSString * const kURLOfSchool            = @"school/jsonOfList";

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
            @15: @"Left Turn",
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
    if ([self.reasonIDToAudioFile objectForKey:reasonId])
    {
        NSString* fileName = [self.reasonIDToAudioFile objectForKey:reasonId];
        return [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4a"];
    }
    return nil;
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

+ (BOOL)hasNewerDataVersion:(NSString**)latestVersion
{
    *latestVersion = [[ResourceManager fetchJSONDataFromURL:kURLOfNewVersion] valueForKey:@"version"];
    NSString* currentVersion = [[[DBVersionAdapter alloc] init] getLatestVersion];
    return (latestVersion &&
            currentVersion &&
            NSOrderedDescending == [*latestVersion compare:currentVersion]);
}

+ (BOOL)updateOnline
{
    NSString *latestVersion = nil;

    if (![ResourceManager hasNewerDataVersion:&latestVersion])
    {
        return NO;
    }
    
    if (![ResourceManager updateCollisionLocationTable])
    {
        return NO;
    }
    
    if (![ResourceManager updateLocationReasonTable])
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
    
    if (![ResourceManager updateSchoolTable])
    {
        return NO;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameVersionHasBeenUpdated
                                                        object:nil
                                                      userInfo:@{@"version":latestVersion}];
    
    return YES;
}

+ (NSString*)getServerBase
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kConstantPlist
                                                          ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return [data valueForKey:kConstantPlistKeyOfServerBase];
}

+ (NSURL*)makeFullURL:(NSString*)relativeUrlStr
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [self getServerBase], relativeUrlStr]];
}

+ (id)fetchJSONDataFromURL:(NSString*)relativeUrlStr
{
    NSError* error = nil;
    NSURL* url = [self makeFullURL:relativeUrlStr];
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

+ (BOOL)updateSchoolTable
{
    NSArray *res = [ResourceManager fetchJSONDataFromURL:kURLOfSchool];
    if (!res)
    {
        return NO;
    }
    
    if (![DBManager deleteFromTable:MAIN_DB_TBL_SCHOOL])
    {
        return NO;
    }
    
    return [DBManager insertJSON:res intoTable:MAIN_DB_TBL_SCHOOL];
}

@end
