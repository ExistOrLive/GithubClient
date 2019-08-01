//
//  ZLGithubUserModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    ZLGithubUserType_User,
    ZLGithubUserType_Organization
} ZLGithubUserType;

@interface ZLGithubUserBriefModel : NSObject <NSCopying>

@property (strong,nonatomic) NSString * id_User;

@property (strong,nonatomic) NSString * node_id;

@property (strong,nonatomic) NSString * loginName;

@property (strong,nonatomic) NSString * name;

@property (strong,nonatomic) NSString * url;

@property (strong,nonatomic) NSString * html_url;                   //github主页地址

@property (strong,nonatomic) NSString * avatar_url;                 //头像

@property (assign,nonatomic) ZLGithubUserType type;                 // 用户类型


@end


@interface ZLGithubUserModel : ZLGithubUserBriefModel <NSCopying>

@property (strong,nonatomic) NSString * company;

@property (strong,nonatomic) NSString * blog;

@property (strong,nonatomic) NSString * location;

@property (strong,nonatomic) NSString * email;

@property (strong,nonatomic) NSString * bio;                        // 描述

@property (assign,nonatomic) NSUInteger public_repos;               //！公开仓库

@property (assign,nonatomic) NSUInteger public_gists;               //! 公开代码片段

@property (assign,nonatomic) NSUInteger followers;

@property (assign,nonatomic) NSUInteger following;

@property (assign,nonatomic) NSUInteger private_gists;

@property (assign,nonatomic) NSUInteger total_private_repos;

@property (assign,nonatomic) NSUInteger owned_private_repos;

@property (strong,nonatomic) NSString * created_at;                   //github主页地址

@property (strong,nonatomic) NSString * updated_at;


+ (instancetype) getInstanceWithDic:(NSDictionary *) dic;

- (NSDate * __nullable) createdDate;

- (NSDate * __nullable) updatedDate;

@end

NS_ASSUME_NONNULL_END
