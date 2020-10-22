//
//  ZLBaseButton.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/21.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseButton.h"

@implementation ZLBaseButton

- (instancetype) initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
        // [self setUpUI];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}


- (void) awakeFromNib{
    [super awakeFromNib];
    
    [self setUpUI];
}


- (void) setUpUI {
    [self.layer setBorderColor:ZLRGBValue_H(0xC4C8CC).CGColor];
    [self.layer setBorderWidth:1/[UIScreen mainScreen].scale];
    [self.layer setCornerRadius:4.0];
    [self.layer setBackgroundColor:ZLRGBValue_H(0xF0F4F6).CGColor];
    
    self.titleLabel.textColor = UIColor.blackColor;
    self.titleLabel.font = [UIFont fontWithName:Font_PingFangSCSemiBold size:11];
    
    [self setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
}
@end
