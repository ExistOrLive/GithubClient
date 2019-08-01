//
//  ZLLoginServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLLoginServiceModel.h"

// network
#import "ZLGithubHttpClient.h"

// model
#import "ZLLoginResultModel.h"

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

- (void) startOAuth
{
    __weak typeof(self) weakSelf = self;
    [[ZLGithubHttpClient defaultClient] startOAuth:^(NSURLRequest * _Nonnull request, BOOL isNeedContinuedLogin, BOOL success) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ZLLoginResultModel * resultModel = [[ZLLoginResultModel alloc] initWithResult:success withIsNeedContinuedLogin:isNeedContinuedLogin loginRequest:request];
            
            [weakSelf postNotification:ZLLoginResult_Notification withParams:resultModel];
        });
        
    }];
   
}

- (void) getAccessToken:(NSString *) queryString
{
    [[ZLGithubHttpClient defaultClient] getAccessToken:queryString];
}


@end
