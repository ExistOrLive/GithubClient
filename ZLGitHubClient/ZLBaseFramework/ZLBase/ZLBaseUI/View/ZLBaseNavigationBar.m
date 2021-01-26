//
//  ZLBaseNavigationBar.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/11/17.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseNavigationBar.h"
#import "ZLBaseUIHeader.h"
#import <Masonry/Masonry.h>

@interface ZLBaseNavigationBar()

@end


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
    
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [ZLBaseUIConfig sharedInstance].navigationBarHeight)];
}


- (void) setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
}

- (void) setZlNavigationBarHidden:(BOOL)zlNavigationBarHidden{
    if(_zlNavigationBarHidden == zlNavigationBarHidden){
        return;
    }
    _zlNavigationBarHidden = zlNavigationBarHidden;
    
    self.titleLabel.hidden = zlNavigationBarHidden;
    self.backButton.hidden = zlNavigationBarHidden;
    self.rightButton.hidden = zlNavigationBarHidden;
    
    [self setNeedsUpdateConstraints];
    
}


- (void) updateConstraints{
    
    [super updateConstraints];
    
    if(self.zlNavigationBarHidden){
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.superview.mas_safeAreaLayoutGuideTop).offset(0);
        }];
    }
    else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.superview.mas_safeAreaLayoutGuideTop).offset([ZLBaseUIConfig sharedInstance].navigationBarHeight);
        }];
    }
}

#pragma mark - initUI

- (void) setUPUI
{
    [self setBackgroundColor:[ZLBaseUIConfig sharedInstance].navigationBarBackgoundColor];
    self.layer.shadowRadius = 0.3;
        
    // 创建返回按钮
    [self setUpBackButton];
    
    // 创建Title
    [self setUpTitleLabel];

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
        make.height.equalTo(@([ZLBaseUIConfig sharedInstance].navigationBarHeight));
    }];
}

- (void) setUpTitleLabel
{
    _titleLabel = [UILabel new];
    [self.titleLabel setTextColor:[ZLBaseUIConfig sharedInstance].navigationBarTitleColor];
    [self.titleLabel setFont:[ZLBaseUIConfig sharedInstance].navigationBarTitleFont];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.titleLabel.adjustsFontSizeToFitWidth = true;
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@([ZLBaseUIConfig sharedInstance].navigationBarHeight));
        make.left.equalTo(self.mas_left).with.offset(80);
        make.right.equalTo(self.mas_right).with.offset(-80);
    }];
}


- (void) setRightButton:(UIButton *)rightButton
{
    _rightButton = rightButton;
    [self addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).with.offset(-10);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@(rightButton.frame.size.width));
        make.height.equalTo(@(rightButton.frame.size.height));
    }];
}



@end
