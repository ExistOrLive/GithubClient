//
//  SYDCentralRouter+ViewController.m
//  
//
//  Created by zhumeng on 2019/1/9.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralRouter+ViewController.h"

#import "SYDCentralFactory+ViewController.h"
#import "UIViewController+SYDRouter.h"

#import <objc/runtime.h>



@implementation SYDCentralRouter (ViewController)

- (void) enterViewController:(const NSString *) viewControllerKey withViewControllerConfig:(id) config withParam:(NSDictionary *) paramDic
{
    NSLog(@"SYDCentralRouter_enterViewController: viewControllerKey[%@] config[%@] paramDic[%@]",viewControllerKey,config,paramDic);
    
    Class viewControllerClass = [self.centralFactory getViewControllerClass:viewControllerKey];
    
    if(!viewControllerClass)
    {
        NSLog(@"SYDCentralRouter_enterViewController: viewcontrollerclass for [%@] not exist",viewControllerKey);
        return;
    }
    
    SEL enterViewControllerSEL = @selector(enterViewControllerWithViewControllerConfig:withParam:);
    
    Method enterViewControllerMethod = class_getClassMethod(viewControllerClass,enterViewControllerSEL);
    
    void(*enterViewController)(id,SEL,id,NSDictionary *) = (void(*)(id,SEL,id,NSDictionary *))method_getImplementation(enterViewControllerMethod);
    
    if(enterViewController)
    {
        enterViewController(viewControllerClass,
                            enterViewControllerSEL,
                            config,
                            paramDic);
    }
    else
    {
        NSLog(@"SYDCentralRouter: enterViewController method for [%@] not exist ",viewControllerKey);
    }
}


@end
