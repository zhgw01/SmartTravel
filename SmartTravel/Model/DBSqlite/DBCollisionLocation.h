//
//  DBCollisionLocation.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/2.
//  Copyright (c) 2015ƒÍ Gongwei. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface DBCollisionLocation: MTLModel<MTLFMDBSerializing>

@property (nonatomic, copy) NSString *locCode;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longtitude;

@end
