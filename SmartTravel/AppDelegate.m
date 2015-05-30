//
//  AppDelegate.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/16.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
#import "AppSettingManager.h"
#import "AppLocationManager.h"
#import "AppDelegate.h"
#import "TermUsage.h"
#import "DBConstants.h"
#import "DBVersionAdapter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString* GMAP_API_KEY =  @"AIzaSyDXhjRks183HMms1UzRmIjeL7fTgy5WqFw";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (![TermUsage agree]) {
        self.window.rootViewController = [self loadControllerFromStoryboard:@"FirstLaunch"];
        [self.window makeKeyAndVisible];
    }
    
    //Initialize GMap
    [GMSServices provideAPIKey:GMAP_API_KEY];
    
    AppSettingManager* appSettings = [AppSettingManager sharedInstance];
    NSInteger runCount = [appSettings getRunCount];
    if (runCount == 0)
    {
        [appSettings setIsWarningVoice:YES];
    }
    
    //Copy database from main bundle with data ready.
    //Only force overwrite for 1st time;
    //later check only and copy in case it was removed by unknown exceptions.
    [self copyResourceFromAppBundle:DB_NAME_MAIN
          toUserDocumentWithNewName:DB_NAME_MAIN
                            withExt:DB_EXT
                     forceOverwrite:(runCount == 0)];
    
    [appSettings setRunCount:(runCount + 1)];
    
    NSLog(@"Current data schema verson is %@", [[DBVersionAdapter alloc] getLatestVersion]);
    
    return YES;
}

// Return YES if copy succeeded
- (BOOL)copyResourceFromAppBundle:(NSString*)oldFileName
        toUserDocumentWithNewName:(NSString*)newFileName
                          withExt:(NSString*)ext
                   forceOverwrite:(BOOL)forceOverwrite
{
    NSString* sourcePath = [[NSBundle mainBundle] pathForResource:oldFileName ofType:ext];
    
    // Return NO if source not exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:sourcePath])
    {
        return NO;
    }
    
    NSString* userDocumentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* targetPath = [[userDocumentDir stringByAppendingPathComponent:newFileName] stringByAppendingPathExtension:ext];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath])
    {
        if (!forceOverwrite)
        {
            return YES;
        }
        // Remove target if it exists and forceOverwrite is YES
        if (forceOverwrite)
        {
            NSError* error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:targetPath error:&error];
            if (error)
            {
                return NO;
            }
        }
    }
    
    NSError* error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:targetPath error:&error];
    return !error;
}

- (UIViewController*)loadControllerFromStoryboard:(NSString *)storyboardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return [storyboard instantiateInitialViewController];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    CLAuthorizationStatus clAuthStatus = [AppLocationManager authorizationStatus];
    if (clAuthStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||
        clAuthStatus == kCLAuthorizationStatusAuthorizedAlways)
    {
        [[AppLocationManager sharedInstance] stopUpdatingHeading];
        [[AppLocationManager sharedInstance] stopUpdatingLocation];
    }
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
    CLAuthorizationStatus clAuthStatus = [AppLocationManager authorizationStatus];
    if (clAuthStatus != kCLAuthorizationStatusAuthorizedWhenInUse &&
        clAuthStatus != kCLAuthorizationStatusAuthorizedAlways)
    {
        [[AppLocationManager sharedInstance] requestWhenInUserAuthorization];
    }
    else
    {
        [[AppLocationManager sharedInstance] startUpdatingHeading];
        [[AppLocationManager sharedInstance] startUpdatingLocation];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
