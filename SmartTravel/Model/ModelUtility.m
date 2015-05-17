//
//  ModelUtility.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/17/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

#import "ModelUtility.h"

#import "JSONConstants.h"
#import "JSONManager.h"

#import "DBConstants.h"
#import "DBManager.h"

#import "DBCollisionLocation.h"
#import "DBWMReasonCondition.h"
#import "DBLocationReason.h"
#import "DBWMDayType.h"

#import "JSONCollisionLocation.h"
#import "JSONWMReasonCondition.h"
#import "JSONLocationReason.h"
#import "JSONWMDayType.h"

@implementation ModelUtility

#pragma - mark Converters to convert data of JSON model to DB model
+(DBCollisionLocation*)generateDBCollisionLocationFromJSON:(JSONCollisionLocation*)jCollisionLocation
{
    if (!jCollisionLocation) return nil;
    
    DBCollisionLocation* dbCollisionLocation = [[DBCollisionLocation alloc] init];
    
    dbCollisionLocation.Loc_code = jCollisionLocation.locCode;
    dbCollisionLocation.Location_name = jCollisionLocation.locationName;
    dbCollisionLocation.Roadway_portion = jCollisionLocation.roadwayPortion;
    dbCollisionLocation.Latitude = jCollisionLocation.latitude;
    dbCollisionLocation.Longitude = jCollisionLocation.longitude;
    
    return dbCollisionLocation;
}

+(DBWMReasonCondition*)generateDBWMReasonConditionFromJSON:(JSONWMReasonCondition*)jWMReasonCondition
{
    if (!jWMReasonCondition) return nil;
    
    DBWMReasonCondition* dbWMReasonCondition = [[DBWMReasonCondition alloc] init];
    
    dbWMReasonCondition.Reason_id = jWMReasonCondition.reasonId;
    dbWMReasonCondition.Reason = jWMReasonCondition.reason;
    dbWMReasonCondition.Month = jWMReasonCondition.month;
    dbWMReasonCondition.Weekday = jWMReasonCondition.weekday;
    dbWMReasonCondition.Weekend = jWMReasonCondition.weenend;
    dbWMReasonCondition.School_day = jWMReasonCondition.schoolDay;
    dbWMReasonCondition.Start_time = jWMReasonCondition.startTime;
    dbWMReasonCondition.End_time = jWMReasonCondition.endTime;
    dbWMReasonCondition.Warning_message = jWMReasonCondition.warnigMessage;
    
    return dbWMReasonCondition;
}

+(DBLocationReason*)generateDBLocationReasonFromJSON:(JSONLocationReason*)jLocationReason
                                              withID:(NSInteger)rowId
{
    if (!jLocationReason) return nil;

    DBLocationReason* dbLocationReason = [[DBLocationReason alloc] init];
    
    dbLocationReason.Id = [NSNumber numberWithInteger:rowId];
    dbLocationReason.Loc_code = jLocationReason.locCode;
    dbLocationReason.Travel_direction = jLocationReason.travelDirection;
    dbLocationReason.Reason_id = jLocationReason.reasonId;
    dbLocationReason.Total = jLocationReason.total;
    dbLocationReason.Warning_priority = jLocationReason.warningPriority;
    
    return dbLocationReason;
}

+(DBWMDayType*)generateDBWMDayTypeFromJSON:(JSONWMDayType*)jWMDayType
{
    if (!jWMDayType) return nil;

    DBWMDayType* dbWMDayType = [[DBWMDayType alloc] init];
    
    dbWMDayType.Date = jWMDayType.date;
    dbWMDayType.Weekday = jWMDayType.weekday;
    dbWMDayType.Weekend = jWMDayType.weenend;
    dbWMDayType.School_day = jWMDayType.schoolDay;
    
    return dbWMDayType;
}

+(BOOL)insertDataIntoMainDBTablesUsingDataFromJSONFiles
{
    DBManager* dbManager = [DBManager sharedInstance];
    if (![dbManager.mainDb open])
    {
        return NO;
    }
    
    JSONManager* jsonManager = [JSONManager sharedInstance];
    
    NSString* smt = [DBManager makeInsertSmtForTable:MAIN_DB_TBL_COLLISION_LOCATION];
    NSArray* collisionLocations = [jsonManager readJSONFromReadonlyJSONFile:JSON_COLLECTION_FILE_NAME_COLLISION_LOCATION];
    for (JSONCollisionLocation* jCollisionLocation in collisionLocations)
    {
        DBCollisionLocation* dbCollisionLocation = [ModelUtility generateDBCollisionLocationFromJSON:jCollisionLocation];
        [dbManager.mainDb executeUpdate:smt withParameterDictionary:[dbCollisionLocation dictionaryValue]];
    }
    
    smt = [DBManager makeInsertSmtForTable:MAIN_DB_TBL_LOCATION_REASON];
    NSArray* locationReasons = [jsonManager readJSONFromReadonlyJSONFile:JSON_COLLECTION_FILE_NAME_FILE_LOCATION_REASON];
    NSInteger locationReasonID = 0;
    for (JSONLocationReason* jLocationReason in locationReasons)
    {
        DBLocationReason* dbLocationReason = [ModelUtility generateDBLocationReasonFromJSON:jLocationReason withID:locationReasonID];
        if ([dbManager.mainDb executeUpdate:smt withParameterDictionary:[dbLocationReason dictionaryValue]])
        {
            ++locationReasonID;
        }
    }
    
    smt = [DBManager makeInsertSmtForTable:MAIN_DB_TBL_WM_DAYTYPE];
    NSArray* wmDayTypes = [jsonManager readJSONFromReadonlyJSONFile:JSON_COLLECITON_FILE_NAME_FILE_WM_DAYTYPE];
    for (JSONWMDayType* jWMDaType in wmDayTypes)
    {
        DBWMDayType* dbWMDayType = [ModelUtility generateDBWMDayTypeFromJSON:jWMDaType];
        [dbManager.mainDb executeUpdate:smt withParameterDictionary:[dbWMDayType dictionaryValue]];
    }

    smt = [DBManager makeInsertSmtForTable:MAIN_DB_TBL_WM_REASON_CONDITION];
    NSArray* wmReasonConditions = [jsonManager readJSONFromReadonlyJSONFile:JSON_COLLECTION_FILE_NAME_FILE_WM_REASON_CONDITION];
    for (JSONWMReasonCondition* jWMReasonCondition in wmReasonConditions)
    {
        DBWMReasonCondition* dbWMReasonCondition = [ModelUtility generateDBWMReasonConditionFromJSON:jWMReasonCondition];
        [dbManager.mainDb executeUpdate:smt withParameterDictionary:[dbWMReasonCondition dictionaryValue]];
    }
    
    if (![dbManager.mainDb close])
    {
        return NO;
    }
    
    return YES;
}

@end
