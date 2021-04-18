//
//  ZLEventServiceHeader.h
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

#ifndef ZLEventServiceHeader_h
#define ZLEventServiceHeader_h

#import "ZLBaseServiceModel.h"

#pragma mark - NotificationName

static NSNotificationName const _Nonnull ZLGetUserReceivedEventResult_Notification = @"ZLGetUserReceivedEventResult_Notification";
static NSNotificationName const _Nonnull ZLGetMyEventResult_Notification = @"ZLGetMyEventResult_Notification";

@protocol ZLEventServiceModuleProtocol <ZLBaseServiceModuleProtocol>

#pragma mark - event

/**
 *  @brief 请求当前用户的event
 *
 **/
- (void) getMyEventsWithpage:(NSUInteger)page
                    per_page:(NSUInteger)per_page
                serialNumber:(NSString * _Nonnull)serialNumber;

/**
 *  @brief 请求用户的event
 *
 **/
- (void) getEventsForUser:(NSString * _Nonnull) userName
                     page:(NSUInteger)page
                 per_page:(NSUInteger)per_page
             serialNumber:(NSString * _Nonnull)serialNumber;



/**
 * @brief 请求某个用户的receive_events
 *
 **/
- (void)getReceivedEventsForUser:(NSString * _Nonnull)userName
                            page:(NSUInteger)page
                        per_page:(NSUInteger)per_page
                    serialNumber:(NSString * _Nonnull)serialNumber;



#pragma mark - notification

- (void) getNotificationsWithShowAll:(bool) showAll
                                page:(int) page
                            per_page:(int) page
                        serialNumber:(NSString * _Nonnull)serialNumber
                      completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;


- (void) markNotificationReadedWithNotificationId:(NSString * _Nonnull) notificationId
                                     serialNumber:(NSString * _Nonnull)serialNumber
                                   completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;


#pragma mark - PR

- (void) getPRInfoWithLogin:(NSString * _Nonnull) login
                   repoName:(NSString * _Nonnull) repoName
                     number:(int) number
                      after:(NSString * _Nullable) after
               serialNumber:(NSString *_Nonnull) serialNumber
             completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;


#pragma mark - issues

- (void) getRepositoryIssueInfoWithLoginName:(NSString * _Nonnull) loginName
                                    repoName:(NSString * _Nonnull) repoName
                                      number:(int) number
                                       after:(NSString * _Nullable) after
                                serialNumber:(NSString * _Nonnull) serialNumber
                              completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


/**
 * @brief 根据repo fullname 创建 issues
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) createIssueWithFullName:(NSString * _Nonnull) fullName
                           title:(NSString * _Nonnull) title
                            body:(NSString * __nullable) body
                          labels:(NSArray * __nullable) labels
                       assignees:(NSArray * __nullable) assignees
                    serialNumber:(NSString * _Nonnull) serialNumber
                  completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;
@end

#endif /* ZLEventServiceHeader_h */
