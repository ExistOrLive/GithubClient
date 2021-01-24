//
//  ZLGithubCommitModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLGithubCommitModel.h"
#import <MJExtension/MJExtension.h>

@implementation ZLGithubFileModel 

@end


@implementation ZLGithubCommitModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"files":[ZLGithubFileModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commit_message":@"commit.message",
             @"commit_verification_verified":@"commit.verification.verified",
             @"commit_at":@"commit.committer.date"
             };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
   if([property.name isEqualToString:@"commit_at"]&&
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
