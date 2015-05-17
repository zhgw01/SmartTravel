//
//  ModelUtility.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/17/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelUtility.h"
#import "JSONConstants.h"
#import "JSONManager.h"

@implementation ModelUtility

+(void)initializeMainDBTablesWithJSON
{
//    JSONManager* JSONManager = [JSONManager sh]
    
//    NSArray* collisionLocations = [JSONManager readJSONFromReadonlyJSONFile:JSON_COLLECTION_FILE_NAME_COLLISION_LOCATION];
    //    for (JSONCollisionLocation* jCollisionLocation in collisionLocations)
    //    {
    //        NSLog(@"locationName:%@, roadwayPortion:%@, longitude:%g, latitude:%g, locCode:%@",
    //              jCollisionLocation.locationName,
    //              jCollisionLocation.roadwayPortion,
    //              [jCollisionLocation.longitude doubleValue],
    //              [jCollisionLocation.latitude doubleValue],
    //              jCollisionLocation.locCode);
    //    }
    
//    NSArray* locationReasons = [[JSONManager sharedInstance] readJSONFromReadonlyJSONFile:JSON_COLLECTION_FILE_NAME_FILE_LOCATION_REASON];
    //    for (JSONLocationReason* jLocationReason in locationReasons)
    //    {
    //        NSLog(@"total:%d, warning_priority:%d, reason_id:%d, travel_direction:%@, loc_code:%@",
    //              [jLocationReason.total intValue],
    //              [jLocationReason.warningPriority intValue],
    //              [jLocationReason.reasonId intValue],
    //              jLocationReason.travelDirection,
    //              jLocationReason.locCode);
    //    }
    
    
//    NSArray* wmDayTypes = [[JSONManager sharedInstance] readJSONFromReadonlyJSONFile:JSON_COLLECITON_FILE_NAME_FILE_WM_DAYTYPE];
    //    for (JSONWMDayType* jWMDaType in wmDayTypes)
    //    {
    //        NSLog(@"weekday:%@, weenend:%@, date:%@, school_day:%@",
    //              jWMDaType.weekday,
    //              jWMDaType.weenend,
    //              jWMDaType.date,
    //              jWMDaType.schoolDay);
    //    }
    
//    NSArray* wmReasonConditions = [[JSONManager sharedInstance] readJSONFromReadonlyJSONFile:JSON_COLLECTION_FILE_NAME_FILE_WM_REASON_CONDITION];
    //    for (JSONWMReasonCondition* jWMReasonCondition in wmReasonConditions)
    //    {
    //        NSLog(@"warnig_message:%@, weekday:%@, reason:%@, weenend:%@, end_time:%@, reason_id:%d, month:%@, start_time:%@, school_day:%@",
    //              jWMReasonCondition.warnigMessage,
    //              jWMReasonCondition.weekday ? @"TRUE" : @"FALSE",
    //              jWMReasonCondition.reason,
    //              jWMReasonCondition.weenend ? @"TRUE" : @"FALSE",
    //              jWMReasonCondition.endTime,
    //              [jWMReasonCondition.reasonId intValue],
    //              jWMReasonCondition.month,
    //              jWMReasonCondition.startTime,
    //              jWMReasonCondition.schoolDay ? @"TRUE" : @"FALSE");
    //    }

}

@end
