//
//  ZLToolManger.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/4.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLLogModuleProtocol.h"

#define ZLLOGMODULE [ZLToolManager sharedInstance].zlLogModule

#pragma mark - 日志模块快速调用宏

#define ZLLog_Error(fmt, ...)    [ZLLOGMODULE  ZLLogError:__PRETTY_FUNCTION__ file:__FILE__ line:__LINE__ format:fmt, ##__VA_ARGS__];
#define ZLLog_Warning(fmt, ...)  [ZLLOGMODULE  ZLLogWarning:__PRETTY_FUNCTION__ file:__FILE__ line:__LINE__ format:fmt, ##__VA_ARGS__];
#define ZLLog_Info(fmt, ...)     [ZLLOGMODULE  ZLLogInfo:__PRETTY_FUNCTION__ file:__FILE__ line:__LINE__ format:fmt, ##__VA_ARGS__];
#define ZLLog_Debug(fmt, ...)    [ZLLOGMODULE  ZLLogDebug:__PRETTY_FUNCTION__ file:__FILE__ line:__LINE__ format:fmt, ##__VA_ARGS__];
#define ZLLog_Verbose(fmt, ...)  [ZLLOGMODULE  ZLLogVerbose:__PRETTY_FUNCTION__ file:__FILE__ line:__LINE__ format:fmt, ##__VA_ARGS__];


#pragma mark - ZLToolManger 


@interface ZLToolManager : NSObject
/**
 *
 * 日志模块组件
 **/
@property(nonatomic,strong,readonly) id<ZLLogModuleProtocol> zlLogModule;

+ (instancetype) sharedInstance;

@end
