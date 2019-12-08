//
//  YKWImageTextPreview.h
//  YKWoodpecker
//
//  Created by Zim on 2018/11/13.
//  Copyright © 2018 Youku. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2019 Alibaba
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <UIKit/UIKit.h>

@interface YKWImageTextPreview : UIView

/**
 The UIImageView to show alike.
 */
@property (nonatomic, strong) UIImageView *sourceImageView;

/**
 Image to show.
 */
@property (nonatomic, strong) UIImage *image;

/**
 Text to show.
 */
@property (nonatomic, strong) NSString *text;

/**
 File path or url to load the text.
 */
@property (nonatomic, copy) NSString *textUrl;

- (void)show;
- (void)hide;

@end
