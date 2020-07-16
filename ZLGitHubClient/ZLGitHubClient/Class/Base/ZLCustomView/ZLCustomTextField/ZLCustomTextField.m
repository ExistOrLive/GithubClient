//
//  ZLCustomTextField.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/6.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLCustomTextField.h"

#define ZLTextFieldSingleLineHeight   1

#define ZLTextFieldLabelWidth         50

#define ZLTextFieldSpacing            10

@interface ZLCustomTextField()

@property(nonatomic,strong) UITextField * textField;

@property(nonatomic,strong) UILabel * label;

@property(nonatomic,strong) UIView * singleLineView;

@end

@implementation ZLCustomTextField

- (instancetype) init
{
    if(self = [super init])
    {
        self.textField = [[UITextField alloc] init];
        
        self.label = [[UILabel alloc] init];
        [self.label setTextColor:[UIColor blackColor]];
        [self.label setFont:[UIFont fontWithName:@"ArialMT" size:20]];
        
        self.singleLineView = [[UIView alloc] init];
        [self.singleLineView setBackgroundColor:[UIColor grayColor]];
        [self.singleLineView setAlpha:0.5];
        
        [self addSubview:self.textField];
        [self addSubview:self.label];
        [self addSubview:self.singleLineView];
    }
    
    return self;
}


- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.textField = [[UITextField alloc] init];
        
        self.label = [[UILabel alloc] init];
        [self.label setTextColor:[UIColor blackColor]];
        [self.label setFont:[UIFont fontWithName:@"ArialMT" size:20]];
        
        self.singleLineView = [[UIView alloc] init];
        [self.singleLineView setBackgroundColor:[UIColor grayColor]];
        [self.singleLineView setAlpha:0.5];
        
        [self addSubview:self.textField];
        [self addSubview:self.label];
        [self addSubview:self.singleLineView];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.textField = [[UITextField alloc] init];
        
        self.label = [[UILabel alloc] init];
        [self.label setTextColor:[UIColor blackColor]];
        [self.label setFont:[UIFont fontWithName:@"ArialMT" size:20]];
        
        self.singleLineView = [[UIView alloc] init];
        [self.singleLineView setBackgroundColor:[UIColor grayColor]];
        [self.singleLineView setAlpha:0.5];
        
        [self addSubview:self.textField];
        [self addSubview:self.label];
        [self addSubview:self.singleLineView];
    }
    return self;
}




- (void) layoutSubviews
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    [self.singleLineView setFrame:CGRectMake(0, height - ZLTextFieldSingleLineHeight, width, ZLTextFieldSingleLineHeight)];
    
    CGFloat labelWidth = 0;
    if([_label.text length])
    {
        labelWidth = ZLTextFieldLabelWidth;
    }
    [self.label setFrame:CGRectMake(0, 0, labelWidth , height / 3 * 2)];
    
    [self.textField setFrame:CGRectMake(labelWidth + ZLTextFieldSpacing,0 , width - labelWidth - ZLTextFieldSpacing  , height / 3 * 2)];
    
}


- (void) setTextFieldLabelStr:(NSString *) text
{
    self.label.text = text;
    [self setNeedsLayout];
}

- (void) setPlaceholder:(NSString *) placeholder
{
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont fontWithName:@"ArialMT" size:18]}];
    [self.textField setAttributedPlaceholder:string];
}


- (BOOL)resignFirstResponder
{
    return [self endEditing:true];
}
@end
