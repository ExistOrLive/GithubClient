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

@implementation ZLGitHubOrgModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_org":@"id"};
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



@implementation ZLCommitCommentBriefInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"id_CommitComment":@"id"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if([property.name isEqualToString:@"created_at"] ||
       [property.name isEqualToString:@"updated_at"] ||
       property.type.typeClass == [NSDate class])
    {
        // String 转为 Date
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormatter dateFromString:oldValue];
    }    
    return oldValue;
}

@end


@implementation ZLWikiPageBriefInfoModel

@end

@implementation ZLIssueCommentBriefInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"id_IssueComment":@"id"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if([property.name isEqualToString:@"created_at"] ||
       [property.name isEqualToString:@"updated_at"] ||
       property.type.typeClass == [NSDate class])
    {
        // String 转为 Date
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormatter dateFromString:oldValue];
    }
    return oldValue;
}


@end


@implementation ZLReleaseBriefInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"id_Release":@"id"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if([property.name isEqualToString:@"created_at"] ||
       [property.name isEqualToString:@"published_at"] ||
       property.type.typeClass == [NSDate class])
    {
        // String 转为 Date
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormatter dateFromString:oldValue];
    }
    return oldValue;
}

@end




#pragma mark - Event Payload

//CommitCommentEvent
@implementation ZLCommitCommentEventPayloadModel

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

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description"};
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if([property.name isEqualToString:@"ref_type"])
    {
        if([oldValue isEqualToString:@"repository"]){
            return [NSNumber numberWithInteger:ZLReferenceType_Repository];
        } else if([oldValue isEqualToString:@"tag"]){
            return [NSNumber numberWithInteger:ZLReferenceType_Tag];
        } else if([oldValue isEqualToString:@"branch"]) {
            return [NSNumber numberWithInteger:ZLReferenceType_Branch];
        } else {
            return [NSNumber numberWithInteger:ZLReferenceType_unknown];
        }
    }
    return oldValue;
}

@end

@implementation ZLDeleteEventPayloadModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if([property.name isEqualToString:@"ref_type"])
    {
        if([oldValue isEqualToString:@"repository"]){
            return [NSNumber numberWithInteger:ZLReferenceType_Repository];
        } else if([oldValue isEqualToString:@"tag"]){
            return [NSNumber numberWithInteger:ZLReferenceType_Tag];
        } else if([oldValue isEqualToString:@"branch"]) {
            return [NSNumber numberWithInteger:ZLReferenceType_Branch];
        } else {
            return [NSNumber numberWithInteger:ZLReferenceType_unknown];
        }
    }
    return oldValue;
}


@end


// ForkEventPaylod
@implementation ZLForkEventPayloadModel


@end


@implementation ZLGollumEventPayloadModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"pages":[ZLWikiPageBriefInfoModel class]};
}

@end

@implementation ZLIssueCommentEventPayloadModel

@end

@implementation ZLIssueEventPayloadModel

@end

@implementation ZLMemberEventPayloadModel

@end


@implementation ZLPullRequestEventPayloadModel

@end

@implementation ZLPullRequestReviewCommentEventPayloadModel

@end

@implementation ZLReleaseEventPayloadModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"releaseModel":@"release"};
}

@end

#pragma mark -

static NSArray * ZLGithubEventTypeArray = nil;

@implementation ZLGithubEventModel

+ (void)initialize
{
    if (self == [ZLGithubEventModel class]) {
        ZLGithubEventTypeArray = @[@"CheckRunEvent",
            @"CheckSuiteEvent",
            @"CommitCommentEvent",
            @"ContentReferenceEvent",
            @"CreateEvent",
            @"DeleteEvent",
            @"DeployKeyEvent",
            @"DeploymentEvent",
            @"DeploymentStatusEvent",
            @"DownloadEvent",
            @"FollowEvent",
            @"ForkEvent",
            @"ForkApplyEvent",
            @"GitHubAppAuthorizationEvent",
            @"GistEvent",
            @"GollumEvent",
            @"InstallationEvent",
            @"InstallationRepositoriesEvent",
            @"IssueCommentEvent",
            @"IssuesEvent",
            @"LabelEvent",
            @"MarketplacePurchaseEvent",
            @"MemberEvent",
            @"MembershipEvent",
            @"MetaEvent",
            @"MilestoneEvent",
            @"OrganizationEvent",
            @"OrgBlockEvent",
            @"PackageEvent",
            @"PageBuildEvent",
            @"ProjectCardEvent",
            @"ProjectColumnEvent",
            @"ProjectEvent",
            @"PublicEvent",
            @"PullRequestEvent",
            @"PullRequestReviewEvent",
            @"PullRequestReviewCommentEvent",
            @"PushEvent",
            @"ReleaseEvent",
            @"RepositoryDispatchEvent",
            @"RepositoryEvent",
            @"RepositoryImportEvent",
            @"RepositoryVulnerabilityAlertEvent",
            @"SecurityAdvisoryEvent",
            @"StarEvent",
            @"StatusEvent",
            @"SponsorshipEvent",
            @"TeamEvent",
            @"TeamAddEvent",
            @"WatchEvent",
            @"UnKnown"];
    }
}


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
        ZLGithubEventType eventType = (ZLGithubEventType)[ZLGithubEventTypeArray indexOfObject:oldValue];
        return @(eventType);
    }
    
    return oldValue;
}

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues
{
    NSDictionary *dic = self.payload;
    
    switch(self.type)
    {
        case ZLGithubEventType_CommitCommentEvent:{
            self.payload = [ZLCommitCommentEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_CreateEvent:
        {
            self.payload = [ZLCreateEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_DeleteEvent:
        {
            self.payload = [ZLDeleteEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_ForkEvent:
        {
            self.payload = [ZLForkEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_PushEvent:
        {
            self.payload = [ZLPushEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_GollumEvent:
        {
            self.payload = [ZLGollumEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_IssueCommentEvent:
        {
            self.payload = [ZLIssueCommentEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_IssuesEvent:
        {
            self.payload = [ZLIssueEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_MemberEvent:
        {
            self.payload = [ZLMemberEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_PublicEvent:
        {
            
        }
            break;
        case ZLGithubEventType_PullRequestReviewCommentEvent:
        {
            self.payload = [ZLPullRequestReviewCommentEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_PullRequestEvent:
        {
            self.payload = [ZLPullRequestEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_ReleaseEvent:
        {
            self.payload = [ZLReleaseEventPayloadModel mj_objectWithKeyValues:dic];
        }
            break;
        case ZLGithubEventType_SponsorshipEvent:
        {
            
        }
            break;
        case ZLGithubEventType_WatchEvent:
        {
            ZLWatchEventPayloadModel *watchEventPayload = [ZLWatchEventPayloadModel mj_objectWithKeyValues:dic];
            self.payload = watchEventPayload;
        }
            break;
        default:
            break;
    }
                  
}


- (NSString *) eventDescription
{
    return [NSString stringWithFormat:@"%@ at %@",ZLGithubEventTypeArray[_type],_repo.name];
}

@end
