//
//  UIFont+ZLExtension.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/2.
//  Copyright © 2021 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 常用字体 weight
#define ZLFontKind_Italic               @"Italic"
#define ZLFontKind_Thin                 @"Thin"
#define ZLFontKind_Bold                 @"Bold"
#define ZLFontKind_BoldItalic           @"BoldItalic"
#define ZLFontKind_ThinItalic           @"ThinItalic"
#define ZLFontKind_Light                @"Light"
#define ZLFontKind_LightItalic          @"LightItalic"
#define ZLFontKind_Regular              @"Regular"
#define ZLFontKind_Medium               @"Medium"
#define ZLFontKind_MediumItalic         @"MediumItalic"
#define ZLFontKind_Semibold             @"Semibold"
#define ZLFontKind_CondensedBold        @"CondensedBold"
#define ZLFontKind_CondensedBlack       @"CondensedBlack"
#define ZLFontKind_Ultralight           @"Ultralight"
#define ZLFontKind_UltraLightItalic     @"UltraLightItalic"

// 常用字体 Family
#define ZLFontFamily_PingFangSC         @"PingFangSC"
#define ZLFontFamily_PingFangHK         @"PingFangHK"
#define ZLFontFamily_HelveticaNeue      @"HelveticaNeue"
#define ZLFontFamily_DINCondensed       @"DINCondensed"


@interface UIFont (ZLExtension)

#pragma mark - 非空 font

+ (UIFont* _Nonnull) zlFontWithName:(NSString* _Nonnull) name size:(CGFloat) size;

#pragma mark - PingFang-SC Font

+ (UIFont* _Nonnull) zlLightFontWithSize: (CGFloat) size;
+ (UIFont* _Nonnull) zlRegularFontWithSize: (CGFloat) size;
+ (UIFont* _Nonnull) zlMediumFontWithSize: (CGFloat) size;
+ (UIFont* _Nonnull) zlSemiBoldFontWithSize: (CGFloat) size;

#pragma mark - PingFang-SC Font

@end

NS_ASSUME_NONNULL_END
