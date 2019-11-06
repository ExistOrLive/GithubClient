//
//  CYInputPopoverView.h
//  gtihub
//
//  Created by ZM on 2019/10/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYInputPopoverTextField :UITextField

@end

@interface CYInputPopoverView : UIView

+ (void) showCYInputPopoverWithPlaceHolder:(NSString * _Nullable)placeHolder withResultBlock:(void(^)(NSString *)) resultBlock;

@end

NS_ASSUME_NONNULL_END
