//
//  ZLGithubAPI.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/29.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLGithubAPI_h
#define ZLGithubAPI_h

#define OAuthState          @"31415"
#define OAuthScope          @"user,repo,gist,notifications,read:org,workflow"
#define MyClientID          @"fbd34c5a34be72f66c35"
#define MyClientSecret      @"02e5eb8a2805f6492d3d1ff7c5a618d73e1edb35"


#pragma mark - media type

#define MediaTypeJson @"application/vnd.github.v3+json"
#define MediaTypeTextJson @"application/vnd.github.v3.text+json"
#define MediaTypeHTMLJson @"application/vnd.github.v3.html+json"            // html
#define MediaTypeFullJson @"application/vnd.github.v3.full+json"
#define MediaTypeRawJson @"application/vnd.github.v3.raw+json"              // 元二进制数据

#pragma mark - OAuth 相关接口

#define GitHubMainURL       @"https://github.com"

#define OAuthAuthorizeURL       @"https://github.com/login/oauth/authorize"
#define OAuthLoginURL           @"https://github.com/login"
#define OAuthLogoutURL          @"https://github.com/logout"
#define OAuthHomePageURL        @"https://github.com/organizations/MengAndJie/Home"
#define OAuthCallBackURL        @"https://github.com/organizations/MengAndJie/CallBack"
#define OAuthAccessTokenURL     @"https://github.com/login/oauth/access_token"


#pragma mark - github业务接口

#define GitHubAPIURL @"https://api.github.com"

#pragma mark -

#define currenUserUrl           @"/user"                            // 当前登陆用户的信息
#define searchUserUrl           @"/search/users"

#define githubUserInfo                @"/users/"
#define orgInfo                 @"/orgs/"

#pragma mark event

#define eventsUrl               @"/events"                          // 所有的公共事件
#define userEventUrl            @"/users/%@/events"                 // 某个用户的事件(如果为当前登陆用户则会包含私密事件)
#define userReceivedEventUrl    @"/users/%@/received_events"        // 某个用户接受的事件(关注的仓库或用户的事件)


#pragma mark repositories

#define currentUserRepoUrl      @"/user/repos"                       // 当前用户的Repo 包括private
#define userRepoUrl             @"/users/%@/repos"                   // 某用户的Repos 不包括private
#define searchRepoUrl           @"/search/repositories"              // 根据关键字搜索repo
#define reposUrl                @"/repos"                            // 获取某个Repo的信息

#define reposReadMeUrl          @"/repos/%@/readme"                  // 获取某个repo的readme信息

#define repoPullRequestUrl      @"/repos/%@/pulls"                   // 获取pullrequest

#define repoCommitsUrl          @"/repos/%@/commits"                 // 获取commits

#define repoBranchedUrl         @"/repos/%@/branches"                // 获取branch

#define repoContentsUrl         @"/repos/%@/contents/%@"                // 获取代码内容

#define repoContributorsUrl         @"/repos/%@/contributors"           // 获取repo的贡献者


#pragma mark starred

#define currentUserStarredURL   @"/user/starred"                    // 当前用户标星的repo
#define userStarredURL          @"/users/%@/starred"                // 某个用户标星的repo


#pragma mark gists

#define gistUrl                 @"/gists"                       // 当前用户的gists 包括private
#define userGistUrl             @"/users/%@/gists"                   // 某用户的gists 不包括private

#pragma mark following

#define userFollowing             @"/user/following/%@"                // get 是否follow PUT follow delete unfollow

#define followingUrl                 @"/user/following"                       // 当前用户的following
#define userfollowingUrl             @"/users/%@/following"                   // 某用户的following

#pragma mark followers

#define followersUrl                 @"/user/followers"                       // 当前用户的followers
#define userfollowersUrl             @"/users/%@/followers"                   // 某用户的followers


#pragma mark issues

#define repoIssuesUrl              @"/repos/%@/issues"                  // get 获取repos的issues

#define createIssueUrl                @"/repos/%@/issues"                  // post 获取repos的issues

#define updateIssueUrl                 @"/repos/%@/issues/%@"               // patch

#pragma mark language

#define languageUrl              @"/languages"


#pragma mark subscription / watch

#define repoSubscription      @"/repos/%@/subscription"            // get 是否订阅某个repo put订阅 delete 解除订阅

#define repoSubscribers       @"/repos/%@/subscribers"            // repo 的 订阅者

#pragma mark star

#define repoStarred     @"/user/starred/%@"            // get 是否标星某个repo put标星 delete 解除标星


#define repoStargazers  @"/repos/%@/stargazers"       // repo的 标星用户


#pragma mark fork

#define repoForks @"/repos/%@/forks"      //  get 获取repo的 forks / post fork repo

#pragma mark repoLanguages

#define repoLanguages @"/repos/%@/languages"    


#pragma mark notification

#define NotificationsURL @"/notifications"

#define NotificationThreadsURL @"/notifications/threads/%@"


#pragma mark action

#define workflowURL          @"/repos/%@/actions/workflows"
#define workflowRunsURL      @"/repos/%@/actions/workflows/%@/runs"
#define rerunworkflowRunsURL       @"/repos/%@/actions/runs/%@/rerun"
#define cancelworkflowRunsURL      @"/repos/%@/actions/runs/%@/cancel"
#define workflowRunsLogsURL      @"/repos/%@/actions/runs/%@/logs"

#pragma mark markdown

#define markdownURL @"/markdown"

#pragma mark block

#define blockedUsersURL        @"/user/blocks"                        // 屏蔽的用户列表
#define blockUserURL        @"/user/blocks/%@"                     // PUT 屏蔽某用户/ get 检查是否屏蔽某用户 取消屏蔽


static const NSNotificationName ZLGithubTokenInvalid_Notification = @"ZLGithubTokenInvalid_Notification";







#endif /* ZLGithubAPI_h */
