//
//  NSDate+Localize.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/9/27.
//  Copyright © 2021 ZM. All rights reserved.
//

#import "NSDate+Localize.h"

@implementation NSDate (Localize)

- (NSString *) dateLocalStrSinceCurrentTime
{
    NSDate * currentDate = [NSDate date];
    
    NSTimeInterval timeInterval = [self timeIntervalSinceDate:currentDate];
    
    if(timeInterval < 0)
    {
        int days = 0 - timeInterval / 24 / 60 / 60;
        
        if(days >= 7)
        {
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            return [dateFormatter stringFromDate:self];
        }
        else if(1 <= days && days < 7)
        {
            return [NSString stringWithFormat:@"%d%@",days,ZLLocalizedString(@"day ago", "天前")];
        }
        else
        {
            int hours = 0 - timeInterval / 60 / 60;
            
            if(hours >= 1)
            {
                return [NSString stringWithFormat:@"%d%@",hours,ZLLocalizedString(@"hour ago", "小时前")];
            }
            else
            {
                int minutes = 0 - timeInterval / 60;
                if(minutes < 0)
                {
                    minutes ++;
                }
                return [NSString stringWithFormat:@"%d%@",minutes,ZLLocalizedString(@"minute ago", "分钟前")];
            }
        }
    }
    else
    {
        int days = timeInterval / 24 / 60 / 60;
        
        if(days >= 7)
        {
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            return [dateFormatter stringFromDate:self];
        }
        else if(1 <= days && days < 7)
        {
            return [NSString stringWithFormat:@"%d%@",days,ZLLocalizedString(@"day later", "天后")];
        }
        else
        {
            int hours = 0 - timeInterval / 60 / 60;
            
            if(hours >= 1)
            {
                return [NSString stringWithFormat:@"%d%@",hours,ZLLocalizedString(@"hour later", "小时后")];
            }
            else
            {
                int minutes = 0 - timeInterval / 60;
                if(minutes < 0)
                {
                    minutes ++;
                }
                return [NSString stringWithFormat:@"%d%@",minutes,ZLLocalizedString(@"minute later", "分钟后")];
            }
        }
    }
}

+ (NSString *) getDateLocalStrSinceCurrentTimeWithGithubTime:(NSString *) githubDateStr {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [dateFormatter dateFromString:githubDateStr];
    
    return [date dateLocalStrSinceCurrentTime];
}

@end
