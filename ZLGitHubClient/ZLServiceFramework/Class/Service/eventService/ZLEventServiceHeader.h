//
//  ZLEventServiceHeader.h
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

#ifndef ZLEventServiceHeader_h
#define ZLEventServiceHeader_h

#import "ZLBaseServiceModel.h"

#pragma mark - NotificationName

static const NSNotificationName ZLGetUserReceivedEventResult_Notification = @"ZLGetUserReceivedEventResult_Notification";
static const NSNotificationName ZLGetMyEventResult_Notification = @"ZLGetMyEventResult_Notification";

@protocol ZLEventServiceModuleProtocol <ZLBaseServiceModuleProtocol>

/**
 *  @brief 请求当前用户的event
 *
 **/
- (void) getMyEventsWithpage:(NSUInteger)page
                    per_page:(NSUInteger)per_page
                serialNumber:(NSString *)serialNumber;

/**
 *  @brief 请求用户的event
 *
 **/
- (void) getEventsForUser:(NSString *) userName
                     page:(NSUInteger)page
                 per_page:(NSUInteger)per_page
             serialNumber:(NSString *)serialNumber;



/**
 * @brief 请求某个用户的receive_events
 *
 **/
- (void)getReceivedEventsForUser:(NSString *)userName
                            page:(NSUInteger)page
                        per_page:(NSUInteger)per_page
                    serialNumber:(NSString *)serialNumber;


@end

#endif /* ZLEventServiceHeader_h */
