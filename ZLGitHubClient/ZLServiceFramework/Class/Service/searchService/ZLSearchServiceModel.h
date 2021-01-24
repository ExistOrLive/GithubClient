//
//  ZLSearchServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/8.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"
#import "ZLSearchServiceHeader.h"



NS_ASSUME_NONNULL_BEGIN

@interface ZLSearchServiceModel : ZLBaseServiceModel <ZLSearchServiceModuleProtocol>

+ (instancetype) sharedServiceModel;

@end

NS_ASSUME_NONNULL_END
