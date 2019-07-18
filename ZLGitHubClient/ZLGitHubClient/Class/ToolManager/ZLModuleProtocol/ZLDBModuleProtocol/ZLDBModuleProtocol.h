//
//  ZLDBModuleProtocol.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLDBModuleProtocol_h
#define ZLDBModuleProtocol_h

#import <Foundation/Foundation.h>
@class ZLGithubUserModel;

@protocol ZLDBModuleProtocol<NSObject>

+ (instancetype) sharedInstance;

// 初始化用户userId的数据库
- (void) initialDBForUser:(NSString *) userId;

// 获取，插入，更新 userId的信息
- (ZLGithubUserModel *) getUserInfoWithUserId:(NSString *) userId;
- (void) insertOrUpdateUserInfo:(ZLGithubUserModel *) model;


@end

#endif /* ZLDBModuleProtocol_h */
