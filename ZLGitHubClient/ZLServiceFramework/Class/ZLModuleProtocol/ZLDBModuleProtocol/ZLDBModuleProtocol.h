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

- (ZLGithubUserBriefModel *) getUserOrOrgInfoWithLoginName:(NSString *) loginName;
- (void) insertOrUpdateUserInfo:(ZLGithubUserBriefModel *) model;


- (ZLGithubUserModel *) getViewerInfoWithLoginName:(NSString *) loginName;
- (void) insertOrUpdateViewerInfo:(ZLGithubUserModel *) model;


- (ZLGithubRepositoryModel *) getRepoInfoWithFullName:(NSString *) fullName;
- (void) insertOrUpdateRepoInfo:(ZLGithubRepositoryModel *) model;


@end

#endif /* ZLDBModuleProtocol_h */
