//
//  NSMutableAttributedString+ZLTextEngine.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/5.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (ZLTextEngine)

- (void) checkUrlWithAttributedString:(NSDictionary *) attributes;


+ (NSMutableAttributedString *) attributedStringWithText:(NSString *) textString
                                                    font:(UIFont *) font
                                     textForegroundColor:(UIColor *) foregroundColor
                                          paragraphStyle:(NSParagraphStyle *) paragraphStyle;


- (CGSize) boundingRectWithWidth:(CGFloat) width;

@end
