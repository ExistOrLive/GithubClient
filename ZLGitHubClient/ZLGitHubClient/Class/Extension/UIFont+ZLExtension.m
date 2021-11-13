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

+ (NSSet *) allFontNames {
    static NSMutableSet *set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableSet set];
        NSArray *familyNames = [UIFont familyNames];
        for(NSString *family in familyNames){
            NSArray* fontName = [UIFont fontNamesForFamilyName:family];
            [set addObjectsFromArray:fontName];
        }
    });
    return set;
}

+ (NSString *) zlFontNameWithFontFamily:(NSString *) fontFamily fontKind:(NSString *) fontKind{
    NSString *fontName = [NSString stringWithFormat:@"%@-%@",fontFamily,fontKind];
    NSAssert([[self allFontNames] containsObject:fontName], @"Font %@ not exist",fontName);
    return fontName;
}


+ (UIFont* _Nonnull) zlLightFontWithSize: (CGFloat) size{
    NSString *fontName = [self zlFontNameWithFontFamily:ZLFontFamily_PingFangSC fontKind:ZLFontKind_Light];
    return [self zlFontWithName:fontName size:size];
}

+ (UIFont* _Nonnull) zlRegularFontWithSize: (CGFloat) size{
    NSString *fontName = [self zlFontNameWithFontFamily:ZLFontFamily_PingFangSC fontKind:ZLFontKind_Regular];
    return [self zlFontWithName:fontName size:size];
}

+ (UIFont* _Nonnull) zlMediumFontWithSize: (CGFloat) size{
    NSString *fontName = [self zlFontNameWithFontFamily:ZLFontFamily_PingFangSC fontKind:ZLFontKind_Medium];
    return [self zlFontWithName:fontName size:size];
}

+ (UIFont* _Nonnull) zlSemiBoldFontWithSize: (CGFloat) size{
    NSString *fontName = [self zlFontNameWithFontFamily:ZLFontFamily_PingFangSC fontKind:ZLFontKind_Semibold];
    return [self zlFontWithName:fontName size:size];
}




@end
