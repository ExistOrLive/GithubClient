//
//  LCLoginRegisterView.m
//  BuDeJie
//
//  Created by LongMac on 2018/7/22.
//  Copyright © 2018年 LongMac. All rights reserved.
//

#import "LCLoginRegisterView.h"

@interface LCLoginRegisterView()

@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;


@end

@implementation LCLoginRegisterView

+ (instancetype)loadLoginView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LCLoginRegisterView" owner:nil options:nil] firstObject];
}

+ (instancetype)loadRegisterView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LCLoginRegisterView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImage *backgroundImg = _loginRegisterButton.currentBackgroundImage;
    //设置不拉伸
    backgroundImg = [backgroundImg stretchableImageWithLeftCapWidth:backgroundImg.size.width * 0.5 topCapHeight:backgroundImg.size.height * 0.5];
    
    [_loginRegisterButton setBackgroundImage:backgroundImg forState:UIControlStateNormal];

}


@end
