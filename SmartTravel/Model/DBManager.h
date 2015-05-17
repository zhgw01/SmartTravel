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

+(NSString*)makeInsertSmtForTable:(NSString*)tableName;

+(NSString*)getPathOfMainDB;

-(NSArray*)selectHotSpots:(HotSpotType)hotSpotType;

@end