//
//  ZLGithubIssueModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/11.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLGithubIssueModel.h"
#import <MJExtension/MJExtension.h>

@implementation ZLGithubLabelModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description",
             @"isDefault":@"default"
             };
}
@end


@implementation ZLGithubMilestoneModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
   if(([property.name isEqualToString:@"updated_at"]||
       [property.name isEqualToString:@"created_at"]||
       [property.name isEqualToString:@"closed_at"]||
       [property.name isEqualToString:@"due_on"]) &&
            property.type.typeClass == [NSDate class])
    {
        if(oldValue == [NSNull null])
        {
            return  nil;
        }
        
        // String 转为 Date
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormatter dateFromString:oldValue];
    }
    
    return oldValue;
}

@end
   

@implementation ZLGithubIssueModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_issue":@"id"};
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
   if(([property.name isEqualToString:@"updated_at"]||
       [property.name isEqualToString:@"created_at"]||
        [property.name isEqualToString:@"closed_at"])&&
            property.type.typeClass == [NSDate class])
    {
        if(oldValue == [NSNull null])
        {
            return  nil;
        }
        
        // String 转为 Date
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormatter dateFromString:oldValue];
    }
    
    return oldValue;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"labels":[ZLGithubLabelModel class]};
}

@end
