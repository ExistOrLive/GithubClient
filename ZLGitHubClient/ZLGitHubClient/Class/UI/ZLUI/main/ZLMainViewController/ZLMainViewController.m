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
@interface ZLMainViewController()

@property(nonatomic, strong) ZLAssistButtonManager * assistManager;

@end

@implementation ZLMainViewController

+ (UIViewController *) getOneViewController
{
    ZLMainViewController * mainViewController = [[ZLMainViewController alloc] init];
    return mainViewController;
}

- (void)dealloc
{
    [[ZLAssistButtonManager sharedInstance] setHidden:YES];
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
    
    [[ZLAssistButtonManager sharedInstance] setHidden:[ZLSharedDataManager sharedInstance].assistButtonHidden];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

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
    
    UIViewController *workboardViewController = [ZLUIRouter getWorkboardViewController];
    ZLBaseNavigationController *workNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:workboardViewController];
    
    UIViewController *notificationViewController = [ZLUIRouter getNotificationViewController];
    ZLBaseNavigationController *notificationNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:notificationViewController];
        
    UIViewController *exploreViewController = [ZLUIRouter getExploreViewController];
    ZLBaseNavigationController *exploreNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:exploreViewController];

    UIViewController *profileViewController = [ZLUIRouter getProfileViewController];
    ZLBaseNavigationController *profileNavigationController = [[ZLBaseNavigationController alloc] initWithRootViewController:profileViewController];
    
    [self addChildViewController:workNavigationController];
    [self addChildViewController:notificationNavigationController];
    [self addChildViewController:exploreNavigationController];
    [self addChildViewController:profileNavigationController];
}

- (void)setupTabBarItems {
    
    for(int i = 0; i < self.childViewControllers.count; i++){
        UITabBarItem *tabBarItem = self.childViewControllers[i].tabBarItem;
        switch(i){
            case 0:{
                tabBarItem.title =  ZLLocalizedString(@"Workboard", "工作台");
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
                tabBarItem.title = ZLLocalizedString(@"explore", @"搜索");
                tabBarItem.image = [UIImage imageOriginalName:@"tabBar_friendTrends_icon"];
                tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_friendTrends_click_icon"];
            }
                break;
            case 3:{
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
  
    // [[UITabBar appearance] setBarTintColor:[UIColor colorNamed:@"ZLTabBarBackColor"]];
    
    UIImage *backImage = [UIImage imageWithColor:[UIColor colorNamed:@"ZLTabBarBackColor"]];
    [self.tabBar setBackgroundImage:backImage];
    [self.tabBar setShadowImage:backImage];
    
}

- (void) justReloadView
{
    ZLBaseNavigationController *newsNavigationController = self.childViewControllers[0];
    newsNavigationController.tabBarItem.title = ZLLocalizedString(@"Workboard", @"工作台");
    newsNavigationController.tabBarItem.image = [UIImage imageOriginalName:@"tabBar_new_icon"];
    newsNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_new_click_icon"];
    
    
    ZLBaseNavigationController *notificaitonNavigationController = self.childViewControllers[1];
    notificaitonNavigationController.tabBarItem.title = ZLLocalizedString(@"Notification", @"通知");
    notificaitonNavigationController.tabBarItem.image = [UIImage imageOriginalName:@"tabBar_Notification"];
    notificaitonNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_Notification_click"];
    
    ZLBaseNavigationController *exploreNavigationController = self.childViewControllers[2];
    exploreNavigationController.tabBarItem.title = ZLLocalizedString(@"explore", @"搜索");
    exploreNavigationController.tabBarItem.image = [UIImage imageOriginalName:@"tabBar_friendTrends_icon"];
    exploreNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_friendTrends_click_icon"];

    ZLBaseNavigationController *profileNavigationController = self.childViewControllers[3];
    profileNavigationController.tabBarItem.title = ZLLocalizedString(@"profile", @"我");
    profileNavigationController.tabBarItem.image = [UIImage imageOriginalName:@"tabBar_essence_icon"];
    profileNavigationController.tabBarItem.selectedImage = [UIImage imageOriginalName:@"tabBar_essence_click_icon"];
    
    UIImage *backImage = [UIImage imageWithColor:[UIColor colorNamed:@"ZLTabBarBackColor"]];
    [self.tabBar setBackgroundImage:backImage];
    [self.tabBar setShadowImage:backImage];
    
}

- (void) justReloadLanguage{

    ZLBaseNavigationController *newsNavigationController = self.childViewControllers[0];
    newsNavigationController.tabBarItem.title = ZLLocalizedString(@"Workboard", @"动态");
    
    ZLBaseNavigationController *notificaitonNavigationController = self.childViewControllers[1];
    notificaitonNavigationController.tabBarItem.title = ZLLocalizedString(@"Notification", @"通知");
        
    ZLBaseNavigationController *exploreNavigationController = self.childViewControllers[2];
    exploreNavigationController.tabBarItem.title = ZLLocalizedString(@"explore", @"搜索");

    ZLBaseNavigationController *profileNavigationController = self.childViewControllers[3];
    profileNavigationController.tabBarItem.title = ZLLocalizedString(@"profile", @"我");
}


- (void) onNotificationArrived:(NSNotification *) notification
{
    if([ZLLanguageTypeChange_Notificaiton isEqualToString:notification.name])
    {
        [self justReloadLanguage];
    }
}

@end
