//
//  AppDelegate.m
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "AppDelegate.h"
#import "ChatViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    // root
    UINavigationController *rootNavVc = [[UINavigationController alloc] initWithRootViewController:[ChatViewController new]];
    self.window.rootViewController = rootNavVc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
