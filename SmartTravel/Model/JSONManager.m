//
//  JSONManager.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Mantle/MTLJSONAdapter.h>
#import "JSONConstants.h"
#import "JSONManager.h"
#import "JSONCollisionLocation.h"
#import "JSONLocationReason.h"
#import "JSONWMDayType.h"
#import "JSONWMReasonCondition.h"

@implementation JSONManager

+ (JSONManager *)sharedInstance
{
    static JSONManager *sharedSingleton = nil;
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
    if ([fileName isEqualToString:JSON_COLLECTION_FILE_NAME_COLLISION_LOCATION])
    {
        return [JSONCollisionLocation class];
    }
    else if ([fileName isEqualToString:JSON_COLLECTION_FILE_NAME_FILE_LOCATION_REASON])
    {
        return [JSONLocationReason class];
    }
    else if ([fileName isEqualToString:JSON_COLLECITON_FILE_NAME_FILE_WM_DAYTYPE])
    {
        return [JSONWMDayType class];        
    }
    else if ([fileName isEqualToString:JSON_COLLECTION_FILE_NAME_FILE_WM_REASON_CONDITION])
    {
        return [JSONWMReasonCondition class];
    }
    NSAssert(NO, @"Invalid JSON file name");
    return nil;
}

- (NSArray*)readJSONFromReadonlyJSONFile:(NSString*)fileName
{
    NSString* filePath = [JSONManager getReadOnlyJsonFilePath:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return nil;
    }
    
    Class modelClass = [JSONManager getClassOfJsonModelInFile:fileName];
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
