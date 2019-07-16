//
//  ZLLoginServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZTE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLLoginServiceModel : NSObject

+ (instancetype) sharedServiceModel;

- (NSURL *) OAuthURL;

- (void) startOAuth;

@end

NS_ASSUME_NONNULL_END
