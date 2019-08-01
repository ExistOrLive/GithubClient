//
//  SYDCentralFactory+ViewController.m
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/9.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralFactory+ViewController.h"
#import "UIViewController+SYDRouter.h"
#import <objc/runtime.h>


@implementation SYDCentralFactory (ViewController)

- (UIViewController *) getOneUIViewController:(const NSString *) viewControllerKey
{
    Class viewControllerClass = [self getViewControllerClass:viewControllerKey];
    
    if(!viewControllerClass)
    {
       NSLog(@"SYDCentralFactory_getOneUIViewController: class for [%@] is not exist",viewControllerKey);
        return nil;
    }
    
    SEL getOneViewControllerSEL = @selector(getOneViewController);
    
    Method getOneViewControllerMethod = class_getClassMethod(viewControllerClass,getOneViewControllerSEL);
    
    UIViewController *(*getOneViewController)(id,SEL) = (UIViewController * (*)(id,SEL))method_getImplementation(getOneViewControllerMethod);
    
    if(getOneViewController)
    {
        return  getOneViewController(viewControllerClass,
                                     getOneViewControllerSEL);
    }
    else
    {
        NSLog(@"SYDCentralFactory_getOneViewController: method for [%@] not exist ",viewControllerKey);
        return class_createInstance(viewControllerClass, 0);
    }
}

- (UIViewController *) getOneUIViewController:(const NSString *) viewControllerKey withInjectParam:(NSDictionary *) param
{
    UIViewController * viewController = [self getOneUIViewController:viewControllerKey];
    
    if(viewController)
    {
        [param enumerateKeysAndObjectsUsingBlock:^(id key,id value,BOOL * stop)
         {
             NSString * tmpKey = key;
             @try
             {
                 [viewController setValue:value forKey:tmpKey];
             }
             @catch(NSException * exception)
             {
                 NSLog(@"SYDCentralFactory_getOneUIViewControllerWithInjectParam: value for key[%@] not exist,exception[%@]",viewControllerKey,exception);
             }
             
         }];
    }

    return viewController;
}

- (Class) getViewControllerClass:(const NSString *) viewControllerKey
{
    Class viewControllerClass = nil;
    
    if(!self.viewControllerModelMapCache)
    {
        self.viewControllerModelMapCache = [[NSMutableDictionary alloc] init];
    }
    else
    {
        viewControllerClass = [self.viewControllerModelMapCache objectForKey:viewControllerKey];
    }
    
    if(!viewControllerClass)
    {
        SYDCentralRouterModel * model = [self getCentralRouterModel:viewControllerKey];
        viewControllerClass = [model cla];
        
        if(!model || !viewControllerClass)
        {
            NSLog(@"SYDCentralFactory_getViewControllerClass: model for [%@] is not exist",viewControllerKey);
            return nil;
        }
        
        [self.viewControllerModelMapCache setObject:viewControllerClass forKey:viewControllerKey];
    }
    
    return viewControllerClass;
}


@end
