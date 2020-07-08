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
 
NS_ASSUME_NONNULL_BEGIN

@interface ZLSharedDataManager : NSObject

+ (instancetype) sharedInstance;

@property(nonatomic,strong,nullable) NSString * githubAccessToken;

@property(nonatomic,strong,nullable) ZLGithubUserModel * userInfoModel;

@property(nonatomic,strong,nullable) NSMutableDictionary * trendingOptions;

@property(nonatomic,strong,nullable) NSArray<NSString *> *searchRecordArray;

- (void) clearGithubTokenAndUserInfo;


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
