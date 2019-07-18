//
//  ZLBaseServiceModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/17.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLBaseServiceModel : NSObject

- (void) registerObserver:(id) observer selector:(SEL) selector name:(NSNotificationName) notificationName;

- (void) unRegisterObserver:(id) observer name:(NSNotificationName) notificationName;

- (void) postNotification:(NSNotificationName) notificationName withParams:(id) params;

@end

@interface NSNotification(ZLBaseServiceModel)

@property (strong, nonatomic, readonly) id params;

@end

NS_ASSUME_NONNULL_END
