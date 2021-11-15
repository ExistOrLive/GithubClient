//
//  UIImage+IconFont.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/14.
//  Copyright © 2021 ZM. All rights reserved.
//

#import "UIImage+IconFont.h"
#import "UIFont+IconFont.h"
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (IconFont)

+ (UIImage *) iconFontImageWithText:(NSString *) text
                           fontSize:(CGFloat) size
                              Color:(UIColor *) color{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), YES, UIScreen.mainScreen.scale);
        
    UIFont *font = [UIFont iconFontWithSize:size];
    NSAttributedString* str = [[NSAttributedString alloc] initWithString:text
                                                              attributes:@{NSFontAttributeName:font,
                                                                           NSForegroundColorAttributeName:color}];
    [str drawAtPoint:CGPointMake(0, 0)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:image.CGImage
                               scale:UIScreen.mainScreen.scale
                         orientation:UIImageOrientationUp];
    
}
@end
