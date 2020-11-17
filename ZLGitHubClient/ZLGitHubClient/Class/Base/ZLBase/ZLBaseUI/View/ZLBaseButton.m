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
    [self.layer setBorderColor:[UIColor colorNamed:@"ZLBaseButtonBorderColor"].CGColor];
    [self.layer setBorderWidth:1/[UIScreen mainScreen].scale];
    [self.layer setCornerRadius:4.0];
    [self.layer setBackgroundColor:[UIColor colorNamed:@"ZLBaseButtonBackColor"].CGColor];
    
    self.titleLabel.textColor = [UIColor colorNamed:@"ZLBaseButtonTitleColor"];
  //  self.titleLabel.font = [UIFont fontWithName:Font_PingFangSCSemiBold size:11];
    
    [self setTitleColor:[UIColor colorNamed:@"ZLBaseButtonTitleColor"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorNamed:@"ZLBaseButtonTitleColor"] forState:UIControlStateSelected];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if(self.traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle) {
            [self.layer setBorderColor:[UIColor colorNamed:@"ZLBaseButtonBorderColor"].CGColor];
            [self.layer setBackgroundColor:[UIColor colorNamed:@"ZLBaseButtonBackColor"].CGColor];
            self.titleLabel.textColor = [UIColor colorNamed:@"ZLBaseButtonTitleColor"];
            self.titleLabel.font = [UIFont fontWithName:Font_PingFangSCSemiBold size:11];
            [self setTitleColor:[UIColor colorNamed:@"ZLBaseButtonTitleColor"] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor colorNamed:@"ZLBaseButtonTitleColor"] forState:UIControlStateSelected];
        }
    }
}

@end
