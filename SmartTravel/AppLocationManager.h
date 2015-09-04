//
//  AppLocationManager.h
//  SmartTravel
//
//  Created by ChenPengyu on 15/5/23.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLocationManager : NSObject

+(AppLocationManager *)sharedInstance;

+(CLAuthorizationStatus)authorizationStatus;

-(void)requestAlwaysAuthorization;

-(void)setDelegate:(id<CLLocationManagerDelegate>)delegate;

@property (assign, nonatomic, readonly) BOOL updatingLocationEnabled;
@property (assign, nonatomic, readonly) BOOL updatingHeadingEnabled;

-(void)startUpdatingLocation;

-(void)stopUpdatingLocation;

-(void)startUpdatingHeading;

-(void)stopUpdatingHeading;

@end
