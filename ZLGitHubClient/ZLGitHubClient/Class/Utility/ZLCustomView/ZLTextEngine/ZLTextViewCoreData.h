//
//  ZLTextViewCoreData.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/5.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface ZLTextViewCoreData : NSObject

@property(nonatomic,assign,readonly) CGFloat textViewHeight;

@property(nonatomic,assign,readonly) CGFloat textViewWidth;

@property(nonatomic,assign,readonly) CTFrameRef frameRef;


- (instancetype) initWithAttributedString:(NSAttributedString *) attributedString
                           textFrameWidth:(CGFloat) width;


- (void) resetAttributedString:(NSAttributedString *) attributedString
                textFrameWidth:(CGFloat) width;

@end
