//
//  ZLGithubPullRequestModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/3.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseObject.h"
@class ZLGithubUserBriefModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZLGithubPullRequestModel : ZLBaseObject

@property(nonatomic, strong) NSString * id_PullRequest;

@property(nonatomic, strong) NSString * html_url;

@property(nonatomic, strong) NSString * __nullable url;

@property(nonatomic, assign) NSUInteger number;         // pullrequest number

@property(nonatomic, strong) NSString * state;          // open / closed

@property(nonatomic, assign) BOOL locked;

@property(nonatomic, strong) NSString * title;          // 标题

@property(nonatomic, strong) NSString * body;

@property(nonatomic, strong) NSDate * created_at;       // 创建时间

@property(nonatomic, strong, nullable) NSDate * updated_at;

@property(nonatomic, strong, nullable) NSDate * closed_at;        // 关闭时间

@property(nonatomic, strong, nullable) NSDate * merged_at;        // 合并时间

@property(nonatomic, strong) ZLGithubUserBriefModel * user;    // pull request 创建者

@end

NS_ASSUME_NONNULL_END
