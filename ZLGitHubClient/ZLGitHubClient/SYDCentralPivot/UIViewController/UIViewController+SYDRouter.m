
//
//  UIViewController+SYDRouter.m
//  
//
//  Created by zhumeng on 2019/1/7.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "UIViewController+SYDRouter.h"
#import <objc/runtime.h>

@implementation UIViewController (SYDRouter)


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
         [controller setValue:value forKey:tmpKey];
     }];
    
    if(config.isNavigated)
    {
        UINavigationController * navigationController = [config.sourceViewController navigationController];
        [navigationController pushViewController:controller animated:YES];
    }
    else
    {
        [config.sourceViewController presentViewController:controller animated:YES completion:nil];
    }
    
}


+ (UIViewController *) getOneViewController
{
    return [[self alloc] init];
}

@end


