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

+ (void)load {
    //获取所有的TabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[ZLMainViewController class]]];
    
    //设置title的颜色
    NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
    attrDic[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrDic forState:UIControlStateSelected];
    
    //设置title字体的大小
    NSMutableDictionary *attrDic2 = [NSMutableDictionary dictionary];
    attrDic2[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:attrDic2 forState:UIControlStateNormal];
}

- (instancetype) init
{
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAllChildViewController];
    [self setupTabBarItems];
}

- (void)setUpContainerViewControllers
{
    UIViewController * tmpViewController = [UIViewController new];
    ZLBaseNavigationController * tmpNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:tmpViewController];
    
    UITabBarItem * tabBarItem = [[UITabBarItem alloc] init];
    [tabBarItem setTitle:@"Search"];
    

    NSDictionary * seletedTextAttribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor brownColor],NSForegroundColorAttributeName,nil];
    [tabBarItem setTitleTextAttributes:seletedTextAttribute forState:UIControlStateSelected];
    
    [tmpNavigationController setTabBarItem:tabBarItem];
    
    [self addChildViewController:tmpNavigationController];
}

- (void)setupAllChildViewController {
    UIViewController *newsViewController = [SYDCentralPivotUIAdapter getZLNewsViewController];
    ZLBaseNavigationController *newsNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:newsViewController];
    
    UIViewController *repositoriesViewController = [SYDCentralPivotUIAdapter getZLRepositoriesViewController];
    ZLBaseNavigationController *repositoriesNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:repositoriesViewController];
    
    UIViewController *exploreViewController = [SYDCentralPivotUIAdapter getZLExploreViewController];
    ZLBaseNavigationController *exploreNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:exploreViewController];

    UIViewController *profileViewController = [SYDCentralPivotUIAdapter getZLProfileViewController];
    ZLBaseNavigationController *profileNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:profileViewController];
    
    [self addChildViewController:newsNavigationController];
    [self addChildViewController:repositoriesNavigationController];
    [self addChildViewController:exploreNavigationController];
    [self addChildViewController:profileNavigationController];
}

- (void)setupTabBarItems {
    ZLBaseNavigationController *newsNavigationController = self.childViewControllers[0];
    newsNavigationController.tabBarItem.title = ZLLocalizedString(@"news", @"动态");
    newsNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    newsNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_new_click_icon"];
    
    ZLBaseNavigationController *repositoriesNavigationController = self.childViewControllers[1];
    repositoriesNavigationController.tabBarItem.title = ZLLocalizedString(@"repositories", @"仓库");
    repositoriesNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    repositoriesNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_essence_click_icon"];
    
    ZLBaseNavigationController *exploreNavigationController = self.childViewControllers[2];
    exploreNavigationController.tabBarItem.title = ZLLocalizedString(@"explore", @"搜索");
    exploreNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    exploreNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_me_click_icon"];
    
    ZLBaseNavigationController *profileNavigationController = self.childViewControllers[3];
    profileNavigationController.tabBarItem.title = ZLLocalizedString(@"profile", @"我");
    profileNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    profileNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_friendTrends_click_icon"];
}


@end
