//
//  ZLLanguageModuleProtocol.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/30.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLLanguageModuleProtocol_h
#define ZLLanguageModuleProtocol_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,ZLLanguageType) {
    ZLLanguageType_English = 0,
    ZLLanguageType_SimpleChinese
};

@protocol ZLLanguageModuleProtocol <NSObject>

- (NSString *)localizedWithKey:(NSString *)key;

- (ZLLanguageType) currentLanguageType;

- (void) setLanguageType:(ZLLanguageType) type error:(NSError **) error;

@end

#endif /* ZLLanguageModuleProtocol_h */
