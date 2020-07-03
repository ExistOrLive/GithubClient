//
//  ZLEventServiceModel.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLEventServiceModel.h"
#import "ZLEventServiceHeader.h"

@implementation ZLEventServiceModel

+ (instancetype)shareInstance
{
    static ZLEventServiceModel *eventServiceModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventServiceModel = [[ZLEventServiceModel alloc] init];
    });

    return eventServiceModel;
}

- (instancetype)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

/**
 *  @brief 请求当前用户的event
 *
 **/
- (void) getMyEventsWithpage:(NSUInteger)page
                    per_page:(NSUInteger)per_page
                serialNumber:(NSString *)serialNumber
{
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch([weakSelf postNotification:ZLGetMyEventResult_Notification withParams:repoResultModel];)
    };
    
    NSString * loginName = [ZLUserServiceModel sharedServiceModel].currentUserLoginName;
       
    [[ZLGithubHttpClient defaultClient] getEventsForUser:loginName
                                                    page:page
                                                per_page:per_page
                                            serialNumber:serialNumber
                                           responseBlock:responseBlock];
}


/**
 *  @brief 请求用户的event
 *
 **/
- (void) getEventsForUser:(NSString *) userName
                     page:(NSUInteger)page
                per_page:(NSUInteger)per_page
            serialNumber:(NSString *)serialNumber
{
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch([weakSelf postNotification:ZLGetUserReceivedEventResult_Notification withParams:repoResultModel];)
    };
           
    [[ZLGithubHttpClient defaultClient] getEventsForUser:userName
                                                    page:page
                                                per_page:per_page
                                            serialNumber:serialNumber
                                           responseBlock:responseBlock];
}


/**
 * @brief 请求某个用户的receive_events
 *
 **/
- (void)getReceivedEventsForUser:(NSString *)userName
                                    page:(NSUInteger)page
                                per_page:(NSUInteger)per_page
                            serialNumber:(NSString *)serialNumber
{
    
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {

        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;

        ZLMainThreadDispatch([weakSelf postNotification:ZLGetUserReceivedEventResult_Notification withParams:repoResultModel];)
    };
    
    [[ZLGithubHttpClient defaultClient] getReceivedEventsForUser:userName page:page per_page:per_page serialNumber:serialNumber responseBlock:responseBlock];
}


@end
