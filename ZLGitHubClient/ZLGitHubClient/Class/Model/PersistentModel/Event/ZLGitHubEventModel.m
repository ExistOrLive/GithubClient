//
//  ZLGitHubEventModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/29.
//  Copyright © 2019 ZM. All rights reserved.
//

/** metal json
{
  "id": "10935002618",
  "type": "PushEvent",
  "actor": {
    "id": 20825931,
    "login": "Zeman-Dalibor",
    "display_login": "Zeman-Dalibor",
    "gravatar_id": "",
    "url": "https://api.github.com/users/Zeman-Dalibor",
    "avatar_url": "https://avatars.githubusercontent.com/u/20825931?"
  },
  "repo": {
    "id": 210201187,
    "name": "Zeman-Dalibor/DotNetLibraryExporter",
    "url": "https://api.github.com/repos/Zeman-Dalibor/DotNetLibraryExporter"
  },
  "payload": {
    "push_id": 4313766002,
    "size": 1,
    "distinct_size": 1,
    "ref": "refs/heads/master",
    "head": "14218504bc53ea7ef3a24ee83a19a0db66b294de",
    "before": "566c319033511f1e8c36f599d4fa5835ee67f793",
    "commits": [
      {
        "sha": "14218504bc53ea7ef3a24ee83a19a0db66b294de",
        "author": {
          "email": "Zeman-Dalibor@users.noreply.github.com",
          "name": "Dalibor Zeman"
        },
        "message": "Update README.md",
        "distinct": true,
        "url": "https://api.github.com/repos/Zeman-Dalibor/DotNetLibraryExporter/commits/14218504bc53ea7ef3a24ee83a19a0db66b294de"
      }
    ]
  },
  "public": true,
  "created_at": "2019-11-24T15:29:10Z"
}

 */

#import "ZLGitHubEventModel.h"
#import <MJExtension/MJExtension.h>

@implementation ZLActorBriefInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_eventActor":@"id"};
}

@end


@implementation ZLRepoBriefInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_repo":@"id"};
}

@end

@implementation ZLCommitInfoModel

@end

//PullEventPayload
@implementation ZLPushEventPayloadModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"commits":[ZLCommitInfoModel class]};
}

@end

//WatchEventPayload
@implementation ZLWatchEventPayloadModel

@end

//CreateEventPayload
@implementation ZLCreateEventPayloadModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if([property.name isEqualToString:@"ref_type"])
    {
        if([oldValue isEqualToString:@"repository"])
        {
            return [NSNumber numberWithInteger:ZLReferenceType_Repository];
        }
        else
        {
            return [NSNumber numberWithInteger:ZLReferenceType_Tag];
        }
    }
    return oldValue;
}

@end

@implementation ZLGitHubOrgModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_org":@"id"};
}

@end


@implementation ZLGithubEventModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"eventId":@"id",
             @"pub":@"public"
             };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if([property.name isEqualToString:@"created_at"] ||
       property.type.typeClass == [NSDate class])
    {
        // String 转为 Date
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormatter dateFromString:oldValue];
    }
    else if([property.name isEqualToString:@"type"])
    {
        if([oldValue isEqualToString:@"CreateEvent"])
        {
            return [NSNumber numberWithInteger:ZLGithubEventType_CreateEvent];
        }
        else if([oldValue isEqualToString:@"PushEvent"])
        {
           return [NSNumber numberWithInteger:ZLGithubEventType_PushEvent];
        }
        else if([oldValue isEqualToString:@"PullRequestEvent"])
        {
           return [NSNumber numberWithInteger:ZLGithubEventType_PullRequestEvent];
        }
        else if([oldValue isEqualToString:@"WatchEvent"])
        {
           return [NSNumber numberWithInteger:ZLGithubEventType_WatchEvent];
        }
        else
        {
           return [NSNumber numberWithInteger:ZLGithubEventType_UnKnown];
        }
    }
    
    return oldValue;
}


@end
