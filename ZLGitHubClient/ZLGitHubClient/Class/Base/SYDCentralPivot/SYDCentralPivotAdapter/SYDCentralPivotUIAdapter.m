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
static const NSString * WorkboardViewController = @"ZLWorkboardViewController";
static const NSString * OrgsViewController = @"ZLOrgsViewController";


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

+ (UIViewController *)getWorkboardViewController{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:WorkboardViewController];
}

+ (UIViewController *)getOrgsViewController{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:OrgsViewController];
}

+ (UIViewController *)getUserInfoViewControllerWithUserInfo:(ZLGithubUserModel *)userModel;{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:@"ZLUserInfoController" withInjectParam:@{@"userInfoModel":userModel}];
}

+ (UIViewController *)getUserInfoViewControllerWithLoginName:(NSString *) loginName withUserType:(ZLGithubUserType) type{
    ZLGithubUserModel * userModel = [ZLGithubUserModel new];
    userModel.loginName = loginName;
    userModel.type = type;
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:@"ZLUserInfoController" withInjectParam:@{@"userInfoModel":userModel}];
}


+ (UIViewController *)getMyIssuesController{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:@"ZLMyIssuesController"];
}

+ (UIViewController *)getMyReposController{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:@"ZLMyRepoesController"];
}

+ (UIViewController *)getEditFixedRepoController{
    return [[SYDCentralFactory sharedInstance] getOneUIViewController:@"ZLEditFixedRepoController"];
}

@end
