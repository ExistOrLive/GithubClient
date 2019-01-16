//
//  LCTextField.m
//  BuDeJie
//
//  Created by LongMac on 2018/7/28.
//  Copyright © 2018年 LongMac. All rights reserved.
//

#import "LCTextField.h"
#import "UITextField+PlaceHolder.h"

@implementation LCTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //设置光标的颜色为白色
    self.tintColor = [UIColor whiteColor];
    //编辑时的文字为白色, 监听事件的三种方式：1.delegate 2.通知 3.target
    [self addTarget:self action:@selector(textFieldBeginEdit) forControlEvents:UIControlEventEditingDidBegin];
    
    [self addTarget:self action:@selector(textFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
    
    //首先为灰色
    self.placeHolderColor = [UIColor grayColor];
}

- (void)textFieldBeginEdit
{
    self.placeHolderColor = [UIColor whiteColor];
    
    //设置placeHolder文字的颜色
//    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
//
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attr];
}

- (void)textFieldDidEndEditing
{
    self.placeHolderColor = [UIColor grayColor];
}


@end
