//
//  ZLSearchFilterInfoModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/8.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLSearchFilterInfoModel.h"




@implementation ZLSearchFilterInfoModel

- (instancetype) init
{
    if(self = [super init])
    {

    }
    
    return self;
}

- (NSString *) finalKeyWordForRepoFilter:(NSString *) keyWord
{
    NSMutableString * finalKeyWord = [keyWord mutableCopy];
    
    if([@"Most stars" isEqualToString:self.order])
    {
        
    }
    else if([@"Fewst stars" isEqualToString:self.order])
    {
        
    }
    else if([@"Most forks" isEqualToString:self.order])
    {
        
    }
    else if([@"Fewest forks" isEqualToString:self.order])
    {
        
    }
    else if([@"Recently updated" isEqualToString:self.order])
    {
        
    }
    else if([@"Least recently updated" isEqualToString:self.order])
    {
        
    }
    

}

@end
