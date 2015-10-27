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
#import "ResourceManager.h"
#import "AppDelegate.h"
#import "TermUsage.h"
#import "DBConstants.h"
#import "DBManager.h"
#import "DBVersionAdapter.h"
#import "StateMachine.h"
#import <AVFoundation/AVFoundation.h>
#import "Flurry.h"
#import "STConstants.h"
#import "DataUpdateVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString* GMAP_API_KEY =  @"AIzaSyDXhjRks183HMms1UzRmIjeL7fTgy5WqFw";
static NSString* FLURRY_TOKEN = @"TSWW3SMF623BGQ37NT6H";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:FLURRY_TOKEN];
    
    //Initialize GMap
    [GMSServices provideAPIKey:GMAP_API_KEY];
    
    AppSettingManager* appSettings = [AppSettingManager sharedInstance];
    NSInteger runCount = [appSettings getRunCount];
    if (runCount == 0)
    {
        [appSettings setIsWarningVoice:YES];
        [appSettings setIsAutoCheckUpdate:YES];
    }
    [appSettings setRunCount:(runCount + 1)];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.26 green:0.73 blue:0.89 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName : [UIFont boldSystemFontOfSize:26]
                                                           }];
    
    return YES;
}

- (UIViewController*)loadControllerFromStoryboard:(NSString *)storyboardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return [storyboard instantiateInitialViewController];
}

- (BOOL)keepAudioSessionActive
{
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setActive:YES
                                         error:&error];
    if (error)
    {
        NSLog(@"Error:%@", error.description);
        return NO;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:&error];
    if (error)
    {
        NSLog(@"Error:%@", error.description);
        return NO;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
    [[StateMachine sharedInstance] eventHappend:kEventUserResignActive];
    
    [self keepAudioSessionActive];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self keepAudioSessionActive];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSString *mainDBPath = [DBManager getPathOfDB:DB_NAME_MAIN];
    if (![[NSFileManager defaultManager] fileExistsAtPath:mainDBPath])
    {
        [ResourceManager copyResourceFromAppBundle:DB_NAME_MAIN
                         toUserDocumentWithNewName:DB_NAME_MAIN
                                           withExt:DB_EXT
                                    forceOverwrite:YES];
    }
    
    BOOL needSyncDB = NO;
    if ([[AppSettingManager sharedInstance] getIsAutoCheckUpdate])
    {
        NSString *latestVersion = nil;
        if ([[ResourceManager sharedInstance] hasNewerDataVersion:&latestVersion])
        {
            needSyncDB = YES;
            
            [Flurry logEvent:kFluryyEventNewDataVersionFound
              withParameters:@{@"version": latestVersion}];
        }
    }
    
    if (needSyncDB)
    {
        DataUpdateVC *dataUpdateVC = [[DataUpdateVC alloc] init];
        self.window.rootViewController = dataUpdateVC;
    }
    else
    {
        [[StateMachine sharedInstance] eventHappend:kEventUserUse];

        CLAuthorizationStatus clAuthStatus = [AppLocationManager authorizationStatus];
        if (clAuthStatus != kCLAuthorizationStatusAuthorizedWhenInUse &&
            clAuthStatus != kCLAuthorizationStatusAuthorizedAlways)
        {
            [[AppLocationManager sharedInstance] requestAlwaysAuthorization];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
