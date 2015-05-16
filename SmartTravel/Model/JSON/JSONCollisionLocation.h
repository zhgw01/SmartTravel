//
//  JSONCollisionLocation.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface JSONCollisionLocation : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString * locationName;
@property (nonatomic, copy) NSString * roadwayPortion;
@property (nonatomic, copy) NSNumber * longitude;
@property (nonatomic, copy) NSNumber * latitude;
@property (nonatomic, copy) NSString * locCode;

@end
