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

@property(nonatomic, strong) NSString * __nullable url;

@property(nonatomic, assign) NSUInteger number;

@property(nonatomic, strong) NSString * state;

@property(nonatomic, assign) BOOL locked;

@property(nonatomic, strong) NSString * __nullable  title;

@property(nonatomic, strong) ZLGithubUserBriefModel * user;

@end

NS_ASSUME_NONNULL_END
