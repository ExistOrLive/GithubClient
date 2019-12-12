//
//  ZLStarReposBaseViewModel.m
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/12/10.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLStarReposBaseViewModel.h"
#import "ZLStarReposBaseView.h"
@interface ZLStarReposBaseViewModel() <ZLReposListViewDelegate>

@property(nonatomic, weak) ZLStarReposBaseView * view;

@property(nonatomic, assign) int pageNum;


@end

@implementation ZLStarReposBaseViewModel

- (void)bindModel:(id)targetModel andView:(UIView *)targetView
{
    if(![targetView isKindOfClass:[ZLStarReposBaseView class]])
    {
        return;
    }
    
    self.view = (ZLStarReposBaseView *) targetView;
    self.view.reposListView.delegate = self;
}

- (void)VCLifeCycle_viewWillAppear
{
    [super VCLifeCycle_viewWillAppear];
    
    [self.view.reposListView beginRefresh];
}




#pragma mark - ZLReposListViewDelegate

- (void)reposListViewRefreshDragDownWithReposListView:(ZLReposListView * _Nonnull)reposListView {
    
}

- (void)reposListViewRefreshDragUpWithReposListView:(ZLReposListView * _Nonnull)reposListView {
    
}


#pragma mark - 

@end
