//
//  ZLSearchServiceHeader.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/8.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLSearchServiceHeader_h
#define ZLSearchServiceHeader_h

#import "ZLBaseServiceModel.h"

@class ZLOperationResultModel;
@class ZLSearchFilterInfoModel;

#pragma mark - ENum

typedef NS_ENUM(NSUInteger, ZLSearchType) {
    ZLSearchTypeRepositories,
    ZLSearchTypeUsers,
    ZLSearchTypeCommits,
    ZLSearchTypeIssues,
    ZLSearchTypeCode,
    ZLSearchTypeTopics
};

typedef enum {
    ZLDateRangeDaily = 0,
    ZLDateRangeWeakly = 1,
    ZLDateRangeMonthly = 2,
} ZLDateRange;

#pragma mark - NotificationName

static const NSNotificationName _Nonnull ZLSearchResult_Notification = @"ZLSearchResult_Notification";



@protocol ZLSearchServiceModuleProtocol <ZLBaseServiceModuleProtocol>

#pragma mark - search

- (void) searchInfoWithKeyWord:(NSString *_Nonnull) keyWord
                          type:(ZLSearchType) type
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *_Nonnull) serialNumber;

- (void) searchInfoWithKeyWord:(NSString *_Nonnull) keyWord
                          type:(ZLSearchType) type
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *_Nonnull) serialNumber
                completeHandle:(void(^_Nonnull)(ZLOperationResultModel *_Nonnull)) handle;


#pragma mark - trend

- (void) trendingWithType:(ZLSearchType) type
                 language:(NSString *__nullable) language
                dateRange:(ZLDateRange) dateRange
             serialNumber:(NSString *_Nonnull) serialNumber
           completeHandle:(void(^_Nonnull)(ZLOperationResultModel *_Nonnull)) handle;

@end

#endif /* ZLSearchServiceHeader_h */
