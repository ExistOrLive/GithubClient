//
//  ZLRepoServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/24.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"
#import "ZLRepoServiceHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLRepoServiceModel : ZLBaseServiceModel <ZLRepoServiceModuleProtocol>

+ (instancetype) sharedServiceModel;

@end

NS_ASSUME_NONNULL_END
