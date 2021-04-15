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

+ (instancetype _Nonnull) sharedInstance;

- (ZLGithubUserBriefModel * _Nullable) getUserOrOrgInfoWithLoginName:(NSString * _Nonnull) loginName;
- (void) insertOrUpdateUserInfo:(ZLGithubUserBriefModel * _Nonnull) model;


- (ZLGithubUserModel * _Nullable) getViewerInfoWithLoginName:(NSString * _Nonnull) loginName;
- (void) insertOrUpdateViewerInfo:(ZLGithubUserModel * _Nonnull) model;


- (ZLGithubRepositoryModel * _Nullable) getRepoInfoWithFullName:(NSString * _Nonnull) fullName;
- (void) insertOrUpdateRepoInfo:(ZLGithubRepositoryModel * _Nonnull) model;

- (NSString * _Nullable) getUserContributionsWithLoginName:(NSString * _Nonnull) loginName;
- (void) insertOrUpdateUserContributions:(NSString * _Nonnull) contributions loginName:(NSString * _Nonnull) loginName;


@end

#endif /* ZLDBModuleProtocol_h */
