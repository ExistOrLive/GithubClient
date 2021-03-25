//
//  ZLAdditionInfoServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLAdditionInfoServiceModel.h"

// HTTP
#import "ZLGithubHTTPClient.h"

// ServiceModel
#import "ZLUserServiceModel.h"

// Model
#import "ZLOperationResultModel.h"

#import "ZLSharedDataManager.h"

@implementation ZLAdditionInfoServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLAdditionInfoServiceModel * model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[ZLAdditionInfoServiceModel alloc] init];
    });
    return model;
}

- (void) getAdditionInfoForUser:(NSString *) userLoginName
                            infoType:(ZLUserAdditionInfoType) type
                                page:(NSUInteger) page
                            per_page:(NSUInteger) per_page
                        serialNumber:(NSString *) serialNumber
{
    // 检查登录名
    if(userLoginName.length == 0)
    {
        ZLLog_Warning(@"userLoginName is nil,so return");
        return;
    }
    
    switch(type)
    {
        case ZLUserAdditionInfoTypeRepositories:
        {
            [self getRepositoriesInfoForUser:userLoginName
                                        page:page
                                    per_page:per_page
                                serialNumber:serialNumber];
        }
            break;
        case ZLUserAdditionInfoTypeGists:
        {
            [self getGistsReposInfoForUser:userLoginName
                                      page:page
                                  per_page:per_page
                              serialNumber:serialNumber];
        }
            break;
        case ZLUserAdditionInfoTypeFollowers:
        {
            [self getFollowersInfoForUser:userLoginName page:page per_page:per_page serialNumber:serialNumber];
        }
            break;
        case ZLUserAdditionInfoTypeFollowing:
        {
            [self getFollowingInfoForUser:userLoginName page:page per_page:per_page serialNumber:serialNumber];
        }
            break;
        case ZLUserAdditionInfoTypeStarredRepos:
        {
            [self getStarredReposInfoForUser:userLoginName page:page per_page:per_page serialNumber:serialNumber];
        }
            break;
    }
    
    
    return;
}




/**
 * @brief 请求repos
 *
 **/
- (NSArray *) getRepositoriesInfoForUser:(NSString *) userLoginName
                                    page:(NSUInteger) page
                                per_page:(NSUInteger) per_page
                            serialNumber:(NSString *) serialNumber
{
    
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
 
        
        ZLMainThreadDispatch([weakSelf postNotification:ZLGetReposResult_Notification withParams:repoResultModel];)
        
       
    };
    
    NSString * currentLoginName = [ZLUserServiceModel sharedServiceModel].currentUserLoginName;
    
    if([currentLoginName isEqualToString:userLoginName])
    {
        // 为当前登陆的用户
        [[ZLGithubHttpClient defaultClient] getRepositoriesForCurrentLoginUser:responseBlock
                                                                          page:page
                                                                      per_page:per_page
                                                                  serialNumber:serialNumber];
    }
    else
    {
        // 不是当前登陆的用户
        [[ZLGithubHttpClient defaultClient] getRepositoriesForUser:responseBlock
                                                         loginName:userLoginName
                                                              page:page
                                                          per_page:per_page
                                                      serialNumber:serialNumber];
    }
    
    return nil;
}

/**
 * @brief 请求followers
 *
 **/
- (NSArray *) getFollowersInfoForUser:(NSString *) userLoginName
                                    page:(NSUInteger) page
                                per_page:(NSUInteger) per_page
                            serialNumber:(NSString *) serialNumber
{
    
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * followerResultModel = [[ZLOperationResultModel alloc] init];
        followerResultModel.result = result;
        followerResultModel.serialNumber = serialNumber;
        followerResultModel.data = responseObject;
     
        
        ZLMainThreadDispatch([weakSelf postNotification:ZLGetFollowersResult_Notification withParams:followerResultModel];)
        
        
    };
    

    [[ZLGithubHttpClient defaultClient] getFollowersForUser:responseBlock
                                                  loginName:userLoginName
                                                       page:page
                                                   per_page:per_page
                                               serialNumber:serialNumber];
    
    
    return nil;
}


/**
 * @brief 请求followers
 *
 **/
- (NSArray *) getFollowingInfoForUser:(NSString *) userLoginName
                                 page:(NSUInteger) page
                             per_page:(NSUInteger) per_page
                         serialNumber:(NSString *) serialNumber
{
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * followingResultModel = [[ZLOperationResultModel alloc] init];
        followingResultModel.result = result;
        followingResultModel.serialNumber = serialNumber;
        followingResultModel.data = responseObject;
 
        
        ZLMainThreadDispatch([weakSelf postNotification:ZLGetFollowingResult_Notification withParams:followingResultModel];)
        
        
    };
    
    
    [[ZLGithubHttpClient defaultClient] getFollowingForUser:responseBlock
                                                  loginName:userLoginName
                                                       page:page
                                                   per_page:per_page
                                               serialNumber:serialNumber];
    return nil;
}



/**
 * @brief 请求标星的repos
 *
 **/
- (NSArray *) getStarredReposInfoForUser:(NSString *) userLoginName
                                    page:(NSUInteger) page
                                per_page:(NSUInteger) per_page
                            serialNumber:(NSString *) serialNumber
{
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
           
           ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
           repoResultModel.result = result;
           repoResultModel.serialNumber = serialNumber;
           repoResultModel.data = responseObject;
    
           
           ZLMainThreadDispatch([weakSelf postNotification:ZLGetStarredReposResult_Notification withParams:repoResultModel];)
           
          
       };
       
    NSString * currentLoginName = [ZLUserServiceModel sharedServiceModel].currentUserLoginName;
       
       if([currentLoginName isEqualToString:userLoginName])
       {
           // 为当前登陆的用户
           [[ZLGithubHttpClient defaultClient] getStarredRepositoriesForCurrentLoginUser:responseBlock
                                                                                    page:page
                                                                                per_page:per_page
                                                                            serialNumber:serialNumber];
       }
       else
       {
           // 不是当前登陆的用户
           [[ZLGithubHttpClient defaultClient] getStarredRepositoriesForUser:responseBlock
                                                                   loginName:userLoginName
                                                                        page:page
                                                                    per_page:per_page
                                                                serialNumber:serialNumber];
       }
       
       return nil;
}


/**
 * @brief 请求标星的repos
 *
 **/
- (NSArray *) getGistsReposInfoForUser:(NSString *) userLoginName
                                  page:(NSUInteger) page
                              per_page:(NSUInteger) per_page
                          serialNumber:(NSString *) serialNumber
{
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        
        ZLMainThreadDispatch([weakSelf postNotification:ZLGetGistsResult_Notification withParams:repoResultModel];)
        
        
    };
    
    NSString * currentLoginName = [ZLUserServiceModel sharedServiceModel].currentUserLoginName;
    
    if([currentLoginName isEqualToString:userLoginName])
    {
        // 为当前登陆的用户
        [[ZLGithubHttpClient defaultClient] getGistsForCurrentUser:responseBlock page:page per_page:per_page serialNumber:serialNumber];
    }
    else
    {
        // 不是当前登陆的用户
        [[ZLGithubHttpClient defaultClient] getGistsForUser:responseBlock loginName:userLoginName page:page per_page:per_page serialNumber:serialNumber];
    }
    
    return nil;
}



/**
 * @brief 获取language列表
 *
 **/
- (void) getLanguagesWithSerialNumber:(NSString *) serialNumber
                       completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(resultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] getLanguagesList:responseBlock
                                            serialNumber:serialNumber];
}



- (void) renderCodeToMarkdownWithCode:(NSString *) code
                         serialNumber:(NSString *) serialNumber
                       completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(resultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] renderCodeToMarkdown:responseBlock code:code serialNumber:serialNumber];
    
    
}


#pragma mark - config

/**
 * @brief 获取功能配置
 *
 **/

- (void) getGithubClientConfig:(NSString *) serialNumber{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        if(result){
            ZLMainThreadDispatch({
                ZLGithubConfigModel *model = responseObject;
                [[ZLSharedDataManager sharedInstance] setConfigModel:model];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZLGithubConfigUpdate_Notification object:nil];
            })
        }
    };
    
    [[ZLGithubHttpClient defaultClient] getGithubClientConfig:responseBlock serialNumber:serialNumber];
}


#pragma mark - org


- (void) getOrgsWithSerialNumber:(NSString *) serialNumber
                  completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        
            
            ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
            resultModel.result = result;
            resultModel.serialNumber = serialNumber;
            resultModel.data = responseObject;
            
            if(handle){
                ZLMainThreadDispatch(handle(resultModel);)
            }
        
    };
    
    [[ZLGithubHttpClient defaultClient] getOrgsWithSerialNumber:serialNumber
                                                          block:responseBlock];
}

#pragma mark - issues

- (void) getMyIssuesWithType:(ZLMyIssueFilterType) type
                       after:(NSString * _Nullable) afterCursor
                serialNumber:(NSString *) serialNumber
              completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
            ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
            resultModel.result = result;
            resultModel.serialNumber = serialNumber;
            resultModel.data = responseObject;
            
            if(handle){
                ZLMainThreadDispatch(handle(resultModel);)
            }
        
    };
    
    NSString *query = @"";
    
    switch (type) {
        case ZLMyIssueFilterTypeCreator:{
            query = @"archived:false sort:created-desc is:open is:issue author:@me";
        }
            break;
        case ZLMyIssueFilterTypeAssigned:{
            query = @"archived:false sort:created-desc is:open is:issue assignee:@me";
        }
            break;
        case ZLMyIssueFilterTypeMentioned:{
            query = @"archived:false sort:created-desc is:open is:issue mentions:@me";
        }
            break;
        default:
            break;
    }
    
    
    [[ZLGithubHttpClient defaultClient] searchIssuesAfter:afterCursor
                                                    query:query
                                             serialNumber:serialNumber
                                                    block:responseBlock];
}

#pragma mark - pr


- (void) getMyPRWithType:(ZLGithubPullRequestState) type
                   after:(NSString * _Nullable) afterCursor
            serialNumber:(NSString *) serialNumber
          completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
            ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
            resultModel.result = result;
            resultModel.serialNumber = serialNumber;
            resultModel.data = responseObject;
            
            if(handle){
                ZLMainThreadDispatch(handle(resultModel);)
            }
        
    };
    
    [[ZLGithubHttpClient defaultClient] getMyPRsWithState:type
                                                    after:afterCursor
                                             serialNumber:serialNumber
                                                    block:responseBlock];
}



- (void) getPRInfoWithLogin:(NSString * _Nonnull) login
                   repoName:(NSString * _Nonnull) repoName
                     number:(int) number
                      after:(NSString * _Nullable) after
               serialNumber:(NSString *_Nonnull) serialNumber
             completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
   
    GithubResponse reposoneBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(resultModel);)
        }
        
    };
    
    [[ZLGithubHttpClient defaultClient] getPRInfoWithLogin:login
                                                  repoName:repoName
                                                    number:number
                                                     after:after
                                              serialNumber:serialNumber
                                                     block:reposoneBlock];
}


@end
