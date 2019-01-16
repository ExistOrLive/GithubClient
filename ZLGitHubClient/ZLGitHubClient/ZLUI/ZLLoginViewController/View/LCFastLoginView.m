//
//  LCFastLoginView.m
//  BuDeJie
//
//  Created by LongMac on 2018/7/25.
//  Copyright © 2018年 LongMac. All rights reserved.
//

#import "LCFastLoginView.h"

@implementation LCFastLoginView

+ (instancetype)fastLoginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

@end
