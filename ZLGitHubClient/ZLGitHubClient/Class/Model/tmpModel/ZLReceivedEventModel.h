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
    ZLReceivedEventType_PushEvent,
    ZLReceivedEventType_PullRequestEvent
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

@interface ZLPayloadModel : NSObject

@property (nonatomic, assign) NSInteger push_id;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger distinct_size;
@property (nonatomic, strong) NSString *ref;
@property (nonatomic, strong) NSString *head;
@property (nonatomic, strong) NSString *before;
@property (nonatomic, strong) id commits;

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
