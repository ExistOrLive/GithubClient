//
//  SYDCentralPivotUIAdapter.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/1/13.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import "SYDCentralPivotUIAdapter.h"

static const NSString * MainViewController = @"ZLMainViewController";

@implementation SYDCentralPivotUIAdapter

+ (UIViewController *) getZLMainViewController
{
    static UIViewController * mainViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainViewController = [[SYDCentralFactory sharedInstance] getOneUIViewController:MainViewController];
    });
    
    return mainViewController;
}

@end
