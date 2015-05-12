//
//  TopCyclist.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/10.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface TopCyclist : MTLModel<MTLFMDBSerializing>

@property (nonatomic, copy) NSString *locationCode;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *portion;
@property (nonatomic, copy) NSNumber *count;
@property (nonatomic, copy) NSNumber *rank;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longtitude;

@end
