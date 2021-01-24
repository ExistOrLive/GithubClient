//
//  ZLBaseUIConfig.m
//  ZLBaseFramework
//
//  Created by 朱猛 on 2020/12/30.
//  Copyright © 2020 ZM. All rights reserved.
//


#import "ZLBaseUIConfig.h"
#import "ZLBaseUIHeader.h"

@implementation ZLBaseUIConfig

+ (instancetype) defaultInstance {
    ZLBaseUIConfig *config = [ZLBaseUIConfig new];
    
    config.navigationBarTitleFont = [UIFont fontWithName:Font_PingFangSCMedium size:18];
    config.navigationBarHeight = 60;       // 默认为60
    
    config.buttonBackColor = [UIColor clearColor];
    config.buttonBorderColor = [UIColor clearColor];
    config.buttonCornerRadius = 0;
    config.buttonBorderWidth = 0;

    if (@available(iOS 13.0, *)) {
        config.navigationBarTitleColor = [UIColor labelColor];
        config.navigationBarBackgoundColor = [UIColor secondarySystemBackgroundColor];
        
        config.viewControllerBackgoundColor = [UIColor systemBackgroundColor];
        
        config.buttonTitleColor = [UIColor labelColor];
    } else {
        config.navigationBarTitleColor = [UIColor blackColor];
        config.navigationBarBackgoundColor = [UIColor whiteColor];
        
        config.viewControllerBackgoundColor = [UIColor whiteColor];
        
        config.buttonTitleColor = [UIColor blackColor];
    }

    return config;
}


+ (instancetype) sharedInstance {
    static ZLBaseUIConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [ZLBaseUIConfig defaultInstance];
    });
    
    return config;
}




@end
