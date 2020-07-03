//
//  ZLLoginServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLBaseServiceModel.h"
#import "ZLLoginServiceHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLLoginServiceModel : ZLBaseServiceModel

+ (instancetype) sharedServiceModel;

/**
 *
 * 当前登陆的过程
 **/
- (ZLLoginStep) currentLoginStep;


- (void) stopLogin;
    

/**
 * 注销登录
 *
 **/
- (void) logout:(NSString *) serialNumber;

/**
 *
 * 进行登陆
 **/
- (void) startOAuth:(NSString *) serialNumber;

/**
 * 登陆认证后，获取token
 *
 **/
- (void) getAccessToken:(NSString *) queryString
           serialNumber:(NSString *) serialNumber;




/***
  * 检查access token是否有效
 */

- (void) checkTokenIsValid:(NSString *) token
              serialNumber:(NSString *) serialNumber;




@end

NS_ASSUME_NONNULL_END
