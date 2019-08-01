//
//  ZLGitHubEventModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/29.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLGitHubEventModel : NSObject

@property(strong, nonatomic) NSString * id_Event;

@property(strong, nonatomic) NSString * type;               // PushEvent WatchEvent CreateEvent

@property(assign, nonatomic, getter=isPub) BOOL pub;        // 是否为公共事件

@property(strong, nonatomic) NSString * created_at;         // 事件时间


@end

NS_ASSUME_NONNULL_END
