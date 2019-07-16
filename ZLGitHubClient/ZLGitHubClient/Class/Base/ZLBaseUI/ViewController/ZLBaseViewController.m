//
//  ZLBaseViewController.m
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import "ZLBaseViewController.h"

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
    
}

- (void) viewWillAppear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewWillAppear at [%@]",self,[NSDate date]);
    [super viewWillAppear:animated];
    
    if([self.viewModel respondsToSelector:NSSelectorFromString(@"VCLifeCycle_viewWillAppear")])
    {
        [self.viewModel performSelector:NSSelectorFromString(@"VCLifeCycle_viewWillAppear")];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewDidAppear at [%@]",self,[NSDate date]);
    [super viewDidAppear:animated];
    
    if([self.viewModel respondsToSelector:NSSelectorFromString(@"VCLifeCycle_viewDidAppear")])
    {
        [self.viewModel performSelector:NSSelectorFromString(@"VCLifeCycle_viewDidAppear")];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewWillDisappear at [%@]",self,[NSDate date]);
    [super viewWillDisappear:animated];
    
    if([self.viewModel respondsToSelector:NSSelectorFromString(@"VCLifeCycle_viewWillDisappear")])
    {
        [self.viewModel performSelector:NSSelectorFromString(@"VCLifeCycle_viewWillDisappear")];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewDidDisappear at [%@]",self,[NSDate date]);
    [super viewDidDisappear:animated];
    
    if([self.viewModel respondsToSelector:NSSelectorFromString(@"VCLifeCycle_viewDidDisappear")])
    {
        [self.viewModel performSelector:NSSelectorFromString(@"VCLifeCycle_viewDidDisappear")];
    }
}

- (void)didReceiveMemoryWarning
{
    ZLLog_Info(@"ZLMonitor: [%@] didReceiveMemoryWarning at [%@]",self,[NSDate date]);
    [super didReceiveMemoryWarning];
    
    if([self.viewModel respondsToSelector:NSSelectorFromString(@"VCLifeCycle_didReceiveMemoryWarning")])
    {
        [self.viewModel performSelector:NSSelectorFromString(@"VCLifeCycle_didReceiveMemoryWarning")];
    }
 
}



#pragma mark - 设置Navigation Bar
- (void) setupNavigationBar:(NSString *) titleText
{
    self.title = titleText;
}

@end
