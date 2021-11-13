//
//  ZLPresentContainerView.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/10/27.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLPresentContainerView.h"
#import "UIColor+ZLExtension.h"
#import <Masonry/Masonry.h>

@interface ZLPresentContainerView() <UIGestureRecognizerDelegate>

@end

@implementation ZLPresentContainerView

- (instancetype) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setUp];
    }
    
    return self;
}


- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self setUp];
    }
    
    return self;
}


- (void) setUp
{
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    gestureRecognizer.delegate = self;
    [self addGestureRecognizer:gestureRecognizer];
}


- (void) singleTapAction
{
    [self setHidden:YES];
    [self removeFromSuperview];
    
}


// 默认以当前的keyWindow为superView，且以占满整个window
+ (void) showPresentContainerViewWithContentView:(UIView *) contentView
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [self showPresentContainerViewWithFrame:window.bounds WithContentView:contentView withSuperView:window];
}

// 默认以当前的keyWindow为superView
+ (void) showPresentContainerViewWithFrame:(CGRect) frame WithContentView:(UIView *) contentView
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [self showPresentContainerViewWithFrame:frame WithContentView:contentView withSuperView:window];
}

+ (void) showPresentContainerViewWithFrame:(CGRect) frame WithContentView:(UIView *) contentView withSuperView:(UIView *) superView
{
    ZLPresentContainerView * view = [[ZLPresentContainerView alloc] initWithFrame:frame];
    [view addSubview:contentView];
    
    [superView addSubview:view];
}

#pragma mark - UIGestureRecoginzer

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 表示该手势只影响当前view，不接受子view的事件
    if(touch.view == self)
    {
        return YES;
    }
    
    return NO;
    
}


@end

@implementation ZLPresentContainerView (contentView)

// 默认以当前的keyWindow为superView，且以占满整个window
+ (void) showPresentContainerViewWithContentView:(UIView *) contentView withContentInSet:(UIEdgeInsets) insets
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    ZLPresentContainerView * view = [[ZLPresentContainerView alloc] initWithFrame:window.bounds];
    [view addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(insets.top);
        make.bottom.equalTo(view.mas_bottom).with.offset(insets.bottom);
        make.left.equalTo(view.mas_left).with.offset(insets.left);
        make.right.equalTo(view.mas_right).with.offset(insets.right);
    }];
    [window addSubview:view];
}

@end
