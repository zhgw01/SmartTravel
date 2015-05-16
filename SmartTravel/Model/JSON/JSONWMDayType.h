//
//  JSONWMDayType.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface JSONWMDayType : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString* weekday;
@property (nonatomic, copy) NSString* weenend; // ? Typo in test .json
@property (nonatomic, copy) NSString* date;
@property (nonatomic, copy) NSString* schoolDay;

@end
