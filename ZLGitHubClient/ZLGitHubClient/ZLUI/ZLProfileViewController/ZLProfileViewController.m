//
//  ZLProfileViewController.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/1/14.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import "ZLProfileViewController.h"

@interface ZLProfileViewController ()

@end

@implementation ZLProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

+ (UIViewController *)getOneViewController {
    ZLProfileViewController * profileViewController = [[ZLProfileViewController alloc] init];
    return profileViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
