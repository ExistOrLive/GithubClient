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


static NSNotificationName const _Nonnull ZLLoginResult_Notification = @"ZLLoginResult_Notification";
static NSNotificationName const _Nonnull ZLLogoutResult_Notification = @"ZLLogoutResult_Notification";

@protocol ZLLoginServiceModuleProtocol <ZLBaseServiceModuleProtocol>


@property(nonatomic, nullable, readonly) NSString* accessToken;

/**
 *
 * 当前登陆的过程
 **/
- (ZLLoginStep) currentLoginStep;


#pragma mark - oauth login action


- (void) stopLogin:(NSString *_Nonnull) serialNumber;
    

/**
 * 注销登录
 *
 **/
- (void) logout:(NSString *_Nonnull) serialNumber;

/**
 *
 * 进行登陆
 **/
- (void) startOAuth:(NSString *_Nonnull) serialNumber;

/**
 * 登陆认证后，获取token
 *
 **/
- (void) getAccessToken:(NSString *_Nonnull) queryString
           serialNumber:(NSString *_Nonnull) serialNumber;



#pragma mark - token login action
/***
  * 检查access token是否有效
 */

- (void) checkTokenIsValid:(NSString *_Nonnull) token
              serialNumber:(NSString *_Nonnull) serialNumber;


@end

#endif /* ZLLoginServiceHeader_h */
