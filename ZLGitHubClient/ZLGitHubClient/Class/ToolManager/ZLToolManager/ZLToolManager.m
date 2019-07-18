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
        _zlLogModule = [[SYDCentralFactory sharedInstance] getCommonBean:ZLLogModule];
        _zlDBModule = [[SYDCentralFactory sharedInstance] getCommonBean:ZLDBModule];
    }
    return self;
}

@end
