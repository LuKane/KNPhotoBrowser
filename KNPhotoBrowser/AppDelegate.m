//
//  AppDelegate.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/1/14.
//  Copyright © 2019 LuKane. All rights reserved.
//  

#import "AppDelegate.h"
#import "NavigationController.h"
#import "FirstViewController.h"

#import "SDImageCache.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // clear memory for test
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        NSLog(@"AppDelegate : clear disk is done for test");
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:[[FirstViewController alloc] init]];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
