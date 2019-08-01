//
//  ZLGithubHttpClient.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/12.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GithubResponse)(BOOL,id _Nullable ,NSString * _Nonnull);

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


#pragma mark - repositories
/**
 * @brief 获取当前登陆的用户 repositories信息
 * @param block 请求回调
 * @param page  第n页
 * @param per_page 一页多少记录
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getRepositoriesForCurrentLoginUser:(GithubResponse) block
                                       page:(NSUInteger) page
                                   per_page:(NSUInteger) per_page
                               serialNumber:(NSString *) serialNumber;




/**
 * @brief 获取某用户 repositories信息
 * @param block 请求回调
 * @param loginName 用户的登陆名
 * @param page  第n页
 * @param per_page 一页多少记录
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getRepositoriesForUser:(GithubResponse) block
                      loginName:(NSString*) loginName
                           page:(NSUInteger) page
                       per_page:(NSUInteger) per_page
                   serialNumber:(NSString *) serialNumber;

#pragma mark - followers


- (void) getFollowersForUser:(GithubResponse) block
                   loginName:(NSString*) loginName
                        page:(NSUInteger) page
                    per_page:(NSUInteger) per_page
                serialNumber:(NSString *) serialNumber;

#pragma mark - following

- (void) getFollowingForUser:(GithubResponse) block
                   loginName:(NSString*) loginName
                        page:(NSUInteger) page
                    per_page:(NSUInteger) per_page
                serialNumber:(NSString *) serialNumber;

@end




NS_ASSUME_NONNULL_END
