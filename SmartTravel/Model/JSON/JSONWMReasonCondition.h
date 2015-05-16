//
//  JSONWMReasonCondition.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface JSONWMReasonCondition : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString* warnigMessage;
@property (nonatomic, assign) BOOL weekday;
@property (nonatomic, copy) NSString* reason;
@property (nonatomic, assign) BOOL weenend;
@property (nonatomic, copy) NSString* endTime;
@property (nonatomic, copy) NSNumber* reasonId;
@property (nonatomic, copy) NSString* month;
@property (nonatomic, copy) NSString* startTime;
@property (nonatomic, assign) BOOL schoolDay;

@end
