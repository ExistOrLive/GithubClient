//
//  ZLKeyChainManager.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLKeyChainManager.h"
#import <Security/Security.h>

#define ZLKeyChainService @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient"
#define ZLAccessTokenKey @"ZLAccessTokenKey"
#define ZLUserAccountKey @"ZLUserAccountKey"
#define ZLUserHeadImageKey @"ZLUserHeadImageKey"

@implementation ZLKeyChainManager

+ (instancetype) sharedInstance
{
    static ZLKeyChainManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZLKeyChainManager alloc] init];
    });
    return manager;
}

- (NSString *) getGithubAccessToken
{
    NSDictionary * info = [ZLKeyChainManager load:ZLKeyChainService];
    
    NSString * accessToken = [info objectForKey:ZLAccessTokenKey];
    
    return accessToken;
}

- (NSString *) getUserAccount
{
    NSDictionary * info = [ZLKeyChainManager load:ZLKeyChainService];
    
    NSString * userAccount = [info objectForKey:ZLUserAccountKey];
    
    return userAccount;
}

- (NSString *) getHeadImageURL
{
    NSDictionary * info = [ZLKeyChainManager load:ZLKeyChainService];
    
    NSString * headImageURL = [info objectForKey:ZLUserHeadImageKey];
    
    return headImageURL;
}

- (BOOL) updateUserAccount:(NSString * __nullable) userAccount withAccessToken:(NSString * __nullable) token
{
    NSMutableDictionary * info = [[NSMutableDictionary alloc] init];
    if(userAccount)
    {
        [info setObject:userAccount forKey:ZLUserAccountKey];
    }
    if(token)
    {
        [info setObject:token forKey:ZLAccessTokenKey];
    }
    [ZLKeyChainManager save:ZLKeyChainService data:info];
    
    return YES;
}

- (BOOL) updateUserAccount:(NSString *) userAccount
{
    if(!userAccount)
    {
        return NO;
    }
    
    NSMutableDictionary * info = [ZLKeyChainManager load:ZLKeyChainService];
    if(!info)
    {
        info = [[NSMutableDictionary alloc] init];
    }
    [info setObject:userAccount forKey:ZLUserAccountKey];
    [ZLKeyChainManager save:ZLKeyChainService data:info];
    
    return YES;
    
    
}

- (BOOL) updateGithubAccessToken:(NSString *) token
{
    if(!token)
    {
        return NO;
    }
    
    NSMutableDictionary * info = [ZLKeyChainManager load:ZLKeyChainService];
    if(!info)
    {
        info = [[NSMutableDictionary alloc] init];
    }
    [info setObject:token forKey:ZLAccessTokenKey];
    [ZLKeyChainManager save:ZLKeyChainService data:info];
    
    return YES;
    
}


- (BOOL) updateUserHeadImageURL:(NSString * __nullable) headImageURL
{
    if(!headImageURL)
    {
        return NO;
    }
    
    NSMutableDictionary * info = [ZLKeyChainManager load:ZLKeyChainService];
    if(!info)
    {
        info = [[NSMutableDictionary alloc] init];
    }
    [info setObject:headImageURL forKey:ZLUserHeadImageKey];
    [ZLKeyChainManager save:ZLKeyChainService data:info];
    
    return YES;
}

- (void) clearGithubTokenAndUserInfo
{
    NSMutableDictionary * info = [ZLKeyChainManager load:ZLKeyChainService];
    if(info)
    {
        [info removeObjectForKey:ZLAccessTokenKey];
        [info removeObjectForKey:ZLUserAccountKey];
        [info removeObjectForKey:ZLUserHeadImageKey];
        [ZLKeyChainManager save:ZLKeyChainService data:info];
    }
}

# pragma mark -

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service{
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service,(__bridge_transfer id)kSecAttrService,
            service,(__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
            (__bridge_transfer id)kSecAttrAccessible,nil];
}

+(void)save:(NSString *)service data:(id)data{
    //Get  search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Delete old item before add new item
    CFDictionaryRef cfquery = (CFDictionaryRef)CFBridgingRetain(keychainQuery);
    SecItemDelete(cfquery);
    
    //Add new object to search dictionary(Attention: the date format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    
    //Add item to keychain with the search dictionary
    SecItemAdd(cfquery, NULL);
    CFRelease(cfquery);
}

+(id)load:(NSString *)service{
    
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:
     (__bridge_transfer id)kSecMatchLimit];
    
    CFDateRef keyData = nil;
    CFDictionaryRef cfquery = (CFDictionaryRef)CFBridgingRetain(keychainQuery);
    OSStatus status = SecItemCopyMatching(cfquery, (CFTypeRef *)&keyData);
    CFRelease(cfquery);
    if (status == errSecSuccess) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        }@catch (NSException *e) {
            ZLLog_Info(@"Unarchive of %@ failed: %@",service,e);
        }@finally {
        }
    }
    return ret;
}

+(void)delete:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    CFDictionaryRef cfquery = (CFDictionaryRef)CFBridgingRetain(keychainQuery);
    SecItemDelete(cfquery);
    CFRelease(cfquery);
}

@end
