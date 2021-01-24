//
//  ZLAdditionInfoServiceHeader.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLAdditionInfoServiceHeader_h
#define ZLAdditionInfoServiceHeader_h

#import "ZLBaseServiceModel.h"
#import "ZLGithubPullRequestModel.h"

#pragma mark - Enum
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


/**
 * github 用户附加信息类型
 *
 **/
typedef NS_ENUM(NSUInteger, ZLMyIssueFilterType) {
    ZLMyIssueFilterTypeCreator,
    ZLMyIssueFilterTypeAssigned,
    ZLMyIssueFilterTypeMentioned,
    ZLMyIssueFilterTypeSubcribe,
};


#pragma mark - NotificationName

static const NSNotificationName _Nonnull ZLGetReposResult_Notification = @"ZLGetReposResult_Notification";
static const NSNotificationName _Nonnull ZLGetFollowersResult_Notification = @"ZLGetFollowersResult_Notification";
static const NSNotificationName _Nonnull ZLGetFollowingResult_Notification = @"ZLGetFollowingResult_Notification";
static const NSNotificationName _Nonnull ZLGetGistsResult_Notification = @"ZLGetGistsResult_Notification";
static const NSNotificationName _Nonnull ZLGetStarredReposResult_Notification = @"ZLGetStarredReposResult_Notification";
static const NSNotificationName _Nonnull ZLGithubConfigUpdate_Notification = @"ZLGithubConfigUpdate_Notification";


@protocol ZLAdditionInfoServiceModuleProtocol <ZLBaseServiceModuleProtocol>

/**
 * @brief 获取repos，gists，followers，following信息
 *
 **/
- (void) getAdditionInfoForUser:(NSString * _Nonnull) userLoginName
                            infoType:(ZLUserAdditionInfoType) type
                                page:(NSUInteger) page
                            per_page:(NSUInteger) per_page
                        serialNumber:(NSString * _Nonnull) serialNumber;



/**
 * @brief 获取language列表
 *
 **/
- (void) getLanguagesWithSerialNumber:(NSString * _Nonnull) serialNumber
                       completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;



/**
* @brief 将代码渲染为markdown
*
**/

- (void) renderCodeToMarkdownWithCode:(NSString * _Nonnull) code
                         serialNumber:(NSString * _Nonnull) serialNumber
                       completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;


/**
 * @brief 获取功能配置
 *
 **/

- (void) getGithubClientConfig:(NSString * _Nonnull) serialNumber;



#pragma mark - org

- (void) getOrgsWithSerialNumber:(NSString * _Nonnull) serialNumber
                  completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

#pragma mark - issues

- (void) getMyIssuesWithType:(ZLMyIssueFilterType) type
                       after:(NSString * _Nullable) afterCursor
                serialNumber:(NSString *_Nonnull) serialNumber
              completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;


#pragma mark - PR

- (void) getMyPRWithType:(ZLGithubPullRequestState) type
                   after:(NSString * _Nullable) afterCursor
            serialNumber:(NSString *_Nonnull) serialNumber
          completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

@end


#endif /* ZLAdditionInfoServiceHeader_h */
