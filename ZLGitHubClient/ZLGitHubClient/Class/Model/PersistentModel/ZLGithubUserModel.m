//
//  ZLGithubUserModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLGithubUserModel.h"
#import <MJExtension/MJExtension.h>

#pragma mark - ZLGithubUserBriefModel

@implementation ZLGithubUserBriefModel

//MARK: NSCopy

- (id)copyWithZone:(nullable NSZone *)zone
{
    ZLGithubUserBriefModel * newModel = [[[self class] alloc] init];
    newModel.id_User = self.id_User;
    newModel.node_id = self.node_id;
    newModel.loginName = self.loginName;
    newModel.name = self.name;
    newModel.html_url = self.html_url;
    newModel.avatar_url = self.avatar_url;
    newModel.url = self.url;
    return newModel;
}

//MARK: MJExtension

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_User":@"id",
             @"loginName":@"login"
             };
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if([property.name isEqualToString:@"type"])
    {
        if([oldValue isEqualToString:@"User"])
        {
            return [NSNumber numberWithInt:ZLGithubUserType_User];
        }
        else
        {
            return [NSNumber numberWithInt:ZLGithubUserType_Organization];
        }
    }
    
    return oldValue;
    
}

@end

#pragma mark - ZLGithubUserModel

@implementation ZLGithubUserModel

//MARK: Setter Getter

- (NSDate *) createdDate
{
    if(!_created_at)
    {
        return nil;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter dateFromString:_created_at];
}

- (NSDate *) updatedDate
{
    if(!_updated_at)
    {
        return nil;
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter dateFromString:_updated_at];
}



- (NSString *) description
{
    return [NSString stringWithFormat:@"id = %@, name = %@ ",self.id_User,self.name];
}

//MARK: NSCopy

- (id)copyWithZone:(nullable NSZone *)zone
{
    ZLGithubUserModel * newModel = [[[self class] alloc] init];
    newModel.id_User = self.id_User;
    newModel.node_id = self.node_id;
    newModel.loginName = self.loginName;
    newModel.name = self.name;
    newModel.html_url = self.html_url;
    newModel.avatar_url = self.avatar_url;
    newModel.url = self.url;
    newModel.company = self.company;
    newModel.blog = self.blog;
    newModel.email = self.email;
    newModel.bio = self.bio;
    newModel.public_repos = self.public_repos;
    newModel.public_gists = self.public_gists;
    newModel.followers = self.followers;
    newModel.following = self.following;
    newModel.private_gists = self.private_gists;
    newModel.total_private_repos = self.total_private_repos;
    newModel.owned_private_repos = self.owned_private_repos;
    newModel.created_at = self.created_at;
    newModel.updated_at = self.updated_at;
    return newModel;
}

//MARK: MJExtension

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_User":@"id",
             @"loginName":@"login"
             };
}

+ (instancetype) getInstanceWithDic:(NSDictionary *) dic
{
    if(!dic)
    {
        return nil;
    }
    
    return [ZLGithubUserModel mj_objectWithKeyValues:dic];
}



@end
