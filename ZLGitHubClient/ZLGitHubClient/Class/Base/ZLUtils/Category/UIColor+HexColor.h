//
//  UIColor+HexColor.h
//  ZLGithubClient
//
//  Created by 谢威彦 on 2019/6/11.
//  Copyright © 2019 zm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
/**16进制颜色转换为UIColor
 *hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 *opacity 透明度
 *返回16进制字符串对应的颜色
 */
+(UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity;

/**十六进制数值转换为UIColor
 */
+(UIColor*)colorWithRGB:(NSUInteger)hex
                  alpha:(CGFloat)alpha;
@end
