//
//  JsonManager.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kJSON_TBL_COLLISION_LOCATION;
extern NSString * const kJSON_TBL_LOCATION_REASON;
extern NSString * const kJSON_TBL_WM_DAYTYPE;
extern NSString * const kJSON_TBL_WM_REASON_CONDITION;

// NOTE: Currently it's a utility class to assit read test data in json format
@interface JsonManager : NSObject

+ (JsonManager *)sharedInstance;

- (NSArray*)readJSONFromReadonlyJSONFile:(NSString*)fileName;

@end
