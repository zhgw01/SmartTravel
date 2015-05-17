//
//  DBWMDayType.h
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/2.
//  Copyright (c) 2015ƒÍ Gongwei. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface DBWMDayType: MTLModel<MTLFMDBSerializing>

@property (nonatomic, copy) NSString* Date;
@property (nonatomic, assign) BOOL Weekday;
@property (nonatomic, assign) BOOL Weekend;
@property (nonatomic, assign) BOOL School_day;

@end
