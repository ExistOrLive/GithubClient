//
//  ZLToastView.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/1/19.
//  Copyright © 2020 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLToastView : NSObject

+ (void) showMessage:(NSString *) message;

+ (void) showMessage:(NSString *)message duration:(NSTimeInterval) duration;

+ (void) showMessage:(NSString *)message duration:(NSTimeInterval) duration sourceView:(UIView *) view;

@end

NS_ASSUME_NONNULL_END
