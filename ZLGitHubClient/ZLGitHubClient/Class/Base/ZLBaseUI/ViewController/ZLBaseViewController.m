//
//  ZLBaseViewController.m
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import "ZLBaseViewController.h"

#import "ZLBaseNavigationBar.h"

#import "ZLBaseViewModel.h"


#import <objc/Runtime.h>
#import <objc/message.h>

@interface ZLBaseViewController ()



@end

@implementation ZLBaseViewController

- (void)viewDidLoad
{
    ZLLog_Info(@"ZLMonitor: [%@] viewDidLoad at [%@]",self,[NSDate date]);
    [super viewDidLoad];
    
    // 初始化UI
    [self setUpUI];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewWillAppear at [%@]",self,[NSDate date]);
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.viewModel VCLifeCycle_viewWillAppear];
}

- (void) viewDidAppear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewDidAppear at [%@]",self,[NSDate date]);
    [super viewDidAppear:animated];

    [self.viewModel VCLifeCycle_viewDidAppear];
}

- (void) viewWillDisappear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewWillDisappear at [%@]",self,[NSDate date]);
    [super viewWillDisappear:animated];
    
    [self.viewModel VCLifeCycle_viewWillDisappear];
}

- (void) viewDidDisappear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewDidDisappear at [%@]",self,[NSDate date]);
    [super viewDidDisappear:animated];
    
    [self.viewModel VCLifeCycle_viewDidDisappear];
}

- (void)didReceiveMemoryWarning
{
    ZLLog_Info(@"ZLMonitor: [%@] didReceiveMemoryWarning at [%@]",self,[NSDate date]);
    [super didReceiveMemoryWarning];

    [self.viewModel VCLifeCycle_didReceiveMemoryWarning];
}

#pragma mark - 初始化UI

- (void) setUpUI
{
    self.view.backgroundColor = ZLRGBStr_H(@"F6F6F6");
    
    [self setUpCustomNavigationbar];
    
    [self setUpContentView];
}


#pragma mark - 设置Navigation Bar
// 这里不使用系统的UINavigationBar，自定义导航栏
- (void) setUpCustomNavigationbar
{
    self.zlNavigationBar = [[ZLBaseNavigationBar alloc] init];
    [self.view addSubview:self.zlNavigationBar];
    
    [self.zlNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    
    if(self.navigationController == nil)   // 如果是model弹出
    {
        [self.zlNavigationBar setHidden:YES];
    }
    else
    {
        NSArray * controllers = self.navigationController.viewControllers;
        
        if(controllers.firstObject == self)  // 如果是UINavigationController的根VC
        {
            [self.zlNavigationBar.backButton setHidden:YES];
        }
    }
}

- (void) setTitle:(NSString *)title
{
    [super setTitle:title];
    [self.zlNavigationBar.titleLabel setText:title];
}


- (void) setZLNavigationBarHidden:(BOOL)hidden
{
    [self.zlNavigationBar setHidden:hidden];
}

#pragma mark - 设置contentView
- (void) setUpContentView
{
    self.contentView = [UIView new];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zlNavigationBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}


@end
