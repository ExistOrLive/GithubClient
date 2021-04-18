//
//  ZLGithubRequestErrorModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLGithubRequestErrorModel.h"

@implementation ZLGithubRequestErrorModel

- (NSString *) description
{
    return [NSString stringWithFormat:@"StatusCode %ld, Error %@",(long)self.statusCode,self.message];
}

+ (ZLGithubRequestErrorModel *) errorModelWithStatusCode:(NSInteger) statusCode
                                                 message:(NSString *) message
                                       documentation_url:(NSString *) url{
    ZLGithubRequestErrorModel *errorModel = [ZLGithubRequestErrorModel new];
    errorModel.statusCode = statusCode;
    errorModel.message = message;
    errorModel.documentation_url = url;
    return errorModel;
}

@end
