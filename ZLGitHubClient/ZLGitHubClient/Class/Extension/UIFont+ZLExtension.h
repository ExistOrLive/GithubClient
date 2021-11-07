//
//  UIFont+ZLExtension.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/2.
//  Copyright © 2021 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (ZLExtension)

#pragma mark - 非空 font

+ (UIFont* _Nonnull) zlFontWithName:(NSString* _Nonnull) name size:(CGFloat) size;


#pragma mark - PingFang-SC Font

+ (UIFont* _Nonnull) zlRegularFontWithSize: (CGFloat) size;
+ (UIFont* _Nonnull) zlMediumFontWithSize: (CGFloat) size;
+ (UIFont* _Nonnull) zlSemiBoldFontWithSize: (CGFloat) size;

@end

NS_ASSUME_NONNULL_END
