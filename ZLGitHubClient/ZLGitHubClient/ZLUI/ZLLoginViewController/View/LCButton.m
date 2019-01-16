//
//  LCButton.m
//  BuDeJie
//
//  Created by LongMac on 2018/7/27.
//  Copyright © 2018年 LongMac. All rights reserved.
//

#import "LCButton.h"
#import "UIView+Frame.h"

@implementation LCButton

//重新布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    //布局按钮
//    self.imageView.lc_y = 0;
//    self.imageView.lc_center_x = self.lc_with * 0.5;   //约束外面就有了，所以就不用在设置了
//    
//    self.titleLabel.lc_y = self.lc_heigh - self.titleLabel.lc_heigh;
//    [self.titleLabel sizeToFit];
//    
//    self.titleLabel.lc_center_x  = self.lc_with * 0.5;
}

@end
