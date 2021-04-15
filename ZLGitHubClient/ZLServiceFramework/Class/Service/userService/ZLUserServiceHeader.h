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
#import "ZLGithubUserType.h"
@class ZLGithubUserContributionData;
/**
 * github 用户附加信息类型
 *
 **/
typedef NS_ENUM(NSUInteger, ZLUserAdditionInfoType) {
    ZLUserAdditionInfoTypeRepositories,
    ZLUserAdditionInfoTypeGists,
    ZLUserAdditionInfoTypeFollowers,
    ZLUserAdditionInfoTypeFollowing,
    ZLUserAdditionInfoTypeStarredRepos,
};



// 获取到登陆用户的信息
static const NSNotificationName _Nonnull ZLGetCurrentUserInfoResult_Notification = @"ZLGetCurrentUserInfoResult_Notification";
//
static const NSNotificationName _Nonnull ZLUpdateUserPublicProfileInfoResult_Notification = @"ZLUpdateUserPublicProfileInfoResult_Notification";


@protocol ZLUserServiceModuleProtocol <ZLBaseServiceModuleProtocol>


/**
 * @brief 根据登陆名获取用户或者组织信息
 * @param loginName 登陆名
 **/
- (ZLGithubUserBriefModel *_Nullable) getUserInfoWithLoginName:(NSString * _Nonnull) loginName
                                                  serialNumber:(NSString * _Nonnull) serailNumber
                                                completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


#pragma mark - user additions info

- (void) getAdditionInfoForUser:(NSString * _Nonnull) userLoginName
                       infoType:(ZLUserAdditionInfoType) type
                           page:(NSUInteger) page
                       per_page:(NSUInteger) per_page
                   serialNumber:(NSString * _Nonnull) serialNumber
                 completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

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

#pragma mark - contributions

/**
 * @brief 查询用户的contributions
 * @param loginName 用户的登录名
 **/
- (NSArray<ZLGithubUserContributionData *> * _Nullable) getUserContributionsDataWithLoginName: (NSString * _Nonnull) loginName
                                                                                 serialNumber: (NSString * _Nonnull) serialNumber
                                                                               completeHandle: (void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle;


@end

#endif /* ZLUserServiceHeader_h */
