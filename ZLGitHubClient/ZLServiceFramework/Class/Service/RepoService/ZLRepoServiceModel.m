//
//  ZLRepoServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/24.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLRepoServiceModel.h"
#import "ZLRepoServiceHeader.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"


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

- (ZLGithubRepositoryModel *) getRepoInfoWithFullName:(NSString * _Nonnull) fullName
                                         serialNumber:(NSString * _Nonnull) serialNumber
                                       completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle{
    
    if(fullName.length <= 1 || ![fullName containsString:@"/"]){
        ZLGithubRequestErrorModel *errorModel = [ZLGithubRequestErrorModel errorModelWithStatusCode:0 message:@"fullName is invalid" documentation_url:nil];
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = false;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = errorModel;
        handle(repoResultModel);
        return nil;
    }
    
    NSString *ownerName = [fullName componentsSeparatedByString:@"/"].firstObject;
    NSString *name = [fullName componentsSeparatedByString:@"/"].lastObject;
    
    return [self getRepoInfoWithOwnerName:ownerName
                                 repoName:name
                             serialNumber:serialNumber
                           completeHandle:handle];
}

/**
 * @brief 根据repo full name 获取仓库信息
 * @param ownerName octocat
 * @param repoName Hello-World
 * @param serialNumber 流水号
 **/
- (ZLGithubRepositoryModel *) getRepoInfoWithOwnerName:(NSString * _Nonnull) ownerName
                                              repoName:(NSString * _Nonnull) repoName
                                          serialNumber:(NSString * _Nonnull) serialNumber
                                        completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(result == true){
            [ZLDBMODULE insertOrUpdateRepoInfo:(ZLGithubRepositoryModel *)responseObject];
        }
        
        ZLMainThreadDispatch(if(handle){
            handle(repoResultModel);
        })
    };
    
    [[ZLGithubHttpClient defaultClient] getRepoInfoWithLogin:ownerName
                                                        name:repoName
                                                serialNumber:serialNumber
                                                       block:response];
    
    return [ZLDBMODULE getRepoInfoWithFullName:[NSString stringWithFormat:@"%@/%@",ownerName,repoName]];
    
}


#pragma mark - commits branch language pullrequest issue


- (void) getRepoReadMeInfoWithFullName:(NSString *) fullName
                                branch:(NSString * __nullable) branch
                                isHTML:(BOOL) isHTML
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
        
        if(handle){
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] getRepositoryReadMeInfo:response
                                                       fullName:fullName
                                                         branch:branch
                                                         isHTML:isHTML
                                                   serialNumber:serialNumber];
}


- (void) getRepoPullRequestWithFullName:(NSString *) fullName
                                  state:(NSString *) state
                               per_page:(NSInteger)per_page
                                   page:(NSInteger)page
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
    
    [[ZLGithubHttpClient defaultClient] getRepositoryPullRequestInfo:response
                                                            fullName:fullName
                                                               state:state
                                                            per_page:per_page
                                                                page:page
                                                        serialNumber:serialNumber];
}



- (void) getRepoCommitWithFullName:(NSString *) fullName
                            branch:(NSString * __nullable) branch
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
                                                          branch:branch
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






/**
 * @brief 根据repo fullname获取 issues
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryIssuesWithFullName:(NSString *) fullName
                                   state:(NSString *) state
                                per_page:(NSInteger) per_page
                                    page:(NSInteger) page
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
    
    
    [[ZLGithubHttpClient defaultClient] getRepositoryIssues:response
                                                   fullName:fullName
                                                      state:state
                                                   per_page:per_page
                                                       page:page
                                               serialNumber:serialNumber];
}






#pragma mark - subscription

- (void) watchRepoWithFullName:(NSString *) fullName
                  serialNumber:(NSString *) serialNumber
                completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"]){
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber){
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] watchRepository:response fullName:fullName serialNumber:serialNumber];
}

- (void) unwatchRepoWithFullName:(NSString *) fullName
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
    
    
    [[ZLGithubHttpClient defaultClient] unwatchRepository:response fullName:fullName serialNumber:serialNumber];
}

- (void) getRepoWatchStatusWithFullName:(NSString *) fullName
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
    
    
    [[ZLGithubHttpClient defaultClient] getWatchRepositoryStatus:response
                                                        fullName:fullName
                                                    serialNumber:serialNumber];
}



- (void) getRepoWatchersWithFullName:(NSString *) fullName
                        serialNumber:(NSString *) serialNumber
                            per_page:(NSInteger) per_page
                                page:(NSInteger) page
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
    
    [[ZLGithubHttpClient defaultClient] getRepoWatchers:response
                                               fullName:fullName
                                               per_page:per_page
                                                   page:page
                                           serialNumber:serialNumber];
}


#pragma mark - star repo

- (void) starRepoWithFullName:(NSString *) fullName
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
    
    
    [[ZLGithubHttpClient defaultClient] starRepository:response fullName:fullName serialNumber:serialNumber];
}

- (void) unstarRepoWithFullName:(NSString *) fullName
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
    
    
    [[ZLGithubHttpClient defaultClient] unstarRepository:response fullName:fullName serialNumber:serialNumber];
}

- (void) getRepoStarStatusWithFullName:(NSString *) fullName
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
    
    
    [[ZLGithubHttpClient defaultClient] getStarRepositoryStatus:response
                                                       fullName:fullName
                                                   serialNumber:serialNumber];
}

- (void) getRepoStargazersWithFullName:(NSString *) fullName
                          serialNumber:(NSString *) serialNumber
                              per_page:(NSInteger) per_page
                                  page:(NSInteger) page
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
    
    
    [[ZLGithubHttpClient defaultClient] getRepoStargazers:response
                                                 fullName:fullName
                                                 per_page:per_page
                                                     page:page
                                             serialNumber:serialNumber];
    
    
}


#pragma mark - fork

- (void) forkRepositoryWithFullName:(NSString *) fullName
                                org:(NSString * __nullable) org
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
    
    
    [[ZLGithubHttpClient defaultClient] forkRepository:response
                                              fullName:fullName
                                                   org:org
                                          serialNumber:serialNumber];
}


- (void) getRepoForksWithFullName:(NSString *) fullName
                     serialNumber:(NSString *) serialNumber
                         per_page:(NSInteger) per_page
                             page:(NSInteger) page
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
    
    [[ZLGithubHttpClient defaultClient] getRepoForks:response
                                            fullName:fullName
                                            per_page:per_page
                                                page:page
                                        serialNumber:serialNumber];
}

#pragma mark - languages

- (void) getRepoLanguagesWithFullName:(NSString *) fullName
                         serialNumber:(NSString *) serialNumber
                       completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    
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
    
    [[ZLGithubHttpClient defaultClient] getRepoLanguages:response fullName:fullName serialNumber:serialNumber];
}



#pragma mark - actions

- (void) getRepoWorkflowsWithFullName:(NSString *) fullName
                             per_page:(NSInteger) per_page
                                 page:(NSInteger) page
                         serialNumber:(NSString *) serialNumber
                       completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
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
    
    [[ZLGithubHttpClient defaultClient] getRepoWorkflows:response
                                                fullName:fullName
                                                per_page:per_page
                                                    page:page
                                            serialNumber:serialNumber];
}


- (void) getRepoWorkflowRunsWithFullName:(NSString *) fullName
                              workflowId:(NSString *) workflowId
                                per_page:(NSInteger) per_page
                                    page:(NSInteger) page
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
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
    
    [[ZLGithubHttpClient defaultClient] getRepoWorkflowRuns:response
                                                   fullName:fullName
                                                 workflowId:workflowId
                                                   per_page:per_page
                                                       page:page
                                               serialNumber:serialNumber];
}


- (void) rerunRepoWorkflowRunWithFullName:(NSString *) fullName
                            workflowRunId:(NSString *) workflowRunId
                             serialNumber:(NSString *) serialNumber
                           completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
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
    
    [[ZLGithubHttpClient defaultClient] rerunRepoWorkflowRun:response
                                                    fullName:fullName
                                               workflowRunId:workflowRunId
                                                serialNumber:serialNumber];
}

- (void) cancelRepoWorkflowRunWithFullName:(NSString *) fullName
                             workflowRunId:(NSString *) workflowRunId
                              serialNumber:(NSString *) serialNumber
                            completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
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
    
    [[ZLGithubHttpClient defaultClient] cancelRepoWorkflowRun:response
                                                     fullName:fullName
                                                workflowRunId:workflowRunId
                                                 serialNumber:serialNumber];
}

- (void) getRepoWorkflowRunLogWithFullName:(NSString *) fullName
                             workflowRunId:(NSString *) workflowRunId
                              serialNumber:(NSString *) serialNumber
                            completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
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
    
    [[ZLGithubHttpClient defaultClient] getRepoWorkflowRunLog:response
                                                     fullName:fullName
                                                workflowRunId:workflowRunId
                                                 serialNumber:serialNumber];
    
}

#pragma mark - File Content


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
                                                   acceptType:nil
                                                 serialNumber:serialNumber];
}



- (void) getRepositoryFileHTMLInfoWithFullName:(NSString *) fullName
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
                                                   acceptType:@"application/vnd.github.v3.html+json"
                                                 serialNumber:serialNumber];
}


- (void) getRepositoryFileRawInfoWithFullName:(NSString *) fullName
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
                                                   acceptType:@"application/vnd.github.v3.raw+json"
                                                 serialNumber:serialNumber];
}

- (void) getRepositoryFileContentWithHTMLURL:(NSString *) htmlURL
                                      branch:(NSString *) branch
                                serialNumber:(NSString *) serialNumber
                              completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSError *error = nil;
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:htmlURL]
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
        
        ZLOperationResultModel * operationResultModel = [[ZLOperationResultModel alloc] init];
        if(error) {
            operationResultModel.result = false;
            operationResultModel.serialNumber = serialNumber;
            ZLGithubRequestErrorModel *model = [[ZLGithubRequestErrorModel alloc] init];
            model.message = error.localizedDescription;
            operationResultModel.data = model;
        } else {
            OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
            NSArray<OCGumboElement *> *tableArray = doc.Query(@"table");
            if(tableArray.count > 0){
                operationResultModel.result = true;
                operationResultModel.serialNumber = serialNumber;
                operationResultModel.data = tableArray.firstObject.parentNode.html();
            } else {
                operationResultModel.result = false;
                operationResultModel.serialNumber = serialNumber;
                ZLGithubRequestErrorModel *model = [[ZLGithubRequestErrorModel alloc] init];
                model.message = @"Not Found";
                operationResultModel.data = model;
            }
        }

        ZLMainThreadDispatch({
            if(handle){
                handle(operationResultModel);
            }
        })
    });
}


@end
