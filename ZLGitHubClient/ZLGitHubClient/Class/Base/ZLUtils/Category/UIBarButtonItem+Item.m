//
//  UIBarButtonItem+Item.m
//  BuDeJie
//
//  Created by LongMac on 2019/1/6.
//  Copyright © 2019年 LongMac. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highlightedImage:(UIImage *)highImage target:(id)target action:(SEL)action {
    UIButton *gameButton = [[UIButton alloc] init];
    [gameButton setImage:image forState:UIControlStateNormal];
    [gameButton setImage:highImage forState:UIControlStateHighlighted];
    [gameButton sizeToFit];
    [gameButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containView = [[UIView alloc] initWithFrame:gameButton.bounds];
    [containView addSubview:gameButton];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containView];
    return leftBarButtonItem;
}

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action {
    UIButton *gameButton = [[UIButton alloc] init];
    [gameButton setImage:image forState:UIControlStateNormal];
    [gameButton setImage:selectedImage forState:UIControlStateSelected];
    [gameButton sizeToFit];
    [gameButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containView = [[UIView alloc] initWithFrame:gameButton.bounds];
    [containView addSubview:gameButton];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containView];
    return leftBarButtonItem;
}

+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title {
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitle:title forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [backButton sizeToFit];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

@end
