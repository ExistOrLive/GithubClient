//
//  ZLLoginViewController.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/3/4.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import "ZLLoginViewController.h"

#import "ZLLoginLogoView.h"
#import "ZLCustomTextField.h"

@interface ZLLoginViewController ()

@property(nonatomic,strong) ZLLoginLogoView * logoView;

@property(nonatomic,strong) ZLCustomTextField * userIdField;

@property(nonatomic,strong) ZLCustomTextField * passWordField;


@end

@implementation ZLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpLogoView];
    
    [self setUpTextField];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init view

- (void) setUpLogoView
{
    self.logoView = [[ZLLoginLogoView alloc] initWithFrame:CGRectMake(0, ZLStatusBarHeight + 20 , ZLScreenWidth, 100)];
    [self.logoView setBackgroundColor:[UIColor whiteColor]];
    [self.logoView setIsVertical:YES];
    [self.view addSubview:self.logoView];
}

- (void) setUpTextField
{
    self.userIdField = [[ZLCustomTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.logoView.frame) + 50 ,ZLScreenWidth - 40 , 40)];
    [self.userIdField setPlaceholder:@"邮箱／手机号"];
    [self.userIdField setTextFieldLabelStr:@"账号"];
    
    self.passWordField = [[ZLCustomTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.userIdField.frame) + 20 ,ZLScreenWidth - 40 , 40)];
    [self.passWordField setPlaceholder:@"请输入密码"];
    [self.passWordField setTextFieldLabelStr:@"密码"];
    
    [self.view addSubview:self.userIdField];
    [self.view addSubview:self.passWordField];
}

@end
