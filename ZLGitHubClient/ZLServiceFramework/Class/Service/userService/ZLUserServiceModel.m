//
//  ZLUserServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

// service
#import "ZLUserServiceModel.h"
#import "ZLLoginServiceModel.h"
#import "ZLOperationResultModel.h"

// network
#import "ZLGithubHttpClient.h"

// tool
#import "ZLSharedDataManager.h"


@implementation ZLUserServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLUserServiceModel * model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[ZLUserServiceModel alloc] init];
    });
    return model;
}

- (instancetype) init
{
    if(self = [super init])
    {
    }
    return self;
}


# pragma mark - interaction with server

- (ZLGithubUserBriefModel *) getUserInfoWithLoginName:(NSString * _Nonnull) loginName
                                         serialNumber:(NSString * _Nonnull) serailNumber
                                       completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle{
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        ZLOperationResultModel * userResultModel = [[ZLOperationResultModel alloc] init];
        userResultModel.result = result;
        userResultModel.serialNumber = serialNumber;
        userResultModel.data = responseObject;
        
        if(result == true && [responseObject isKindOfClass:[ZLGithubUserBriefModel class]]) {
            [ZLDBMODULE insertOrUpdateUserInfo:(ZLGithubUserBriefModel *)responseObject];
        }
        
        ZLMainThreadDispatch(if(handle){handle(userResultModel);})
    };
    
    [[ZLGithubHttpClient defaultClient] getUserOrOrgInfoWithLogin:loginName
                                                     serialNumber:serailNumber
                                                            block:response];
    
    return [ZLDBMODULE getUserOrOrgInfoWithLoginName:loginName];
}



#pragma mark - follow

/**
 * @brief 获取user follow状态
 * @param loginName 用户的登录名
 **/
- (void) getUserFollowStatusWithLoginName:(NSString *) loginName
                             serialNumber:(NSString *) serialNumber
                           completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    if(loginName.length <= 0){
        ZLLog_Info(@"loginName is invalid");
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
    
    [[ZLGithubHttpClient defaultClient] getUserFollowStatus:response loginName:loginName serialNumber:serialNumber];
    
}

/**
 * @brief follow user
 * @param loginName 用户的登录名
 **/
- (void) followUserWithLoginName:(NSString *)loginName
                    serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    if(loginName.length <= 0){
        ZLLog_Info(@"loginName is invalid");
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
    
    [[ZLGithubHttpClient defaultClient] followUser:response loginName:loginName serialNumber:serialNumber];
    
}
/**
 * @brief unfollow user
 * @param loginName 用户的登录名
 **/
- (void) unfollowUserWithLoginName:(NSString *)loginName
                      serialNumber:(NSString *) serialNumber
                    completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    if(loginName.length <= 0){
        ZLLog_Info(@"loginName is invalid");
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
    
    [[ZLGithubHttpClient defaultClient] unfollowUser:response loginName:loginName serialNumber:serialNumber];
    
}

#pragma mark - block

/**
 * @brief 获取当前屏蔽的用户
 **/

- (void) getBlockedUsersWithSerialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] getBlocks:response serialNumber:serialNumber];
}



- (void) getUserBlockStatusWithLoginName: (NSString *) loginName
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] getUserBlockStatus:response
                                                 loginName:loginName
                                              serialNumber:serialNumber];
}

- (void) blockUserWithLoginName: (NSString *) loginName
                   serialNumber: (NSString *) serialNumber
                 completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] blockUser:response
                                        loginName:loginName
                                     serialNumber:serialNumber];
    
}

- (void) unBlockUserWithLoginName: (NSString *) loginName
                     serialNumber: (NSString *) serialNumber
                   completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] unBlockUser:response
                                         loginName:loginName
                                      serialNumber:serialNumber];
}



#pragma mark - contributions

/**
 * @brief 查询用户的contributions
 * @param loginName 用户的登录名
 **/
- (void) getUserContributionsDataWithLoginName: (NSString * _Nonnull) loginName
                                 serialNumber: (NSString * _Nonnull) serialNumber
                                completeHandle: (void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] getUserContributionsData:response
                                                       loginName:loginName
                                                    serialNumber:serialNumber];
}


@end

