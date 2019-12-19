//
//  ZLBuglyManager.m
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/12/19.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBuglyManager.h"
#import <Bugly/Bugly.h>
#import "ZLAppInfo.h"

#define ZLBuyglyAppId @"ff723a2926"
 
@interface ZLBuglyManager() <BuglyDelegate>

@property(nonatomic, strong) BuglyConfig * myBuglyConfig;

@end

@implementation ZLBuglyManager

+ (instancetype) sharedManager
{
    static ZLBuglyManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZLBuglyManager alloc] init];
    });
    return manager;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addObservers];
        
    }
    return self;
}

- (BuglyConfig *) myBuglyConfig
{
    if(!_myBuglyConfig)
    {
        BuglyConfig * config = [BuglyConfig new];
        config.debugMode = YES;
        config.channel = @"ZM";
        config.version = [ZLAppInfo version];
        config.deviceIdentifier = @"zhumeng";
        
        
        config.blockMonitorEnable = YES;
        config.blockMonitorTimeout = 2.0;
        config.delegate = self;
        
    }
    return _myBuglyConfig;
}


- (void) setUp
{
    [Bugly startWithAppId:ZLBuyglyAppId config:self.myBuglyConfig];
}


#pragma mark - Notification

- (void) addObservers
{
     [[ZLUserServiceModel sharedServiceModel] registerObserver:self selector:@selector(onNotificationArrived:) name:ZLGetCurrentUserInfoResult_Notification];
}


- (void) removeObservers
{
    [[ZLUserServiceModel sharedServiceModel] unRegisterObserver:self name:ZLGetCurrentUserInfoResult_Notification];
}

- (void) onNotificationArrived:(NSNotification *) notification
{
    if([ZLGetCurrentUserInfoResult_Notification isEqualToString:notification.name])
    {
        ZLOperationResultModel * resultModel = (ZLOperationResultModel *)notification.params;
        if(resultModel.result)
        {
            ZLGithubUserModel * model = resultModel.data;
            [Bugly setUserIdentifier:model.loginName];
        }
    }
}


#pragma mark - buglydelegate

/**
 *  发生异常时回调
 *
 *  @param exception 异常信息
 *
 *  @return 返回需上报记录，随异常上报一起上报
 */
- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception
{
    ZLLog_Error(@"Exception : %@",exception);
    
    return nil;
}

@end
