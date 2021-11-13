//
//  UIColor+ZLExtension.h
//  ZLGithubClient
//
//  Created by zm on 2019/6/11.
//  Copyright © 2019 zm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZLExtension)

#pragma mark - UIColor Hex

/**16进制颜色转换为UIColor
 *hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 *opacity 透明度
 *返回16进制字符串对应的颜色
 */
+(UIColor* _Nullable)colorWithHexString:(NSString * _Nonnull)hexColor alpha:(float)opacity;

/**十六进制数值转换为UIColor
 */
+(UIColor* _Nullable)colorWithRGB:(NSUInteger)hex
                  alpha:(CGFloat)alpha;


#pragma mark - UIColor Appearance
+ (BOOL) isLightColor:(UIColor* _Nonnull)clr;


#pragma mark - UIColor name

+ (UIColor* _Nonnull) labelColorWithName:(NSString * _Nonnull) name;

+ (UIColor* _Nonnull) linkColorWithName:(NSString * _Nonnull) name;

+ (UIColor* _Nonnull) backColorWithName:(NSString * _Nonnull) name;

@end
