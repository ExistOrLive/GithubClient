//
//  ZLGithubRepositoryModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/29.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLGithubRepositoryModel.h"
#import <MJExtension/MJExtension.h>

@implementation ZLGithubRepositoryModel

// MARK: MJExtension

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_Repo":@"id",
             @"desc_Repo":@"description",
             @"priva":@"private",
             @"sourceRepoFullName":@"source.full_name"
             };
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
   if(([property.name isEqualToString:@"updated_at"]||
            [property.name isEqualToString:@"created_at"]||
            [property.name isEqualToString:@"pushed_at"])&&
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
