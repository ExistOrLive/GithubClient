//
//  ZLRepositoriesViewController.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/1/14.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLRepositoriesViewController.h"

@interface ZLRepositoriesViewController ()

@end

@implementation ZLRepositoriesViewController

+ (UIViewController *)getOneViewController {
    ZLRepositoriesViewController * repositoriesViewController = [[ZLRepositoriesViewController alloc] init];
    return repositoriesViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
