//
//  DBSchoolAdapter.h
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/26.
//  Copyright © 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kColId;
extern NSString * const kColLongitude;
extern NSString * const kColLatitude;
extern NSString * const kColSzSegments;
extern NSString * const kColSchoolName;

@interface DBSchoolAdapter : NSObject

- (NSArray*)selectAllSchoolsOrderByName;

@end
