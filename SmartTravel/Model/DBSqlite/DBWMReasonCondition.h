//
//  DBWMReasonCondition.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/2.
//  Copyright (c) 2015ƒÍ Gongwei. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface DBWMReasonCondition: MTLModel<MTLFMDBSerializing>

@property (nonatomic, copy) NSString *reasonId;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, assign) BOOL weekday;
@property (nonatomic, assign) BOOL weekend;
@property (nonatomic, assign) BOOL schoolDay;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@end
