//
//  DBManager.h
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+(DBManager *)sharedInstance;

-(NSArray*)selectAllCollisions;

-(NSArray*)selectAllVRUs;

@end