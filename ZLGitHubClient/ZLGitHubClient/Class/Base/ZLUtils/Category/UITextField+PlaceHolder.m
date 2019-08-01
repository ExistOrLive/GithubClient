//
//  UITextField+PlaceHolder.m
//  BuDeJie
//
//  Created by LongMac on 2018/7/28.
//  Copyright © 2018年 LongMac. All rights reserved.
//

#import "UITextField+PlaceHolder.h"
#import <objc/message.h>

@implementation UITextField (PlaceHolder)

//方法的互换之操作一次
+ (void)load
{
    //方法分为实例方法和类方法
    Method setPlaceholder = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setLCPlaceholder = class_getInstanceMethod(self, @selector(setLCPlaceholder:));
    
    //交换两个方法的实现
    method_exchangeImplementations(setPlaceholder, setLCPlaceholder);
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    //使用runtime首先保存颜色
    objc_setAssociatedObject(self, @"placeHolderColor", placeHolderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //kvc, 重复复杂的东西就要封装
    UILabel *placeHolder = [self valueForKey:@"placeholderLabel"];
    placeHolder.textColor = placeHolderColor;
}

- (UIColor *)placeHolderColor
{
    UIColor *placeHolderColor = objc_getAssociatedObject(self, @"placeHolderColor");
    return placeHolderColor;
}

//这里就考虑到了方法的互换
- (void)setLCPlaceholder:(NSString *)placeholder
{
    [self setLCPlaceholder:placeholder];

    UILabel *placeHolder = [self valueForKey:@"placeholderLabel"];
    placeHolder.textColor = self.placeHolderColor;
}

@end
