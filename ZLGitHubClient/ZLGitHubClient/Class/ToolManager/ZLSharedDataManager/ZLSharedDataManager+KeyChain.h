//
//  ZLSharedDataManager+KeyChain.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/21.
//  Copyright © 2021 ZM. All rights reserved.
//

#import <ZLServiceFramework/ZLServiceFramework.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLSharedDataManager (KeyChain)

#pragma mark - fix repo

- (void) setFixRepos:(NSArray<ZLGithubCollectedRepoModel *>*)repos forLoginUser:(NSString *)login;

- (NSArray<ZLGithubCollectedRepoModel *>* __nullable) fixReposForLoginUser:(NSString *)login;

@end

NS_ASSUME_NONNULL_END
