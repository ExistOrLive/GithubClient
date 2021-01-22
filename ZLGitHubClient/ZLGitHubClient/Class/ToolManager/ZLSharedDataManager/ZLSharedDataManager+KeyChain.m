//
//  ZLSharedDataManager+KeyChain.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/21.
//  Copyright © 2021 ZM. All rights reserved.
//

#import "ZLSharedDataManager+KeyChain.h"
#import "ZLKeyChainManager.h"

#define ZLKeyChainService @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient"
#define ZLKeyChainServiceFixRepos @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient.fixrepo"

@implementation ZLSharedDataManager (KeyChain)

#pragma mark - fix repo

- (void) setFixRepos:(NSArray<ZLGithubCollectedRepoModel *>*)repos forLoginUser:(NSString *)login{
    if(!repos || !login){
        return;
    }
    
    NSMutableDictionary *reposDic =  [ZLKeyChainManager load:ZLKeyChainServiceFixRepos];
    if(!reposDic) {
        reposDic = [NSMutableDictionary new];
    }
    [reposDic setObject:repos forKey:login];
    [ZLKeyChainManager save:ZLKeyChainServiceFixRepos data:reposDic];
}

- (NSArray<ZLGithubCollectedRepoModel *>* __nullable) fixReposForLoginUser:(NSString *)login{
    NSMutableDictionary *reposDic =  [ZLKeyChainManager load:ZLKeyChainServiceFixRepos];
    return [reposDic objectForKey:login];
}


@end
