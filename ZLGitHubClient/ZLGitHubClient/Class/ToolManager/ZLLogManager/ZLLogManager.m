

//
//  ZLLogManager.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/2.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLLogManager.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG

static const DDLogLevel ddLogLevel = DDLogLevelDebug;

#else

static const DDLogLevel ddLogLevel = DDLogLevelInfo;

#endif


@implementation ZLLogManager

+ (instancetype) sharedInstance
{
    static ZLLogManager * logManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logManager = [[ZLLogManager alloc] init];
    });
    return logManager;
}

- (instancetype) init
{
    if(self = [super init])
    {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        DDFileLogger * fileLogger = [[DDFileLogger alloc] init];
        fileLogger.rollingFrequency = 24 * 60 * 60;
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        fileLogger.maximumFileSize = 1024 * 1024 * 5;
        
        [DDLog addLogger:fileLogger];
    }
    return self;
}

- (void)ZLLogError:(const char *)function
              file:(const char *)file
              line:(NSUInteger)line
            format:(NSString *)format, ...
{
    if(!(LOG_LEVEL_DEF & DDLogFlagError))
    {
        return;
    }
    
    if(format)
    {
        va_list list;
        va_start(list, format);
        
        [DDLog log:NO level:LOG_LEVEL_DEF flag:DDLogFlagError context:0 file:file function:function line:line tag:nil format:format args:list];
        
        va_end(list);
    }
    
}

- (void)ZLLogWarning:(const char *)function
                file:(const char *)file
                line:(NSUInteger)line
              format:(NSString *)format, ...
{
    if(!(LOG_LEVEL_DEF & DDLogFlagWarning))
    {
        return;
    }
    
    if(format)
    {
        va_list list;
        va_start(list, format);
        
        [DDLog log:LOG_ASYNC_ENABLED level:LOG_LEVEL_DEF flag:DDLogFlagWarning context:0 file:file function:function line:line tag:nil format:format args:list];
        
        va_end(list);
    }
    
}
- (void)ZLLogInfo:(const char *)function
             file:(const char *)file
             line:(NSUInteger)line
           format:(NSString *)format, ...
{
    if(!(LOG_LEVEL_DEF & DDLogFlagInfo))
    {
        return;
    }
    
    if(format)
    {
        va_list list;
        va_start(list, format);
        
        [DDLog log:LOG_ASYNC_ENABLED level:LOG_LEVEL_DEF flag:DDLogFlagInfo context:0 file:file function:function line:line tag:nil format:format args:list];
        
        va_end(list);
    }
    
}

- (void)ZLLogDebug:(const char *)function
              file:(const char *)file
              line:(NSUInteger)line
            format:(NSString *)format, ...
{
    if(!(LOG_LEVEL_DEF & DDLogFlagDebug))
    {
        return;
    }
    
    if(format)
    {
        va_list list;
        va_start(list, format);
        
        [DDLog log:LOG_ASYNC_ENABLED level:LOG_LEVEL_DEF flag:DDLogFlagDebug context:0 file:file function:function line:line tag:nil format:format args:list];
        
        va_end(list);
    }
    
}
- (void)ZLLogVerbose:(const char *)function
                file:(const char *)file
                line:(NSUInteger)line
              format:(NSString *)format, ...
{
    if(!(LOG_LEVEL_DEF & DDLogFlagVerbose))
    {
        return;
    }
    
    if(format)
    {
        va_list list;
        va_start(list, format);
        
        [DDLog log:LOG_ASYNC_ENABLED level:LOG_LEVEL_DEF flag:DDLogFlagVerbose context:0 file:file function:function line:line tag:nil format:format args:list];
        
        va_end(list);
    }
    
}


@end
