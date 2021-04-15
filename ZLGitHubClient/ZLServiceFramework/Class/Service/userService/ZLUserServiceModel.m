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

#import <MJExtension/MJExtension.h>


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


# pragma mark - user info

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
    
    [[ZLGithubHttpClient defaultClient] getUserInfo:response
                                          loginName:loginName
                                       serialNumber:serailNumber];
    
//    [[ZLGithubHttpClient defaultClient] getUserOrOrgInfoWithLogin:loginName
//                                                     serialNumber:serailNumber
//                                                            block:response];
    
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
- (NSArray<ZLGithubUserContributionData *> *) getUserContributionsDataWithLoginName: (NSString * _Nonnull) loginName
                                                                       serialNumber: (NSString * _Nonnull) serialNumber
                                                                     completeHandle: (void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    NSString *contributionsStr = [ZLDBMODULE getUserContributionsWithLoginName:loginName];
    NSMutableArray *contributionsArray = [ZLGithubUserContributionData mj_objectArrayWithKeyValuesArray:contributionsStr];
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(result == true){
            id keyValueArray = [ZLGithubUserContributionData mj_keyValuesArrayWithObjectArray:responseObject];
            NSString *tmpcontributionStr = [keyValueArray mj_JSONString];
            if(tmpcontributionStr != nil){
                [ZLDBMODULE insertOrUpdateUserContributions:tmpcontributionStr loginName:loginName];
            }
        }
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] getUserContributionsData:response
                                                       loginName:loginName
                                                    serialNumber:serialNumber];
    
    return contributionsArray;
}



#pragma mark - user additions info (repos followers followings gists)

- (void) getAdditionInfoForUser:(NSString * _Nonnull) userLoginName
                       infoType:(ZLUserAdditionInfoType) type
                           page:(NSUInteger) page
                       per_page:(NSUInteger) per_page
                   serialNumber:(NSString * _Nonnull) serialNumber
                 completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    // 检查登录名
    if(userLoginName.length == 0){
        ZLLog_Warning(@"userLoginName is nil,so return");
        ZLOperationResultModel* resultModel = [ZLOperationResultModel new];
        resultModel.result = false;
        resultModel.data = [ZLGithubRequestErrorModel errorModelWithStatusCode:0 message:@"login is nil" documentation_url:nil];
        resultModel.serialNumber = serialNumber;
        handle(resultModel);
        return;
    }
    
    switch(type)
    {
        case ZLUserAdditionInfoTypeRepositories:
        {
            [self getRepositoriesInfoForUser:userLoginName
                                        page:page
                                    per_page:per_page
                                serialNumber:serialNumber
                              completeHandle:handle];
        }
            break;
        case ZLUserAdditionInfoTypeGists:
        {
            [self getGistsForUser:userLoginName
                             page:page
                         per_page:per_page
                     serialNumber:serialNumber
                   completeHandle:handle];
        }
            break;
        case ZLUserAdditionInfoTypeFollowers:
        {
            [self getFollowersInfoForUser:userLoginName
                                     page:page
                                 per_page:per_page
                             serialNumber:serialNumber
                           completeHandle:handle];
        }
            break;
        case ZLUserAdditionInfoTypeFollowing:
        {
            [self getFollowingInfoForUser:userLoginName
                                     page:page
                                 per_page:per_page
                             serialNumber:serialNumber
                           completeHandle:handle];
        }
            break;
        case ZLUserAdditionInfoTypeStarredRepos:
        {
            [self getStarredReposInfoForUser:userLoginName
                                        page:page
                                    per_page:per_page
                                serialNumber:serialNumber
                              completeHandle:handle];
        }
            break;
    }
    
    
    return;
}




/**
 * @brief 请求repos
 *
 **/
- (void) getRepositoriesInfoForUser:(NSString *) userLoginName
                                    page:(NSUInteger) page
                                per_page:(NSUInteger) per_page
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
 
        
        if(handle){
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    NSString * currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel.currentUserLoginName;
    
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
    
}

/**
 * @brief 请求followers
 *
 **/
- (void) getFollowersInfoForUser:(NSString *) userLoginName
                                    page:(NSUInteger) page
                                per_page:(NSUInteger) per_page
                            serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * followerResultModel = [[ZLOperationResultModel alloc] init];
        followerResultModel.result = result;
        followerResultModel.serialNumber = serialNumber;
        followerResultModel.data = responseObject;
     
        if(handle){
            ZLMainThreadDispatch(handle(followerResultModel);)
        }
    };
    

    [[ZLGithubHttpClient defaultClient] getFollowersForUser:responseBlock
                                                  loginName:userLoginName
                                                       page:page
                                                   per_page:per_page
                                               serialNumber:serialNumber];
}


/**
 * @brief 请求followers
 *
 **/
- (void) getFollowingInfoForUser:(NSString *) userLoginName
                                 page:(NSUInteger) page
                             per_page:(NSUInteger) per_page
                         serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * followingResultModel = [[ZLOperationResultModel alloc] init];
        followingResultModel.result = result;
        followingResultModel.serialNumber = serialNumber;
        followingResultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(followingResultModel);)
        }
        
    };
    
    
    [[ZLGithubHttpClient defaultClient] getFollowingForUser:responseBlock
                                                  loginName:userLoginName
                                                       page:page
                                                   per_page:per_page
                                               serialNumber:serialNumber];
}



/**
 * @brief 请求标星的repos
 *
 **/
- (void) getStarredReposInfoForUser:(NSString *) userLoginName
                                    page:(NSUInteger) page
                                per_page:(NSUInteger) per_page
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle
{
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    NSString * currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel.currentUserLoginName;
    
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
}


/**
 * @brief 请求gists
 *
 **/
- (void) getGistsForUser:(NSString *) userLoginName
                    page:(NSUInteger) page
                per_page:(NSUInteger) per_page
            serialNumber:(NSString *) serialNumber
          completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle
{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch( handle(repoResultModel);)
        }
    };
    
    NSString * currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel.currentUserLoginName;
    
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
    
}



@end

