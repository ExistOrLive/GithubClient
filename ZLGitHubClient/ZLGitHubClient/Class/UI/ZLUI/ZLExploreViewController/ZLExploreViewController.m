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
    
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
