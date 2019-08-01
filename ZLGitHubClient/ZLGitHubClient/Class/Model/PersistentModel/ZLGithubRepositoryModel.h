//
//  ZLGithubRepositoryModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/29.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZLGithubUserBriefModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZLGithubRepositoryModel : NSObject

@property(strong, nonatomic) NSString * id_Repo;
@property(strong, nonatomic) NSString * node_id;
@property(strong, nonatomic) NSString * html_url;                               //！web地址
@property(strong, nonatomic) NSString * url;                                    //！url

@property(strong, nonatomic) NSString * name;
@property(strong, nonatomic) NSString * full_name;
@property(strong, nonatomic) NSString * desc_Repo;
@property(assign, nonatomic, getter=isPriva) BOOL priva;                        //! 是否为私有库
@property(strong, nonatomic) NSDate * updated_at;                               //! 上一次更新时间
@property(strong, nonatomic) NSDate * created_at;                               //! 创建时间
@property(strong, nonatomic) NSDate * pushed_at;                                //！上一次提交时间
@property(strong, nonatomic) NSString * language;                               //！仓库语言
@property(assign, nonatomic) NSUInteger size;                                   //！仓库大小
@property(strong, nonatomic) NSString * default_branch;                         //！默认分支
@property(assign, nonatomic) NSUInteger score;                                  //! 得分

@property(assign, nonatomic) NSUInteger open_issues_count;                      //！issue公开问题数
@property(assign, nonatomic) NSUInteger stargazers_count;                       //! star订阅数
@property(assign, nonatomic) NSUInteger watchers_count;                         //! watch关注数
@property(assign, nonatomic) NSUInteger forks_count;                            //! fork拷贝数         这四个属性不准确，尽量用底下四个
@property(assign, nonatomic) NSUInteger open_issues;                            //！issue公开问题数
@property(assign, nonatomic) NSUInteger subscribers_count;                      //! star订阅数
@property(assign, nonatomic) NSUInteger watchers;                               //! watch关注数
@property(assign, nonatomic) NSUInteger forks;                                  //! fork拷贝数

@property(strong, nonatomic) ZLGithubUserBriefModel * owner;                    //! 仓库拥有者


@end

NS_ASSUME_NONNULL_END
