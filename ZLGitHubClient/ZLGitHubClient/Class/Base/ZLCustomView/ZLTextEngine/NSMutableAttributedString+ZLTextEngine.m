//
//  NSMutableAttributedString+ZLTextEngine.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/5.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "NSMutableAttributedString+ZLTextEngine.h"
#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString (ZLTextEngine)

- (void) checkUrlWithAttributedString:(NSDictionary *) attributes
{
    NSError * error = nil;
    NSRegularExpression * regularExpression = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:NSRegularExpressionCaseInsensitive  error:&error];
    
    if(!error)
    {
        [regularExpression enumerateMatchesInString:self.string options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            [self addAttributes:attributes range:result.range];
        }];
    }
    else
    {
        NSLog(@"checkUrlWithAttributedString error:%@",[error localizedDescription]);
    }
    
}


+ (NSMutableAttributedString *) attributedStringWithText:(NSString *) textString
                                                    font:(UIFont *) font
                                     textForegroundColor:(UIColor *) foregroundColor
                                          paragraphStyle:(NSParagraphStyle *) paragraphStyle
{
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:textString];
    
    if(font)
    {
        [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attributeString length])];
    }
    
    if(foregroundColor)
    {
        [attributeString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:NSMakeRange(0, [attributeString length])];
    }
    
    if(paragraphStyle)
    {
        [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributeString length])];
    }
    
    return attributeString;
}


- (CGSize) boundingRectWithWidth:(CGFloat) width
{
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), nil);
    
    CFRelease(framesetterRef);
    
    return suggestSize;
}

@end
