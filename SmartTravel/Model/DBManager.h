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

@property (nonatomic, copy) NSString* path;
@property (nonatomic, readonly) FMDatabase* db;

@end
