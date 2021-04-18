//
//  ZLAdditionServiceHeader.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLAdditionServiceHeader_h
#define ZLAdditionServiceHeader_h

#import "ZLBaseServiceModel.h"

#pragma mark - NotificationName

static const NSNotificationName _Nonnull ZLGithubConfigUpdate_Notification = @"ZLGithubConfigUpdate_Notification";


@protocol ZLAdditionServiceModuleProtocol <ZLBaseServiceModuleProtocol>


@property(nonatomic,readonly,strong) ZLGithubConfigModel* _Nullable config;

@property(nonatomic,readonly,strong) NSArray<NSString *>* _Nullable githubLanguageList;





/**
 * @brief 获取language列表
 *
 **/
- (NSArray<NSString *> * _Nullable) getLanguagesWithSerialNumber:(NSString * _Nonnull) serialNumber
                                                  completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;



/**
* @brief 将代码渲染为markdown
*
**/

- (void) renderCodeToMarkdownWithCode:(NSString * _Nonnull) code
                         serialNumber:(NSString * _Nonnull) serialNumber
                       completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;



#pragma mark - config

/**
 * @brief 获取功能配置
 *
 **/

- (void) getGithubClientConfig:(NSString * _Nonnull) serialNumber;





@end


#endif /* ZLAdditionServiceHeader_h */
