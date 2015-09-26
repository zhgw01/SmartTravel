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

NSString * const kNotificationNameVersionHasBeenUpdated = @"kNotificationNameVersionHasBeenUpdated";

static NSString * const kURLOfCollisionLocation = @"http://129.128.250.97:8080/STRESTWeb/collisionLocation/jsonOfList";
static NSString * const kURLOfLocationReason = @"http://129.128.250.97:8080/STRESTWeb/locationReason/jsonOfList";
static NSString * const kURLOfWMDayType = @"http://129.128.250.97:8080/STRESTWeb/wmDayType/jsonOfList";
static NSString * const kURLOfWMReasonCondition = @"http://129.128.250.97:8080/STRESTWeb/wmReasonCondition/jsonOfList";
static NSString * const kURLOfNewVersion = @"http://129.128.250.97:8080/STRESTWeb/newVersion/json";

/*
 "id":42,
  "school_type":"Public”,
  "lontitude":-113.440958114,
  "school_name":"Ekota”,
  "address":"1395 - Knottwood Road East NW”,
  "sz_segments":”[
  [-113.44081842600,53.44805739300,-113.44062148200,53.44828551500,-113.44043576800,53.44851838120,-113.44025462700,53.44886229170,-113.44023934700,53.44922268610,-113.44033134000,53.44947530660,-113.44071442100,53.44993267910,-113.44050561500,53.44971197040,-113.44040855700,53.44959624160,-113.44027472700,53.44935037400,-113.44022585400,53.44904216970,-113.44032505600,53.44868655580]
  ]”,
 "latitude":53.4491888706,
 "grade_level":"Elementary"
 */
static NSString * const kURLOfSchool = @"http://129.128.250.97:8080/STRESTWeb/school/jsonOfList";

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
