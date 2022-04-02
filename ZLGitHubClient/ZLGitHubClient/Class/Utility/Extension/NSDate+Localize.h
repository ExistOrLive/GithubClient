//
//  NSDate+Localize.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/9/27.
//  Copyright © 2021 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Localize)

- (NSString *) dateLocalStrSinceCurrentTime;

+ (NSString *) getDateLocalStrSinceCurrentTimeWithGithubTime:(NSString *) githubDateStr;

@end

NS_ASSUME_NONNULL_END
