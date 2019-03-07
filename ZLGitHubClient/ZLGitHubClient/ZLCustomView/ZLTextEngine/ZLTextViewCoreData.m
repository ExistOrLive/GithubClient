//
//  ZLTextViewCoreData.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/5.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import "ZLTextViewCoreData.h"

@implementation ZLTextViewCoreData

- (instancetype) initWithAttributedString:(NSAttributedString *) attributedString
                           textFrameWidth:(CGFloat) width
{
    if(self = [super init])
    {
        [self parseAttribuedString:attributedString
                    textFrameWidth:width];
    }
    
    return self;
}


- (void) resetAttributedString:(NSAttributedString *) attributedString
                textFrameWidth:(CGFloat) width
{
    [self parseAttribuedString:attributedString
                textFrameWidth:width];
}


/**
 *
 * 计算高度，生成CTFrame
 **/
- (void) parseAttribuedString:(NSAttributedString *) attributedString
               textFrameWidth:(CGFloat) width
{
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), nil);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, width,suggestSize.height));
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, [attributedString length]), pathRef, NULL);
    
    CGPathRelease(pathRef);
    CFRelease(framesetterRef);
    
    if(_frameRef && _frameRef != frameRef)
    {
        CFRelease(_frameRef);
    }
    _frameRef = frameRef;
    _textViewHeight = suggestSize.height;
    _textViewWidth = width;
}


@end
