//
//  SYDCentralRouter.m
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/7.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralRouter.h"

@interface SYDCentralRouter()

@end


@implementation SYDCentralRouter

+ (instancetype) sharedInstance
{
    static SYDCentralRouter * centeralRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        centeralRouter = [[SYDCentralRouter alloc] init];
    });
    
    return centeralRouter;
}


- (instancetype) init
{
    if(self = [super init])
    {
        _centralFactory = [SYDCentralFactory sharedInstance];
    }
    return self;
}






@end
