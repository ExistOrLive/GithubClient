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
 
    self.viewModel = [[ZLNewsViewModel alloc] initWithViewController:self];
    self.baseView = [[NSBundle mainBundle] loadNibNamed:@"ZLNewsBaseView" owner:self options:nil].firstObject;
    [self.contentView addSubview:self.baseView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.viewModel bindModel:nil andView:self.baseView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
