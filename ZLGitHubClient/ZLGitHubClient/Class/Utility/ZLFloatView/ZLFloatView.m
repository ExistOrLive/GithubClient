//
//  ZLFloatView.m
//  chengyu
//
//  Created by BeeCloud on 2020/1/2.
//  Copyright © 2020 BeeCloud. All rights reserved.
//

#import "ZLFloatView.h"




@implementation ZLFloatViewConfig

@end


@interface ZLFloatViewController()

@property(nonatomic, strong) void(^rotateBlock)(void);

@end

@implementation ZLFloatViewController


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if(self.rotateBlock){
        self.rotateBlock();
    }
}

@end

@implementation ZLFloatWindow

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        self.rootViewController = [ZLFloatViewController new];
        self.rootViewController.view.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 50.0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc{

}

// 不能成为keywindow
- (void)becomeKeyWindow {
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow makeKeyWindow];
}


@end

@interface ZLFloatView() <UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIWindow *floatWindow;

@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end


@implementation ZLFloatView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingNone;
        
        UIPanGestureRecognizer *panGestureRecongnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [self addGestureRecognizer:panGestureRecongnizer];
        self.panGesture = panGestureRecongnizer;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)setFrame:(CGRect)frame {
    CGRect newFrame = [self ajustFrameByMargin:frame];

    if (self.config.viewType == ZLFloatViewType_OverAllWindow &&
        self.floatWindow) {
        [self.floatWindow setFrame:newFrame];
        CGRect bounds = CGRectMake(0, 0, CGRectGetWidth(newFrame),
                                   CGRectGetHeight(newFrame));
        [super setFrame:bounds];
    } else {
        [super setFrame:newFrame];
    }
}

- (void)setConfig:(ZLFloatViewConfig *)config {
    _config = config;
    
    [self removeFromSuperview];
    self.floatWindow = nil;
    [self.floatWindow setHidden:YES];
    
    self.panGesture.enabled = config.canPan;
    
    switch (_config.viewType) {
        case ZLFloatViewType_OverAllWindow: {
            self.floatWindow = [ZLFloatWindow new];
            __weak ZLFloatView * weakSelf = self;
            ((ZLFloatViewController *)self.floatWindow.rootViewController).rotateBlock = ^{
                CGRect originFrame = weakSelf.frame;
                if(weakSelf.config.viewType == ZLFloatViewType_OverAllWindow){
                    originFrame = weakSelf.floatWindow.frame;
                }
                [weakSelf setFrame:originFrame];
                
            };
            [self.floatWindow.rootViewController.view addSubview:self];
            [self.floatWindow setHidden:NO];
        } break;
        case ZLFloatViewType_OverCurrentWindow: {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            [window addSubview:self];
        } break;
        case ZLFloatViewType_OverCurrentView: {
            UIView *view = _config.superView;
            [view addSubview:self];
        } break;
    }

    [self adjustPositionByMargin];
}


- (void)adjustPositionByMargin {
    CGRect newFrame = [self ajustFrameByMargin:self.frame];

    [self setFrame:newFrame];
}

- (CGRect)ajustFrameByMargin:(CGRect)originFrame {
    if (!self.config) {
        return originFrame;
    }

    CGRect tmpFrame = originFrame;

    CGRect superFrame = self.superview.frame;
    if (self.config.viewType == ZLFloatViewType_OverAllWindow) {
        superFrame = [UIApplication sharedApplication].delegate.window.bounds;
    }
    
    UIEdgeInsets margin = self.config.margin;
    if(UIEdgeInsetsEqualToEdgeInsets(margin, UIEdgeInsetsZero)) {
        if (self.config.viewType == ZLFloatViewType_OverAllWindow) {
            margin = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        } else {
            margin = self.superview.safeAreaInsets;
        }
    }
    
    if (CGRectGetMinX(tmpFrame) < margin.left) {
        tmpFrame = CGRectOffset(
            tmpFrame, margin.left - CGRectGetMinX(tmpFrame), 0);
    }

    if (CGRectGetMinY(tmpFrame) < margin.top) {
        tmpFrame = CGRectOffset(
            tmpFrame, 0, margin.top - CGRectGetMinY(tmpFrame));
    }

    if (CGRectGetMaxX(tmpFrame) >
        ((CGRectGetWidth(superFrame) - margin.right))) {
        tmpFrame =
            CGRectOffset(tmpFrame,
                         CGRectGetWidth(superFrame) - margin.right -
                             CGRectGetMaxX(tmpFrame),
                         0);
    }

    if (CGRectGetMaxY(tmpFrame) >
        ((CGRectGetHeight(superFrame) - margin.bottom))) {
        tmpFrame = CGRectOffset(tmpFrame, 0,
                                CGRectGetHeight(superFrame) -
                                    margin.bottom -
                                    CGRectGetMaxY(tmpFrame));
    }

    return tmpFrame;
}

#pragma mark - onPan onLongPress

- (void) onPan:(UIPanGestureRecognizer *) recognizer {
    //1、获得拖动位移
    CGPoint offsetPoint = [recognizer translationInView:recognizer.view];
    //2、清空拖动位移
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
    
    CGRect originFrame = self.frame;
    if (self.config.viewType == ZLFloatViewType_OverAllWindow) {
        originFrame = self.floatWindow.frame;
    }
    
    CGRect newFrame = CGRectOffset(originFrame, offsetPoint.x, offsetPoint.y);
    
    if(self.config.bounces) {
        if (self.config.viewType == ZLFloatViewType_OverAllWindow) {
            [self.floatWindow setFrame:newFrame];
            CGRect bounds = CGRectMake(0, 0, CGRectGetWidth(newFrame),
                                       CGRectGetHeight(newFrame));
            [super setFrame:bounds];
        } else {
            [super setFrame:newFrame];
        }
    } else {
        [self setFrame:newFrame];
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^{
            [self setFrame:newFrame];
        }];
    }
}


@end
