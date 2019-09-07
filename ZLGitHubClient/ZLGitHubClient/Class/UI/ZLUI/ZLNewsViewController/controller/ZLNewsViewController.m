//
//  ZLNewsViewController.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/1/14.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLNewsViewController.h"

#import "ZLVideoRecorder.h"

@interface ZLNewsViewController ()

@property (strong, nonatomic) ZLNewsBaseView * baseView;

@end

@implementation ZLNewsViewController

+ (UIViewController *)getOneViewController {
    ZLNewsViewController * newsViewController = [[ZLNewsViewController alloc] init];
    return newsViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = ZLLocalizedString(@"news", @"动态");
    
    self.viewModel = [[ZLNewsViewModel alloc] initWithViewController:self];
    self.baseView = [[NSBundle mainBundle] loadNibNamed:@"ZLNewsBaseView" owner:self options:nil].firstObject;
    [self.baseView setFrame:ZLScreenBounds];
    [self.view addSubview:self.baseView];
    [self.viewModel bindModel:nil andView:self.baseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
