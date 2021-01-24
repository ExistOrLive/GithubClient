//
//  CYRangePickerPopoverView.h
//  gtihub
//
//  Created by ZM on 2019/10/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYRangePickerPopoverView : UIView

+ (void) showCYRangePickerPopoverWithTitle:(NSString *)title withDataArray1:(NSArray<NSString *> *)dataArray1  withDataArray2:(NSArray<NSString *> *)dataArray2 withResultBlock:(void(^)(int,int)) resultBlock;

@end

NS_ASSUME_NONNULL_END
