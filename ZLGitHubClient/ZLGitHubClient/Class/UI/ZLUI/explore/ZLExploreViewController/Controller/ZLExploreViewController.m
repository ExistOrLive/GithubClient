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
    ZLExploreBaseViewModel *viewModel = [ZLExploreBaseViewModel new];
    
    ZLExploreBaseView * baseView = [[NSBundle mainBundle] loadNibNamed:@"ZLExploreBaseView" owner:viewModel options:nil].firstObject;
    [baseView setFrame:ZLScreenBounds];
    [self.view addSubview:baseView];
    
    [self addSubViewModel:viewModel];
    // 关联View ViewModel VC
    [viewModel bindModel:nil andView:baseView];
    
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
