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
        intoTable:(NSString*)tableName;

// For test purpose
+(void)insertTestData;

+(NSString*)getPathOfMainDB;

-(NSArray*)selectHotSpots:(HotSpotType)hotSpotType;

-(NSArray*)getHotSpotDetailsByLocationCode:(NSString*)locCode;

@end