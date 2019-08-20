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
#import "ZLLoginResultModel.h"

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
        
        // DB
        [ZLDBMODULE initialDBForUser:model.id_User];
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
        ZLMainThreadDispatch([weakSelf postNotification:ZLGetSpecifiedUserInfoResult_Notification withParams:repoResultModel];)
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


#pragma mark - onNotificationArrived:

- (void) onNotificationArrived:(NSNotification *) notification
{
    ZLLog_Info(@"notification[%@] arrived",notification.name)
    
    if([notification.name isEqualToString:ZLLoginResult_Notification])
    {
        ZLLoginResultModel * resultModel = notification.params;
        if(resultModel.result == YES)
        {
            // 登陆成功后，获取当前用户信息
            [self getCurrentUserInfoForServer:@"serialNumber"];
        }
    }
}

@end

