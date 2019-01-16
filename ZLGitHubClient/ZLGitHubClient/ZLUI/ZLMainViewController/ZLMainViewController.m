//
//  ZLMainViewController.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/1/13.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLMainViewController.h"
#import "ZLBaseNavigationViewController.h"
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
    ZLBaseNavigationViewController * tmpNavigationController = [[ZLBaseNavigationViewController alloc] initWithRootViewController:tmpViewController];
    
    UITabBarItem * tabBarItem = [[UITabBarItem alloc] init];
    [tabBarItem setTitle:@"Search"];
    

    NSDictionary * seletedTextAttribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor brownColor],NSForegroundColorAttributeName,nil];
    [tabBarItem setTitleTextAttributes:seletedTextAttribute forState:UIControlStateSelected];
    
    [tmpNavigationController setTabBarItem:tabBarItem];
    
    [self addChildViewController:tmpNavigationController];
}

- (void)setupAllChildViewController {
    UIViewController *newsViewController = [SYDCentralPivotUIAdapter getZLNewsViewController];
    ZLBaseNavigationViewController *newsNavigationController = [[ZLBaseNavigationViewController alloc] initWithRootViewController:newsViewController];
    
    UIViewController *repositoriesViewController = [SYDCentralPivotUIAdapter getZLRepositoriesViewController];
    ZLBaseNavigationViewController *repositoriesNavigationController = [[ZLBaseNavigationViewController alloc] initWithRootViewController:repositoriesViewController];
    
    UIViewController *exploreViewController = [SYDCentralPivotUIAdapter getZLExploreViewController];
    ZLBaseNavigationViewController *exploreNavigationController = [[ZLBaseNavigationViewController alloc] initWithRootViewController:exploreViewController];

    UIViewController *profileViewController = [SYDCentralPivotUIAdapter getZLProfileViewController];
    ZLBaseNavigationViewController *profileNavigationController = [[ZLBaseNavigationViewController alloc] initWithRootViewController:profileViewController];
    
    [self addChildViewController:newsNavigationController];
    [self addChildViewController:repositoriesNavigationController];
    [self addChildViewController:exploreNavigationController];
    [self addChildViewController:profileNavigationController];
}

- (void)setupTabBarItems {
    ZLBaseNavigationViewController *newsNavigationController = self.childViewControllers[0];
    newsNavigationController.tabBarItem.title = @"News";
    newsNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    newsNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_essence_click_icon"];
    
    ZLBaseNavigationViewController *repositoriesNavigationController = self.childViewControllers[1];
    repositoriesNavigationController.tabBarItem.title = @"repositories";
    repositoriesNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    repositoriesNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_essence_click_icon"];
    
    ZLBaseNavigationViewController *exploreNavigationController = self.childViewControllers[2];
    exploreNavigationController.tabBarItem.title = @"explore";
    exploreNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    exploreNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_essence_click_icon"];
    
    ZLBaseNavigationViewController *profileNavigationController = self.childViewControllers[3];
    profileNavigationController.tabBarItem.title = @"profile";
    profileNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    profileNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_essence_click_icon"];
}

@end
