//
//  SYDCentralFactory+SYDService.h
//  
//
//  Created by zhumeng on 2019/1/9.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralFactory.h"

@interface SYDCentralFactory (SYDService)

- (id) getSYDServiceBean:(const NSString *) serviceKey;

@end
