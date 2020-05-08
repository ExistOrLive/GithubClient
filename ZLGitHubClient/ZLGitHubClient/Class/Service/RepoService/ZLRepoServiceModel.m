//
//  ZLRepoServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/24.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLRepoServiceModel.h"
#import "ZLRepoServiceHeader.h"

// network
#import "ZLGithubHttpClient.h"

@implementation ZLRepoServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLRepoServiceModel * serviceModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceModel = [[ZLRepoServiceModel alloc] init];
    });
    return serviceModel;
}


/**
 * @brief 根据repo full name 获取仓库信息
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepoInfoWithFullName:(NSString *) fullName
                    serialNumber:(NSString *) serialNumber
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch(
        [weakSelf postNotification:ZLGetSpecifiedRepoInfoResult_Notification withParams:repoResultModel];)
    };
    
    [[ZLGithubHttpClient defaultClient] getRepositoryInfo:response
                                                 fullName:fullName
                                             serialNumber:serialNumber];
}

/**
 * @brief 根据repo full name 获取仓库信息
 * @param ownerName octocat
 * @param repoName Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepoInfoWithOwnerName:(NSString *) ownerName
                     withrepoName:(NSString *) repoName
                     serialNumber:(NSString *) serialNumber
{
    if(ownerName.length == 0 || repoName.length == 0)
    {
        ZLLog_Info(@"ownerName  or repoName is not valid");
        return;
    }
    
    NSString * fullName = [NSString stringWithFormat:@"%@/%@",ownerName,repoName];
    
    [self getRepoInfoWithFullName:fullName serialNumber:serialNumber];
}



- (void) getRepoReadMeInfoWithFullName:(NSString *) fullName
                          serialNumber:(NSString *) serialNumber
                        completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
         ZLLog_Info(@"fullName is not valid");
         return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] getRepositoryReadMeInfo:response
                                                       fullName:fullName
                                                   serialNumber:serialNumber];
}


- (void) getRepoPullRequestWithFullName:(NSString *) fullName
                                  state:(NSString *) state
                           serialNumber:(NSString *) serialNumber
                         completeHandle:(void(^)(ZLOperationResultModel *)) handle

{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
       {
            ZLLog_Info(@"fullName is not valid");
            return;
       }
       
       GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
       {
           ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
           repoResultModel.result = result;
           repoResultModel.serialNumber = serialNumber;
           repoResultModel.data = responseObject;
           
           if(handle)
           {
               ZLMainThreadDispatch(handle(repoResultModel);)
           }
       };
       
    [[ZLGithubHttpClient defaultClient] getRepositoryPullRequestInfo:response
                                                            fullName:fullName
                                                               state:state
                                                        serialNumber:serialNumber];
}



- (void) getRepoCommitWithFullName:(NSString *) fullName
                             until:(NSDate *) untilDate
                             since:(NSDate *) sinceDate
                      serialNumber:(NSString *) serialNumber
                    completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    
    [[ZLGithubHttpClient defaultClient] getRepositoryCommitsInfo:response
                                                        fullName:fullName
                                                           until:untilDate
                                                           since:sinceDate
                                                    serialNumber:serialNumber];
}


/**
* @brief 根据repo 获取branch
* @param fullName octocat/Hello-World
* @param serialNumber 流水号
**/
- (void) getRepositoryBranchesInfoWithFullName:(NSString *) fullName
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    
    [[ZLGithubHttpClient defaultClient] getRepositoryBranchesInfo:response
                                                         fullName:fullName
                                                     serialNumber:serialNumber];
}


/**
* @brief 根据repo fullname获取 内容
* @param fullName octocat/Hello-World
* @param serialNumber 流水号
**/
- (void) getRepositoryContentsInfoWithFullName:(NSString *) fullName
                                          path:(NSString *) path
                                        branch:(NSString *) branch
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
       {
           ZLLog_Info(@"fullName is not valid");
           return;
       }
       
       GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
       {
           ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
           repoResultModel.result = result;
           repoResultModel.serialNumber = serialNumber;
           repoResultModel.data = responseObject;
           
           if(handle)
           {
               ZLMainThreadDispatch(handle(repoResultModel);)
           }
       };
       
       
    [[ZLGithubHttpClient defaultClient] getRepositoryContentsInfo:response
                                                         fullName:fullName
                                                             path:path
                                                           branch:branch
                                                     serialNumber:serialNumber];
}


- (void) getRepositoryFileInfoWithFullName:(NSString *) fullName
                                      path:(NSString *) path
                                    branch:(NSString *) branch
                              serialNumber:(NSString *) serialNumber
                            completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    
    [[ZLGithubHttpClient defaultClient] getRepositoryFileInfo:response
                                                     fullName:fullName
                                                         path:path
                                                       branch:branch
                                                 serialNumber:serialNumber];
}


/**
 * @brief 根据repo fullname获取 贡献者
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryContributorsWithFullName:(NSString *) fullName
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle{
   
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    
    [[ZLGithubHttpClient defaultClient] getRepositoryContributors:response
                                                         fullName:fullName
                                                     serialNumber:serialNumber];
}

@end
