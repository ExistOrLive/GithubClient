//
//  ZLTextView.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/5.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import "ZLTextView.h"
#import "ZLTextViewCoreData.h"

@interface ZLTextView()

@end

@implementation ZLTextView


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if(!self.coreData || !self.coreData.frameRef)
    {
        ZLLog_Debug(@"ZLTextView_drawRect: coredata is nil");
        return;
    }

    /**
     *
     * 1、调整坐标系，Core Graphics 坐标系原点在右下角， UIKit 原点在右上角
     **/
      CGContextRef contextRef = UIGraphicsGetCurrentContext();
      CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
      CGContextTranslateCTM(contextRef, 0 , CGRectGetHeight(rect));
      CGContextScaleCTM(contextRef, 1.0 , -1.0);

    CTFrameDraw(self.coreData.frameRef, contextRef);
    
    
}



- (void)setCoreData:(ZLTextViewCoreData *)coreData
{
    _coreData = coreData;
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), _coreData.textViewHeight);
    [self setNeedsDisplay];
}


@end
