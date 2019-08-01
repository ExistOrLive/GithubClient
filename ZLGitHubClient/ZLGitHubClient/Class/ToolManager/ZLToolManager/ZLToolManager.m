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

+ (instancetype) sharedInstance
{
    static ZLToolManager * toolManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toolManager = [[ZLToolManager alloc] init];
    });
    
    return toolManager;
}

- (instancetype) init
{
    if(self = [super init])
    {
        // 日志模块放在最前面初始化
        _zlLogModule = [[SYDCentralFactory sharedInstance] getCommonBean:ZLLogModule];
        
        // 数据库模块
        _zlDBModule = [[SYDCentralFactory sharedInstance] getCommonBean:ZLDBModule];
        
        // 国际化模块
        _zlLANModule = [[SYDCentralFactory sharedInstance] getCommonBean:ZLLANModule];
    }
    return self;
}

@end
