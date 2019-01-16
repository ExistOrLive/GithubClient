//
//  ZLNewsViewController.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/1/14.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import "ZLNewsViewController.h"

@interface ZLNewsViewController ()

@end

@implementation ZLNewsViewController

+ (UIViewController *)getOneViewController {
    ZLNewsViewController * newsViewController = [[ZLNewsViewController alloc] init];
    return newsViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
