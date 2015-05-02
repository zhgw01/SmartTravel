//
//  VRU.h
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface VRU : MTLModel<MTLFMDBSerializing>

@property (nonatomic, copy) NSString *locationCode;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSNumber *count;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longtitude;

@end
