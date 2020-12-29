//
//  ZLWidgetService.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/12/26.
//  Copyright © 2020 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FixedRepoDateRange.h"
#import "FixedRepoLanguage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLSimpleRepoModel : NSObject

@property(nonatomic, strong,nullable) NSString *fullName;
@property(nonatomic, strong,nullable) NSString *RepoName;
@property(nonatomic, strong,nullable) NSString *ownerName;
@property(nonatomic, strong,nullable) NSString *desc;
@property(nonatomic, strong,nullable) NSString *language;
@property(nonatomic, assign) int forkNumber;
@property(nonatomic, assign) int starNumber;


@end


@interface ZLWidgetService : NSObject

+ (void) trendingRepoWithDateRange:(FixedRepoDateRange) dateRange
                      withLanguage:(FixedRepoLanguage) language
                withCompleteHandle:(void(^)(BOOL,NSArray *)) handle;

@end

NS_ASSUME_NONNULL_END
