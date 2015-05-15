//
//  AppDelegate.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/16.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "AppDelegate.h"
#import "TermUsage.h"
#import <GoogleMaps/GoogleMaps.h>

#ifdef DEBUG
#import "JsonManager.h"
#import "JSONCollisionLocation.h"
#import "JSONLocationReason.h"
#import "JSONWMDayType.h"
#import "JSONWMReasonCondition.h"
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString* GMAP_API_KEY =  @"AIzaSyDXhjRks183HMms1UzRmIjeL7fTgy5WqFw";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef DEBUG
//    NSArray* collisionLocations = [[JsonManager sharedInstance] readJSONFromReadonlyJSONFile:kJSON_TBL_COLLISION_LOCATION];
//    for (JSONCollisionLocation* jCollisionLocation in collisionLocations)
//    {
//        NSLog(@"locationName:%@, roadwayPortion:%@, longitude:%g, latitude:%g, locCode:%@",
//              jCollisionLocation.locationName,
//              jCollisionLocation.roadwayPortion,
//              [jCollisionLocation.longitude doubleValue],
//              [jCollisionLocation.latitude doubleValue],
//              jCollisionLocation.locCode);
//    }
    
//    NSArray* locationReasons = [[JsonManager sharedInstance] readJSONFromReadonlyJSONFile:kJSON_TBL_LOCATION_REASON];
//    for (JSONLocationReason* jLocationReason in locationReasons)
//    {
//        NSLog(@"total:%d, warning_priority:%d, reason_id:%d, travel_direction:%@, loc_code:%@",
//              [jLocationReason.total intValue],
//              [jLocationReason.warningPriority intValue],
//              [jLocationReason.reasonId intValue],
//              jLocationReason.travelDirection,
//              jLocationReason.locCode);
//    }
    
    
//    NSArray* wmDayTypes = [[JsonManager sharedInstance] readJSONFromReadonlyJSONFile:kJSON_TBL_WM_DAYTYPE];
//    for (JSONWMDayType* jWMDaType in wmDayTypes)
//    {
//        NSLog(@"weekday:%@, weenend:%@, date:%@, school_day:%@",
//              jWMDaType.weekday,
//              jWMDaType.weenend,
//              jWMDaType.date,
//              jWMDaType.schoolDay);
//    }

    NSArray* wmReasonConditions = [[JsonManager sharedInstance] readJSONFromReadonlyJSONFile:kJSON_TBL_WM_REASON_CONDITION];
    for (JSONWMReasonCondition* jWMReasonCondition in wmReasonConditions)
    {
        NSLog(@"warnig_message:%@, weekday:%@, reason:%@, weenend:%@, end_time:%@, reason_id:%d, month:%@, start_time:%@, school_day:%@",
              jWMReasonCondition.warnigMessage,
              jWMReasonCondition.weekday ? @"TRUE" : @"FALSE",
              jWMReasonCondition.reason,
              jWMReasonCondition.weenend ? @"TRUE" : @"FALSE",
              jWMReasonCondition.endTime,
              [jWMReasonCondition.reasonId intValue],
              jWMReasonCondition.month,
              jWMReasonCondition.startTime,
              jWMReasonCondition.schoolDay ? @"TRUE" : @"FALSE");
    }

#endif
    
    if (![TermUsage agree]) {
        self.window.rootViewController = [self loadControllerFromStoryboard:@"FirstLaunch"];
        [self.window makeKeyAndVisible];
    }
    
    //Initialize GMap
    [GMSServices provideAPIKey:GMAP_API_KEY];
    
    return YES;
}

- (UIViewController*)loadControllerFromStoryboard:(NSString *)storyboardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return [storyboard instantiateInitialViewController];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
