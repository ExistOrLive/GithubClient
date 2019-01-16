//
//  LCLoginRegisterViewController.m
//  BuDeJie
//
//  Created by LongMac on 2018/7/22.
//  Copyright © 2018年 LongMac. All rights reserved.
//

#import "ZLLoginRegisterViewController.h"
#import "LCLoginRegisterView.h"
#import "LCFastLoginView.h"

@interface ZLLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet UIView *buttomView;



@end

@implementation ZLLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.一般冲xib中加载的view需要重新设置其尺寸
    LCLoginRegisterView *loginView = [LCLoginRegisterView loadLoginView];
    [_centerView addSubview:loginView];
    
    LCLoginRegisterView *registerView = [LCLoginRegisterView loadRegisterView];
    [_centerView addSubview:registerView];
    
    LCFastLoginView *fastLoginView = [LCFastLoginView fastLoginView];
    [_buttomView addSubview:fastLoginView];
}

//为了做自适应
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    LCLoginRegisterView *loginView = [self.centerView.subviews firstObject];
    loginView.frame = CGRectMake(0, 0, _centerView.lc_with * 0.5, _centerView.lc_heigh);
    
    LCLoginRegisterView *registerView = [self.centerView.subviews lastObject];
    registerView.frame = CGRectMake(_centerView.lc_with * 0.5, 0, _centerView.lc_with * 0.5, _centerView.lc_heigh);
    
    LCFastLoginView *fastLoginView = [_buttomView.subviews firstObject];
    fastLoginView.frame = _buttomView.bounds;
}

//关闭按钮点击
- (IBAction)closeButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//注册按钮点击
- (IBAction)registerButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    //切换
    _leftConstraint.constant = _leftConstraint.constant == 0 ? - _centerView.lc_with * 0.5 : 0;
    
    //重新布局
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
