//
//  CYInputPopoverView.m
//  gtihub
//
//  Created by ZM on 2019/10/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "CYInputPopoverView.h"


@implementation CYInputPopoverTextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(16,0,bounds.size.width,bounds.size.height);
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(16,0,bounds.size.width,bounds.size.height);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(0,0,16.0,bounds.size.height);
}

@end


@interface CYInputPopoverView() <UIGestureRecognizerDelegate,UITextFieldDelegate>

@property(nonatomic,strong) CYInputPopoverTextField * textFiled;

@property(nonatomic,strong) UIButton * comfirmButton;

@property(nonatomic,copy) void(^ resultBlock)(NSString *);

@end

@implementation CYInputPopoverView


+ (void) showCYInputPopoverWithPlaceHolder:(NSString *)placeHolder withResultBlock:(void(^)(NSString *)) resultBlock
{
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    
    CYInputPopoverView *  InputPopover = [[CYInputPopoverView alloc] initWithFrame:window.bounds];
    [InputPopover setBackgroundColor:LZRGBAValue_H(0x000000, 0.5)];
    InputPopover.resultBlock = resultBlock;
    if(placeHolder)
    {
        InputPopover.textFiled.placeholder = placeHolder;
    }
    
    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:InputPopover action:@selector(onCloseAction)];
    gestureRecognizer.delegate = InputPopover;
    [InputPopover addGestureRecognizer:gestureRecognizer];
    
    [window addSubview:InputPopover];
    [window makeKeyAndVisible];
}

- (void) onCloseAction
{
    [self removeFromSuperview];
}


#pragma mark - init

- (instancetype) init
{
    if(self = [super init])
    {
        [self createUI];
    }
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder
{
    if(self = [super initWithCoder:coder])
    {
        [self createUI];
    }
    
    return self;
}

- (void) createUI
{
    UIView * containerView = [UIView new];
    [containerView setBackgroundColor:[UIColor whiteColor]];
    containerView.layer.cornerRadius = 8.0;
    
    // _textFiled
    _textFiled = [CYInputPopoverTextField new];
    [_textFiled setLeftViewMode:UITextFieldViewModeAlways];
    [_textFiled setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 10)]];
    [_textFiled setBorderStyle:UITextBorderStyleNone];
    [_textFiled setBackgroundColor:LZRGBValue_H(0xF9F9F9)];
    _textFiled.layer.borderColor = LZRGBValue_H(0xEEEEEE).CGColor;
    _textFiled.layer.borderWidth = 1;
    _textFiled.layer.cornerRadius = 4;
    _textFiled.delegate = self;
    
    [containerView addSubview:_textFiled];
    [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_top).with.offset(24);
        make.centerX.equalTo(containerView.mas_centerX);
        make.width.equalTo(@232);
        make.height.equalTo(@40);
    }];
    
    _comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString * attributedTitle = [[NSAttributedString alloc] initWithString:@"确认" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [_comfirmButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [_comfirmButton setBackgroundImage:[UIImage imageNamed:@"Popover_inputbtn_disabled"] forState:UIControlStateDisabled];
    [_comfirmButton setBackgroundImage:[UIImage imageNamed:@"Popover_btn_normal"] forState:UIControlStateNormal];
    [_comfirmButton setEnabled:NO];
    [_comfirmButton addTarget:self action:@selector(onConfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:_comfirmButton];
    
    [_comfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(containerView.mas_bottom).with.offset(-32);
        make.centerX.equalTo(containerView.mas_centerX);
    }];
    
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@280);
        make.height.equalTo(@152);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

- (void) onConfirmButtonClicked:(UIButton *) button
{
    if(self.resultBlock)
    {
        self.resultBlock(self.textFiled.text);
    }
    
    [self removeFromSuperview];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(touch.view != self)
    {
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * oldText = textField.text;
    NSString * newText = nil;
    if(oldText)
    {
        newText = [oldText stringByReplacingCharactersInRange:range withString:string];
    }
    else
    {
        newText = string;
    }
    
    if([newText length] > 20)
    {
        return NO;
    }
    
    if([newText length] == 0)
    {
        [self.comfirmButton setEnabled:NO];
    }
    else
    {
        [self.comfirmButton setEnabled:YES];
    }
    
    return YES;
}

@end
