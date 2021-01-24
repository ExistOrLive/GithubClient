//
//  ZLSharedDataManager.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/7.
//  Copyright © 2020 ZM. All rights reserved.
//

/**
 *   维护保存在keychain，userdefaults 或者沙盒中的数据
 *
 */

#import <Foundation/Foundation.h>
#import "ZLSearchServiceHeader.h"


@class ZLGithubUserModel;
@class ZLGithubConfigModel;
@class ZLGithubCollectedRepoModel;
 
NS_ASSUME_NONNULL_BEGIN


@interface ZLSharedDataManager : NSObject

+ (instancetype) sharedInstance;

@property(nonatomic,strong,nullable) NSString * githubAccessToken;

@property(nonatomic,strong,nullable) ZLGithubUserModel * userInfoModel;

@property(nonatomic,strong,nullable) NSMutableDictionary * trendingOptions;

// 搜索记录
@property(nonatomic,strong,nullable) NSArray<NSString *> *searchRecordArray;

// 是否展示所有notification
@property(nonatomic,assign) BOOL showAllNotifications;

// 应用动态配置
@property(nonatomic,strong,nullable) ZLGithubConfigModel *configModel;

// 用户界面外观选项
@property(nonatomic,assign) UIUserInterfaceStyle currentUserInterfaceStyle API_AVAILABLE(ios(12.0));

// 辅助按钮
@property(nonatomic,assign,getter=isAssistButtonHidden) BOOL assistButtonHidden;


- (void) clearGithubTokenAndUserInfo;

#pragma mark - fix repo

- (void) setFixRepos:(NSArray *)repos forLoginUser:(NSString *)login;

- (NSArray* __nullable) fixReposForLoginUser:(NSString *)login;

#pragma mark - trend

- (NSString * __nullable) lanaguageForTrendingRepo;

- (NSString * __nullable) lanaguageForTrendingUser;

- (void) setLanguageForTrendingRepo:(NSString * __nullable) language;

- (void) setLanguageForTrendingUser:(NSString * __nullable) language;

- (ZLDateRange) dateRangeForTrendingRepo ;
- (ZLDateRange) dateRangeForTrendingUser;

- (void) setDateRangeForTrendingRepo:(ZLDateRange) range;

- (void) setDateRangeForTrendingUser:(ZLDateRange) range;




@end

NS_ASSUME_NONNULL_END
