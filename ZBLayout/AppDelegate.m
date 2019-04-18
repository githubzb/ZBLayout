//
//  AppDelegate.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/12.
//  Copyright © 2019 zb. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    self.window = window;
    
    ViewController *vc = [[ViewController alloc] init];
    window.rootViewController = vc;
    [window makeKeyAndVisible];
    return YES;
}


@end
