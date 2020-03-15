//
//  ZLRepoServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/24.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"

@class ZLOperationResultModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZLRepoServiceModel : ZLBaseServiceModel

+ (instancetype) sharedServiceModel;

/**
 * @brief 根据repo full name 获取仓库信息
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepoInfoWithFullName:(NSString *) fullName
                     serialNumber:(NSString *) serialNumber;

/**
 * @brief 根据repo full name 获取仓库信息
 * @param ownerName octocat
 * @param repoName Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepoInfoWithOwnerName:(NSString *) ownerName
                     withrepoName:(NSString *) repoName
                    serialNumber:(NSString *) serialNumber;


/**
* @brief 根据repo readMe 地址
* @param fullName octocat/Hello-World
* @param serialNumber 流水号
**/
- (void) getRepoReadMeInfoWithFullName:(NSString *) fullName
                          serialNumber:(NSString *) serialNumber
                        completeHandle:(void(^)(ZLOperationResultModel *)) handle;


/**
* @brief 根据repo 获取pullrequest
* @param fullName octocat/Hello-World
* @param serialNumber 流水号
**/

- (void) getRepoPullRequestWithFullName:(NSString *) fullName
                                  state:(NSString *) state
                           serialNumber:(NSString *) serialNumber
                         completeHandle:(void(^)(ZLOperationResultModel *)) handle;




@end

NS_ASSUME_NONNULL_END
