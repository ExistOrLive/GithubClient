//
//  UIViewController+SYDRouter.h
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/7.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDCentralRouterModel.h"


@interface UIViewController (SYDRouter)

@property(nonatomic, copy, readonly) NSString *VCKey;

+ (void) enterViewControllerWithViewControllerConfig:(id) config withParam:(NSDictionary *) paramDic;

+ (UIViewController *) getOneViewController;

@end


@interface UIViewController (Tool)

+ (UIViewController *)getTopViewController;

+ (UIViewController *)getTopViewControllerFromViewController:(UIViewController *)rootVC;

+ (UIViewController *)getTopViewControllerFromWindow:(UIWindow *) window;

@end
