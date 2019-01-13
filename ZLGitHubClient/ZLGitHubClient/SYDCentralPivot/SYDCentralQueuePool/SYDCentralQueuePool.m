
//
//  SYDCentralQueuePool.m
//  
//
//  Created by zhumeng on 2019/1/10.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralQueuePool.h"
#include <pthread.h>

@interface SYDCentralQueuePool()
{
    pthread_mutex_t mutex;
}

@property(nonatomic,strong) NSMutableDictionary * queueDic;

@property(nonatomic,strong) NSMutableDictionary * queueThreadMap;

@end


@implementation SYDCentralQueuePool

+ (instancetype) sharedInstance
{
    static SYDCentralQueuePool * queuePool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queuePool = [[SYDCentralQueuePool alloc] init];
    });
    
    return queuePool;
}

- (instancetype) init
{
    if(self = [super init])
    {
        NSArray * array = @[@"MOAChatQueue",@"MOARosterQueue"];
        
        _queueDic = [[NSMutableDictionary alloc] init];
        _queueThreadMap = [[NSMutableDictionary alloc] init];
        
        for(NSString * queueTag in array)
        {
            dispatch_queue_t queue = [self createSerialQueue:queueTag];
            [_queueDic setObject:queue forKey:queueTag];
        }
        
        pthread_mutex_init(&mutex, NULL);
    }
    
    return self;
}

- (dispatch_queue_t) createSerialQueue:(NSString *) queueTag
{
    dispatch_queue_t queue = dispatch_queue_create([queueTag UTF8String], DISPATCH_QUEUE_SERIAL);
    
    if(!queue)
    {
        queue = dispatch_get_main_queue();
        
        NSLog(@"create serial queue for [%@] failed, so use the main queue",queueTag);
    }
    else
    {
        NSLog(@"create serial queue for [%@] successfully",queueTag);
    }
    
    return queue;
}


- (dispatch_queue_t) getSerailQueueForTag:(const NSString *) queueTag
{
    dispatch_queue_t queue = nil;
    
    pthread_mutex_lock(&mutex);
    
    queue = [self.queueDic objectForKey:queueTag];
    
    pthread_mutex_unlock(&mutex);
    
    return queue;
}

- (void) asyncPerformBlock:(void(^)(void)) dispatchBlock inQueueForTag:(const NSString *) queueTag
{
    dispatch_queue_t queue = [self getSerailQueueForTag:queueTag];
    
    if(!queue)
    {
        NSLog(@"serial queue for [%@] not exist,so use main queue",queueTag);
        queue = dispatch_get_main_queue();
    }
    
    dispatch_async(queue, dispatchBlock);
    
}

- (void) syncPerformBlock:(void(^)(void)) dispatchBlock inQueueForTag:(const NSString *) queueTag
{
    dispatch_queue_t queue = [self getSerailQueueForTag:queueTag];
    
    if(!queue)
    {
        NSLog(@"serial queue for [%@] not exist,so use main queue",queueTag);
        queue = dispatch_get_main_queue();
    }
    
    dispatch_async(queue, dispatchBlock);
    
}



@end
