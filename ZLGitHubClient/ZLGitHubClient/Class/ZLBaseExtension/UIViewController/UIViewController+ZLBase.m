
//
//  UIViewController+ZLBase.m
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/7.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "UIViewController+ZLBase.h"

@implementation UIViewController (ZLBase)

+ (UIViewController *)getTopViewController{
    return [self getTopViewControllerFromWindow:[UIApplication sharedApplication].delegate.window];
}

+ (UIViewController *)getTopViewControllerFromWindow:(UIWindow *) window{
    return [self getTopViewControllerFromViewController:window.rootViewController];
}


+ (UIViewController *)getTopViewControllerFromViewController:(UIViewController *)rootVC{
    
    UIViewController *currentVC = nil;
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        
        // 根视图为UITabBarController
        currentVC = [self
                     getTopViewControllerFromViewController:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        
        // 根视图为UINavigationController
        currentVC =
        [self getTopViewControllerFromViewController:[(UINavigationController *)
                                rootVC visibleViewController]];
    } else if(currentVC.presentedViewController) {
        // 视图是被presented出来的
        rootVC = [self getTopViewControllerFromViewController:rootVC.presentedViewController];
    }
    else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
