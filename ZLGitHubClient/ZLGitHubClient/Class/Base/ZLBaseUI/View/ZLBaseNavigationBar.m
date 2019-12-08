//
//  ZLBaseNavigationBar.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/11/17.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseNavigationBar.h"



@implementation ZLBaseNavigationBar

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
    return [self initWithFrame:CGRectMake(0, 0, ZLScreenWidth, ZLCustomNavigationBarHeight)];
}


- (void) setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    [self setNeedsUpdateConstraints];
}


- (void) updateConstraints
{
    [super updateConstraints];
    
    if(self.hidden)
    {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    else
    {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ZLCustomNavigationBarHeight));
        }];
    }
}

#pragma mark - initUI

- (void) setUPUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // 创建返回按钮
    [self setUIBackButton];
    
    // 创建Title
    [self setUpTitleLabel];

    // 约束高度
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(ZLCustomNavigationBarHeight));
    }];
}

- (void) setUIBackButton
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back_Common"] forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@30);
        make.height.equalTo(@60);
    }];
}

- (void) setUpTitleLabel
{
    self.titleLabel = [UILabel new];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setFont:[UIFont fontWithName:Font_PingFangSCMedium size:18]];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@60);
    }];
}





@end
