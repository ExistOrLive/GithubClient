
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
#define ZLKeyChainServiceFixRepos @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient.fixrepo"
#define ZLKeyChainServiceDeviceId @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient.deviceId"

#define ZLAccessTokenKey @"ZLAccessTokenKey"
#define ZLGithubConfigKey @"ZLGithubConfigKey"
#define ZLCurrentUserInterfaceStyleKey @"ZLCurrentUserInterfaceStyleKey"

@interface ZLSharedDataManager()

@property(nonatomic,strong,nullable) ZLGithubUserModel * userInfoModel;

@end 

 
@implementation ZLSharedDataManager

@synthesize userInfoModel = _userInfoModel;
@synthesize githubAccessToken = _githubAccessToken;
@synthesize configModel = _configModel;
@dynamic deviceId;

+ (instancetype) sharedInstance{
    static ZLSharedDataManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZLSharedDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark -

- (void) setCurrentLoginName:(NSString *)currentLoginName{
    [[NSUserDefaults standardUserDefaults] setObject:currentLoginName forKey:@"currentLoginName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (NSString *) currentLoginName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLoginName"];
}


// deprecated
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




#pragma mark accesstoken

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


#pragma mark

- (void) clearGithubTokenAndUserInfo{
    [self setCurrentLoginName:nil];
    [self setUserInfoModel:nil];
    [self setGithubAccessToken:nil];
}


#pragma mark - 与用户无关的配置

#pragma mark deviceId

- (NSString *) deviceId {
    
    static NSString* deviceId = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceId = [ZLKeyChainManager load:ZLKeyChainServiceDeviceId];
        if(deviceId == nil || deviceId.length == 0) {
            
            NSString* idfv =  [UIDevice currentDevice].identifierForVendor.UUIDString;
            idfv = [idfv stringByReplacingOccurrencesOfString:@"-" withString:@""];
            idfv = [idfv lowercaseString];
            deviceId = [[NSString alloc] initWithFormat:@"%@-%lf",idfv,[NSDate new].timeIntervalSince1970];
            [ZLKeyChainManager save:ZLKeyChainServiceDeviceId data:deviceId];
        }
    });

    return deviceId;
}


#pragma mark  config

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

#pragma mark  fix repo

- (void) setFixRepos:(NSArray *)repos forLoginUser:(NSString *)login{
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

- (NSArray * __nullable) fixReposForLoginUser:(NSString *)login{
    NSMutableDictionary *reposDic =  [ZLKeyChainManager load:ZLKeyChainServiceFixRepos];
    return [reposDic objectForKey:login];
}


@end
