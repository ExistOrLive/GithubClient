//
//  ZLStarReposBaseViewModel.m
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/12/10.
//  Copyright © 2019 ZM. All rights reserved.
//

// vm
#import "ZLStarReposBaseViewModel.h"

// v
#import "ZLStarReposBaseView.h"

// m
#import "ZLGithubRepositoryModel.h"

// service
#import "ZLAdditionInfoServiceModel.h"
#import "ZLUserServiceModel.h"

@interface ZLStarReposBaseViewModel() <ZLReposListViewDelegate>

@property(nonatomic, weak) ZLStarReposBaseView * view;

@property(nonatomic, assign) int pageNum;

@property(nonatomic, strong) NSString * serialNumber;      // 流水号

@property(nonatomic, assign) BOOL isFreshNew;

@end

@implementation ZLStarReposBaseViewModel

- (void) dealloc
{
    [[ZLUserServiceModel sharedServiceModel] unRegisterObserver:self name:ZLGetCurrentUserInfoResult_Notification];
    [[ZLAdditionInfoServiceModel sharedServiceModel] unRegisterObserver:self name:ZLGetStarredReposResult_Notification];
}

- (void)bindModel:(id)targetModel andView:(UIView *)targetView
{
    if(![targetView isKindOfClass:[ZLStarReposBaseView class]])
    {
        return;
    }
    
    self.view = (ZLStarReposBaseView *) targetView;
    self.view.reposListView.delegate = self;
    
    [[ZLUserServiceModel sharedServiceModel] registerObserver:self selector:@selector(onNotificationArrived:) name:ZLGetCurrentUserInfoResult_Notification];
    [[ZLAdditionInfoServiceModel sharedServiceModel] registerObserver:self selector:@selector(onNotificationArrived:) name:ZLGetStarredReposResult_Notification];
    
}

- (void)VCLifeCycle_viewWillAppear
{
    [super VCLifeCycle_viewWillAppear];
    
    [self loadNewData];
}




#pragma mark - ZLReposListViewDelegate

- (void)reposListViewRefreshDragDownWithReposListView:(ZLReposListView * _Nonnull)reposListView {
    [self loadNewData];
}

- (void)reposListViewRefreshDragUpWithReposListView:(ZLReposListView * _Nonnull)reposListView {
    [self loadMoreData];
}


#pragma mark -  notification

- (void) loadMoreData
{
    NSString * loginName = [[ZLUserServiceModel sharedServiceModel] currentUserLoginName];
    
    if([loginName length] > 0)
    {
        self.serialNumber = [NSString generateSerialNumber];
        self.isFreshNew = NO;
        [[ZLAdditionInfoServiceModel sharedServiceModel] getAdditionInfoForUser:loginName
                                                                       infoType:ZLUserAdditionInfoTypeStarredRepos
                                                                           page:self.pageNum
                                                                       per_page:10
                                                                   serialNumber:self.serialNumber];
    }
    else
    {
        [self.view.reposListView endRefreshWithError];
    }
}

- (void) loadNewData
{
    NSString * loginName = [[ZLUserServiceModel sharedServiceModel] currentUserLoginName];
    
    if([loginName length] > 0)
    {
        self.serialNumber = [NSString generateSerialNumber];
        self.isFreshNew = YES;
        [[ZLAdditionInfoServiceModel sharedServiceModel] getAdditionInfoForUser:loginName
                                                                       infoType:ZLUserAdditionInfoTypeStarredRepos
                                                                           page:1
                                                                       per_page:10
                                                                   serialNumber:self.serialNumber];
    }
    else
    {
        [self.view.reposListView endRefreshWithError];
    }
}


- (void) onNotificationArrived:(NSNotification *) notification
{
    if([notification.name isEqualToString:ZLGetCurrentUserInfoResult_Notification])
    {
        [self loadNewData];
    }
    else if([notification.name isEqualToString:ZLGetStarredReposResult_Notification])
    {
        ZLOperationResultModel * resultModel = (ZLOperationResultModel *)notification.params;
        
        if(![resultModel.serialNumber isEqualToString:self.serialNumber])
        {
            return;
        }
        
        self.serialNumber = nil;
        
        if(!resultModel.result)
        {
            ZLLog_Warning(@"error");
        }
        
        NSArray<ZLGithubRepositoryModel *> * repoModels = resultModel.data;
        NSMutableArray<ZLRepositoryTableViewCellData *> * celldatas = [NSMutableArray new];
        for(ZLGithubRepositoryModel * model in repoModels)
        {
            ZLRepositoryTableViewCellData * cellData = [[ZLRepositoryTableViewCellData alloc] initWithData:model];
            [celldatas addObject:cellData];
        }
        
        if(self.isFreshNew)
        {
            self.pageNum = 2;
            [self.view.reposListView resetCellDatasWithCellDatas:celldatas];
        }
        else
        {
            self.pageNum ++;
            [self.view.reposListView apppendCellDatasWithCellDatas:celldatas];
        }
    }
}

@end
