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
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

@interface ZLUserServiceModel()
{
    ZLGithubUserModel * _myInfoModel;
}

@property (strong, nonatomic) dispatch_queue_t concurrentQueue;

@property (strong, nonatomic) ZLGithubUserModel * myInfoModel;          // 缓存，不要直接访问
@end

@implementation ZLUserServiceModel

@dynamic myInfoModel;

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
        _concurrentQueue = dispatch_queue_create("ZLUserServiceModel_Queue", DISPATCH_QUEUE_CONCURRENT);
        [[ZLLoginServiceModel sharedServiceModel] registerObserver:self selector:@selector(onNotificationArrived:) name:ZLLoginResult_Notification];
        [[ZLLoginServiceModel sharedServiceModel] registerObserver:self selector:@selector(onNotificationArrived:) name:ZLLogoutResult_Notification];
    }
    return self;
}

- (void) dealloc
{
    [[ZLLoginServiceModel sharedServiceModel] unRegisterObserver:self name:ZLLoginResult_Notification];
}

# pragma mark - outer

- (NSString *) currentUserLoginName
{
    NSString * userName = self.myInfoModel.loginName;
    return userName;
}

- (ZLGithubUserModel * __nullable) currentUserInfo
{
    ZLGithubUserModel * model = [self.myInfoModel copy];
    
    [self getCurrentUserInfoForServer:@"serialNumber"];
    
    return model;
}

#pragma mark - setter getter

- (ZLGithubUserModel *) myInfoModel
{
    __block ZLGithubUserModel * model = nil;
    dispatch_sync(self.concurrentQueue, ^{
        if(!_myInfoModel)
        {
            _myInfoModel = [[ZLSharedDataManager sharedInstance] userInfoModel];
        }
        model = _myInfoModel;
    });
    return model;
}

- (void) setMyInfoModel:(ZLGithubUserModel *) model
{
    dispatch_barrier_async(self.concurrentQueue, ^{
        self->_myInfoModel = model;
    });
}



# pragma mark - interaction with server

- (void) getCurrentUserInfoForServer:(NSString *) serialNumber
{
    __weak typeof(self) weakSelf = self;
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLLog_Info(@"result = %d, model = %@",result,responseObject);
        if(!result)
        {
            ZLLog_Error(@"get current login ")
            return;
        }
        
        weakSelf.myInfoModel = [responseObject copy];
        [[ZLSharedDataManager sharedInstance] setUserInfoModel:weakSelf.myInfoModel];
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        // 在UI线程发出通知
        ZLMainThreadDispatch([weakSelf postNotification:ZLGetCurrentUserInfoResult_Notification withParams:repoResultModel];)
    };
    
    [[ZLGithubHttpClient defaultClient] getCurrentLoginUserInfo:response serialNumber:serialNumber];
}

- (void) getUserInfoWithLoginName:(NSString *) loginName
                         userType:(ZLGithubUserType) userType
                     serialNumber:(NSString *) serailNumber
{
    __weak typeof(self) weakSelf = self;
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLLog_Info(@"result = %d, model = %@",result,responseObject);
       
        ZLOperationResultModel * userResultModel = [[ZLOperationResultModel alloc] init];
        userResultModel.result = result;
        userResultModel.serialNumber = serialNumber;
        userResultModel.data = responseObject;
        
        // 在UI线程发出通知
        ZLMainThreadDispatch([weakSelf postNotification:ZLGetSpecifiedUserInfoResult_Notification withParams:userResultModel];
)
    };
    
    if([loginName isEqualToString:self.currentUserLoginName] && userType == ZLGithubUserType_User)
    {
        [[ZLGithubHttpClient defaultClient] getCurrentLoginUserInfo:response serialNumber:serailNumber];
    }
    else if(userType == ZLGithubUserType_User)
    {
        [[ZLGithubHttpClient defaultClient] getUserInfo:response
                                              loginName:loginName
                                           serialNumber:serailNumber];
    }
    else if(userType == ZLGithubUserType_Organization)
    {
        [[ZLGithubHttpClient defaultClient] getOrgInfo:response
                                             loginName:loginName
                                          serialNumber:serailNumber];
    }
}


- (void) updateUserPublicProfileWithemail:(NSString *) email
                                     blog:(NSString *) blog
                                  company:(NSString *) company
                                 location:(NSString *) location
                                      bio:(NSString *) bio
                             serialNumber:(NSString *) serialNumber
{
    __weak typeof(self) weakSelf = self;
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLLog_Info(@"result = %d, model = %@",result,responseObject);
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        // 在UI线程发出通知
        ZLMainThreadDispatch(
                             
        [weakSelf postNotification:ZLUpdateUserPublicProfileInfoResult_Notification withParams:repoResultModel];
                            
        if(result){
            [weakSelf postNotification:ZLGetCurrentUserInfoResult_Notification withParams:repoResultModel];
            
        })
    };
    
    [[ZLGithubHttpClient defaultClient] updateUserPublicProfile:response
                                                           name:nil
                                                          email:email
                                                           blog:blog
                                                        company:company
                                                       location:location
                                                       hireable:nil
                                                            bio:bio
                                                   serialNumber:serialNumber];
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





#pragma mark - onNotificationArrived:

- (void) onNotificationArrived:(NSNotification *) notification
{
    ZLLog_Info(@"notification[%@] arrived",notification.name)
    
    if([notification.name isEqualToString:ZLLoginResult_Notification])
    {
        ZLLoginProcessModel * resultModel = notification.params;
        if(resultModel.loginStep == ZLLoginStep_Success)
        {
            
            // 如果本地缓存了数据，就先从本地取出数据
            ZLGithubUserModel * myInfoModel = [[ZLSharedDataManager sharedInstance] userInfoModel];
            [self setMyInfoModel:myInfoModel];
            
            // 登陆成功后，获取当前用户信息
            [self getCurrentUserInfoForServer:@"serialNumber"];
        }
    }
    else if([notification.name isEqualToString:ZLLogoutResult_Notification])
    {
        ZLOperationResultModel * resultModel = notification.params;
        if(resultModel.result)
        {
            // 注销成功
            [self setMyInfoModel:nil];
        }
    }
}


#pragma mark - contributions

/**
 * @brief 查询用户的contributions
 * @param loginName 用户的登录名
 **/
- (void) getUserContributionsDataWithLoginName: (NSString * _Nonnull) loginName
                                 serialNumber: (NSString * _Nonnull) serialNumber
                                completeHandle: (void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    NSString *contributionsUrl = [NSString stringWithFormat:@"https://github.com/users/%@/contributions",loginName];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSError *error = nil;
        
        ZLOperationResultModel *resultModel = [ZLOperationResultModel new];
        resultModel.serialNumber = serialNumber;
        
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:contributionsUrl] encoding:NSUTF8StringEncoding error:&error];
        
        if(error) {
            resultModel.result = false;
            ZLGithubRequestErrorModel *errorModel =  [ZLGithubRequestErrorModel new];
            errorModel.message = error.localizedDescription;
            resultModel.data = errorModel;
        } else {
            OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
            OCQueryObject *queryResult = doc.Query(@".ContributionCalendar-day");
            
            NSMutableArray *contributionsArray = [NSMutableArray new];
            
            for(OCGumboElement *gumboNode in queryResult) {
                if( [gumboNode hasAttribute:@"data-count"]){
                    ZLGithubUserContributionData *data = [ZLGithubUserContributionData new];
                    data.contributionsNumber = [[gumboNode getAttribute:@"data-count"] intValue];
                    data.contributionsDate =  [gumboNode getAttribute:@"data-date"];
                    data.contributionsLevel = [[gumboNode getAttribute:@"data-level"] intValue];;
                    [contributionsArray addObject:data];
                }
            }
            resultModel.result = true;
            resultModel.data = contributionsArray;
        }
        
        ZLMainThreadDispatch({
            handle(resultModel);
        })
    });
}


@end

