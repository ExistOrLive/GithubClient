//
//  ZLEventServiceModel.h
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"
#import "ZLEventServiceHeader.h"

@interface ZLEventServiceModel : ZLBaseServiceModel <ZLEventServiceModuleProtocol>

+ (instancetype) sharedServiceModel;


@end
