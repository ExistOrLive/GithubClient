//
//  ZLGithubIssueModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/11.
//  Copyright © 2020 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLGithubUserBriefModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZLGithubIssueState) {
    ZLGithubIssueState_Open,
    ZLGithubIssueState_Closed
};

@interface ZLGithubLabelModel : ZLBaseObject

@property(nonatomic, strong) NSString * url;

@property(nonatomic, strong) NSString * name;

@property(nonatomic, strong) NSString * color;

@property(nonatomic, strong) NSString * desc;

@property(nonatomic, assign) BOOL isDefault;

@end


@interface ZLGithubMilestoneModel : ZLBaseObject

@property(nonatomic, strong) NSString * url;

@property(nonatomic, assign) NSUInteger number;

@property(nonatomic, strong) NSString * title;

@property(nonatomic, strong) NSString * desc;

@property(nonatomic, strong) NSString * state;                        // open closed

@property(nonatomic, strong, nullable) NSDate * due_on;


@property(nonatomic, strong) ZLGithubUserBriefModel *creator;

@property(nonatomic, assign) NSUInteger open_issues;

@property(nonatomic, assign) NSUInteger closed_issues;

@property(nonatomic, strong, nullable) NSDate * created_at;

@property(nonatomic, strong, nullable) NSDate * updated_at;

@property(nonatomic, strong, nullable) NSDate * closed_at;        // 关闭时间


@end




@interface ZLGithubIssueModel : ZLBaseObject

@property(nonatomic, strong) NSString * id_issue;

@property(nonatomic, strong) NSString * html_url;

@property(nonatomic, strong) NSString * repository_url;

@property(nonatomic, strong) NSString * comments_url;

@property(nonatomic, strong) NSString * labels_url;

@property(nonatomic, strong) NSString * url;

@property(nonatomic, strong) NSString * node_id;


@property(nonatomic, assign) NSUInteger number;                       // 编号

@property(nonatomic, strong) NSString * title;                        //  标题

@property(nonatomic, strong) NSString * body;                         //  内容

@property(nonatomic, assign) ZLGithubIssueState state;                        // open closed

@property(nonatomic, strong) NSString * author_association;           // OWNER NONE

@property(nonatomic, assign) BOOL locked;                             //

@property(nonatomic, assign) NSUInteger comments;                     // 评论数

@property(nonatomic, strong) NSArray<ZLGithubLabelModel *> *labels;   // 标签

@property(nonatomic, strong) ZLGithubMilestoneModel *milestone;      // milestone

@property(nonatomic, strong) ZLGithubUserBriefModel *user;

@property(nonatomic, strong) ZLGithubUserBriefModel *close_by;


@property(nonatomic, strong, nullable) NSDate * created_at;

@property(nonatomic, strong, nullable) NSDate * updated_at;

@property(nonatomic, strong, nullable) NSDate * closed_at;        // 关闭时间

@end

NS_ASSUME_NONNULL_END
