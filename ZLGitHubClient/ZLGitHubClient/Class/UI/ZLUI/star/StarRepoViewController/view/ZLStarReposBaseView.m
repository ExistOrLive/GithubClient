//
//  ZLStarReposBaseView.m
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/12/10.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLStarReposBaseView.h"

@implementation ZLStarReposBaseView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self setUpUI];
    }
    
    return self;
}


- (void) setUpUI
{
    self.listView = [[ZLGithubItemListView alloc] initWithFrame:self.bounds];
    [self.listView setTableViewFooter];
    [self.listView setTableViewHeader];
    [self addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


@end
