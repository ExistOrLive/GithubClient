//
//  ZLGithubRequestErrorModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLGithubRequestErrorModel : NSObject

@property (assign, nonatomic) NSInteger statusCode;         // 结果码

@property (strong, nonatomic) NSString * message;           // errorMessage

@property (strong, nonatomic) NSString * documentation_url;

@end

NS_ASSUME_NONNULL_END
