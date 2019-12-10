//
//  ZLStarReposBaseViewModel.m
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/12/10.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLStarReposBaseViewModel.h"
#import "ZLStarReposBaseView.h"
@interface ZLStarReposBaseViewModel()

@property(nonatomic, weak) ZLStarReposBaseView * view;


@end

@implementation ZLStarReposBaseViewModel

- (void)bindModel:(id)targetModel andView:(UIView *)targetView
{
    if(![targetView isKindOfClass:[ZLStarReposBaseView class]])
    {
        return;
    }
    
    self.view = (ZLStarReposBaseView *) targetView;
    self.view.reposListView.dele
    
    
    
    
}

@end
