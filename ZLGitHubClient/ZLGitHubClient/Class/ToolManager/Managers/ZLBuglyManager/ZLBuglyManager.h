//
//  ZLBuglyManager.h
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/12/19.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLBuglyManager : NSObject


+ (instancetype) sharedManager;

- (void) setUp;

@end

NS_ASSUME_NONNULL_END
