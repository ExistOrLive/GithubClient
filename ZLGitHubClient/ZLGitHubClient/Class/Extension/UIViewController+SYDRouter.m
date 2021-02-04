
//
//  UIViewController+SYDRouter.m
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/7.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "UIViewController+SYDRouter.h"
#import <objc/runtime.h>


@implementation UIViewController (SYDRouter)

- (void) setVCKey:(NSString *)VCKey {
    objc_setAssociatedObject(self, "VCKey", VCKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *) VCKey{
    NSString *key = objc_getAssociatedObject(self, "VCKey");
    if(!key){
        key = @"UIViewController";
    }
    return key;
}



+ (void) enterViewControllerWithViewControllerConfig:(id) pConfig withParam:(NSDictionary *) paramDic
{
    SYDCentralRouterViewControllerConfig * config = pConfig;
    
    UIViewController * controller = [self getOneViewController];
    controller.hidesBottomBarWhenPushed = config.hidesBottomBarWhenPushed;
    
    /**
     *
     * 传递参数
     **/
    [paramDic enumerateKeysAndObjectsUsingBlock:^(id  key,id value,BOOL * stop)
     {
         NSString * tmpKey = key;
         @try
         {
             [controller setValue:value forKey:tmpKey];
         }
         @catch(NSException * exception)
         {
             NSLog(@"enterViewControllerWithViewControllerConfig: value for key[%@] not exist,exception[%@]",key,exception);
         }
       
     }];
    
    if(config.isNavigated)
    {
        UINavigationController * navigationController = [config.sourceViewController navigationController];
        [navigationController pushViewController:controller animated:config.animated];
    }
    else
    {
        [config.sourceViewController presentViewController:controller animated:config.animated completion:nil];
    }
    
}


+ (UIViewController *) getOneViewController
{
    return [[self alloc] init];
}


@end



@implementation UIViewController (Tool)

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
