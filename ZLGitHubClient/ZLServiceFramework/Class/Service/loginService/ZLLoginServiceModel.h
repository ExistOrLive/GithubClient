//
//  ZLLoginServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLBaseServiceModel.h"
#import "ZLLoginServiceHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLLoginServiceModel : ZLBaseServiceModel <ZLLoginServiceModuleProtocol>

+ (instancetype) sharedServiceModel;

@end



NS_ASSUME_NONNULL_END
