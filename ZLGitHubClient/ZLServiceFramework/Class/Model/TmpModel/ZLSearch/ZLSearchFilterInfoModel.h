//
//  ZLSearchFilterInfoModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/8.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLSearchFilterInfoModel : NSObject

// repos: stars forks updated
// users: followers joined repositories
// orgs:  repositories joined
// issues: created commented updated
// prs: created commented updated
@property(nonatomic,strong,nullable) NSString * order;
@property(nonatomic,assign,getter=isAsc) BOOL asc;
@property(nonatomic,strong,nullable) NSString * language;
@property(nonatomic,strong,nullable) NSString * firstCreatedTimeStr;
@property(nonatomic,strong,nullable) NSString * secondCreatedTimeStr;

@property(nonatomic,assign) NSUInteger firstStarNum;
@property(nonatomic,assign) NSUInteger secondStarNum;
@property(nonatomic,assign) NSUInteger firstForkNum;
@property(nonatomic,assign) NSUInteger secondForkNum;

@property(nonatomic,assign) NSUInteger firstFollowersNum;
@property(nonatomic,assign) NSUInteger secondFollowersNum;
@property(nonatomic,assign) NSUInteger firstPubReposNum;
@property(nonatomic,assign) NSUInteger secondPubReposNum;

@property(nonatomic,assign) BOOL issueOrPRClosed;    // 默认open




// For REST API
- (NSString *) finalKeyWordForRepoFilter:(NSString *) keyWord;
- (NSString *) finalKeyWordForUserFilter:(NSString *) keyWord;

// For GraphQL API
- (NSString *) GraphqlQueryForUserFilter:(NSString *) keyWord;
- (NSString *) GraphqlQueryForOrgFilter:(NSString *) keyWord;
- (NSString *) GraphqlQueryForRepoFilter:(NSString *) keyWord;
- (NSString *) GraphqlQueryForIssueFilter:(NSString *) keyWord;
- (NSString *) GraphqlQueryForPullRequestFilter:(NSString *) keyWord;

@end

NS_ASSUME_NONNULL_END
