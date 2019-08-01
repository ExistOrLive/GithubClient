//
//  ZLLoginResultModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLLoginResultModel : NSObject

@property (assign, nonatomic) BOOL result;                   // 登录是否成功，取到token

@property (assign, nonatomic) BOOL isNeedContinuedLogin;        // 上次OAuth登录的cookie过期，需要手动登陆

@property (strong, nonatomic) NSURLRequest * loginRequest;      // 重定向的login请求，用于转到登陆页面

- (instancetype) initWithResult:(BOOL) result
       withIsNeedContinuedLogin:(BOOL) isNeedContinuedLogin
                   loginRequest:(NSURLRequest *) loginRequest;

@end

NS_ASSUME_NONNULL_END
