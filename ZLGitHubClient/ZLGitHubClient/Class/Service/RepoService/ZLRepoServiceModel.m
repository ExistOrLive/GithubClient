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



@end
