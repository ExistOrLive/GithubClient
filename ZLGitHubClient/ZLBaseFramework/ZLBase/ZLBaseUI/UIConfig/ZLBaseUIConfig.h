//
//  ZLBaseUIConfig.h
//  ZLBaseFramework
//
//  Created by 朱猛 on 2020/12/30.
//  Copyright © 2020 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLBaseUIConfig : NSObject

// iOS 13 后 建议Color 支持 dark mode

@property(nonatomic, strong) UIColor *navigationBarBackgoundColor;
@property(nonatomic, strong) UIColor *navigationBarTitleColor;
@property(nonatomic, strong) UIFont *navigationBarTitleFont;
@property(nonatomic, assign) CGFloat navigationBarHeight;

@property(nonatomic, strong) UIColor *viewControllerBackgoundColor;

@property(nonatomic, strong) UIColor *buttonBorderColor;
@property(nonatomic, strong) UIColor *buttonBackColor;
@property(nonatomic, strong) UIColor *buttonTitleColor;
@property(nonatomic, strong) UIFont *buttonTitleFont;
@property(nonatomic, assign) CGFloat buttonCornerRadius;
@property(nonatomic, assign) CGFloat buttonBorderWidth;

+ (instancetype) sharedInstance;

@end

NS_ASSUME_NONNULL_END
