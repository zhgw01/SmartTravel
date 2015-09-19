//
//  ReasonInfo.h
//  SmartTravel
//
//  Created by chenpold on 9/19/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReasonInfo : NSObject

@property (nonatomic, assign) int      reasonId;
@property (nonatomic, copy  ) NSString *reason;
@property (nonatomic, copy  ) NSString *warningMessage;

@end
