//
//  ZLProfileViewController.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/1/14.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLProfileViewController.h"

@interface ZLProfileViewController ()

@property (strong, nonatomic) ZLProfileBaseView * baseView;

@end

@implementation ZLProfileViewController

+ (UIViewController *)getOneViewController {
    ZLProfileViewController * profileViewController = [[ZLProfileViewController alloc] init];
    return profileViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setZLNavigationBarHidden:YES];
    
    ZLProfileBaseViewModel *viewModel = [ZLProfileBaseViewModel new];
    
    self.baseView = [[NSBundle mainBundle] loadNibNamed:@"ZLProfileBaseView" owner:viewModel options:nil].firstObject;
    [self.view addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addSubViewModel:viewModel];
    [viewModel bindModel:nil andView:self.baseView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
