//
//  ZLKeyChainManager.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLKeyChainManager : NSObject

+ (instancetype) sharedInstance;

+ (void) save:(NSString *)service data:(id)data;

+ (id) load:(NSString *)service;

+ (void) delete:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
