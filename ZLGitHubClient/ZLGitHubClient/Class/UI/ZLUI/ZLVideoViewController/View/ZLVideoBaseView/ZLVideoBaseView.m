//
//  ZLVideoView.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/2.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLVideoBaseView.h"

#import "ZLVideoOverlayView.h"

@implementation ZLVideoBaseView

- (instancetype) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _overlayView = [[NSBundle mainBundle] loadNibNamed:@"ZLVideoOverlayView" owner:nil options:nil].firstObject;
        [_overlayView setFrame:self.bounds];
        [self addSubview:_overlayView];
        [_overlayView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
    }
    return self;
}

- (void) setOverlayView:(ZLVideoOverlayView *)overlayView
{
    [_overlayView removeFromSuperview];
    _overlayView = overlayView;
    [_overlayView setFrame:self.bounds];
    [self addSubview:_overlayView];
    [_overlayView setAutoresizingMask:(UIViewAutoresizing)UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
}

- (void) setContentView:(UIView *)contentView
{
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [_contentView setFrame:self.bounds];
    [self insertSubview:_contentView atIndex:0];
    [_contentView setAutoresizingMask:(UIViewAutoresizing)UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
}

@end
