//
//  SYDCentralRouter.h
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/7.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SYDCentralFactory;

@interface SYDCentralRouter : NSObject

@property(nonatomic,strong) SYDCentralFactory * centralFactory;

+ (instancetype) sharedInstance;

- (void) addConfigWithFilePath:(NSString *) filePath withBundle:(NSBundle *) bundle;

@end

@interface SYDCentralRouter (ViewController)

- (void) enterViewController:(const NSString *) viewControllerKey withViewControllerConfig:(id) config withParam:(NSDictionary *) paramDic;

@end

@interface SYDCentralRouter (SYDService)

- (id) sendMessageToService:(const NSString *) serviceKey withSEL:(SEL) message withPara:(NSArray *) paramArray isInstanceMessage:(BOOL) isInstanceMessage;

@end

