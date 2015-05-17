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

@property (nonatomic, assign) BOOL weekday;
@property (nonatomic, assign) BOOL schoolDay;
@property (nonatomic, copy) NSString* date;

@end
