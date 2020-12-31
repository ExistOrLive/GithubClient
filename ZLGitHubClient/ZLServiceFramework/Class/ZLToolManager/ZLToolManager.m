//
//  ZLToolManger.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/4.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLToolManager.h"
#import "SYDCentralFactory.h"

static const NSString * ZLLogModule = @"ZLLogModule";
static const NSString * ZLDBModule = @"ZLDBModule";
static const NSString * ZLLANModule = @"ZLLANModule";

@implementation ZLToolManager

@synthesize zlLogModule;
@synthesize zlLANModule;
@synthesize zlDBModule;

+ (instancetype) sharedInstance
{
    static ZLToolManager * toolManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toolManager = [[ZLToolManager alloc] init];
    });
    
    return toolManager;
}

- (id<ZLLogModuleProtocol>) zlLogModule{
    return [[SYDCentralFactory sharedInstance] getCommonBean:ZLLogModule];
}

- (id<ZLLanguageModuleProtocol>) zlLANModule{
    return [[SYDCentralFactory sharedInstance] getCommonBean:ZLLANModule];
}

- (id<ZLDBModuleProtocol>) zlDBModule{
    return [[SYDCentralFactory sharedInstance] getCommonBean:ZLDBModule];
}

@end
