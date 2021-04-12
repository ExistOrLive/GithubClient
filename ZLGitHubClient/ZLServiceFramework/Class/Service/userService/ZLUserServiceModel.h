//
//  ZLUserServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"
#import "ZLUserServiceHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLUserServiceModel : ZLBaseServiceModel <ZLUserServiceModuleProtocol>

+ (instancetype) sharedServiceModel;

@end

NS_ASSUME_NONNULL_END
