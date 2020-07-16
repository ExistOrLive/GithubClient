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
static const NSString * StarRepoViewController = @"ZLStarRepoViewController";
static const NSString * ExploreViewController = @"ZLExploreViewController";
static const NSString * ProfileViewController = @"ZLProfileViewController";
static const NSString * AboutViewController = @"ZLAboutViewController";

@implementation SYDCentralPivotUIAdapter

+ (UIViewController *)getZLMainViewController
{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:MainViewController];
}

+ (UIViewController *)getZLNewsViewController
{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:NewsViewController];
}

+ (UIViewController *)getZLStarRepoViewController
{
    return  [[SYDCentralFactory sharedInstance] getOneUIViewController:StarRepoViewController];
}

+ (UIViewController *)getZLExploreViewController
{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:ExploreViewController];
}

+ (UIViewController *)getZLProfileViewController
{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:ProfileViewController];
}

+ (UIViewController *)getZLAboutViewController{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:AboutViewController];
}



@end
