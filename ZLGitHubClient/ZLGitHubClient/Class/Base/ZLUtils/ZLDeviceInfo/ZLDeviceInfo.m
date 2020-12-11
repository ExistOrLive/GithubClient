//
//  ZLDeviceInfo.m
//  ZLGitHubClient
//
//  Created by ZM on 2019/12/19.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLDeviceInfo.h"
#import <sys/utsname.h>

@implementation ZLDeviceInfo

+ (NSString *) getDeviceSystemVersion{
    NSString *deviceSystemVersion = [NSString stringWithFormat:@"%@%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    return deviceSystemVersion;
}

+ (NSString *) getDeviceModel{
    
    /**
     *  ref : https://github.com/pluwen/Apple-Device-Model-list
     * */
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10.4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE 2";
    if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    
    // iPad
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad6,11"]) return @"iPad 5";
    if ([platform isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([platform isEqualToString:@"iPad7,5"]) return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,6"]) return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,11"]) return @"iPad 7";
    if ([platform isEqualToString:@"iPad7,12"]) return @"iPad 7";
    if ([platform isEqualToString:@"iPad11,6"]) return @"iPad 8";
    if ([platform isEqualToString:@"iPad11,7"]) return @"iPad 8";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad11,3"]) return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad11,4"]) return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad13,1"]) return @"iPad Air 4";
    if ([platform isEqualToString:@"iPad13,2"]) return @"iPad Air 4";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    if ([platform isEqualToString:@"iPad11,1"]) return @"iPad Mini 5";
    if ([platform isEqualToString:@"iPad11,2"]) return @"iPad Mini 5";
    
    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7-inch";
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
    if ([platform isEqualToString:@"iPad7,3"]) return @"iPad Pro 10.5-inch";
    if ([platform isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
    if ([platform isEqualToString:@"iPad8,1"]) return @"iPad Pro 11-inch";
    if ([platform isEqualToString:@"iPad8,2"]) return @"iPad Pro 11-inch";
    if ([platform isEqualToString:@"iPad8,3"]) return @"iPad Pro 11-inch";
    if ([platform isEqualToString:@"iPad8,4"]) return @"iPad Pro 11-inch";
    if ([platform isEqualToString:@"iPad8,9"]) return @"iPad Pro 11-inch 2";
    if ([platform isEqualToString:@"iPad8,10"]) return @"iPad Pro 11-inch 2";
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9-inch";
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
    if ([platform isEqualToString:@"iPad7,1"]) return @"iPad Pro 12.9-inch 2";
    if ([platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([platform isEqualToString:@"iPad8,5"]) return @"iPad Pro 12.9-inch 3";
    if ([platform isEqualToString:@"iPad8,6"]) return @"iPad Pro 12.9-inch 3";
    if ([platform isEqualToString:@"iPad8,7"]) return @"iPad Pro 12.9-inch 3";
    if ([platform isEqualToString:@"iPad8,8"]) return @"iPad Pro 12.9-inch 3";
    if ([platform isEqualToString:@"iPad8,11"]) return @"iPad Pro 12.9-inch 4";
    if ([platform isEqualToString:@"iPad8,12"]) return @"iPad Pro 12.9-inch 4";
    
    // Simulator
    if ([platform isEqualToString:@"i386"]) return @"Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"Simulator";
  
    return platform;
}

+ (NSString *) getAppShortVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return bundleVersion;
}


+ (NSString *) getAppVersion {
    
    NSDictionary * infoDic = [NSBundle mainBundle].infoDictionary;
    NSString * versionStr = [NSString stringWithFormat:@"%@(%@)",infoDic[@"CFBundleShortVersionString"],infoDic[@"CFBundleVersion"]];
    return versionStr;
}

+ (NSString *) getAppName {
    NSDictionary * infoDic = [NSBundle mainBundle].infoDictionary;
    return infoDic[@"CFBundleName"];
}


+ (BOOL)isIpad{
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isIPhone{
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPhone"]) {
        return YES;
    }
    return NO;
}


+ (UIDeviceOrientation) getDeviceOrientation{
    return [UIDevice currentDevice].orientation;
}

@end
