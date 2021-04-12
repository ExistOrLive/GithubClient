//
//  ZLGithubGistModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/10.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLGithubGistModel.h"
#import <MJExtension/MJExtension.h>

@implementation ZLGithubGistFileModel


@end



@implementation ZLGithubGistModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_Gist":@"id",
             @"pub":@"public",
             @"desc_Gist":@"description"
             };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if(([property.name isEqualToString:@"updated_at"]||
        [property.name isEqualToString:@"created_at"])&&
       property.type.typeClass == [NSDate class])
    {
        // String 转为 Date
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormatter dateFromString:oldValue];
    }
    
    if([property.name isEqualToString:@"files"] && property.type.typeClass == [NSDictionary class])
    {
        NSDictionary * oldDic = (NSDictionary *)oldValue;
        NSMutableDictionary * newDic = [NSMutableDictionary new];
        for(NSString * key in oldDic.allKeys)
        {
            [newDic setObject:[ZLGithubGistFileModel mj_objectWithKeyValues:oldDic[key]] forKey:key];
        }
        return [newDic copy];
    }
    
    return oldValue;
}

@end
