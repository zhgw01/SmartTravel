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

@property (nonatomic, copy) NSNumber *Reason_id;
@property (nonatomic, copy) NSString *Reason;
@property (nonatomic, copy) NSString *Month;
@property (nonatomic, assign) BOOL Weekday;
@property (nonatomic, assign) BOOL Weekend;
@property (nonatomic, assign) BOOL School_day;
@property (nonatomic, copy) NSString *Start_time;
@property (nonatomic, copy) NSString *End_time;
@property (nonatomic, copy) NSString *Warning_message;

@end
