//
//  CYDatePickerView.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/11/2.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYDatePickerView : UIView

+ (void) showCYDatePickerPopoverWithTitle:(NSString *)title  withYearRange:(NSRange) range withResultBlock:(void(^)(NSDate *)) resultBlock;

@end

NS_ASSUME_NONNULL_END
