//
//  UIColor+HexColor.m
//  ZLGithubClient
//
//  Created by 谢威彦 on 2019/6/11.
//  Copyright © 2019 zm. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)
+(UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity{
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}

+(UIColor*)colorWithRGB:(NSUInteger)hex
                  alpha:(CGFloat)alpha{
    float r, g, b, a;
    a = alpha;
    b = hex & 0x0000FF;
    hex = hex >> 8;
    g = hex & 0x0000FF;
    hex = hex >> 8;
    r = hex;
    
    return [UIColor colorWithRed:r/255.0f
                           green:g/255.0f
                            blue:b/255.0f
                           alpha:a];
}



+ (BOOL) isLightColor:(UIColor*)clr {
    CGFloat components[3];
    [self getRGBComponents:components forColor:clr];     
    CGFloat num = components[0] + components[1] + components[2];
    if(num < 382)
        return NO;
    else
        return YES;
}


//获取RGB值
+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
     
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 bitmapInfo);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
     
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component];
    }
}

#pragma mark - Name Color

+ (UIColor* _Nonnull) labelColorWithName:(NSString * _Nonnull) name{
    UIColor *color = [UIColor colorNamed:name];
    if(color) {
        return color;
    } else {
        if (@available(iOS 13.0, *)) {
            return [UIColor labelColor];
        } else {
            return [UIColor blackColor];
        }
    }
}


+ (UIColor* _Nonnull) linkColorWithName:(NSString * _Nonnull) name{
    UIColor *color = [UIColor colorNamed:name];
    if(color) {
        return color;
    } else {
        if (@available(iOS 13.0, *)) {
            return [UIColor linkColor];
        } else {
            return [UIColor systemBlueColor];
        }
    }
}


+ (UIColor* _Nonnull) backColorWithName:(NSString * _Nonnull) name{
    UIColor *color = [UIColor colorNamed:name];
    if(color) {
        return color;
    } else {
        if (@available(iOS 13.0, *)) {
            return [UIColor systemBackgroundColor];
        } else {
            return [UIColor systemGrayColor];
        }
    }
}


@end
