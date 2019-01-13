//
//  SYDCentralRouter+ViewController.h
//  
//
//  Created by zhumeng on 2019/1/9.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralRouter.h"

@interface SYDCentralRouter (ViewController)

- (void) enterViewController:(const NSString *) viewControllerKey withViewControllerConfig:(id) config withParam:(NSDictionary *) paramDic;

@end
