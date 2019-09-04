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

- (NSString *) getGithubAccessToken;

- (NSString *) getUserAccount;

- (NSString *) getHeadImageURL;

- (BOOL) updateUserAccount:(NSString * __nullable) userAccount withAccessToken:(NSString * __nullable) token;

- (BOOL) updateUserHeadImageURL:(NSString * __nullable) headImageURL;

@end

NS_ASSUME_NONNULL_END
