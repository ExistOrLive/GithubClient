//
//  ZLReceivedEventResultModel.h
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZLReceivedEventType)
{
    ZLReceivedEventType_CreateEvent,
    ZLReceivedEventType_PushEvent,
    ZLReceivedEventType_PullRequestEvent,
    ZLReceivedEventType_WatchEvent,
    ZLReceivedEventType_UnKnown
};

typedef NS_ENUM(NSInteger, ZLReferenceType)
{
    ZLReferenceType_Repository,
    ZLReferenceType_Tag
};

@interface ZLEventActorModel : NSObject

@property (nonatomic, assign) NSInteger id_eventActor;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *display_login;
@property (nonatomic, strong) NSString * _Nullable gravatar_id;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *avatar_url;

@end

@interface ZLRepoBriefInfoModel : NSObject

@property (nonatomic, assign) NSInteger id_repo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;

@end

@interface ZLCommitInfoModel : NSObject

@property (nonatomic, strong) NSString *sha;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) BOOL distinct;
@property (nonatomic, assign) NSString *url;

@end

//PullEventPayload
@interface ZLPayloadModel : NSObject

@property (nonatomic, assign) NSInteger push_id;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger distinct_size;
@property (nonatomic, strong) NSString *ref;
@property (nonatomic, strong) NSString *head;
@property (nonatomic, strong) NSString *before;
@property (nonatomic, strong) id commits;

@end

//WatchEventPayload
@interface ZLWatchEventPayloadModel : NSObject

@property (nonatomic, strong) NSString *action;     //! 目前只有stared

@end

//CreateEventPayload
@interface ZLCreateEventPayloadModel : NSObject

@property (nonatomic, strong) NSString *ref;             //! 提交的sha
@property (nonatomic, assign) ZLReferenceType ref_type;  //! 目前有两种类型：repository、tag
@property (nonatomic, strong) NSString *master_branch;   //! 默认是master
//@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *pusher_type;

@end


@interface ZLGitHubOrgModel : NSObject

@property (nonatomic, assign) NSInteger id_org;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *gravatar_id;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *avatar_url;

@end


@interface ZLReceivedEventModel : NSObject

@property (nonatomic, strong) NSString *id_eventRecv;
@property (nonatomic, assign) ZLReceivedEventType type;
@property (nonatomic, strong) ZLEventActorModel *actor;
@property (nonatomic, strong) ZLRepoBriefInfoModel *repo;
@property (nonatomic, strong) id payload;
@property (nonatomic, assign, getter=isPub) BOOL pub;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) ZLGitHubOrgModel *org;

@end

NS_ASSUME_NONNULL_END
