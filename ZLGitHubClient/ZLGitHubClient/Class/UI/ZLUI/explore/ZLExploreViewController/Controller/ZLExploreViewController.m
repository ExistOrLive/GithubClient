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

    ZLExploreBaseView * baseView = [[NSBundle mainBundle] loadNibNamed:@"ZLExploreBaseView" owner:self.viewModel options:nil].firstObject;
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
