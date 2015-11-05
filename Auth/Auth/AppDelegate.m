//
//  AppDelegate.m
//  Auth
//
//  Created by Jose on 11/5/15.
//  Copyright © 2015 Jose Bethancourt. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthScanner.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"didReceiveRemoteNotification"];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    return YES;
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"APN: %@", devToken);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"apntoken"]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"apntoken"] == devToken)
        {
            NSLog(@"[APN] Token changed updating.");
        }else {
            NSLog(@"[APN] Token already stored.");
        }
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:devToken forKey:@"apntoken"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"apnsTokenSentSuccessfully"];
        [NSUserDefaults standardUserDefaults];
        NSLog(@"[APN] Token stored.");
        
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [AuthScanner validateFingerFromPush:userInfo];
}
-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error

{
    NSLog(@"Failed to get token, error: %@", error);
#if (TARGET_IPHONE_SIMULATOR)
    [[NSUserDefaults standardUserDefaults] setObject:@"SIMULATOR" forKey:@"apntoken"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"apnsTokenSentSuccessfully"];
    [NSUserDefaults standardUserDefaults];
    NSLog(@"[APN] Token stored. | Simulator");
#endif
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
