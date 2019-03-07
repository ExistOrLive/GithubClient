
//
//  ZLLoginLogoView.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/6.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import "ZLLoginLogoView.h"
#import "NSMutableAttributedString+ZLTextEngine.h"

@implementation ZLLoginLogoView

- (void) drawRect:(CGRect)rect
{
    UIImage * image = [UIImage imageNamed:@"icon.png"];

    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:@"Github"];
    
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:30]} range:NSMakeRange(0, [attributedString length])];
    
    CGSize size = [attributedString boundingRectWithWidth:CGFLOAT_MAX];
    
    if(self.isVertical)
    {
        CGFloat imageWidth =  CGRectGetHeight(self.frame) - size.height - 20;
        
        [image drawInRect:CGRectMake((CGRectGetWidth(self.frame) - imageWidth) / 2 , 0, imageWidth, imageWidth)];
        [attributedString drawAtPoint:CGPointMake((CGRectGetWidth(self.frame) - size.width) / 2,CGRectGetHeight(self.frame) - size.height)];
    }
    else
    {
        [image drawInRect:CGRectMake(20, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        [attributedString drawAtPoint:CGPointMake(40 + CGRectGetHeight(self.frame) , CGRectGetHeight(self.frame) - size.height)];
    }
}


- (void) setIsVertical:(BOOL)isVertical
{
    _isVertical = isVertical;
    [self setNeedsDisplay];
}
@end
