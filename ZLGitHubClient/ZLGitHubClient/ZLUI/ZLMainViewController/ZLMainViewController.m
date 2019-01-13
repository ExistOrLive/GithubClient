//
//  ZLMainViewController.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/1/13.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLMainViewController.h"
#import "ZLBaseNavigationViewController.h"

@implementation ZLMainViewController

+ (UIViewController *) getOneViewController
{
    ZLMainViewController * mainViewController = [[ZLMainViewController alloc] init];
    [mainViewController setUpContainerViewControllers];
    return mainViewController;
}

- (instancetype) init
{
    return [super init];
}


- (void) setUpContainerViewControllers
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




@end
