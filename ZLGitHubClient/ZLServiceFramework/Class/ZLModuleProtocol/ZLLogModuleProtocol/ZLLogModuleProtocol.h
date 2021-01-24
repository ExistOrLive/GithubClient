//
//  ZLLogModuleProtocol.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/2.
//  Copyright © 2019年 ZM. All rights reserved.
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



- (void)ZLLogError:(NSString *)function
              file:(NSString *)file
              line:(NSUInteger)line
               str:(NSString *)str;

- (void)ZLLogWarning:(NSString *)function
                file:(NSString *)file
                line:(NSUInteger)line
                 str:(NSString *)str;

- (void)ZLLogInfo:(NSString *)function
             file:(NSString *)file
             line:(NSUInteger)line
              str:(NSString *)str;

- (void)ZLLogDebug:(NSString *)function
              file:(NSString *)file
              line:(NSUInteger)line
               str:(NSString *)str;

- (void)ZLLogVerbose:(NSString *)function
                file:(NSString *)file
                line:(NSUInteger)line
                 str:(NSString *)str;

@end



