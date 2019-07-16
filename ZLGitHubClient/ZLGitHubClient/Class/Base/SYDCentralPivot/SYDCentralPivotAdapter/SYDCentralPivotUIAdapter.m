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
    static UIViewController * mainViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainViewController = [[SYDCentralFactory sharedInstance] getOneUIViewController:MainViewController];
    });
    
    return mainViewController;
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
    static UIViewController * newsViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        newsViewController = [[SYDCentralFactory sharedInstance] getOneUIViewController:RepositoriesViewController];
    });
    
    return newsViewController;
}

+ (UIViewController *)getZLExploreViewController
{
    static UIViewController * profileViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profileViewController = [[SYDCentralFactory sharedInstance] getOneUIViewController:ExploreViewController];
    });
    
    return profileViewController;
}

+ (UIViewController *)getZLProfileViewController
{
    static UIViewController * profileViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profileViewController = [[SYDCentralFactory sharedInstance] getOneUIViewController:ProfileViewController];
    });
    
    return profileViewController;
}



@end
