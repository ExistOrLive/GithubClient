//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by LongMac on 2019/1/6.
//  Copyright © 2019年 LongMac. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setLc_with:(CGFloat)lc_with {
    CGRect rect = self.frame;
    rect.size.width = lc_with;
    self.frame = rect;
}

- (CGFloat)lc_with {
    return self.frame.size.width;
}

- (void)setLc_height:(CGFloat)lc_height {
    CGRect rect = self.frame;
    rect.size.height = lc_height;
    self.frame = rect;
}

- (CGFloat)lc_height {
    return self.frame.size.height;
}

- (void)setLc_x:(CGFloat)lc_x {
    CGRect rect = self.frame;
    rect.origin.x = lc_x;
    self.frame = rect;
}

- (CGFloat)lc_x {
    return self.frame.origin.x;
}

- (void)setLc_y:(CGFloat)lc_y {
    CGRect rect = self.frame;
    rect.origin.y = lc_y;
    self.frame = rect;
}

- (CGFloat)lc_y {
    return self.frame.origin.y;
}

@end
