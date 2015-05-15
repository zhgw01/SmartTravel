//
//  JsonManager.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Mantle/MTLJSONAdapter.h>
#import "JsonManager.h"
#import "JSONCollisionLocation.h"

NSString * const kJSON_TBL_COLLISION_LOCATION = @"TBL_COLLISION_LOCATION";
NSString * const kJSON_TBL_LOCATION_REASON = @"TBL_LOCATION_REASON";
NSString * const kJSON_TBL_WM_DAYTYPE = @"TBL_WM_DAYTYPE";
NSString * const kJSON_TBL_WM_REASON_CONDITION = @"TBL_WSM_REASON_CONDITION";

@implementation JsonManager

+ (JsonManager *)sharedInstance
{
    static JsonManager *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

+ (NSString*)getReadOnlyJsonFilePath:(NSString*)fileName
{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
}

+ (Class)getClassOfJsonModelInFile:(NSString*)fileName
{
    if ([fileName isEqualToString:kJSON_TBL_COLLISION_LOCATION])
    {
        return [JSONCollisionLocation class];
    }
    else if ([fileName isEqualToString:kJSON_TBL_LOCATION_REASON])
    {
        // TODO: CPY
        return nil;
    }
    else if ([fileName isEqualToString:kJSON_TBL_WM_DAYTYPE])
    {
        // TODO: CPY
        return nil;
    }
    else if ([fileName isEqualToString:kJSON_TBL_WM_REASON_CONDITION])
    {
        // TODO: CPY
        return nil;
    }
    return nil;
}

- (NSArray*)readJSONFromReadonlyJSONFile:(NSString*)fileName
{
    NSString* filePath = [JsonManager getReadOnlyJsonFilePath:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return nil;
    }
    
    Class modelClass = [JsonManager getClassOfJsonModelInFile:fileName];
    if (!modelClass)
    {
        return nil;
    }
    
    NSMutableArray* res = [[NSMutableArray alloc] init];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    NSError* err = nil;
    NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    for (NSDictionary* dic in array)
    {
        id json = [MTLJSONAdapter modelOfClass:modelClass
                            fromJSONDictionary:dic
                                         error:&err];
        if (!err)
        {
            [res addObject:json];
        }
    }
    return [res copy];
}

@end
