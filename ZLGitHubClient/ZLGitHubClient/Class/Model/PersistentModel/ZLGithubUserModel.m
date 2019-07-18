//
//  ZLGithubUserModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLGithubUserModel.h"
#import <MJExtension/MJExtension.h>

@implementation ZLGithubUserModel

+ (instancetype) getInstanceWithDic:(NSDictionary *) dic
{
    if(!dic)
    {
        return nil;
    }
    
    [ZLGithubUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"identity":@"id",
                 @"loginName":@"login"
                 };
    }];
    
    return [ZLGithubUserModel mj_objectWithKeyValues:dic];
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    ZLGithubUserModel * newModel = [[[self class] alloc] init];
    newModel.identity = self.identity;
    newModel.node_id = self.node_id;
    newModel.loginName = self.loginName;
    newModel.name = self.name;
    newModel.company = self.company;
    newModel.blog = self.blog;
    newModel.email = self.email;
    newModel.bio = self.bio;
    newModel.html_url = self.html_url;
    newModel.avatar_url = self.avatar_url;
    newModel.public_repos = self.public_repos;
    newModel.public_gists = self.public_gists;
    newModel.followers = self.followers;
    newModel.following = self.following;
    newModel.created_at = self.created_at;
    newModel.updated_at = self.updated_at;
    return newModel;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"id = %@, name = %@ ",self.identity,self.name];
}

@end
