//
//  AppDelegate.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRItemsViewController.h"
#import "BNRItemStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 如果应用没有触发状态恢复，就创建并设置各个控制器
    if (!self.window.rootViewController) {
        BNRItemsViewController *itemsVC = [[BNRItemsViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:itemsVC];
        
        // 将UINavigationController对象的类名设置为恢复标识
        navi.restorationIdentifier = NSStringFromClass([navi class]);
        
        self.window.rootViewController = navi;
    }
    [self.window makeKeyAndVisible];

    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    // 创建一个新的UINavigationController对象
    UIViewController *vc = [[UINavigationController alloc] init];
    
    // 恢复标识路径中的最后一个对象就是UINavigationController对象的恢复标识
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    // 如果恢复标识路径中只有一个对象
    // 就姜UINavigationController对象设置为UIWindow的rootViewController
    if ([identifierComponents count] == 1) {
        self.window.rootViewController = vc;
    }
    return vc;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    BOOL success = [[BNRItemStore sharedInstance] saveChanges];
    if (success) {
        NSLog(@"Items Archive Success!");
    }else {
        NSLog(@"Items Archive Failed!");
    }
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
