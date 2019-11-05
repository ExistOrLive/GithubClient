//
//  CYSinglePickerView.h
//  gtihub
//
//  Created by ZM on 2019/10/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYSinglePickerPopoverView: UIView

+ (void) showCYSinglePickerPopoverWithTitle:(NSString *)title withInitIndex:(NSUInteger)initIndex withDataArray:(NSArray<NSString *> *)dataArray  withResultBlock:(void(^)(NSUInteger)) resultBlock;

@end

NS_ASSUME_NONNULL_END
