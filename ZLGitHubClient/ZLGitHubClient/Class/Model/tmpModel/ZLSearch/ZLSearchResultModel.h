//
//  ZLSearchResultModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/10.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLSearchResultModel : NSObject

@property (assign, nonatomic) NSUInteger totalNumber;       // 这次搜索的结果总数

@property (assign, nonatomic) BOOL incomplete_results;

@property (strong, nonatomic) NSArray * data;               // ZLGithubRepositoryModel /ZLGithubUserInfoModel

@end

NS_ASSUME_NONNULL_END
