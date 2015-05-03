//
//  AppDelegate.h
//  SmartTravel
//
//  Created by Gongwei on 15/4/16.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FMDB/FMDB.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FMDatabase *database;

@end

