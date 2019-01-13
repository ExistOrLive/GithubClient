//
//  UIViewController+SYDRouter.h
//  
//
//  Created by zhumeng on 2019/1/7.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDCentralRouterModel.h"


@interface UIViewController (SYDRouter)

+ (void) enterViewControllerWithViewControllerConfig:(id) config withParam:(NSDictionary *) paramDic;

+ (UIViewController *) getOneViewController;

@end
