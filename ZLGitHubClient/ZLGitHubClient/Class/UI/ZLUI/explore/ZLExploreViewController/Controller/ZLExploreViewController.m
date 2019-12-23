//
//  ZLExploreViewController.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/1/14.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLExploreViewController.h"

@interface ZLExploreViewController ()

@end

@implementation ZLExploreViewController

+ (UIViewController *)getOneViewController {
    ZLExploreViewController * exploreViewController = [[ZLExploreViewController alloc] init];
    return exploreViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  创建ViewModel
    self.viewModel = [[ZLExploreBaseViewModel alloc] initWithViewController:self];
    
    // 创建baseView
    ZLPageTabViewController * pageTabViewController = [ZLPageTabViewController new];
    UIViewController * controller1 = [UIViewController new];
    [controller1.view setBackgroundColor:[UIColor redColor]];
    controller1.title = @"red";
    
    UIViewController * controller2 = [UIViewController new];
       [controller2.view setBackgroundColor:[UIColor yellowColor]];
       controller2.title = @"yellow";
    
    UIViewController * controller3 = [UIViewController new];
       [controller3.view setBackgroundColor:[UIColor greenColor]];
       controller3.title = @"green";
    
    [pageTabViewController addChildViewController:controller1];
    [pageTabViewController addChildViewController:controller2];
    [pageTabViewController addChildViewController:controller3];

    [self addChildViewController:pageTabViewController];
    
    ZLExploreBaseView * baseView = [[NSBundle mainBundle] loadNibNamed:@"ZLExploreBaseView" owner:self.viewModel options:nil].firstObject;
    [baseView addMainViewWithMainView:pageTabViewController.view];
    [baseView setFrame:ZLScreenBounds];
    [self.view addSubview:baseView];
    
    // 关联View ViewModel VC
    [self.viewModel bindModel:nil andView:baseView];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
