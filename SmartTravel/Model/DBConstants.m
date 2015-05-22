//
//  DBConstants.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/17/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConstants.h"

NSString * const DB_EXT = @"sqlite";

// DB names
NSString * const DB_NAME_TOPLOCATION = @"smartTravelTopLocation";
NSString * const DB_NAME_MAIN_TEMPLATE = @"smartTravelTemplate";
NSString * const DB_NAME_MAIN = @"smartTravel";

// Table names of main db
NSString * const MAIN_DB_TBL_COLLISION_LOCATION = @"TBL_COLLISION_LOCATION";
NSString * const MAIN_DB_TBL_WM_REASON_CONDITION = @"TBL_WM_REASON_CONDITION";
NSString * const MAIN_DB_TBL_LOCATION_REASON = @"TBL_LOCATION_REASON";
NSString * const MAIN_DB_TBL_WM_DAYTYPE = @"TBL_WM_DAYTYPE";
NSString * const MAIN_DB_TBL_NEW_VERSION = @"TBL_NEW_VERSION";