//
//  AppDelegate.h
//  ZLGitHubClient
//
//  Created by zhumeng on 2018/12/27.
//  Copyright © 2018年 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL allowRotation;

#pragma mark -

- (void) switchToMainController:(BOOL) animated;

- (void) switchToLoginController:(BOOL) animated;


@end

