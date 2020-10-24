//
//  ZLBaseNavigationBar.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/11/17.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ZLBaseNavigationBarHeight 60

@interface ZLBaseNavigationBar : UIView

@property(nonatomic, assign) BOOL isLandScape;       // 是否横屏

@property(nonatomic, readonly) UIButton * backButton;

@property(nonatomic, readonly) UILabel * titleLabel;

@property(nonatomic, strong) UIButton * rightButton;

@end

NS_ASSUME_NONNULL_END
