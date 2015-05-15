//
//  JSONLocationReason.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface JSONLocationReason : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSNumber* total;
@property (nonatomic, copy) NSNumber* warningPriority;
@property (nonatomic, copy) NSNumber* reasonId;
@property (nonatomic, copy) NSString* travelDirection;
@property (nonatomic, copy) NSString* locCode;

@end
