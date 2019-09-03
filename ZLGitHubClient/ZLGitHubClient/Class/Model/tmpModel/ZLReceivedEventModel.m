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

@implementation ZLPayloadModel

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
       if([oldValue isEqualToString:@"PushEvent"])
       {
           return [NSNumber numberWithInteger:ZLReceivedEventType_PushEvent];
       }
       else if([oldValue isEqualToString:@"PullRequestEvent"])
       {
           return [NSNumber numberWithInteger:ZLReceivedEventType_PullRequestEvent];
       }
    }
    
    return oldValue;
}

@end






