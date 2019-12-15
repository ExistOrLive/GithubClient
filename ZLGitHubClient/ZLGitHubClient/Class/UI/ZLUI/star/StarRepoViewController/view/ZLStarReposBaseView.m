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
    self.reposListView = [[ZLReposListView alloc] initWithFrame:self.bounds];
    [self addSubview:self.reposListView];
    [self.reposListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
}


@end
