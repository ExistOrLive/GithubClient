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
#import "ZLGithubRepositoryModel.h"

// service
#import "ZLAdditionInfoServiceModel.h"
#import "ZLUserServiceModel.h"

#define ZLQueryMoreStarRequestKey @"ZLQueryMoreMyEventRequestKey"
#define ZLQueryNewStarRequestKey @"ZLQueryNewMyEventRequestKey"

@interface ZLStarReposBaseViewModel() <ZLGithubItemListViewDelegate>

@property(nonatomic, weak) ZLStarReposBaseView * view;

@property(nonatomic, assign) int pageNum;

@property(nonatomic, assign) BOOL isFreshNew;

@property(nonatomic, strong) NSMutableDictionary * serialNumerDic;

@end

@implementation ZLStarReposBaseViewModel

- (instancetype) init {
    if(self = [super init]){
        self.serialNumerDic = [NSMutableDictionary new];
    }
    return self;
}

- (void) dealloc
{
    [[ZLUserServiceModel sharedServiceModel] unRegisterObserver:self name:ZLGetCurrentUserInfoResult_Notification];
    [[ZLAdditionInfoServiceModel sharedServiceModel] unRegisterObserver:self name:ZLGetStarredReposResult_Notification];
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
    
    [[ZLUserServiceModel sharedServiceModel] registerObserver:self selector:@selector(onNotificationArrived:) name:ZLGetCurrentUserInfoResult_Notification];
    [[ZLAdditionInfoServiceModel sharedServiceModel] registerObserver:self selector:@selector(onNotificationArrived:) name:ZLGetStarredReposResult_Notification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationArrived:) name:ZLLanguageTypeChange_Notificaiton object:nil];
    
    [self.view.listView beginRefresh];
}

- (void)VCLifeCycle_viewWillAppear
{
    [super VCLifeCycle_viewWillAppear];
    
    if(self.view.listView.itemCount == 0)
    {
       [self.view.listView beginRefresh];
    }
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
    NSString * loginName = [[ZLUserServiceModel sharedServiceModel] currentUserLoginName];
    
    if([loginName length] > 0)
    {
        NSString *serialNumer = [NSString generateSerialNumber];
        [self.serialNumerDic setObject:serialNumer forKey:ZLQueryMoreStarRequestKey];
        [[ZLAdditionInfoServiceModel sharedServiceModel] getAdditionInfoForUser:loginName
                                                                       infoType:ZLUserAdditionInfoTypeStarredRepos
                                                                           page:self.pageNum
                                                                       per_page:10
                                                                   serialNumber:serialNumer];
    }
    else
    {
        [self.view.listView endRefreshWithError];
    }
}

- (void) loadNewData
{
    NSString * loginName = [[ZLUserServiceModel sharedServiceModel] currentUserLoginName];
    
    if([loginName length] > 0)
    {
        NSString *serialNumber = [NSString generateSerialNumber];
        [self.serialNumerDic setObject:serialNumber forKey:ZLQueryNewStarRequestKey];
        [[ZLAdditionInfoServiceModel sharedServiceModel] getAdditionInfoForUser:loginName
                                                                       infoType:ZLUserAdditionInfoTypeStarredRepos
                                                                           page:1
                                                                       per_page:10
                                                                   serialNumber:serialNumber];
    }
    else
    {
        [self.view.listView endRefreshWithError];
    }
}


- (void) onNotificationArrived:(NSNotification *) notification
{
    if([notification.name isEqualToString:ZLGetCurrentUserInfoResult_Notification])
    {
        if(self.view.listView.itemCount == 0)
        {
            [self.view.listView beginRefresh];
        }
    }
    else if([notification.name isEqualToString:ZLGetStarredReposResult_Notification])
    {
        ZLOperationResultModel * resultModel = (ZLOperationResultModel *)notification.params;
        
        if(![self.serialNumerDic.allValues containsObject:resultModel.serialNumber]){
            return;
        }
        
        if(!resultModel.result){
            [self.view.listView endRefreshWithError];
            ZLGithubRequestErrorModel * model = resultModel.data;
            [ZLToastView showMessage:[NSString stringWithFormat:@"query stars failed statusCode[%ld] errorMessage[%@]",(long)model.statusCode,model.message]];
            return;
        }
        
        NSArray<ZLGithubRepositoryModel *> * repoModels = resultModel.data;
        NSMutableArray<ZLRepositoryTableViewCellData *> * celldatas = [NSMutableArray new];
        for(ZLGithubRepositoryModel * model in repoModels)
        {
            ZLRepositoryTableViewCellData * cellData = [[ZLRepositoryTableViewCellData alloc] initWithData:model];
            [self addSubViewModel:cellData];
            [celldatas addObject:cellData];
        }
        
        if([resultModel.serialNumber isEqualToString:self.serialNumerDic[ZLQueryNewStarRequestKey]])
        {
            self.pageNum = 2;
            [self.view.listView resetCellDatasWithCellDatas:celldatas];
        }
        else if([resultModel.serialNumber isEqualToString:self.serialNumerDic[ZLQueryMoreStarRequestKey]])
        {
            self.pageNum ++;
            [self.view.listView appendCellDatasWithCellDatas:celldatas];
        }
    }else if([ZLLanguageTypeChange_Notificaiton isEqualToString:notification.name]){
        self.viewController.title = ZLLocalizedString(@"star", "");
        [self.view.listView justRefresh];
    }
}

@end
