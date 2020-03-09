//
//  ZLGithubPullRequestModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/3.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLGithubPullRequestModel.h"
#import <MJExtension/MJExtension.h>

@implementation ZLGithubPullRequestModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
   if(([property.name isEqualToString:@"updated_at"]||
       [property.name isEqualToString:@"created_at"]||
        [property.name isEqualToString:@"pushed_at"]||
       [property.name isEqualToString:@"merged_at"])&&
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
