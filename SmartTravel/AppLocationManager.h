//
//  AppLocationManager.h
//  SmartTravel
//
//  Created by ChenPengyu on 15/5/23.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AppLocationManager : NSObject

+(AppLocationManager *)sharedInstance;

-(void)requestWhenInUserAuthorization;

-(void)setDelegate:(id<CLLocationManagerDelegate>)delegate;

-(void)startUpdatingLocation;

-(void)stopUpdatingLocation;

-(void)startUpdatingHeading;

-(void)stopUpdatingHeading;

@end
