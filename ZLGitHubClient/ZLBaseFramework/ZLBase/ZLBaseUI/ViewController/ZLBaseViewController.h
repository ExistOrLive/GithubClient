//
//  ZLBaseViewController.h
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLBaseViewModel.h"
@class ZLBaseNavigationBar;

@interface ZLBaseViewController : UIViewController <ZLBaseViewModel>

#pragma mark -

// 导航栏
@property(nonatomic, strong) ZLBaseNavigationBar * zlNavigationBar;

// contentView
@property(nonatomic, strong) UIView * contentView;


#pragma mark - 设置Navigation Bar

- (void) setZLNavigationBarHidden:(BOOL)hidden;

- (void) onBackButtonClicked:(UIButton *) button;


@end


@interface ZLBaseViewController(Tool)

+ (UIViewController *)getTopViewController;

+ (UIViewController *)getTopViewControllerFromViewController:(UIViewController *)rootVC;

+ (UIViewController *)getTopViewControllerFromWindow:(UIWindow *) window;

@end

