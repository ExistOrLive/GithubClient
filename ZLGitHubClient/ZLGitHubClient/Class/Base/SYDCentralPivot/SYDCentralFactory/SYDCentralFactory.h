//
//  SYDCentralFactory.h
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/9.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SYDCentralRouterModel.h"

@interface SYDCentralFactory : NSObject

@property(nonatomic,strong) NSMutableDictionary * viewControllerModelMapCache;

@property(nonatomic,strong) NSMutableDictionary * serviceModelMapCache;

@property(nonatomic,strong) NSMutableDictionary * otherMapCache;


#pragma mark - SYDCentralFactory 单例

+ (instancetype) sharedInstance;

- (SYDCentralRouterModel *) getCentralRouterModel:(const NSString *) beanKey;

#pragma mark - 获取实例

- (id) getCommonBean:(const NSString *) beanKey;

- (id) getCommonBean:(const NSString *) beanKey withInjectParam:(NSDictionary *) param;

- (id) getSingleton:(const NSString *) beanKey;

@end
