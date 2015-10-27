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

+ (ResourceManager *)sharedInstance
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

- (BOOL)hasNewerDataVersion:(NSString**)latestVersion
{
    NSError *error = nil;
    NSURL* url = [self makeFullURL:kURLOfNewVersion];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:nil
                                                     error:&error];
    if (error)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
        return NO;
    }
    
    id res = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingAllowFragments
                                               error:&error];
    if (error)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
        return NO;
    }
    
    *latestVersion = [res valueForKey:@"version"];
    NSString* currentVersion = [[[DBVersionAdapter alloc] init] getLatestVersion];
    return (latestVersion &&
            currentVersion &&
            NSOrderedDescending == [*latestVersion compare:currentVersion]);
}

- (void)hasNewerDataVersionWithCompletion:(void(^)())completion
{
    [self synchronouslyFetchJSONDataFromURL:kURLOfNewVersion
                          completionHandler:^(id jsonData) {
        NSString *latestVersion = [jsonData valueForKey:@"version"];
        NSString* currentVersion = [[[DBVersionAdapter alloc] init] getLatestVersion];
        if (latestVersion && currentVersion && NSOrderedDescending == [latestVersion compare:currentVersion])
        {
            completion();
        }
    }];
}

- (void)updateOnlineWithCompletion:(void(^)(BOOL))completion
{
    [self hasNewerDataVersionWithCompletion:^void{
        __block BOOL res = YES;
        void(^syncOnlineTable)(NSString *, NSString *, NSString *) = ^(NSString* dbName, NSString *tableName, NSString *url) {
            if (![self fillTable:tableName
                            ofDB:dbName
                         fromURL:url])
            {
                res = NO;
            }
        };
        
        NSString *tempDbName = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970])];
        [ResourceManager copyResourceFromAppBundle:DB_NAME_TEMPLATE
                         toUserDocumentWithNewName:tempDbName
                                           withExt:DB_EXT
                                    forceOverwrite:YES];
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        
        dispatch_group_async(group, queue, ^{
            syncOnlineTable(tempDbName,
                            MAIN_DB_TBL_COLLISION_LOCATION,
                            kURLOfCollisionLocation);
        });
        
        dispatch_group_async(group, queue, ^{
            syncOnlineTable(tempDbName,
                            MAIN_DB_TBL_LOCATION_REASON,
                            kURLOfLocationReason);
        });

        dispatch_group_async(group, queue, ^{
            syncOnlineTable(tempDbName,
                            MAIN_DB_TBL_WM_REASON_CONDITION,
                            kURLOfWMReasonCondition);
        });
        
        dispatch_group_async(group, queue, ^{
            syncOnlineTable(tempDbName,
                            MAIN_DB_TBL_WM_DAYTYPE,
                            kURLOfWMDayType);
        });
        
        dispatch_group_async(group, queue, ^{
            syncOnlineTable(tempDbName,
                            MAIN_DB_TBL_SCHOOL,
                            kURLOfSchool);
        });
        
        dispatch_group_async(group, queue, ^{
            syncOnlineTable(tempDbName,
                            MAIN_DB_TBL_NEW_VERSION,
                            kURLOfNewVersion);
        });
        
        dispatch_group_notify(group, queue, ^{
            NSString *mainDbPath = [DBManager getPathOfDB:DB_NAME_MAIN];
            NSString *tempDbPath = [DBManager getPathOfDB:tempDbName];
            
            NSError *error = nil;
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:mainDbPath])
            {
                [fm removeItemAtPath:mainDbPath error:&error];
                if (error)
                {
                    NSLog(@"Error: %@", [error localizedDescription]);
                    res = NO;
                }
            }
            
            [fm moveItemAtPath:tempDbPath toPath:mainDbPath error:&error];
            if (error)
            {
                NSLog(@"Error: %@", [error localizedDescription]);
                res = NO;
            }
            
            completion(res);
        });
    }];
}

- (NSString*)getServerBase
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kConstantPlist
                                                          ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
#ifdef DEBUG
    return [data valueForKey:kConstantPlistKeyOfServerBaseDev];
#else
    return [data valueForKey:kConstantPlistKeyOfServerBase];
#endif
}

- (NSURL*)makeFullURL:(NSString*)relativeUrlStr
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [self getServerBase], relativeUrlStr]];
}

- (void)synchronouslyFetchJSONDataFromURL:(NSString*)relativeUrlStr
                        completionHandler:(void(^)(id jsonData))completion
{
    NSURL* url = [self makeFullURL:relativeUrlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (error)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    else
    {
        id res = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
        if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else
        {
            completion(res);
        }
    }
}

- (BOOL)fillTable:(NSString*)tableName
             ofDB:(NSString*)dbName
          fromURL:(NSString*)urlString
{
    __block BOOL res = NO;
    [self synchronouslyFetchJSONDataFromURL:urlString
                          completionHandler:^(id jsonData) {
        if (jsonData)
        {
            res = [DBManager insertJSON:jsonData
                              intoTable:tableName
                                   ofDB:dbName];
        }
    }];
    return res;
}

@end
