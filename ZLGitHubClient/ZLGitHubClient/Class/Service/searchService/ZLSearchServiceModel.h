//
//  ZLSearchServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/8.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"
#import "ZLSearchServiceHeader.h"

@class ZLSearchFilterInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZLSearchServiceModel : ZLBaseServiceModel

+ (instancetype) sharedServiceModel;

- (void) searchInfoWithKeyWord:(NSString *) keyWord
                          type:(ZLSearchType) type
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *) serialNumber;

@end

NS_ASSUME_NONNULL_END
