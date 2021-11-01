//
//  UIFont+ZLExtension.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/2.
//  Copyright © 2021 ZM. All rights reserved.
//

#import "UIFont+ZLExtension.h"

@implementation UIFont (ZLExtension)

+ (UIFont* _Nonnull) zlFontWithName:(NSString* _Nonnull) name size:(CGFloat) size{
    UIFont* font = [UIFont fontWithName:name size:size];
    if(font) {
        return font;
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont* _Nonnull) zlRegularFontWithSize: (CGFloat) size{
    return [self zlFontWithName:@"PingFang-SC-Regular" size:size];
}

+ (UIFont* _Nonnull) zlMediumFontWithSize: (CGFloat) size{
    return [self zlFontWithName:@"PingFang-SC-Medium" size:size];
}

+ (UIFont* _Nonnull) zlBoldFontWithSize: (CGFloat) size{
    return [self zlFontWithName:@"PingFang-SC-SemiBold" size:size];
}

@end
