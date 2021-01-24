
//
//  ZLLoginProcessModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/1.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLLoginProcessModel.h"

@implementation ZLLoginProcessModel


- (NSString *)description
{
    return [NSString stringWithFormat:@"LoginProcessModel(result[%d],loginStep[%lu],error[%@])", self.result,(unsigned long)self.loginStep,self.errorModel];
}

@end
