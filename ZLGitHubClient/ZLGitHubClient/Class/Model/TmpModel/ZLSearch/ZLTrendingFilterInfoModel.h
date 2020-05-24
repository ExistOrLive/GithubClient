//
//  ZLTrendingFilterInfoModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/21.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseObject.h"
#import "ZLSearchServiceHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZLTrendingFilterInfoModel : ZLBaseObject

@property(nonatomic, strong) NSString * language;

@property(nonatomic, assign) ZLDateRange dateRange;

@end

NS_ASSUME_NONNULL_END
