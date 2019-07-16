//
//  ZLGithubUserModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZTE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    ZLGithubUserType_User,
    ZLGithubUserType_Organization
} ZLGithubUserType;

@interface ZLGithubUserModel : NSObject

@property (strong,nonatomic) NSString * identity;

@property (strong,nonatomic) NSString * loginName;

@property (strong,nonatomic) NSString * name;

@property (strong,nonatomic) NSString * company;

@property (strong,nonatomic) NSString * blog;

@property (strong,nonatomic) NSString * location;

@property (strong,nonatomic) NSString * email;

@property (strong,nonatomic) NSString * bio;

@property (strong,nonatomic) NSString * html_url;                   //github主页地址

@property (strong,nonatomic) NSString * avatar_url;                 //头像

@property (assign,nonatomic) NSUInteger public_repos;

@property (assign,nonatomic) NSUInteger public_gists;

@property (assign,nonatomic) NSUInteger followers;

@property (assign,nonatomic) NSUInteger following;

@property (strong,nonatomic) NSString * created_at;                   //github主页地址

@property (strong,nonatomic) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
