//
//  ZLAdditionServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"
#import "ZLAdditionServiceHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLAdditionServiceModel : ZLBaseServiceModel <ZLAdditionServiceModuleProtocol>

+ (instancetype) sharedServiceModel;

@end

NS_ASSUME_NONNULL_END
