//
//  NSDate+localizeStr.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/25.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (localizeStr)

- (NSString *) dateLocalStrSinceCurrentTime;

- (NSString *) dateStrForYYYYMMdd;

@end

NS_ASSUME_NONNULL_END
