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
    
    self.baseView = [[NSBundle mainBundle] loadNibNamed:@"ZLProfileBaseView" owner:self options:nil].firstObject;
    [self.baseView setFrame:ZLScreenBounds];
    [self.view addSubview:self.baseView];
    
    self.viewModel = [[ZLProfileBaseViewModel alloc] initWithViewController:self];
    [self.viewModel bindModel:nil andView:self.baseView];
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
