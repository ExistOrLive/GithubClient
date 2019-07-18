//
//  ZLLoginResultModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLLoginResultModel.h"

@implementation ZLLoginResultModel

- (instancetype) initWithResult:(BOOL) result
       withIsNeedContinuedLogin:(BOOL) isNeedContinuedLogin
                   loginRequest:(NSURLRequest *) loginRequest
{
    if(self = [super init])
    {
        _result = result;
        _isNeedContinuedLogin = isNeedContinuedLogin;
        _loginRequest = loginRequest;
    }
    return self;
}

@end
