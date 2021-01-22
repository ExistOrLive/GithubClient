//
//  ZLUserServiceHeader.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLUserServiceHeader_h
#define ZLUserServiceHeader_h

#import "ZLBaseServiceModel.h"
#import "ZLGithubUserModel.h"

// 获取到登陆用户的信息
static const NSNotificationName _Nonnull ZLGetCurrentUserInfoResult_Notification = @"ZLGetCurrentUserInfoResult_Notification";

static const NSNotificationName _Nonnull ZLGetSpecifiedUserInfoResult_Notification = @"ZLGetSpecifiedUserInfoResult_Notification";

static const NSNotificationName _Nonnull ZLUpdateUserPublicProfileInfoResult_Notification = @"ZLUpdateUserPublicProfileInfoResult_Notification";


@protocol ZLUserServiceModuleProtocol <ZLBaseServiceModuleProtocol>

# pragma mark - outer

/**
 * @brief 当前用户的登陆名
 * @return string
 **/
- (NSString * __nullable) currentUserLoginName;

/**
 * @brief 获取当前登陆用户的详细信息，会先返回内存中的用户信息，并从服务器拉取最新的用户信息
 * @return ZLGithubUserModel
 **/
- (ZLGithubUserModel * __nullable) currentUserInfo;


/**
 * @brief 根据登陆名和用户类型获取用户信息
 * @param loginName 登陆名
 * @param userType 用户类型 ZLGithubUserType_User，ZLGithubUserType_Origanzation
 **/
- (void) getUserInfoWithLoginName:(NSString * _Nonnull) loginName
                         userType:(ZLGithubUserType) userType
                     serialNumber:(NSString * _Nonnull) serailNumber;



/**
 * @brief 更新用户的public Profile info
 * @param email 邮箱
 * @param blog 博客 nil时不更新
 * @param company 公司 nil时不更新
 * @param location 地址 nil时不更新
 * @param bio 自我描述 nil时不更新
 **/
- (void) updateUserPublicProfileWithemail:(NSString * _Nullable) email
                                     blog:(NSString * _Nullable) blog
                                  company:(NSString * _Nullable) company
                                 location:(NSString * _Nullable) location
                                      bio:(NSString * _Nullable) bio
                             serialNumber:(NSString * _Nonnull) serialNumber;

#pragma mark - follow

/**
 * @brief 获取user follow状态
 * @param loginName 用户的登录名
 **/
- (void) getUserFollowStatusWithLoginName:(NSString * _Nonnull)loginName
                             serialNumber:(NSString * _Nonnull) serialNumber
                           completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


/**
* @brief follow user
* @param loginName 用户的登录名
**/
- (void) followUserWithLoginName:(NSString * _Nonnull)loginName
                    serialNumber:(NSString * _Nonnull) serialNumber
                  completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

/**
* @brief unfollow user
* @param loginName 用户的登录名
**/
- (void) unfollowUserWithLoginName:(NSString * _Nonnull)loginName
                      serialNumber:(NSString * _Nonnull) serialNumber
                    completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


#pragma mark - block

/**
 * @brief 获取当前屏蔽的用户列表
 **/

- (void) getBlockedUsersWithSerialNumber:(NSString * _Nonnull) serialNumber
                          completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;



/**
 * @brief 获取当前用户的屏蔽状态
 * @param loginName 用户的登录名
 **/

- (void) getUserBlockStatusWithLoginName: (NSString * _Nonnull) loginName
                            serialNumber:(NSString * _Nonnull) serialNumber
                          completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

/**
 * @brief 屏蔽当前用户
 * @param loginName 用户的登录名
 **/

- (void) blockUserWithLoginName: (NSString * _Nonnull) loginName
                   serialNumber: (NSString * _Nonnull) serialNumber
                 completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

/**
 * @brief 取消屏蔽当前用户
 * @param loginName 用户的登录名
 **/

- (void) unBlockUserWithLoginName: (NSString * _Nonnull) loginName
                     serialNumber: (NSString * _Nonnull) serialNumber
                   completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

/**
 * @brief 查询用户的contributions
 * @param loginName 用户的登录名
 **/
- (void) getUserContributionsDataWithLoginName: (NSString * _Nonnull) loginName
                                  serialNumber: (NSString * _Nonnull) serialNumber
                                completeHandle: (void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle;


@end

#endif /* ZLUserServiceHeader_h */
