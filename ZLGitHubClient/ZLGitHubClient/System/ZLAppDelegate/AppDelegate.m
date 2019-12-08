//
//  AppDelegate.m
//  ZLGitHubClient
//
//  Created by zhumeng on 2018/12/27.
//  Copyright © 2018年 ZM. All rights reserved.
//

#import "AppDelegate.h"
#import "ZLGithubAPI.h"
#import <YKWoodpecker/YKWoodpecker.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - UIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setUpYKWoodpecker];
    
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
    
    
    if([[ZLKeyChainManager sharedInstance] getGithubAccessToken].length == 0)
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
    UIViewController * rootViewController = [SYDCentralPivotUIAdapter getZLMainViewController];
    [self.window setRootViewController:rootViewController];
}

- (void) switchToLoginController
{
    UIViewController * rootViewController = [[ZLLoginViewController alloc] init];
    [self.window setRootViewController:rootViewController];
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

#pragma mark - 啄木鸟

- (void) setUpYKWoodpecker
{
      // 方法监听命令配置JSON地址 * 可选，如无单独配置，可使用 https://github.com/ZimWoodpecker/WoodpeckerCmdSource 上的配置
       [YKWoodpeckerManager shareInstance].cmdSourceUrl = @"https://raw.githubusercontent.com/ZimWoodpecker/WoodpeckerCmdSource/master/cmdSource/default/cmds_cn.json";
       
       // Release 下可开启安全模式，只支持打开安全插件 * 可选
    #ifndef DEBUG
       [YKWoodpeckerManager sharedInstance].safePluginMode = YES;
    #endif

       // 设置 parseDelegate，可通过 YKWCmdCoreCmdParseDelegate 协议实现自定义命令 * 可选
       [YKWoodpeckerManager shareInstance].cmdCore.parseDelegate = self;
       
       // 显示啄幕鸟，启动默认打开UI检查插件
       [[YKWoodpeckerManager shareInstance] show];
       
       // 启动时可直接打开某一插件 * 可选
    //    [[YKWoodpeckerManager sharedInstance] openPluginNamed:@"xxx"];
}
 
@end
