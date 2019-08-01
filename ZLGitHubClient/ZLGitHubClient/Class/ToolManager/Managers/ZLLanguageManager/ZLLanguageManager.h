//
//  ZLLanguageManager.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/30.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLLanguageModuleProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 国际化管理，实现字符串的国际化，修改语言类型，语言修改后发出全局的通知
 *
 **/
@interface ZLLanguageManager : NSObject <ZLLanguageModuleProtocol>



@end

NS_ASSUME_NONNULL_END
