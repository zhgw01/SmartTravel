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

@property (nonatomic, copy) NSString *Loc_code;
@property (nonatomic, copy) NSString *Location_name;
@property (nonatomic, copy) NSString *Roadway_portion;
@property (nonatomic, copy) NSNumber *Latitude;
@property (nonatomic, copy) NSNumber *Longitude;

@end
