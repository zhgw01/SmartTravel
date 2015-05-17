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

@property (nonatomic, copy) NSString* locCode;
@property (nonatomic, copy) NSString* travelDirection;
@property (nonatomic, copy) NSNumber* reasonId;
@property (nonatomic, copy) NSNumber* total;
@property (nonatomic, copy) NSNumber* warningPriority;

@end

