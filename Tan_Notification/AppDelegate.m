//
//  AppDelegate.m
//  Tan_Notification
//
//  Created by M C on 2017/4/26.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "AppDelegate.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#define iOS_VERSION_INFO  [[[UIDevice currentDevice] systemVersion] floatValue]

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self registerPushNotification];    //注册推送通知
    
    if (launchOptions){
        NSString *str = [NSString stringWithFormat:@"%@", launchOptions];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"知道了1" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UNUserNotificationCenterDelegate
/** app在前台时调用的方法 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0){
    NSLog(@".....1..1.1.1..: %@", notification);
    
    UNNotificationContent *content = notification.request.content;
    
    NSString *str = [NSString stringWithFormat:@"subtitle: %@, \ntitle:%@, \nuserInfo: %@, \nbody: %@", content.subtitle, content.title, content.userInfo, content.body];
    NSLog(@"str: %@", str);
}

/** app在后台时调用的方法 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED{
    NSLog(@"...2.2.2.2.2..: %@", response.notification);
    
    UNNotificationContent *content = response.notification.request.content;
    
    NSString *str = [NSString stringWithFormat:@"subtitle: %@, \ntitle:%@, \nuserInfo: %@, \nbody: %@", content.subtitle, content.title, content.userInfo, content.body];
    NSLog(@"str: %@", str);
    /*
     str: subtitle: sub标题呢,
     title:Hello_Title,
     userInfo: {
        age = 18;
        id = 88;
        name = "\U738b\U5927\U9524";
     },
     body: Hello_Message_Body
     */
}

#pragma mark - 系统通知代理方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSString *str = [NSString stringWithFormat:@"后台远程通知： %@", userInfo];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"知道了2" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    /*
     @property(nullable, nonatomic,copy) NSString *alertBody;      // defaults to nil. pass a string or localized string key to show an alert
     @property(nonatomic) BOOL hasAction;                // defaults to YES. pass NO to hide launching button/slider
     @property(nullable, nonatomic,copy) NSString *alertAction;    // used in UIAlert button or 'slide to unlock...' slider in place of unlock
     @property(nullable, nonatomic,copy) NSString *alertLaunchImage;   // used as the launch image (UILaunchImageFile) when launch button is tapped
     @property(nullable, nonatomic,copy) NSString *alertTitle NS_AVAILABLE_IOS(8_2);  // defaults to nil. pass a string or localized string key
     
     // sound
     @property(nullable, nonatomic,copy) NSString *soundName;      // name of resource in app's bundle to play or UILocalNotificationDefaultSoundName
     
     // badge
     @property(nonatomic) NSInteger applicationIconBadgeNumber;  // 0 means no change. defaults to 0
     
     // user info
     @property(nullable, nonatomic,copy) NSDictionary *userInfo;   // throws if contains non-property list types
     
     // category identifer of the local notification, as set on a UIUserNotificationCategory and passed to +[UIUserNotificationSettings settingsForTypes:categories:]
     @property (nullable, nonatomic, copy) NSString *category NS_AVAILABLE_IOS(8_0);
     */
    NSString *str = [NSString stringWithFormat:@"后台本地通知： %@", notification];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"知道了3" otherButtonTitles:nil, nil];
    [alertView show];
}


#pragma mark - private method
- (void)registerPushNotification{
    //Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        [self registerPushNotificationSystemVersion8_10]
#endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self registerPushNotificationSystemVersion8_10];
    }
}

/** 注册iOS系统8-10 */
- (void)registerPushNotificationSystemVersion8_10{
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

@end
