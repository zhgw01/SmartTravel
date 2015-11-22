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

+(NSString*)getPathOfDB:(NSString*)dbName;

-(NSArray*)selectHotSpots:(HotSpotType)hotSpotType;

-(NSArray*)selectHotSpotsOfCategory:(NSString*)category;

-(NSArray*)getHotSpotDetailsByLocationCode:(NSString*)locCode;

-(NSArray*)selectCategories;

-(NSString*)selectCategoryOfLocationCode:(NSString*)locationCode;

@end