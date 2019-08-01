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
#import "ZLAdditionInfoResultModel.h"


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

- (NSArray *) getAdditionInfoForUser:(NSString *) userLoginName
                            infoType:(ZLUserAdditionInfoType) type
                                page:(NSUInteger) page
                            per_page:(NSUInteger) per_page
                        serialNumber:(NSString *) serialNumber
{
    // 首先检查流水号
    //    if(serialNumber.length == 0)
    //    {
    //        ZLLog_Warning(@"serialNumber is nil,so return");
    //        return nil;
    //    }
    
    // 检查登录名
    if(userLoginName.length == 0)
    {
        ZLLog_Warning(@"userLoginName is nil,so return");
        return nil;
    }
    
    switch(type)
    {
        case ZLUserAdditionInfoTypeRepositories:
        {
            return [self getRepositoriesInfoForUser:userLoginName
                                               page:page
                                           per_page:per_page
                                       serialNumber:serialNumber];
        }
            break;
        case ZLUserAdditionInfoTypeGists:
        {
            
        }
            break;
        case ZLUserAdditionInfoTypeFollowers:
        {
            return [self getFollowersInfoForUser:userLoginName page:page per_page:per_page serialNumber:serialNumber];
        }
            break;
        case ZLUserAdditionInfoTypeFollowing:
        {
            return [self getFollowingInfoForUser:userLoginName page:page per_page:per_page serialNumber:serialNumber];
        }
            break;
        case ZLUserAdditionInfoTypeStars:
        {
            
        }
            break;
    }
    
    
    return nil;
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
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLAdditionInfoResultModel * repoResultModel = [[ZLAdditionInfoResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        
        if(result)
        {
            repoResultModel.data = responseObject;
        }
        else
        {
            repoResultModel.errorModel = responseObject;
        }
        
        ZLMainThreadDispatch([self postNotification:ZLGetReposResult_Notification withParams:repoResultModel])
        
       
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
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLAdditionInfoResultModel * followerResultModel = [[ZLAdditionInfoResultModel alloc] init];
        followerResultModel.result = result;
        followerResultModel.serialNumber = serialNumber;
        
        if(result)
        {
            followerResultModel.data = responseObject;
        }
        else
        {
            followerResultModel.errorModel = responseObject;
        }
        
        ZLMainThreadDispatch([self postNotification:ZLGetFollowersResult_Notification withParams:followerResultModel])
        
        
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
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLAdditionInfoResultModel * followingResultModel = [[ZLAdditionInfoResultModel alloc] init];
        followingResultModel.result = result;
        followingResultModel.serialNumber = serialNumber;
        
        if(result)
        {
            followingResultModel.data = responseObject;
        }
        else
        {
            followingResultModel.errorModel = responseObject;
        }
        
        ZLMainThreadDispatch([self postNotification:ZLGetFollowingResult_Notification withParams:followingResultModel])
        
        
    };
    
    
    [[ZLGithubHttpClient defaultClient] getFollowingForUser:responseBlock
                                                  loginName:userLoginName
                                                       page:page
                                                   per_page:per_page
                                               serialNumber:serialNumber];
    return nil;
}
@end
