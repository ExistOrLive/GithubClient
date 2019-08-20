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



@end

NS_ASSUME_NONNULL_END
