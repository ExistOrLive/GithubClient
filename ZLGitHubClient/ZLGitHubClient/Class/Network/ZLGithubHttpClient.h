//
//  ZLGithubHttpClient.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/12.
//  Copyright © 2019 ZTE. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@end

NS_ASSUME_NONNULL_END
