//
//  ZLKeyChainManager.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLKeyChainManager.h"
#import <Security/Security.h>



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
