//
//  ZLEventServiceModel.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLEventServiceModel.h"
#import "ZLEventServiceHeader.h"
#import "ZLUserServiceModel.h"

@implementation ZLEventServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLEventServiceModel *eventServiceModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventServiceModel = [[ZLEventServiceModel alloc] init];
    });

    return eventServiceModel;
}


#pragma mark - event

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
    
    NSString * loginName = ZLServiceManager.sharedInstance.viewerServiceModel.currentUserLoginName;
       
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


#pragma mark - notification

- (void) getNotificationsWithShowAll:(bool) showAll
                                page:(int) page
                            per_page:(int) per_page
                        serialNumber:(NSString * _Nonnull)serialNumber
                      completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {

        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;

        ZLMainThreadDispatch(if(handle)handle(resultModel);)
    };
    
    [[ZLGithubHttpClient defaultClient] getNotification:responseBlock
                                                showAll:showAll
                                                   page:page
                                               per_page:per_page
                                           serialNumber:serialNumber];
    
}


- (void) markNotificationReadedWithNotificationId:(NSString * _Nonnull) notificationId
                                     serialNumber:(NSString * _Nonnull)serialNumber
                                   completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {

        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;

        ZLMainThreadDispatch(if(handle)handle(resultModel);)
    };
    
    [[ZLGithubHttpClient defaultClient] markNotificationRead:responseBlock
                                              notificationId:notificationId
                                                serialNumber:serialNumber];
    
}



#pragma mark - pr

- (void) getPRInfoWithLogin:(NSString * _Nonnull) login
                   repoName:(NSString * _Nonnull) repoName
                     number:(int) number
                      after:(NSString * _Nullable) after
               serialNumber:(NSString *_Nonnull) serialNumber
             completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
   
    GithubResponse reposoneBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(resultModel);)
        }
        
    };
    
    [[ZLGithubHttpClient defaultClient] getPRInfoWithLogin:login
                                                  repoName:repoName
                                                    number:number
                                                     after:after
                                              serialNumber:serialNumber
                                                     block:reposoneBlock];
}


#pragma mark - issue

- (void) getRepositoryIssueInfoWithLoginName:(NSString * _Nonnull) loginName
                                    repoName:(NSString * _Nonnull) repoName
                                      number:(int) number
                                       after:(NSString * _Nullable) after
                                serialNumber:(NSString * _Nonnull) serialNumber
                              completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle{
    
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
   
    [[ZLGithubHttpClient defaultClient] getIssueInfoWithLogin:loginName
                                                     repoName:repoName
                                                       number:number
                                                        after:after
                                                 serialNumber:serialNumber
                                                        block:response];
    
}


- (void) createIssueWithFullName:(NSString *) fullName
                           title:(NSString *) title
                            body:(NSString *) body
                          labels:(NSArray *) labels
                       assignees:(NSArray *) assignees
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
    
    
    [[ZLGithubHttpClient defaultClient] createIssue:response
                                           fullName:fullName
                                              title:title
                                            content:body
                                             labels:labels
                                          assignees:assignees
                                       serialNumber:serialNumber];
}


@end
