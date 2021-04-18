//
//  ZLBuglyManager.m
//  ZLGitHubClient
//
//  Created by ZM on 2019/12/19.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBuglyManager.h"
#import <Bugly/Bugly.h>
#import "ZLGithubAppKey.h"
 
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
        config.version = [ZLDeviceInfo getAppShortVersion];
        config.deviceIdentifier = [ZLSharedDataManager sharedInstance].deviceId;
        
        
        config.unexpectedTerminatingDetectionEnable = YES;
        config.symbolicateInProcessEnable = YES;
        config.viewControllerTrackingEnable = YES;
        
        config.blockMonitorEnable = YES;
        config.blockMonitorTimeout = 2.0;
        config.delegate = self;
        _myBuglyConfig = config;
        
    }
    return _myBuglyConfig;
}


- (void) setUp
{
    BOOL isDevelopmentDevice = NO;
#ifdef debug
    isDevelopmentDevice = YES;
#endif
    
    [Bugly startWithAppId:ZLBuyglyAppId  developmentDevice:isDevelopmentDevice config:self.myBuglyConfig];
    
    if([[ZLServiceManager sharedInstance].viewerServiceModel.currentUserLoginName length] > 0)
    {
        [Bugly setUserIdentifier:[ZLServiceManager sharedInstance].viewerServiceModel.currentUserLoginName];
    }
    
    ZLLog_Info(@"bugly %@ start up ------\n",[Bugly sdkVersion]);
}


- (void) log:(NSString *) eventName parameters:(NSDictionary *) parameters{
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingSortedKeys error:nil];
    NSString *paramStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BLYLog(BuglyLogLevelInfo, @"%@[%@]",eventName,paramStr);
}

#pragma mark - Notification

- (void) addObservers
{
     [[ZLServiceManager sharedInstance].viewerServiceModel registerObserver:self selector:@selector(onNotificationArrived:) name:ZLGetCurrentUserInfoResult_Notification];
}


- (void) removeObservers
{
    [[ZLServiceManager sharedInstance].viewerServiceModel unRegisterObserver:self name:ZLGetCurrentUserInfoResult_Notification];
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
