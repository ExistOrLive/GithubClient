//
//  UIImage+ZLExtension.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/8.
//  Copyright © 2021 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZLExtension)

#pragma mark - 创建shape图片

/**
 根据贝塞尔曲线创建图片
 */
+ (UIImage * _Nullable) imageWithFillColor:(UIColor * _Nullable) fillColor
                               strokeColor:(UIColor * _Nullable) strokeColor
                               strokeWidth:(CGFloat) stokeWidth
                                      size:(CGSize)size
                                      path:(UIBezierPath * _Nonnull)path;

/**
  圆形图片
 */
+ (UIImage * _Nullable) circleImageWithFillColor:(UIColor * _Nullable) fillColor
                                     strokeColor:(UIColor * _Nullable) strokeColor
                                     strokeWidth:(CGFloat) stokeWidth
                                          radius:(CGFloat)radius;

+ (UIImage * _Nullable) circleImageWithColor:(UIColor * _Nullable) color
                                      radius:(CGFloat)radius;


/**
   矩形图片
 */
+ (UIImage * _Nullable) rectangleImageWithFillColor:(UIColor * _Nullable) fillColor
                                        strokeColor:(UIColor * _Nullable) strokeColor
                                        strokeWidth:(CGFloat) stokeWidth
                                               size:(CGSize) size
                                       cornerRadius:(CGFloat)radius;

+ (UIImage * _Nullable) rectangleImageWithColor:(UIColor * _Nullable) Color
                                           size:(CGSize) size
                                   cornerRadius:(CGFloat) radius;



#pragma mark - 裁剪图片

/***
  @param size 新图片大小
  @param frame 图片的绘制范围
  @param path 截取的path
 */
- (UIImage * _Nullable) clipImageWithSize:(CGSize) size
                                 drawRect:(CGRect) frame
                                     path:(UIBezierPath * _Nonnull) path;


// 仅截图不修改图片大小
- (UIImage * _Nullable) clipImageWithPath:(UIBezierPath * _Nonnull) path;


// 修改图片大小 并 截图
- (UIImage * _Nullable) clipImageWithSize:(CGSize)size
                                     path:(UIBezierPath * _Nonnull) path;

// 图片圆角 图片大小不变
- (UIImage *) roundRectangleImageWithCornerRadius:(CGFloat) cornerRadius
                                           corner:(UIRectCorner) corner;


// 截取圆形 直径为 MIN(width,height)
- (UIImage *) circleImage;


// 截取圆形 并绘制为新的大小
- (UIImage *) circleImageWithRadius:(CGFloat) radius;



#pragma mark - resize图片

- (UIImage *) resizeImageWithSize:(CGSize) size;

@end

NS_ASSUME_NONNULL_END

