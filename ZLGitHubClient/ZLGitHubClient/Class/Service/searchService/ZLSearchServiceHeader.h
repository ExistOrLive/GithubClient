//
//  ZLSearchServiceHeader.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/8.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLSearchServiceHeader_h
#define ZLSearchServiceHeader_h

#pragma mark - ENum

typedef NS_ENUM(NSUInteger, ZLSearchType) {
    ZLSearchTypeRepositories,
    ZLSearchTypeUsers,
    ZLSearchTypeCommits,
    ZLSearchTypeIssues,
    ZLSearchTypeCode,
    ZLSearchTypeTopics
};

#pragma mark - NotificationName

static const NSNotificationName ZLSearchResult_Notification = @"ZLSearchResult_Notification";

#endif /* ZLSearchServiceHeader_h */
