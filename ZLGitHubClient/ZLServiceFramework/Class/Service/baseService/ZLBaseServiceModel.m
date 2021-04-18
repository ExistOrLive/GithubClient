//
//  ZLBaseServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/17.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseServiceModel.h"



@interface ZLBaseServiceModel()

@property(strong, nonatomic) NSNotificationCenter * notificationCenter;

@end

@implementation ZLBaseServiceModel

- (instancetype) init
{
    if(self = [super init])
    {
        _notificationCenter = [[NSNotificationCenter alloc] init];
    }
    return self;
}

- (void) registerObserver:(id) observer selector:(SEL) selector name:(NSNotificationName) notificationName
{
    [self.notificationCenter addObserver:observer selector:selector name:notificationName object:self];
}

- (void) unRegisterObserver:(id) observer name:(NSNotificationName) notificationName
{
    [self.notificationCenter removeObserver:observer name:notificationName object:self];
}

- (void) postNotification:(NSNotificationName) notificationName withParams:(id) params
{
    NSDictionary * userInfo = nil;
    if(params)
    {
        userInfo = @{@"params":params};
    }
    [self.notificationCenter postNotificationName:notificationName object:self userInfo:userInfo];
}

- (void) dealloc{
    self.notificationCenter = nil;
}

@end


static void* const GlobaleServiceOperationQueueIdentityKey = (void *)&GlobaleServiceOperationQueueIdentityKey;

@implementation ZLBaseServiceModel(OperationQueue)

+ (dispatch_queue_t) serviceOperationQueue{
    
    static dispatch_once_t onceToken;
    static dispatch_queue_t _serviceOperationQueue;
    dispatch_once(&onceToken, ^{
        _serviceOperationQueue = dispatch_queue_create("ZLBaseService Operation Queue", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(_serviceOperationQueue, "GlobaleServiceOperationQueueIdentityKey", GlobaleServiceOperationQueueIdentityKey, NULL);
    });
    
    return _serviceOperationQueue;
}

+ (void) dispatchAsyncInOperationQueue:(void(^)(void)) asyncBlock{
    
    if(asyncBlock == nil) {
        return;
    }
    
    dispatch_async([self serviceOperationQueue], asyncBlock);
}

+ (void) dispatchSyncInOperationQueue:(void(^)(void)) syncBlock{
    
    if(syncBlock == nil) {
        return;
    }
    
    if(dispatch_get_specific("GlobaleServiceOperationQueueIdentityKey")) {
        syncBlock();
    } else {
        dispatch_sync([self serviceOperationQueue], syncBlock);
    }
}

@end



@implementation NSNotification(ZLBaseServiceModel)

@dynamic params;

- (id) params
{
    NSDictionary * userInfo = self.userInfo;
    return [userInfo objectForKey:@"params"];
}


@end


