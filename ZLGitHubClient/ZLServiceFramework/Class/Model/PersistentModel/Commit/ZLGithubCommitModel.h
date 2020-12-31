//
//  ZLGithubCommitModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseObject.h"
@class ZLGithubUserBriefModel;

NS_ASSUME_NONNULL_BEGIN
/**
 {
   "url": "https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e",
   "sha": "6dcb09b5b57875f334f61aebed695e2e4193db5e",
   "node_id": "MDY6Q29tbWl0NmRjYjA5YjViNTc4NzVmMzM0ZjYxYWViZWQ2OTVlMmU0MTkzZGI1ZQ==",
   "html_url": "https://github.com/octocat/Hello-World/commit/6dcb09b5b57875f334f61aebed695e2e4193db5e",
   "comments_url": "https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e/comments",
   "commit": {
     "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e",
     "author": {
       "name": "Monalisa Octocat",
       "email": "support@github.com",
       "date": "2011-04-14T16:00:49Z"
     },
     "committer": {
       "name": "Monalisa Octocat",
       "email": "support@github.com",
       "date": "2011-04-14T16:00:49Z"
     },
     "message": "Fix all the bugs",
     "tree": {
       "url": "https://api.github.com/repos/octocat/Hello-World/tree/6dcb09b5b57875f334f61aebed695e2e4193db5e",
       "sha": "6dcb09b5b57875f334f61aebed695e2e4193db5e"
     },
     "comment_count": 0,
     "verification": {
       "verified": false,
       "reason": "unsigned",
       "signature": null,
       "payload": null
     }
   },
   "author": {
     "login": "octocat",
     "id": 1,
     "node_id": "MDQ6VXNlcjE=",
     "avatar_url": "https://github.com/images/error/octocat_happy.gif",
     "gravatar_id": "",
     "url": "https://api.github.com/users/octocat",
     "html_url": "https://github.com/octocat",
     "followers_url": "https://api.github.com/users/octocat/followers",
     "following_url": "https://api.github.com/users/octocat/following{/other_user}",
     "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
     "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
     "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
     "organizations_url": "https://api.github.com/users/octocat/orgs",
     "repos_url": "https://api.github.com/users/octocat/repos",
     "events_url": "https://api.github.com/users/octocat/events{/privacy}",
     "received_events_url": "https://api.github.com/users/octocat/received_events",
     "type": "User",
     "site_admin": false
   },
   "committer": {
     "login": "octocat",
     "id": 1,
     "node_id": "MDQ6VXNlcjE=",
     "avatar_url": "https://github.com/images/error/octocat_happy.gif",
     "gravatar_id": "",
     "url": "https://api.github.com/users/octocat",
     "html_url": "https://github.com/octocat",
     "followers_url": "https://api.github.com/users/octocat/followers",
     "following_url": "https://api.github.com/users/octocat/following{/other_user}",
     "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
     "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
     "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
     "organizations_url": "https://api.github.com/users/octocat/orgs",
     "repos_url": "https://api.github.com/users/octocat/repos",
     "events_url": "https://api.github.com/users/octocat/events{/privacy}",
     "received_events_url": "https://api.github.com/users/octocat/received_events",
     "type": "User",
     "site_admin": false
   },
   "parents": [
     {
       "url": "https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e",
       "sha": "6dcb09b5b57875f334f61aebed695e2e4193db5e"
     }
   ],
   "stats": {
     "additions": 104,
     "deletions": 4,
     "total": 108
   },
   "files": [
     {
       "filename": "file1.txt",
       "additions": 10,
       "deletions": 2,
       "changes": 12,
       "status": "modified",
       "raw_url": "https://github.com/octocat/Hello-World/raw/7ca483543807a51b6079e54ac4cc392bc29ae284/file1.txt",
       "blob_url": "https://github.com/octocat/Hello-World/blob/7ca483543807a51b6079e54ac4cc392bc29ae284/file1.txt",
       "patch": "@@ -29,7 +29,7 @@\n....."
     }
   ]
 }
 
 
 https://developer.github.com/v3/repos/commits/
 */

@interface ZLGithubFileModel : ZLBaseObject

@property (nonatomic,strong) NSString * filename;

@property (nonatomic,assign) int additions;

@property (nonatomic,assign) int deletions;

@property (nonatomic,assign) int changes;

@property (nonatomic,strong) NSString * status;

@property (nonatomic, strong) NSString * raw_url;

@property (nonatomic, strong) NSString * blob_url;

@property (nonatomic, strong) NSString * patch;

@end



@interface ZLGithubCommitModel : ZLBaseObject

@property(nonatomic, strong) NSString * html_url;

@property(nonatomic, strong) NSString * __nullable url;

@property(nonatomic, strong) NSString * sha;                                // 提交的散列值

@property(nonatomic, strong) NSString * commit_message;

@property(nonatomic, strong, nullable) NSDate * commit_at;                           // 提交时间

@property(nonatomic, strong) NSString * comments_url;

@property(nonatomic, assign) int commit_comment_count;

@property(nonatomic, assign) BOOL commit_verification_verified;

@property(nonatomic, strong) ZLGithubUserBriefModel * author;               // 所有者
 
@property(nonatomic, strong) ZLGithubUserBriefModel * committer;            // 提交者

@property(nonatomic, strong) NSArray<ZLGithubFileModel *> * files;          // 修改的文件

@end

NS_ASSUME_NONNULL_END
