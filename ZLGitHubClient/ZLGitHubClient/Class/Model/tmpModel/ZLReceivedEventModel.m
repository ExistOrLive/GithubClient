//
//  ZLReceivedEventResultModel.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLReceivedEventModel.h"
#import <MJExtension/MJExtension.h>

@implementation ZLEventActorModel

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
@implementation ZLPayloadModel

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

@implementation ZLReceivedEventModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_eventRecv":@"id",
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
            return [NSNumber numberWithInteger:ZLReceivedEventType_CreateEvent];
        }
        else if([oldValue isEqualToString:@"PushEvent"])
        {
           return [NSNumber numberWithInteger:ZLReceivedEventType_PushEvent];
        }
        else if([oldValue isEqualToString:@"PullRequestEvent"])
        {
           return [NSNumber numberWithInteger:ZLReceivedEventType_PullRequestEvent];
        }
        else if([oldValue isEqualToString:@"WatchEvent"])
        {
           return [NSNumber numberWithInteger:ZLReceivedEventType_WatchEvent];
        }
        else
        {
           return [NSNumber numberWithInteger:ZLReceivedEventType_UnKnow];
        }
    }
    
    return oldValue;
}

@end






