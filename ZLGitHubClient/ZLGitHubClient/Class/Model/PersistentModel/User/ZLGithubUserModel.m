//
//  ZLGithubUserModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLGithubUserModel.h"
#import <MJExtension/MJExtension.h>

#pragma mark - ZLGithubUserBriefModel

@implementation ZLGithubUserBriefModel

//MARK: MJExtension

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_User":@"id",
             @"loginName":@"login"
             };
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if([property.name isEqualToString:@"type"])
    {
        if([oldValue isEqualToString:@"User"])
        {
            return @(ZLGithubUserType_User);
        }
        else
        {
            return @(ZLGithubUserType_Organization);
        }
    }
    
    return oldValue;
    
}

@end

#pragma mark - ZLGithubUserModel

@implementation ZLGithubUserModel

//MARK: Setter Getter

- (NSDate *) createdDate
{
    if(!_created_at)
    {
        return nil;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter dateFromString:_created_at];
}

- (NSDate *) updatedDate
{
    if(!_updated_at)
    {
        return nil;
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter dateFromString:_updated_at];
}



- (NSString *) description
{
    return [NSString stringWithFormat:@"id = %@, name = %@ ",self.id_User,self.name];
}

//MARK: MJExtension

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"id_User":@"id",
             @"loginName":@"login"
             };
}

+ (instancetype) getInstanceWithDic:(NSDictionary *) dic
{
    if(!dic)
    {
        return nil;
    }
    
    return [ZLGithubUserModel mj_objectWithKeyValues:dic];
}



@end
