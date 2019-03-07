//
//  SYDCentralFactory+ViewController.h
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/9.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralFactory.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SYDCentralFactory (ViewController)

#pragma mark - UI跳转

- (Class) getViewControllerClass:(const NSString *) viewControllerKey;

- (UIViewController *) getOneUIViewController:(const NSString *) viewControllerKey;

- (UIViewController *) getOneUIViewController:(const NSString *) viewControllerKey withInjectParam:(NSDictionary *) param;


@end
