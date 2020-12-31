//
//  ZLLoginServiceHeader.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLLoginServiceHeader_h
#define ZLLoginServiceHeader_h

#import "ZLBaseServiceModel.h"

typedef enum : NSUInteger {
    ZLLoginStep_init,
    ZLLoginStep_checkIsLogined,
    ZLLoginStep_logining,
    ZLLoginStep_getToken,
    ZLLoginStep_checkToken,
    ZLLoginStep_Success,
} ZLLoginStep;


static const NSNotificationName ZLLoginResult_Notification = @"ZLLoginResult_Notification";
static const NSNotificationName ZLLogoutResult_Notification = @"ZLLogoutResult_Notification";

@protocol ZLLoginServiceModuleProtocol <ZLBaseServiceModuleProtocol>

/**
 *
 * 当前登陆的过程
 **/
- (ZLLoginStep) currentLoginStep;


- (void) stopLogin:(NSString *) serialNumber;
    

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

#endif /* ZLLoginServiceHeader_h */
