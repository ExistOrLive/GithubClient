//
//  ZLVideoViewController.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/2.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLVideoViewController.h"

#import "ZLVideoBaseView.h"
#import "ZLVideoViewModel.h"

@interface ZLVideoViewController ()

@end

@implementation ZLVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZLVideoBaseView * view = [[ZLVideoBaseView alloc] initWithFrame:ZLScreenBounds];
    [self.view addSubview:view];
    
    self.viewModel = [[ZLVideoViewModel alloc] initWithViewController:self];
    [self.viewModel bindModel:nil andView:view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
