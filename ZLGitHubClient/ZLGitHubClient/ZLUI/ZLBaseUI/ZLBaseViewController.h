//
//  ZLBaseViewController.h
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLBaseViewController : UIViewController

#pragma mark -


@property (assign, nonatomic ) BOOL isNavigated;   // 进入方式，是否通过NavigationBar

#pragma mark - 设置Navigation Bar
- (void) setupNavigationBar:(NSString *) titleText;


@end
