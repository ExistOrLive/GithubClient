//
//  ZLUserServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"
#import "ZLUserServiceHeader.h"
#import "ZLGithubUserModel.h"
@class ZLOperationResultModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZLUserServiceModel : ZLBaseServiceModel

+ (instancetype) sharedServiceModel;

# pragma mark - outer

/**
 * @brief 当前用户的登陆名
 * @return string
 **/
- (NSString *) currentUserLoginName;

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
- (void) getUserInfoWithLoginName:(NSString *) loginName
                         userType:(ZLGithubUserType) userType
                     serialNumber:(NSString *) serailNumber;



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
                             serialNumber:(NSString *) serialNumber;

#pragma mark - follow

/**
 * @brief 获取user follow状态
 * @param loginName 用户的登录名
 **/
- (void) getUserFollowStatusWithLoginName:(NSString *)loginName
                             serialNumber:(NSString *) serialNumber
                           completeHandle:(void(^)(ZLOperationResultModel *)) handle;


/**
* @brief follow user
* @param loginName 用户的登录名
**/
- (void) followUserWithLoginName:(NSString *)loginName
                    serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^)(ZLOperationResultModel *)) handle;

/**
* @brief unfollow user
* @param loginName 用户的登录名
**/
- (void) unfollowUserWithLoginName:(NSString *)loginName
                      serialNumber:(NSString *) serialNumber
                    completeHandle:(void(^)(ZLOperationResultModel *)) handle;


#pragma mark - block

/**
 * @brief 获取当前屏蔽的用户列表
 **/

- (void) getBlockedUsersWithSerialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle;



/**
 * @brief 获取当前用户的屏蔽状态
 * @param loginName 用户的登录名
 **/

- (void) getUserBlockStatusWithLoginName: (NSString *) loginName
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle;

/**
 * @brief 屏蔽当前用户
 * @param loginName 用户的登录名
 **/

- (void) blockUserWithLoginName: (NSString *) loginName
                   serialNumber: (NSString *) serialNumber
                 completeHandle:(void(^)(ZLOperationResultModel *)) handle;

/**
 * @brief 取消屏蔽当前用户
 * @param loginName 用户的登录名
 **/

- (void) unBlockUserWithLoginName: (NSString *) loginName
                     serialNumber: (NSString *) serialNumber
                   completeHandle:(void(^)(ZLOperationResultModel *)) handle;



@end

NS_ASSUME_NONNULL_END
