//
//  ZLBaseViewController.h
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLBaseViewModel;
@class ZLBaseNavigationBar;

@interface ZLBaseViewController : UIViewController

#pragma mark -

// 导航栏
@property(nonatomic, strong) ZLBaseNavigationBar * zlNavigationBar;

// contentView
@property(nonatomic, strong) UIView * contentView;


@property (strong, nonatomic) ZLBaseViewModel * viewModel;

#pragma mark - 设置Navigation Bar

- (void) setZLNavigationBarHidden:(BOOL)hidden;


@end
