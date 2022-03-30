//
//  UIViewController+ZLBase.h
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/7.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZLBase)

+ (UIViewController *)getTopViewController;

+ (UIViewController *)getTopViewControllerFromViewController:(UIViewController *)rootVC;

+ (UIViewController *)getTopViewControllerFromWindow:(UIWindow *) window;

@end
