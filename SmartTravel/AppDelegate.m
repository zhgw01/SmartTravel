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
#import "DBConstants.h"
#import "ModelUtility.h"

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
    if (![TermUsage agree]) {
        self.window.rootViewController = [self loadControllerFromStoryboard:@"FirstLaunch"];
        [self.window makeKeyAndVisible];
    }
    
    //Initialize GMap
    [GMSServices provideAPIKey:GMAP_API_KEY];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
        //Prepare database
        [self perpareSqliteDB];
        
        //Initialize database with JSON data
        [ModelUtility insertDataIntoMainDBTablesUsingDataFromJSONFiles];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    return YES;
}

- (void)perpareSqliteDB
{
    // Copy TopLocation DB to user document
    [self copyResourceFromAppBundle:DB_NAME_TOPLOCATION
          toUserDocumentWithNewName:DB_NAME_TOPLOCATION
                            withExt:DB_EXT];
    
    // Copy Main DB Template to user document
    [self copyResourceFromAppBundle:DB_NAME_MAIN_TEMPLATE
          toUserDocumentWithNewName:DB_NAME_MAIN
                            withExt:DB_EXT];
}

// Return YES if copy succeeded or the target file exists
- (BOOL)copyResourceFromAppBundle:(NSString*)oldFileName
        toUserDocumentWithNewName:(NSString*)newFileName
                          withExt:(NSString*)ext
{
    NSString* userDocumentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* targetPath = [[userDocumentDir stringByAppendingPathComponent:newFileName] stringByAppendingPathExtension:ext];
    
    NSString* sourcePath = [[NSBundle mainBundle] pathForResource:oldFileName ofType:ext];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:sourcePath])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath])
        {
            return YES;
        }
        NSError* error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:targetPath error:&error];
        return !error;
    }
    
    return NO;
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
