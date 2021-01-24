//
//  ZLLoginProcessModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/1.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLLoginServiceHeader.h"
#import "ZLGithubRequestErrorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLLoginProcessModel : NSObject

@property (assign, nonatomic) BOOL result;                   // 登陆流程是否正常

@property (assign, nonatomic) ZLLoginStep loginStep;

@property (strong, nonatomic) NSString * serialNumber;      // 流水号

//! 当需要登陆验证时，不为空
@property (strong, nonatomic) NSURLRequest * loginRequest;      // 重定向的login请求，用于转到登陆页面

@property (strong, nonatomic) ZLGithubRequestErrorModel * errorModel;

@end

NS_ASSUME_NONNULL_END
