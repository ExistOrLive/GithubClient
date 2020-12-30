//
//  ZLBaseUIHeader.h
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#ifndef ZLBaseUIHeader_h
#define ZLBaseUIHeader_h

#import "UIView+HJViewStyle.h"
#import "UIColor+HexColor.h"

#import "ZLBaseUIConfig.h"

#import "ZLBaseViewController.h"
#import "ZLBaseNavigationController.h"
#import "ZLBaseTabBarController.h"

#import "ZLBaseView.h"
#import "ZLBaseButton.h"
#import "ZLBaseNavigationBar.h"

#import "ZLBaseViewModel.h"

#import "ZLBaseObject.h"

#pragma mark - Scale

#define ZLScreenScale       [UIScreen mainScreen].scale

#define ZLScreenHeight      [UIScreen mainScreen].bounds.size.height
#define ZLScreenWidth       [UIScreen mainScreen].bounds.size.width
#define ZLScreenBounds      [UIScreen mainScreen].bounds

#define ZLStatusBarHeight CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)

#define ZLKeyWindowHeight [UIApplication sharedApplication].keyWindow.frame.size.height
#define ZLKeyWindowWidth  [UIApplication sharedApplication].keyWindow.frame.size.width

#pragma mark - ZLColor

#define ZLRGBValue_H(colorValue) [UIColor colorWithRGB:colorValue alpha:1.0]
#define ZLRGBAValue_H(colorValue,alphaValue) [UIColor colorWithRGB:colorValue alpha:alphaValue]
#define ZLRGBStr_H(colorStr) [UIColor colorWithHexString:colorStr alpha:1.0]
#define ZLRawColor(colorName) [UIColor colorWithCGColor:[UIColor colorNamed:colorName].CGColor]


#pragma mark - font

#define Font_PingFangSCMedium @"PingFang-SC-Medium"
#define Font_PingFangSCSemiBold @"PingFang-SC-SemiBold"
#define Font_PingFangSCRegular @"PingFang-SC-Regular"


#endif /* ZLBaseUIHeader_h */
