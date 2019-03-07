//
//  ZLLogModuleProtocol.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/2.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZLLogModuleProtocol <NSObject>

+ (instancetype) sharedInstance;

- (void)ZLLogError:(const char *)function
              file:(const char *)file
              line:(NSUInteger)line
            format:(NSString *)format, ...;

- (void)ZLLogWarning:(const char *)function
                file:(const char *)file
                line:(NSUInteger)line
              format:(NSString *)format, ...;

- (void)ZLLogInfo:(const char *)function
             file:(const char *)file
             line:(NSUInteger)line
           format:(NSString *)format, ...;

- (void)ZLLogDebug:(const char *)function
              file:(const char *)file
              line:(NSUInteger)line
            format:(NSString *)format, ...;

- (void)ZLLogVerbose:(const char *)function
                file:(const char *)file
                line:(NSUInteger)line
              format:(NSString *)format, ...;

@end



