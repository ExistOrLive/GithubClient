//
//  SYDCentralRouter.h
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/7.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SYDCentralFactory.h"


@interface SYDCentralRouter : NSObject

@property(nonatomic,strong) SYDCentralFactory * centralFactory;

+ (instancetype) sharedInstance;

@end
