//
//  UIFont+IconFont.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/14.
//  Copyright © 2021 ZM. All rights reserved.
//

#import "UIFont+IconFont.h"
#import "UIFont+ZLBase.h"
#import <CoreText/CoreText.h>
@implementation UIFont (IconFont)

+ (UIFont *) iconFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:[self iconFontName] size:size];
    if (font == nil) {
        NSURL *fontFileUrl = [[NSBundle mainBundle] URLForResource:[self iconFontName] withExtension:@"ttf"];
        NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[fontFileUrl path]], @"Font file doesn't exist");
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontFileUrl);
        CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
        CGDataProviderRelease(fontDataProvider);
        CTFontManagerRegisterGraphicsFont(newFont, nil);
        CGFontRelease(newFont);
        font = [UIFont fontWithName:[self iconFontName] size:size];
        NSAssert(font, @"UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.");
    }
    return font;
}

+ (NSString *) iconFontName{
    return @"iconfont";
}

+ (UIFont* _Nonnull) zlIconFontWithSize: (CGFloat) size{
    return [self iconFontWithSize:size];
}

@end
