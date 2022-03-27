//
//  UIImage+ZLExtension.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/8.
//  Copyright © 2021 ZM. All rights reserved.
//

#import "UIImage+ZLExtension.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (ZLExtension)

#pragma mark - 创建shape图片

// shape 纯色图片
+ (UIImage *) imageWithFillColor:(UIColor *) fillColor
                     strokeColor:(UIColor *) strokeColor
                     strokeWidth:(CGFloat) stokeWidth
                            size:(CGSize)size
                            path:(UIBezierPath *)path{
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef,stokeWidth);
    [fillColor setFill];
    [strokeColor setStroke];
    [path fill];
    [path stroke];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // UIImage的size以逻辑像素为单位， 与图片的实际像素和图片的scale有关
    return [UIImage imageWithCGImage:image.CGImage scale:UIScreen.mainScreen.scale orientation:UIImageOrientationUp];
}


+ (UIImage * _Nullable) circleImageWithFillColor:(UIColor *) fillColor
                                     strokeColor:(UIColor *) strokeColor
                                     strokeWidth:(CGFloat) stokeWidth
                                          radius:(CGFloat)radius{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2 * radius, 2 * radius)
                                                    cornerRadius:radius];
    
    return [self imageWithFillColor:fillColor
                        strokeColor:strokeColor
                        strokeWidth:stokeWidth
                               size:CGSizeMake(2 * radius, 2 * radius)
                               path:path];
}

+ (UIImage * _Nullable) circleImageWithColor:(UIColor *) color
                                      radius:(CGFloat)radius{
    return [self circleImageWithFillColor:color
                              strokeColor:nil
                              strokeWidth:0
                                   radius:radius];
}


+ (UIImage * _Nullable) rectangleImageWithFillColor:(UIColor *) fillColor
                                        strokeColor:(UIColor *) strokeColor
                                        strokeWidth:(CGFloat) stokeWidth
                                               size:(CGSize) size
                                       cornerRadius:(CGFloat)radius{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height)
                                                    cornerRadius:radius];
    
    return [self imageWithFillColor:fillColor
                        strokeColor:strokeColor
                        strokeWidth:stokeWidth
                               size:size
                               path:path];
}

+ (UIImage * _Nullable) rectangleImageWithColor:(UIColor *) color
                                           size:(CGSize) size
                                   cornerRadius:(CGFloat) radius{
    return [self rectangleImageWithFillColor:color
                                 strokeColor:nil
                                 strokeWidth:0
                                        size:size
                                cornerRadius:radius];
}


#pragma mark - 裁剪图片

/***
  @param size 新图片大小
  @param frame 图片的绘制范围
  @param path 截取的path
 */
- (UIImage * _Nullable) clipImageWithSize:(CGSize) size
                                 drawRect:(CGRect) frame
                                     path:(UIBezierPath * _Nonnull) path{
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    [path addClip];
    [self drawInRect:frame];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage imageWithCGImage:image.CGImage scale:UIScreen.mainScreen.scale orientation:UIImageOrientationUp];
}



// 仅截图不修改图片大小
- (UIImage * _Nullable) clipImageWithPath:(UIBezierPath * _Nonnull) path{
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    [path addClip];
    [self drawAtPoint:CGPointZero];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage imageWithCGImage:image.CGImage scale:UIScreen.mainScreen.scale orientation:UIImageOrientationUp];
}


// 修改图片大小 并 截图
- (UIImage * _Nullable) clipImageWithSize:(CGSize)size
                                     path:(UIBezierPath * _Nonnull) path{
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    [path addClip];
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage imageWithCGImage:image.CGImage scale:UIScreen.mainScreen.scale orientation:UIImageOrientationUp];
}


// 图片圆角 图片大小不变
- (UIImage *) roundRectangleImageWithCornerRadius:(CGFloat) cornerRadius
                                           corner:(UIRectCorner) corner{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.size.width, self.size.height)
                                               byRoundingCorners:corner
                                                     cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    return [self clipImageWithPath:path];
}


// 截取圆形 直径为 MIN(width,height)
- (UIImage *) circleImage{
    CGFloat radius = MIN(self.size.width, self.size.height) / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                        radius:radius
                                                    startAngle:0
                                                      endAngle: 2 * M_PI
                                                     clockwise:true];
    return [self clipImageWithSize:CGSizeMake(2 * radius, 2 * radius)
                          drawRect:CGRectMake(radius - self.size.width / 2, radius - self.size.height / 2, self.size.width, self.size.height)
                              path:path];
    
}


// 截取圆形 并绘制为新的大小
- (UIImage *) circleImageWithRadius:(CGFloat) radius {
    CGFloat originRadius = MIN(self.size.width, self.size.height) / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                        radius:radius
                                                    startAngle:0
                                                      endAngle: 2 * M_PI
                                                     clockwise:true];
    return [self clipImageWithSize:CGSizeMake(2 * radius, 2 * radius)
                          drawRect:CGRectMake(radius - self.size.width * radius / originRadius / 2,
                                              radius - self.size.height * radius / originRadius / 2,
                                              self.size.width * radius / originRadius,
                                              self.size.height * radius / originRadius)
                              path:path];
    
}


#pragma mark - resize图片

- (UIImage *) resizeImageWithSize:(CGSize) size {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // UIImage的size以逻辑像素为单位， 与图片的实际像素和图片的scale有关
    return [UIImage imageWithCGImage:image.CGImage scale:UIScreen.mainScreen.scale orientation:UIImageOrientationUp];
}

#pragma mark - 

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
