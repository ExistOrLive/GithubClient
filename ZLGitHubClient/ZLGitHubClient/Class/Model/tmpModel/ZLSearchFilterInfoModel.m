//
//  ZLSearchFilterInfoModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/8.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLSearchFilterInfoModel.h"

@interface ZLSearchFilterInfoModel()
{
    NSString * _sortKey;
    BOOL _isAsc;
}

@end


@implementation ZLSearchFilterInfoModel

- (instancetype) init
{
    if(self = [super init])
    {
        _firstCreatedTimeStr = @"*";
        _secondCreatedTimeStr = @"*";
    }
    
    return self;
}

- (NSString *) finalKeyWordForRepoFilter:(NSString *) keyWord
{
    NSMutableString * finalKeyWord = [keyWord mutableCopy];
    
    if([@"Most stars" isEqualToString:self.order])
    {
        _sortKey = @"stars";
        _isAsc = NO;
    }
    else if([@"Fewst stars" isEqualToString:self.order])
    {
        _sortKey = @"stars";
        _isAsc = YES;
    }
    else if([@"Most forks" isEqualToString:self.order])
    {
        _sortKey = @"forks";
        _isAsc = NO;
    }
    else if([@"Fewest forks" isEqualToString:self.order])
    {
        _sortKey = @"forks";
        _isAsc = YES;
    }
    else if([@"Recently updated" isEqualToString:self.order])
    {
        _sortKey = @"updated";
        _isAsc = NO;
    }
    else if([@"Least recently updated" isEqualToString:self.order])
    {
        _sortKey = @"updated";
        _isAsc = YES;
    }
    
    if(self.language && [self.language length] > 0)
    {
        [finalKeyWord appendFormat:@"+language:%@",self.language];
    }
    
    if([self.firstCreatedTimeStr length] > 0 || [self.secondCreatedTimeStr length] > 0)
    {
        [finalKeyWord appendFormat:@"+created:%@..%@",[self.firstCreatedTimeStr length] > 0 ? self.firstCreatedTimeStr : @"*",[self.secondCreatedTimeStr length] > 0 ? self.secondCreatedTimeStr : @"*"];
    }
    
    if(self.firstForkNum > 0 || self.secondForkNum > 0)
    {
        [finalKeyWord appendFormat:@"+fork:%@..%@",self.firstForkNum > 0 ? @(self.firstForkNum) : @"*",self.secondForkNum > 0 ? @(self.secondForkNum) : @"*" ];
    }
    
    if(self.firstStarNum > 0 || self.secondStarNum > 0)
    {
         [finalKeyWord appendFormat:@"+stars:%@..%@",self.firstStarNum > 0 ? @(self.firstStarNum) : @"*",self.secondStarNum > 0 ? @(self.secondStarNum) : @"*" ];
    }
    
    return [finalKeyWord copy];

}


- (NSString *) getSortFiled
{
    return _sortKey;
}

- (BOOL) getIsAsc
{
    return _isAsc;
}

@end
