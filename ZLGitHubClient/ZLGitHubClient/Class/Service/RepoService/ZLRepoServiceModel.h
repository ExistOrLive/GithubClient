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
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/

- (void) getRepoInfoWithFullName:(NSString *) fullName
                    serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^)(ZLOperationResultModel *)) handle;


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
                                branch:(NSString * __nullable) branch
                                isHTML:(BOOL) isHTML
                          serialNumber:(NSString *) serialNumber
                        completeHandle:(void(^)(ZLOperationResultModel *)) handle;

/**
 * @brief 根据repo 获取pullrequest
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/

- (void) getRepoPullRequestWithFullName:(NSString *) fullName
                                  state:(NSString *) state
                               per_page:(NSInteger)per_page
                                   page:(NSInteger)page
                           serialNumber:(NSString *) serialNumber
                         completeHandle:(void(^)(ZLOperationResultModel *)) handle;


/**
 * @brief 根据repo 获取commit
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/

- (void) getRepoCommitWithFullName:(NSString *) fullName
                            branch:(NSString * __nullable) branch
                             until:(NSDate * __nullable) untilDate
                             since:(NSDate * __nullable) sinceDate
                      serialNumber:(NSString *) serialNumber
                    completeHandle:(void(^)(ZLOperationResultModel *)) handle;


/**
 * @brief 根据repo 获取branch
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryBranchesInfoWithFullName:(NSString *) fullName
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle;





/**
 * @brief 根据repo fullname获取 贡献者
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryContributorsWithFullName:(NSString *) fullName
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle;


#pragma mark - Issues

/**
 * @brief 根据repo fullname获取 issues
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryIssuesWithFullName:(NSString *) fullName
                                   state:(NSString *) state
                                per_page:(NSInteger) per_page
                                    page:(NSInteger) page
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle;



/**
 * @brief 根据repo fullname 创建 issues
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) createIssueWithFullName:(NSString *) fullName
                           title:(NSString *) title
                            body:(NSString * __nullable) body
                          labels:(NSArray * __nullable) labels
                       assignees:(NSArray * __nullable) assignees
                    serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^)(ZLOperationResultModel *)) handle;


#pragma mark - subscription

- (void) watchRepoWithFullName:(NSString *) fullName
                  serialNumber:(NSString *) serialNumber
                completeHandle:(void(^)(ZLOperationResultModel *)) handle;

- (void) unwatchRepoWithFullName:(NSString *) fullName
                    serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^)(ZLOperationResultModel *)) handle;

- (void) getRepoWatchStatusWithFullName:(NSString *) fullName
                           serialNumber:(NSString *) serialNumber
                         completeHandle:(void(^)(ZLOperationResultModel *)) handle;

- (void) getRepoWatchersWithFullName:(NSString *) fullName
                        serialNumber:(NSString *) serialNumber
                            per_page:(NSInteger) per_page
                                page:(NSInteger) page
                      completeHandle:(void(^)(ZLOperationResultModel *)) handle;


#pragma mark - top repo

- (void) getTopReposWithAfterCursor:(NSString * __nullable) after
                       serialNumber:(NSString *) serialNumber
                     completeHandle:(void(^)(ZLOperationResultModel *)) handle;


#pragma mark - star repo

- (void) starRepoWithFullName:(NSString *) fullName
                  serialNumber:(NSString *) serialNumber
                completeHandle:(void(^)(ZLOperationResultModel *)) handle;

- (void) unstarRepoWithFullName:(NSString *) fullName
                    serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^)(ZLOperationResultModel *)) handle;

- (void) getRepoStarStatusWithFullName:(NSString *) fullName
                           serialNumber:(NSString *) serialNumber
                         completeHandle:(void(^)(ZLOperationResultModel *)) handle;

- (void) getRepoStargazersWithFullName:(NSString *) fullName
                          serialNumber:(NSString *) serialNumber
                              per_page:(NSInteger) per_page
                                  page:(NSInteger) page
                        completeHandle:(void(^)(ZLOperationResultModel *)) handle;



#pragma mark - fork

- (void) forkRepositoryWithFullName:(NSString *) fullName
                                org:(NSString * __nullable) org
                       serialNumber:(NSString *) serialNumber
                     completeHandle:(void(^)(ZLOperationResultModel *)) handle;

- (void) getRepoForksWithFullName:(NSString *) fullName
                     serialNumber:(NSString *) serialNumber
                         per_page:(NSInteger) per_page
                             page:(NSInteger) page
                   completeHandle:(void(^)(ZLOperationResultModel *)) handle;


#pragma mark - languages

- (void) getRepoLanguagesWithFullName:(NSString *) fullName
                     serialNumber:(NSString *) serialNumber
                       completeHandle:(void(^)(ZLOperationResultModel *)) handle;


#pragma mark - actions

- (void) getRepoWorkflowsWithFullName:(NSString *) fullName
                             per_page:(NSInteger) per_page
                                 page:(NSInteger) page
                         serialNumber:(NSString *) serialNumber
                       completeHandle:(void(^)(ZLOperationResultModel *)) handle;



- (void) getRepoWorkflowRunsWithFullName:(NSString *) fullName
                              workflowId:(NSString *) workflowId
                                per_page:(NSInteger) per_page
                                    page:(NSInteger) page
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle;

- (void) rerunRepoWorkflowRunWithFullName:(NSString *) fullName
                            workflowRunId:(NSString *) workflowRunId
                             serialNumber:(NSString *) serialNumber
                           completeHandle:(void(^)(ZLOperationResultModel *)) handle;

- (void) cancelRepoWorkflowRunWithFullName:(NSString *) fullName
                             workflowRunId:(NSString *) workflowRunId
                              serialNumber:(NSString *) serialNumber
                            completeHandle:(void(^)(ZLOperationResultModel *)) handle;

- (void) getRepoWorkflowRunLogWithFullName:(NSString *) fullName
                             workflowRunId:(NSString *) workflowRunId
                              serialNumber:(NSString *) serialNumber
                            completeHandle:(void(^)(ZLOperationResultModel *)) handle;


#pragma mark - FileContent


/**
 * @brief 根据repo fullname获取 内容
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryContentsInfoWithFullName:(NSString *) fullName
                                          path:(NSString *) path
                                        branch:(NSString *) branch
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle;


- (void) getRepositoryFileInfoWithFullName:(NSString *) fullName
                                      path:(NSString *) path
                                    branch:(NSString *) branch
                              serialNumber:(NSString *) serialNumber
                            completeHandle:(void(^)(ZLOperationResultModel *)) handle;


- (void) getRepositoryFileHTMLInfoWithFullName:(NSString *) fullName
                                          path:(NSString *) path
                                        branch:(NSString *) branch
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle;


- (void) getRepositoryFileRawInfoWithFullName:(NSString *) fullName
                                         path:(NSString *) path
                                       branch:(NSString *) branch
                                 serialNumber:(NSString *) serialNumber
                               completeHandle:(void(^)(ZLOperationResultModel *)) handle;


- (void) getRepositoryFileContentWithHTMLURL:(NSString *) htmlURL
                                      branch:(NSString *) branch
                                serialNumber:(NSString *) serialNumber
                              completeHandle:(void(^)(ZLOperationResultModel *)) handle;


@end

NS_ASSUME_NONNULL_END
