//
//  UITextField+PlaceHolder.h
//  BuDeJie
//
//  Created by LongMac on 2018/7/28.
//  Copyright © 2018年 LongMac. All rights reserved.
//

#import <UIKit/UIKit.h>
/**分类使用property定义的属性只是声明，不会生成getter、setter方法的，需要自己实现**/
@interface UITextField (PlaceHolder)

@property (nonatomic, strong) UIColor *placeHolderColor;

@end
