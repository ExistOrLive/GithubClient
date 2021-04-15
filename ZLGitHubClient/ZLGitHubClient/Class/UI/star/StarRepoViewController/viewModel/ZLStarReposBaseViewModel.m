//
//  ZLStarReposBaseViewModel.m
//  ZLGitHubClient
//
//  Created by ZM on 2019/12/10.
//  Copyright © 2019 ZM. All rights reserved.
//

// vm
#import "ZLStarReposBaseViewModel.h"

// v
#import "ZLStarReposBaseView.h"

// m

// service
#import <ZLServiceFramework/ZLServiceFramework.h>


@interface ZLStarReposBaseViewModel() <ZLGithubItemListViewDelegate>

@property(nonatomic, weak) ZLStarReposBaseView * view;

@property(nonatomic, assign) int pageNum;

@end

@implementation ZLStarReposBaseViewModel


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)bindModel:(id)targetModel andView:(UIView *)targetView
{
    if(![targetView isKindOfClass:[ZLStarReposBaseView class]])
    {
        return;
    }
    
    self.view = (ZLStarReposBaseView *) targetView;
    self.view.listView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationArrived:) name:ZLLanguageTypeChange_Notificaiton object:nil];
    
    [self.view.listView beginRefresh];
}



#pragma mark - ZLReposListViewDelegate

- (void) githubItemListViewRefreshDragUpWithPullRequestListView:(ZLGithubItemListView *)pullRequestListView{
    [self loadMoreData];
}

- (void) githubItemListViewRefreshDragDownWithPullRequestListView:(ZLGithubItemListView *)pullRequestListView{
    [self loadNewData];
}


#pragma mark -  notification

- (void) loadMoreData
{
    NSString * loginName = [ZLServiceManager sharedInstance].viewerServiceModel.currentUserLoginName;
    
    if([loginName length] > 0){
        
        __weak typeof(self) weakSelf = self;
        [[ZLServiceManager sharedInstance].userServiceModel getAdditionInfoForUser:loginName
                                                                          infoType:ZLUserAdditionInfoTypeStarredRepos
                                                                              page:self.pageNum + 1
                                                                          per_page:10
                                                                      serialNumber:NSString.generateSerialNumber completeHandle:^(ZLOperationResultModel * _Nonnull resultModel) {
            if(resultModel.result){
               
                NSArray<ZLGithubRepositoryModel *> * array = (NSArray<ZLGithubRepositoryModel *> *)resultModel.data;
                NSMutableArray<ZLGithubItemTableViewCellData *> * cellDatas = [NSMutableArray new];
                for(ZLGithubRepositoryModel *model in array){
                    ZLGithubItemTableViewCellData* cellData = [[ZLRepositoryTableViewCellData alloc] initWithData:model];
                    [cellDatas addObject:cellData];
                }
                [weakSelf addSubViewModels:cellDatas];
                [weakSelf.view.listView appendCellDatasWithCellDatas:cellDatas];
                weakSelf.pageNum = weakSelf.pageNum + 1;
                
            } else {
                ZLGithubRequestErrorModel *errorModel = (ZLGithubRequestErrorModel *)resultModel.data;
                [ZLToastView showMessage:[NSString stringWithFormat:@"query star repo error [%ld](%@)",errorModel.statusCode,errorModel.message]];
                [self.view.listView endRefreshWithError];
            }
        }];
    }
    else
    {
        [self.view.listView endRefreshWithError];
    }
}

- (void) loadNewData
{
    NSString * loginName = [ZLServiceManager sharedInstance].viewerServiceModel.currentUserLoginName;
    
    if([loginName length] > 0)
    {
        __weak typeof(self) weakSelf = self;
        [[ZLServiceManager sharedInstance].userServiceModel getAdditionInfoForUser:loginName
                                                                          infoType:ZLUserAdditionInfoTypeStarredRepos
                                                                              page:1
                                                                          per_page:10
                                                                      serialNumber:NSString.generateSerialNumber completeHandle:^(ZLOperationResultModel * _Nonnull resultModel) {
            if(resultModel.result){
               
                NSArray<ZLGithubRepositoryModel *> * array = (NSArray<ZLGithubRepositoryModel *> *)resultModel.data;
                NSMutableArray<ZLGithubItemTableViewCellData *> * cellDatas = [NSMutableArray new];
                for(ZLGithubRepositoryModel *model in array){
                    ZLGithubItemTableViewCellData* cellData = [[ZLRepositoryTableViewCellData alloc] initWithData:model];
                    [cellDatas addObject:cellData];
                }
                [weakSelf addSubViewModels:cellDatas];
                [weakSelf.view.listView resetCellDatasWithCellDatas:cellDatas];
                weakSelf.pageNum = 1;
                
            } else {
                ZLGithubRequestErrorModel *errorModel = (ZLGithubRequestErrorModel *)resultModel.data;
                [ZLToastView showMessage:[NSString stringWithFormat:@"query star repo error [%ld](%@)",errorModel.statusCode,errorModel.message]];
                [self.view.listView endRefreshWithError];
            }
        }];
    }
    else
    {
        [self.view.listView endRefreshWithError];
    }
}


- (void) onNotificationArrived:(NSNotification *) notification
{
    if([ZLLanguageTypeChange_Notificaiton isEqualToString:notification.name]){
        self.viewController.title = ZLLocalizedString(@"star", "");
        [self.view.listView justRefresh];
    }
}

@end
