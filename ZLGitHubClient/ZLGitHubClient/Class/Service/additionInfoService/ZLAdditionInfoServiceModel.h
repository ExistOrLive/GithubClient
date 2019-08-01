//
//  ZLAdditionInfoServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"
#import "ZLAdditionInfoServiceHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLAdditionInfoServiceModel : ZLBaseServiceModel

+ (instancetype) sharedServiceModel;


/**
 * @brief 获取repos，gists，followers，following信息
 *
 **/
- (NSArray *) getAdditionInfoForUser:(NSString *) userLoginName
                            infoType:(ZLUserAdditionInfoType) type
                                page:(NSUInteger) page
                            per_page:(NSUInteger) per_page
                        serialNumber:(NSString *) serialNumber;


@end

NS_ASSUME_NONNULL_END
