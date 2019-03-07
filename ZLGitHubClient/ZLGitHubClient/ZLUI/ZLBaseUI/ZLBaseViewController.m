//
//  ZLBaseViewController.m
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import "ZLBaseViewController.h"

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
}

- (void) viewDidAppear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewDidAppear at [%@]",self,[NSDate date]);
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewWillDisappear at [%@]",self,[NSDate date]);
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewDidDisappear at [%@]",self,[NSDate date]);
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    ZLLog_Info(@"ZLMonitor: [%@] didReceiveMemoryWarning at [%@]",self,[NSDate date]);
    [super didReceiveMemoryWarning];
 
}



#pragma mark - 设置Navigation Bar
- (void) setupNavigationBar:(NSString *) titleText
{
    self.title = titleText;
}

@end
