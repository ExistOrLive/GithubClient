//
//  UIImage+Image.m
//  BuDeJie
//
//  Created by LongMac on 2018/12/30.
//  Copyright © 2018年 LongMac. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

/**
  返回未经渲染的原始图片
 */
+ (UIImage *)imageOriginalName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
