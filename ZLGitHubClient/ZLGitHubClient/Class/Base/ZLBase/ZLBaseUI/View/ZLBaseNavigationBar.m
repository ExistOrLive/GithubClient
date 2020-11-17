//
//  ZLBaseNavigationBar.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/11/17.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseNavigationBar.h"

static CGFloat ZLBaseNavigationBarStatusBarHeight = 0;

@implementation ZLBaseNavigationBar

+ (void) initialize{
    [super initialize];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ZLBaseNavigationBarStatusBarHeight = ZLStatusBarHeight;            // 一般默认竖屏，记录竖屏时的ZLStatusBarHeight
    });
    
}



- (instancetype) initWithCoder:(NSCoder *)coder
{
    if(self = [super initWithCoder:coder])
    {
        [self setUPUI];
    }
    return self;
}


- (instancetype) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setUPUI];
    }
    return self;
}

- (instancetype) init
{
    return [self initWithFrame:CGRectMake(0, 0, ZLScreenWidth, ZLBaseNavigationBarHeight)];
}


- (void) setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    [self setNeedsUpdateConstraints];
}


- (void) updateConstraints{
    
    [super updateConstraints];
    
    if(self.hidden){
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            if(self.isLandScape) {
                make.height.equalTo(@(ZLBaseNavigationBarHeight));
            } else {
                make.height.equalTo(@(ZLBaseNavigationBarStatusBarHeight+ZLBaseNavigationBarHeight));
            }
        }];
    }
}

#pragma mark - initUI

- (void) setUPUI
{
    [self setBackgroundColor:[UIColor colorNamed:@"ZLNavigationBarBackColor"]];
    self.layer.shadowRadius = 0.3;
    
    // 确定横竖屏
    if(ZLScreenWidth > ZLScreenHeight) {
        self.isLandScape = YES;
    } else {
        self.isLandScape = NO;
    }
    
    
    // 创建返回按钮
    [self setUpBackButton];
    
    // 创建Title
    [self setUpTitleLabel];

    // 约束高度
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        if(self.isLandScape) {
            make.height.equalTo(@(ZLBaseNavigationBarHeight));
        } else {
            make.height.equalTo(@(ZLBaseNavigationBarStatusBarHeight+ZLBaseNavigationBarHeight));
        }
    }];
}

- (void) setUpBackButton
{
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back_Common"] forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@30);
        make.height.equalTo(@(ZLBaseNavigationBarHeight));
    }];
}

- (void) setUpTitleLabel
{
    _titleLabel = [UILabel new];
    [self.titleLabel setTextColor:[UIColor colorNamed:@"ZLNavigationBarTitleColor"]];
    [self.titleLabel setFont:[UIFont fontWithName:Font_PingFangSCMedium size:18]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.titleLabel.adjustsFontSizeToFitWidth = true;
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(ZLBaseNavigationBarHeight));
        make.left.equalTo(self.mas_left).with.offset(50);
        make.right.equalTo(self.mas_right).with.offset(-50);
    }];
}


- (void) setRightButton:(UIButton *)rightButton
{
    _rightButton = rightButton;
    [self addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@(rightButton.frame.size.width));
        make.height.equalTo(@(rightButton.frame.size.height));
    }];
}



@end
