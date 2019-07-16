//
//  ZLLoginServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZTE. All rights reserved.
//

#import "ZLLoginServiceModel.h"
#import <AFNetworking/AFNetworking.h>

@implementation ZLLoginServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLLoginServiceModel * serviceModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceModel = [[ZLLoginServiceModel alloc] init];
    });
    return serviceModel;
}


@end
