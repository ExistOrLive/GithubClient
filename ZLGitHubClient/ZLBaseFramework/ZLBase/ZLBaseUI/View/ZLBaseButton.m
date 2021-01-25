//
//  ZLBaseButton.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/21.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseButton.h"
#import "ZLBaseUIHeader.h"

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
   
    [self.layer setBorderColor:[ZLBaseUIConfig sharedInstance].buttonBorderColor.CGColor];
    [self.layer setBorderWidth:[ZLBaseUIConfig sharedInstance].buttonBorderWidth];
    [self.layer setCornerRadius:[ZLBaseUIConfig sharedInstance].buttonCornerRadius];
    [self setBackgroundColor:[ZLBaseUIConfig sharedInstance].buttonBackColor];
    
    self.titleLabel.textColor = [ZLBaseUIConfig sharedInstance].buttonTitleColor;
    [self setTitleColor:[ZLBaseUIConfig sharedInstance].buttonTitleColor forState:UIControlStateNormal];
    [self setTitleColor:[ZLBaseUIConfig sharedInstance].buttonTitleColor forState:UIControlStateSelected];
    

}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if(self.traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle) {
            [self.layer setBorderColor:[ZLBaseUIConfig sharedInstance].buttonBorderColor.CGColor];
            
            self.titleLabel.textColor = [ZLBaseUIConfig sharedInstance].buttonTitleColor;
            [self setTitleColor:[ZLBaseUIConfig sharedInstance].buttonTitleColor forState:UIControlStateNormal];
            [self setTitleColor:[ZLBaseUIConfig sharedInstance].buttonTitleColor forState:UIControlStateSelected];
        }
    }
}

@end
