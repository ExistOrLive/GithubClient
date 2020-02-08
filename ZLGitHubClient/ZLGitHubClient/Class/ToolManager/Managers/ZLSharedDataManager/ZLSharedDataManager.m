
//
//  ZLSharedDataManager.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/7.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLSharedDataManager.h"
#import "ZLKeyChainManager.h"

#define ZLKeyChainService @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient"
#define ZLAccessTokenKey @"ZLAccessTokenKey"
#define ZLUserAccountKey @"ZLUserAccountKey"
#define ZLUserHeadImageKey @"ZLUserHeadImageKey"

@implementation ZLSharedDataManager

@synthesize userInfoModel = _userInfoModel;
@synthesize githubAccessToken = _githubAccessToken;

+ (instancetype) sharedInstance
{
    static ZLSharedDataManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZLSharedDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark -

- (void) setUserInfoModel:(ZLGithubUserModel * _Nullable)userInfoModel
{
    if(userInfoModel)
    {
        _userInfoModel = userInfoModel;
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:userInfoModel];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfoModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (ZLGithubUserModel *) userInfoModel
{
    if(!_userInfoModel)
    {
        _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoModel"]];
    }
    return _userInfoModel;
}




#pragma mark -

- (void) setGithubAccessToken:(NSString * _Nullable)githubAccessToken
{
    _githubAccessToken = githubAccessToken;
    
    NSMutableDictionary * keychainInfo = [ZLKeyChainManager load:ZLKeyChainService];
    if(!keychainInfo)
    {
        keychainInfo = [[NSMutableDictionary alloc] init];
    }
    
    if(githubAccessToken)
    {
        [keychainInfo setObject:githubAccessToken forKey:ZLAccessTokenKey];
    }
    else
    {
        [keychainInfo removeObjectForKey:ZLAccessTokenKey];
    }
    [ZLKeyChainManager save:ZLKeyChainService data:keychainInfo];
    
}

- (NSString *) githubAccessToken
{
    if(!_githubAccessToken)
    {
        NSMutableDictionary * keychainInfo = [ZLKeyChainManager load:ZLKeyChainService];
        _githubAccessToken = [keychainInfo objectForKey:ZLAccessTokenKey];
    }
    return _githubAccessToken;
    
}


- (void) clearGithubTokenAndUserInfo
{
    [self setUserInfoModel:nil];
    [self setGithubAccessToken:nil];
}

@end
