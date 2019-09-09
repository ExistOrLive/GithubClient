//
//  SYDCentralPivotUIAdapter.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/1/13.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "SYDCentralPivotUIAdapter.h"

static const NSString * MainViewController = @"ZLMainViewController";
static const NSString * NewsViewController = @"ZLNewsViewController";
static const NSString * RepositoriesViewController = @"ZLRepositoriesViewController";
static const NSString * ExploreViewController = @"ZLExploreViewController";
static const NSString * ProfileViewController = @"ZLProfileViewController";

@implementation SYDCentralPivotUIAdapter

+ (UIViewController *)getZLMainViewController
{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:MainViewController];
}

+ (UIViewController *)getZLNewsViewController
{
    static UIViewController * profileViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profileViewController = [[SYDCentralFactory sharedInstance] getOneUIViewController:NewsViewController];
    });
    
    return profileViewController;
}

+ (UIViewController *)getZLRepositoriesViewController
{
    return  [[SYDCentralFactory sharedInstance] getOneUIViewController:RepositoriesViewController];
}

+ (UIViewController *)getZLExploreViewController
{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:ExploreViewController];
}

+ (UIViewController *)getZLProfileViewController
{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:ProfileViewController];
}



@end
