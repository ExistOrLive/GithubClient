//
//  ZLEventServiceModel.h
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"

@interface ZLEventServiceModel : ZLBaseServiceModel

+ (instancetype)shareInstance;


/**
 * @brief 请求某个用户的receive_events
 *
 **/
- (void)getReceivedEventsForUser:(NSString *)userName
                                 page:(NSUInteger)page
                             per_page:(NSUInteger)per_page
                         serialNumber:(NSString *)serialNumber;

@end
