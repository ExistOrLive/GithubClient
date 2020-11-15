//
//  ZLMainViewController.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/1/13.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLMainViewController.h"
#import "ZLBaseNavigationController.h"
#import "UIImage+Image.h"

@implementation ZLMainViewController

+ (UIViewController *) getOneViewController
{
    ZLMainViewController * mainViewController = [[ZLMainViewController alloc] init];
    return mainViewController;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZLLanguageTypeChange_Notificaiton object:nil];
}

- (instancetype) init
{
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setTranslucent:NO];
    [self setupAllChildViewController];
    [self setupTabBarItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationArrived:) name:ZLLanguageTypeChange_Notificaiton object:nil];
    
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    // 外观模式切换
    [super traitCollectionDidChange:previousTraitCollection];
    
    if (@available(iOS 13.0, *)) {
        if(self.traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle){
            [self justReloadView];
        }
    }
}


- (void)setupAllChildViewController {
    UIViewController *newsViewController = [SYDCentralPivotUIAdapter getZLNewsViewController];
    ZLBaseNavigationController *newsNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:newsViewController];
    
    UIViewController *notificationViewController = [[ZLNotificationController alloc] init];
    ZLBaseNavigationController *notificationNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:notificationViewController];
    
    UIViewController *starsViewController = [SYDCentralPivotUIAdapter getZLStarRepoViewController];
    ZLBaseNavigationController *repositoriesNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:starsViewController];
    
    UIViewController *exploreViewController = [SYDCentralPivotUIAdapter getZLExploreViewController];
    ZLBaseNavigationController *exploreNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:exploreViewController];

    UIViewController *profileViewController = [SYDCentralPivotUIAdapter getZLProfileViewController];
    ZLBaseNavigationController *profileNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:profileViewController];
    
    [self addChildViewController:newsNavigationController];
    [self addChildViewController:notificationNavigationController];
    [self addChildViewController:repositoriesNavigationController];
    [self addChildViewController:exploreNavigationController];
    [self addChildViewController:profileNavigationController];
}

- (void)setupTabBarItems {
    
    for(int i = 0; i < self.childViewControllers.count; i++){
        UITabBarItem *tabBarItem = self.childViewControllers[i].tabBarItem;
        switch(i){
            case 0:{
                tabBarItem.title = ZLLocalizedString(@"news", @"动态");
                tabBarItem.image = [UIImage imageOriginalName:@"tabBar_new_icon"];
                tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_new_click_icon"];
            }
                break;
            case 1:{
                tabBarItem.title =  ZLLocalizedString(@"Notification", "通知");
                tabBarItem.image = [UIImage imageOriginalName:@"tabBar_Notification"];
                tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_Notification_click"];
            }
                break;
            case 2:{
                tabBarItem.title =  ZLLocalizedString(@"star", "标星");
                tabBarItem.image = [UIImage imageOriginalName:@"tabBar_me_icon"];
                tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_me_click_icon"];
            }
                break;
            case 3:{
                tabBarItem.title = ZLLocalizedString(@"explore", @"搜索");
                tabBarItem.image = [UIImage imageOriginalName:@"tabBar_friendTrends_icon"];
                tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_friendTrends_click_icon"];
            }
                break;
            case 4:{
                tabBarItem.title = ZLLocalizedString(@"profile", @"我");
                tabBarItem.image = [UIImage imageOriginalName:@"tabBar_essence_icon"];
                tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_essence_click_icon"];
            }
                break;
        }
    }
    
    if(@available(iOS 13.0, *)){
        self.tabBar.tintColor = [UIColor colorNamed:@"ZLTabBarTintColor"];
    }else{
        //设置title的颜色
        NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
        attrDic[NSForegroundColorAttributeName] = [UIColor colorNamed:@"ZLTabBarTintColor"];
        [[UITabBarItem appearance] setTitleTextAttributes:attrDic forState:UIControlStateSelected];
    }
    [[UITabBar appearance] setBarTintColor:[UIColor colorNamed:@"ZLTabBarBackColor"]];
    
}

- (void) justReloadView
{
    ZLBaseNavigationController *newsNavigationController = self.childViewControllers[0];
    newsNavigationController.tabBarItem.title = ZLLocalizedString(@"news", @"动态");
    newsNavigationController.tabBarItem.image = [UIImage imageOriginalName:@"tabBar_new_icon"];
    newsNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_new_click_icon"];
    
    ZLBaseNavigationController *notificaitonNavigationController = self.childViewControllers[1];
    notificaitonNavigationController.tabBarItem.title = ZLLocalizedString(@"Notification", @"通知");
    notificaitonNavigationController.tabBarItem.image = [UIImage imageOriginalName:@"tabBar_Notification"];
    notificaitonNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_Notification_click"];
    
    ZLBaseNavigationController *repositoriesNavigationController = self.childViewControllers[2];
    repositoriesNavigationController.tabBarItem.title = ZLLocalizedString(@"star", @"标星");
    repositoriesNavigationController.tabBarItem.image = [UIImage imageOriginalName:@"tabBar_me_icon"];
    repositoriesNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_me_click_icon"];
    
    ZLBaseNavigationController *exploreNavigationController = self.childViewControllers[3];
    exploreNavigationController.tabBarItem.title = ZLLocalizedString(@"explore", @"搜索");
    exploreNavigationController.tabBarItem.image = [UIImage imageOriginalName:@"tabBar_friendTrends_icon"];
    exploreNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_friendTrends_click_icon"];

    ZLBaseNavigationController *profileNavigationController = self.childViewControllers[4];
    profileNavigationController.tabBarItem.title = ZLLocalizedString(@"profile", @"我");
    profileNavigationController.tabBarItem.image = [UIImage imageOriginalName:@"tabBar_essence_icon"];
    profileNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_essence_click_icon"];
}

- (void) onNotificationArrived:(NSNotification *) notification
{
    if([ZLLanguageTypeChange_Notificaiton isEqualToString:notification.name])
    {
        [self justReloadView];
    }
}

@end
