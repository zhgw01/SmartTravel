//
//  DBManager.h
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "HotSpot.h"

@interface DBManager : NSObject

+(DBManager *)sharedInstance;

// Delete all items in table
+(BOOL)deleteFromTable:(NSString*)tableName;

+(BOOL)insertJSON:(id)jsonArrayOrDic
        intoTable:(NSString*)tableName
             ofDB:(NSString*)dbName;

//+(NSString*)getPathOfMainDB;
+(NSString*)getPathOfDB:(NSString*)dbName;

-(NSArray*)selectHotSpots:(HotSpotType)hotSpotType;

/**
 *  Selecta all hot spots of specific reason
 *
 *  @param reasonId ID of reason
 *
 *  @return array of hotspot of HotSpot type
 */
-(NSArray*)selectHotSpotsOfReason:(int)reasonId;

-(NSArray*)getHotSpotDetailsByLocationCode:(NSString*)locCode;

/**
 *  Select all reason categories
 *
 *  @return array of {Reason_id:@"", Category:""}
 */
-(NSArray*)selectReasonCategories;

@end