//
//  ZLToastView.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/1/19.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLToastView.h"
#import <Toast/Toast.h>

@implementation ZLToastView

+ (void) showMessage:(NSString *) message
{
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow makeToast:message];
}

+ (void) showMessage:(NSString *)message duration:(NSTimeInterval) duration;
{
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow makeToast:message duration:duration position:CSToastPositionBottom];
}

+ (void) showMessage:(NSString *)message duration:(NSTimeInterval) duration sourceView:(UIView *) view
{
    [view makeToast:message duration:duration position:CSToastPositionBottom];
}

@end
