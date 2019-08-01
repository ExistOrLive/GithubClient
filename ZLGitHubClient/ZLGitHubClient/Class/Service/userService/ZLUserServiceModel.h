//
//  ZLUserServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"
#import "ZLUserServiceHeader.h"

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

@end

NS_ASSUME_NONNULL_END
