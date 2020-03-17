//
//  ZLNewsViewController.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/1/14.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLNewsViewController.h"

@interface ZLNewsViewController ()

@end

@implementation ZLNewsViewController

+ (UIViewController *)getOneViewController {
    ZLNewsViewController * newsViewController = [[ZLNewsViewController alloc] init];
    return newsViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = ZLLocalizedString(@"news",@"动态");
 
    self.viewModel = [[ZLNewsViewModel alloc] initWithViewController:self];
    ZLGithubItemListView * baseView = [[ZLGithubItemListView alloc] init];
    [baseView setTableViewFooter];
    [baseView setTableViewHeader];
    [self.contentView addSubview:baseView];
    
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
    [self.viewModel bindModel:nil andView:baseView];
    

}

@end
