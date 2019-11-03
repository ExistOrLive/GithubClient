//
//  ZLPresentContainerView.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/10/27.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLPresentContainerView : UIView

// 默认以当前的keyWindow为superView，且以占满整个window
+ (void) showPresentContainerViewWithContentView:(UIView *) contentView;

// 默认以当前的keyWindow为superView
+ (void) showPresentContainerViewWithFrame:(CGRect) frame WithContentView:(UIView *) contentView;

+ (void) showPresentContainerViewWithFrame:(CGRect) frame WithContentView:(UIView *) contentView withSuperView:(UIView *) superView;

@end


@interface ZLPresentContainerView (contentView)

// 默认以当前的keyWindow为superView，且以占满整个window
+ (void) showPresentContainerViewWithContentView:(UIView *) contentView withContentInSet:(UIEdgeInsets) insets;

@end

NS_ASSUME_NONNULL_END
