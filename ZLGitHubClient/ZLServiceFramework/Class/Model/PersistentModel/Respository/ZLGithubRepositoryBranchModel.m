//
//  ZLGithubRepositoryBranchModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/18.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLGithubRepositoryBranchModel.h"

@implementation ZLGithubRepositoryBranchModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"protect":@"protected",
             @"commit_sha":@"commit.sha",
             @"commit_url":@"commit.url"
             };
}

@end
