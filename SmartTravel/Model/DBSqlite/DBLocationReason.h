//
//  DBLocationReason.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/2.
//  Copyright (c) 2015ƒÍ Gongwei. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface DBLocationReason: MTLModel<MTLFMDBSerializing>

@property (nonatomic, copy) NSNumber* Id;
@property (nonatomic, copy) NSString* Loc_code;
@property (nonatomic, copy) NSString* Travel_direction;
@property (nonatomic, copy) NSNumber* Reason_id;
@property (nonatomic, copy) NSNumber* Total;
@property (nonatomic, copy) NSNumber* Warning_priority;

@end

