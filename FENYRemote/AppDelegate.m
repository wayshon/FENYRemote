//
//  AppDelegate.m
//  ipadDemo
//
//  Created by 王旭 on 15/10/31.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import "AppDelegate.h"
#import "ODXSocket.h"
#import "SocketModel.h"
#import "ODXGuideViewController.h"
#import "TabBarController.h"


@interface AppDelegate ()
@property (atomic,strong) ODXSocket *socket;
@property (atomic,strong) SocketModel *model;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        ODXGuideViewController *GuideViewController = [[ODXGuideViewController alloc] init];
        self.window.rootViewController = GuideViewController;
    }
    else{
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TabBarController *tabBarVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"tabBarController"];
            self.window.rootViewController = tabBarVC;
        } else {
            UIStoryboard *iPhoneStoryBoard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
            TabBarController *tabBarVC = [iPhoneStoryBoard instantiateViewControllerWithIdentifier:@"phoneTabVC"];
            self.window.rootViewController = tabBarVC;
        }
    }
    [self.window makeKeyAndVisible];
    _socket = [ODXSocket sharedSocket];
    _model = [SocketModel sharedModel];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)dealloc {
    
}

@end
