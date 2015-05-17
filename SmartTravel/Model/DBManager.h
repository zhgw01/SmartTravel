//
//  DBManager.h
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface DBManager : NSObject

@property (readonly, strong) FMDatabase* topLocationDb;
@property (readonly, strong) FMDatabase* mainDb;

+(DBManager *)sharedInstance;

+(NSString*)makeInsertSmtForTable:(NSString*)tableName;

-(NSArray*)selectAllCollisions;

-(NSArray*)selectAllVRUs;

@end