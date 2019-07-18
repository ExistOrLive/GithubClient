//
//  ZLGithubHttpClient.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/12.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZLGithubUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZLGithubHttpClient : NSObject

+ (instancetype) defaultClient;

/**
 *
 * OAuth 认证
 **/
- (void) startOAuth:(void(^)(NSURLRequest * request,BOOL isNeedContinuedLogin,BOOL success)) block;

/**
 *
 * OAuth 认证后 获取token
 **/
- (void) getAccessToken:(NSString *) queryString;

/**
 *
 * 获取当前登陆的用户信息
 **/
- (void) getCurrentLoginUserInfo:(void(^)(BOOL,ZLGithubUserModel *)) block;

@end

NS_ASSUME_NONNULL_END
