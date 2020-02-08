//
//  AppDelegate.m
//  ZLGitHubClient
//
//  Created by zhumeng on 2018/12/27.
//  Copyright © 2018年 ZM. All rights reserved.
//

#import "AppDelegate.h"
#import "ZLGithubAPI.h"
#import "ZLBuglyManager.h"
#import "ZLSharedDataManager.h"

#ifdef DEBUG
#import <DoraemonKit/DoraemonManager.h>
#endif


@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - UIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setUpDoraemonKit];
    
    [self setUpBugly];
    
    /**
     *
     *  初始化中间件
     **/
    [SYDCentralRouter sharedInstance];
    
    /**
     *
     * 初始化工具模块
     **/
    [ZLToolManager sharedInstance];
    
    [ZLLoginServiceModel sharedServiceModel];
    [ZLUserServiceModel sharedServiceModel];
    
    ZLLog_Info(@"中间件，工具模块初始化完毕");
    
    /**
     *
     *  添加监听
     **/
    
    [self addObserver];
    
      /**
       *
       *  初始化window
       **/
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    
    if([[ZLSharedDataManager sharedInstance] githubAccessToken].length == 0)
    {
        // token为空，切到登陆界面
        [self switchToLoginController];
    }
    else
    {
        // token不为空，跳到主界面
        [self switchToMainController];
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
    [self removeObserver];
}


#pragma mark -

- (void) switchToMainController
{
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
        UIViewController * rootViewController = [SYDCentralPivotUIAdapter getZLMainViewController];
        [self.window setRootViewController:rootViewController];
        
    } completion:^(BOOL finished) {
        
    }];
    
  
}

- (void) switchToLoginController
{
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
          
        UIViewController * rootViewController = [[ZLLoginViewController alloc] init];
        [self.window setRootViewController:rootViewController];
          
      } completion:^(BOOL finished) {
          
      }];
}


#pragma mark -

- (void) addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGithubTokenInvalid) name:ZLGithubTokenInvalid_Notification object:nil];
}

- (void) removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZLGithubTokenInvalid_Notification object:nil];
    
  
}


#pragma mark -

- (void) onGithubTokenInvalid
{
    if(![self.window.rootViewController isKindOfClass:[ZLLoginViewController class]])
    {
        [self switchToLoginController];
    }
}

#pragma mark - DoraemonKit

- (void) setUpDoraemonKit
{
    #ifdef DEBUG
           //默认
           [[DoraemonManager shareInstance] install];
           // 或者使用传入位置,解决遮挡关键区域,减少频繁移动
           //[[DoraemonManager shareInstance] installWithStartingPosition:CGPointMake(66, 66)];
       #endif
}

#pragma mark - Bugly
- (void) setUpBugly
{
    [[ZLBuglyManager sharedManager] setUp];
}

 
@end
