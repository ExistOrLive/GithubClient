//
//  UIImage+IconFont.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/14.
//  Copyright © 2021 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (IconFont)

+ (UIImage *) iconFontImageWithText:(NSString *)text fontSize:(CGFloat) size Color:(UIColor *) color;

@end

NS_ASSUME_NONNULL_END
