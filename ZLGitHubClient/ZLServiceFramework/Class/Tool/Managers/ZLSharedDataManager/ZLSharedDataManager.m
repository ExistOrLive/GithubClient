
//
//  ZLSharedDataManager.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/7.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLSharedDataManager.h"
#import "ZLKeyChainManager.h"
#import "ZLTrendingFilterInfoModel.h"

#define ZLKeyChainService @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient"
#define ZLKeyChainServiceFixRepos @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient.fixrepo"
#define ZLAccessTokenKey @"ZLAccessTokenKey"
#define ZLUserAccountKey @"ZLUserAccountKey"
#define ZLUserHeadImageKey @"ZLUserHeadImageKey"
#define ZLSearchRecordKey @"ZLSearchRecordKey"
#define ZLShowAllNotificationsKey @"ZLShowAllNotificationsKey"
#define ZLGithubConfigKey @"ZLGithubConfigKey"
#define ZLCurrentUserInterfaceStyleKey @"ZLCurrentUserInterfaceStyleKey"
 
@implementation ZLSharedDataManager

@synthesize userInfoModel = _userInfoModel;
@synthesize githubAccessToken = _githubAccessToken;
@synthesize trendingOptions = _trendingOptions;
@synthesize searchRecordArray = _searchRecordArray;
@synthesize configModel = _configModel;
@dynamic showAllNotifications;
@dynamic currentUserInterfaceStyle;

+ (instancetype) sharedInstance{
    static ZLSharedDataManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZLSharedDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark -

- (void) setUserInfoModel:(ZLGithubUserModel * _Nullable)userInfoModel{
    if(userInfoModel){
        _userInfoModel = userInfoModel;
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:userInfoModel];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfoModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        _userInfoModel = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (ZLGithubUserModel *) userInfoModel{
    if(!_userInfoModel){
        _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoModel"]];
    }
    return _userInfoModel;
}




#pragma mark -

- (void) setGithubAccessToken:(NSString * _Nullable)githubAccessToken{
    _githubAccessToken = githubAccessToken;
    [[NSUserDefaults standardUserDefaults] setObject:githubAccessToken forKey:ZLAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) githubAccessToken{
    if(!_githubAccessToken){
        _githubAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ZLAccessTokenKey];
    }
    return _githubAccessToken;
}


#pragma mark - fix repo

- (void) setFixRepos:(NSArray<ZLGithubCollectedRepoModel *>*)repos forLoginUser:(NSString *)login{
    if(!repos || !login){
        return;
    }
    
    NSMutableDictionary *reposDic =  [ZLKeyChainManager load:ZLKeyChainServiceFixRepos];
    if(!reposDic) {
        reposDic = [NSMutableDictionary new];
    }
    [reposDic setObject:repos forKey:login];
    [ZLKeyChainManager save:ZLKeyChainServiceFixRepos data:reposDic];
}

- (NSArray<ZLGithubCollectedRepoModel *>* __nullable) fixReposForLoginUser:(NSString *)login{
    NSMutableDictionary *reposDic =  [ZLKeyChainManager load:ZLKeyChainServiceFixRepos];
    return [reposDic objectForKey:login];
}


#pragma mark -


- (void) setTrendingOptions:(NSMutableDictionary *)trendingOptions {
    _trendingOptions = trendingOptions;
    if(trendingOptions){
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:trendingOptions];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"trendingOptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"trendingOptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (NSMutableDictionary *) trendingOptions {
    if(!_trendingOptions) {
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"trendingOptions"];
        NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _trendingOptions = [dic mutableCopy];
    }
    if(!_trendingOptions) {
        _trendingOptions = [NSMutableDictionary new];
        _trendingOptions[@"repo"] = [ZLTrendingFilterInfoModel new];
        _trendingOptions[@"user"] = [ZLTrendingFilterInfoModel new];
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:_trendingOptions];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"trendingOptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return _trendingOptions;
}

- (NSString * __nullable) lanaguageForTrendingRepo {
    ZLTrendingFilterInfoModel *model = self.trendingOptions[@"repo"];
    return model.language;
}

- (NSString * __nullable) lanaguageForTrendingUser {
    ZLTrendingFilterInfoModel *model = self.trendingOptions[@"user"];
    return model.language;
}

- (void) setLanguageForTrendingRepo:(NSString * __nullable) language {
    ZLTrendingFilterInfoModel *model = self.trendingOptions[@"repo"];
    model.language = language;
    self.trendingOptions = self.trendingOptions;
}

- (void) setLanguageForTrendingUser:(NSString * __nullable) language {
     ZLTrendingFilterInfoModel *model = self.trendingOptions[@"user"];
     model.language = language;
     self.trendingOptions = self.trendingOptions;
}


- (ZLDateRange) dateRangeForTrendingRepo {
    ZLTrendingFilterInfoModel *model = self.trendingOptions[@"repo"];
    return model.dateRange;
}

- (ZLDateRange) dateRangeForTrendingUser {
    ZLTrendingFilterInfoModel *model = self.trendingOptions[@"user"];
    return model.dateRange;
}

- (void) setDateRangeForTrendingRepo:(ZLDateRange) range {
    NSMutableDictionary * options = self.trendingOptions;
    ZLTrendingFilterInfoModel *model = options[@"repo"];
    model.dateRange = range;
    self.trendingOptions = options;
}

- (void) setDateRangeForTrendingUser:(ZLDateRange) range  {
    NSMutableDictionary * options = self.trendingOptions;
    ZLTrendingFilterInfoModel *model = options[@"user"];
    model.dateRange = range;
    self.trendingOptions = options;
}

#pragma mark - search

- (void)setSearchRecordArray:(NSArray<NSString *> *)searchRecordArray{
    _searchRecordArray = [searchRecordArray copy];
    [[NSUserDefaults standardUserDefaults] setObject:_searchRecordArray forKey:ZLSearchRecordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray<NSString *> *)searchRecordArray {
    if(!_searchRecordArray) {
        _searchRecordArray = [[NSUserDefaults standardUserDefaults] objectForKey:ZLSearchRecordKey];
    }
    return _searchRecordArray;
}

#pragma mark -

- (void)setShowAllNotifications:(BOOL)showAllNotifications{
    [[NSUserDefaults standardUserDefaults] setBool:showAllNotifications forKey:ZLShowAllNotificationsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) showAllNotifications{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ZLShowAllNotificationsKey];
}


#pragma mark - config

- (void) setConfigModel:(ZLGithubConfigModel *)configModel{
    _configModel = configModel;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:configModel];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:ZLGithubConfigKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (ZLGithubConfigModel *)configModel{
    if(!_configModel){
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:ZLGithubConfigKey];
        _configModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return _configModel;
}


#pragma mark - UIInterfaceStyle

- (void) setCurrentUserInterfaceStyle:(UIUserInterfaceStyle)currentUserInterfaceStyle{
    [[NSUserDefaults standardUserDefaults] setInteger:currentUserInterfaceStyle forKey:ZLCurrentUserInterfaceStyleKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIUserInterfaceStyle) currentUserInterfaceStyle{
    return (UIUserInterfaceStyle)[[NSUserDefaults standardUserDefaults] integerForKey:ZLCurrentUserInterfaceStyleKey];
}

#pragma mark -

- (void) clearGithubTokenAndUserInfo{
    [self setUserInfoModel:nil];
    [self setGithubAccessToken:nil];
    [self setTrendingOptions:nil];
    [self setSearchRecordArray:nil];
    [self setShowAllNotifications:NO];
}



@end
