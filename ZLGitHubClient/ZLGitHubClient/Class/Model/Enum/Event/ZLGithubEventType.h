//
//  ZLGithbEventType.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/11/25.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLGithbEventType_h
#define ZLGithbEventType_h

// https://docs.github.com/en/developers/webhooks-and-events/github-event-types
typedef NS_ENUM(NSInteger, ZLGithubEventType)
{
    ZLGithubEventType_CheckRunEvent,
    ZLGithubEventType_CheckSuiteEvent,
    ZLGithubEventType_CommitCommentEvent,                  // 对某次提交评论 #commitcommentevent
    ZLGithubEventType_ContentReferenceEvent,
    ZLGithubEventType_CreateEvent,
    ZLGithubEventType_DeleteEvent,
    ZLGithubEventType_DeployKeyEvent,
    ZLGithubEventType_DeploymentEvent,
    ZLGithubEventType_DeploymentStatusEvent,
    ZLGithubEventType_DownloadEvent,
    ZLGithubEventType_FollowEvent,
    ZLGithubEventType_ForkEvent,
    ZLGithubEventType_ForkApplyEvent,
    ZLGithubEventType_GitHubAppAuthorizationEvent,
    ZLGithubEventType_GistEvent,
    ZLGithubEventType_GollumEvent,
    ZLGithubEventType_InstallationEvent,
    ZLGithubEventType_InstallationRepositoriesEvent,
    ZLGithubEventType_IssueCommentEvent,
    ZLGithubEventType_IssuesEvent,
    ZLGithubEventType_LabelEvent,
    ZLGithubEventType_MarketplacePurchaseEvent,
    ZLGithubEventType_MemberEvent,
    ZLGithubEventType_MembershipEvent,
    ZLGithubEventType_MetaEvent,
    ZLGithubEventType_MilestoneEvent,
    ZLGithubEventType_OrganizationEvent,
    ZLGithubEventType_OrgBlockEvent,
    ZLGithubEventType_PackageEvent,
    ZLGithubEventType_PageBuildEvent,
    ZLGithubEventType_ProjectCardEvent,
    ZLGithubEventType_ProjectColumnEvent,
    ZLGithubEventType_ProjectEvent,
    ZLGithubEventType_PublicEvent,
    ZLGithubEventType_PullRequestEvent,
    ZLGithubEventType_PullRequestReviewEvent,
    ZLGithubEventType_PullRequestReviewCommentEvent,
    ZLGithubEventType_PushEvent,
    ZLGithubEventType_ReleaseEvent,
    ZLGithubEventType_RepositoryDispatchEvent,
    ZLGithubEventType_RepositoryEvent,
    ZLGithubEventType_RepositoryImportEvent,
    ZLGithubEventType_RepositoryVulnerabilityAlertEvent,
    ZLGithubEventType_SecurityAdvisoryEvent,
    ZLGithubEventType_StarEvent,
    ZLGithubEventType_StatusEvent,
    ZLGithubEventType_TeamEvent,
    ZLGithubEventType_TeamAddEvent,
    ZLGithubEventType_WatchEvent,
    ZLGithubEventType_UnKnown
};


#endif /* ZLGithbEventType_h */
