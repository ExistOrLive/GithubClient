//
//  ZLBaseNavigationController.m
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import "ZLBaseNavigationController.h"

@interface ZLBaseNavigationController () <UIGestureRecognizerDelegate>
{
    UIScreenEdgePanGestureRecognizer * _ScreenEdgePanGestureRecognizer;
}

@end

@implementation ZLBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCustomPopGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 右滑手势支持

- (void) setUpCustomPopGestureRecognizer
{
    /**
     * 当不使用系统的返回按钮，右滑手势interactivePopGestureRecognizer将会失效
     * 这里创建UIScreenEdgePanGestureRecognizer 实现右滑 target 和 delegate 均为interactivePopGestureRecognizer.delegate
     **/
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
   
    UIScreenEdgePanGestureRecognizer * recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    recognizer.edges = UIRectEdgeLeft;
    recognizer.delegate = self.interactivePopGestureRecognizer.delegate;
    [self.view addGestureRecognizer:recognizer];
    [[super interactivePopGestureRecognizer] setEnabled:NO];
    
    _ScreenEdgePanGestureRecognizer = recognizer;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
