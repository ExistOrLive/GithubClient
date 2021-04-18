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
    
    if([property.name isEqualToString:@"state"]){
        if(oldValue == [NSNull null])
        {
            return oldValue;
        }
        NSString *state = oldValue;
        if([@"open" isEqualToString:state]){
            return [NSNumber numberWithUnsignedInteger:ZLGithubPullRequestState_Open];
        } else if ([@"closed" isEqualToString:state]) {
            return [NSNumber numberWithUnsignedInteger:ZLGithubPullRequestState_Closed];
        } else {
            return [NSNumber numberWithUnsignedInteger:ZLGithubPullRequestState_Merged];
        }
    }
    
    return oldValue;
}


@end
