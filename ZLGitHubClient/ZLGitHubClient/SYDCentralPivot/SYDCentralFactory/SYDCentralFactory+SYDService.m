//
//  SYDCentralFactory+SYDService.m
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/9.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralFactory+SYDService.h"
#import <objc/Runtime.h>
#import <objc/message.h>

@implementation SYDCentralFactory (SYDService)

- (id) getSYDServiceBean:(const NSString *) serviceKey
{
    id serviceBean = nil;
    
    if(!self.serviceModelMapCache)
    {
        self.serviceModelMapCache = [[NSMutableDictionary alloc] init];
    }
    else
    {
        serviceBean = [self.serviceModelMapCache objectForKey:serviceKey];
    }
    
    if(!serviceBean)
    {
        serviceBean = [self getCommonBean:serviceKey];
        
        if(serviceBean)
        {
            [self.serviceModelMapCache setObject:serviceBean forKey:serviceKey];
        }
        else
        {
            NSLog(@"SYDCentralFactory_getSYDServiceBean: serviceBean for [%@] not exist",serviceKey);
        }
    }
    
    return serviceBean;
}





@end
