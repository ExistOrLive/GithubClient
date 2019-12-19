//
//  ZLAppInfo.m
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/12/19.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLAppInfo.h"

@implementation ZLAppInfo

+ (NSString *) version
{
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
     NSString *bundleVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
     return bundleVersion;
}

+ (NSString *) buildId
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * buildId = [infoDictionary objectForKey:@"CFBundleVersion"];
    return buildId;
}

+ (NSDictionary *) infoDic
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary;
}

@end
