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

// network
#import "ZLGithubHttpClient.h"

// model

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
        
        // 初始化数据库
        NSString * userLoginName = [[ZLKeyChainManager sharedInstance] getUserAccount];
        [ZLDBMODULE initialDBForUser:userLoginName];
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
    
   // [self getCurrentUserInfoForServer:@"serialNumber"];
    
    return model;
}

#pragma mark - setter getter

- (ZLGithubUserModel *) myInfoModel
{
    __block ZLGithubUserModel * model = nil;
    dispatch_sync(self.concurrentQueue, ^{
        if(!_myInfoModel)
        {
            _myInfoModel = [ZLDBMODULE getCurrentUserInfo];
        }
        model = _myInfoModel;
    });
    return model;
}

- (void) setMyInfoModel:(ZLGithubUserModel *) model
{
    dispatch_barrier_async(self.concurrentQueue, ^{
        _myInfoModel = model;
    });
}



# pragma mark - interaction with server

- (void) getCurrentUserInfoForServer:(NSString *) serialNumber
{
    __weak typeof(self) weakSelf = self;
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLGithubUserModel * model = (ZLGithubUserModel *) responseObject;
        ZLLog_Info(@"result = %d, model = %@",result,responseObject);
        if(!result)
        {
            ZLLog_Error(@"get current login ")
            return;
        }
        weakSelf.myInfoModel = [responseObject copy];
        
        // 更新用户名和头像URL
        [[ZLKeyChainManager sharedInstance] updateUserHeadImageURL:model.avatar_url];
        [[ZLKeyChainManager sharedInstance] updateUserAccount:model.loginName];
        
        // 更新本地数据库中个人信息
        [ZLDBMODULE initialDBForUser:model.loginName];
        [ZLDBMODULE insertOrUpdateUserInfo:model];
        
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
       
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        // 在UI线程发出通知
        ZLMainThreadDispatch([weakSelf postNotification:ZLGetSpecifiedUserInfoResult_Notification withParams:repoResultModel];
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
        ZLMainThreadDispatch([weakSelf postNotification:ZLUpdateUserPublicProfileInfoResult_Notification withParams:repoResultModel];
                             if(result){[weakSelf postNotification:ZLGetCurrentUserInfoResult_Notification withParams:repoResultModel];})
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
            NSString * loginName = [[ZLKeyChainManager sharedInstance] getUserAccount];
            if(loginName != nil && ![loginName isEqualToString:@""])
            {
                ZLGithubUserModel * userModel = [ZLDBMODULE getUserInfoWithUserLoginName:loginName];
                if(userModel != nil)
                {
                    [self setMyInfoModel:userModel];
                }
            }
            
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

@end

