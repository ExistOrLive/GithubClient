//
//  SYDCentralQueuePool.h
//  
//
//  Created by zhumeng on 2019/1/10.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYDCentralQueuePool : NSObject

+ (instancetype) sharedInstance;

- (dispatch_queue_t) getSerailQueueForTag:(const NSString *) queueTag;

- (void) asyncPerformBlock:(void(^)(void)) dispatchBlock inQueueForTag:(const NSString *) queueTag;

@end
