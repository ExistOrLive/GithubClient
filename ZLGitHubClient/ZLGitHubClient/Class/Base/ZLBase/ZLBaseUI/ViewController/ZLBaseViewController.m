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
    
@property(nonatomic, strong) NSMutableSet * realSubViewModels;

@end

@implementation ZLBaseViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.realSubViewModels = [NSMutableSet new];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder{
    if(self = [super initWithCoder:coder]) {
        self.realSubViewModels = [NSMutableSet new];
    }
    return self;
}

- (void)viewDidLoad
{
    ZLLog_Info(@"ZLMonitor: [%@] viewDidLoad at [%@]",self,[NSDate date]);
    [super viewDidLoad];
    
    // 初始化UI
    [self setBaseUpUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewWillAppear at [%@]",self,[NSDate date]);
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewWillAppear];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewDidAppear at [%@]",self,[NSDate date]);
    [super viewDidAppear:animated];

    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewDidAppear];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewWillDisappear at [%@]",self,[NSDate date]);
    [super viewWillDisappear:animated];
    
    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewWillDisappear];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    ZLLog_Info(@"ZLMonitor: [%@] viewDidDisappear at [%@]",self,[NSDate date]);
    [super viewDidDisappear:animated];
    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewDidDisappear];
    }
}

- (void)didReceiveMemoryWarning
{
    ZLLog_Info(@"ZLMonitor: [%@] didReceiveMemoryWarning at [%@]",self,[NSDate date]);
    [super didReceiveMemoryWarning];

    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_didReceiveMemoryWarning];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    if(size.height > size.width) {
        self.zlNavigationBar.isLandScape = false;
    } else {
        self.zlNavigationBar.isLandScape = true;
    }
    [self.zlNavigationBar setNeedsUpdateConstraints];
}


#pragma mark - 初始化UI

- (void) setBaseUpUI{
    
    self.view.backgroundColor = [UIColor colorNamed:@"ZLVCBackColor"];
    
    [self setUpCustomNavigationbar];
    
    [self setUpContentView];
}


#pragma mark - 设置Navigation Bar
// 这里不使用系统的UINavigationBar，自定义导航栏
- (void) setUpCustomNavigationbar{
    
    self.zlNavigationBar = [[ZLBaseNavigationBar alloc] init];
    [self.view addSubview:self.zlNavigationBar];
    [self.zlNavigationBar.backButton addTarget:self action:@selector(onBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.zlNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(ZLBaseNavigationBarHeight);
    }];
    
    if(self.navigationController == nil)   // 如果是model弹出
    {
        [self.zlNavigationBar setZlNavigationBarHidden:YES];
    }
    else
    {
        NSArray * controllers = self.navigationController.viewControllers;
        
        if(controllers.firstObject == self)  // 如果是UINavigationController的根VC
        {
            [self.zlNavigationBar.backButton setHidden:YES];
        }
        else
        {
            [self.zlNavigationBar.backButton setHidden:NO];
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
    [self.zlNavigationBar setZlNavigationBarHidden:hidden];
}

- (void) onBackButtonClicked:(UIButton *) button
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
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


#pragma mark - ZLBaseViewModel

- (ZLBaseViewController *) viewController{
    return self;
}

- (id<ZLBaseViewModel>) superViewModel{
    return nil;
}

- (NSArray *) subViewModels{
    return [_realSubViewModels allObjects];
}



/**
 * 添加子viewModel， 建立父子关系
 * @param subViewModel        子viewModel
 **/
- (void) addSubViewModel:(ZLBaseViewModel *) subViewModel
{
    if(!subViewModel){
        return;
    }
    [subViewModel setValue:self forKey:@"realSuperViewModel"];
    [self.realSubViewModels addObject:subViewModel];
}

- (void) addSubViewModels:(NSArray<ZLBaseViewModel *> *) subViewModels
{
    if(!subViewModels)
    {
        return;
    }
    [subViewModels setValue:self forKey:@"realSuperViewModel"];
    [self.realSubViewModels addObjectsFromArray:subViewModels];
}

- (void) removeSubViewModel:(ZLBaseViewModel *) subViewModel{
    if(!subViewModel){
        return;
    }
    if([self.realSubViewModels containsObject:subViewModel]){
        [subViewModel setValue:nil forKey:@"realSuperViewModel"];
        [self.realSubViewModels removeObject:subViewModel];
    }

}

/**
 * UIViewController 不需要
 */
- (void) removeFromSuperViewModel{
  
}

/**
 * 绑定 viewModel,View,model, 由superViewModel或者VC调用
 * @param targetModel           model
 * @param targetView         view
 **/
- (void) bindModel:(id) targetModel andView:(UIView *) targetView
{
    /**
     * code
     * 绑定 viewModel,View,model
     **/
}

/**
 * 子ViewModel给父vViewModel上报事件
 * @param event             事件内容
 * @param subViewModel      子viewModel
 **/
- (void) getEvent:(id)event  fromSubViewModel:(ZLBaseViewModel *) subViewModel
{
    /**
     * code
     * 父viewModel 处理event
     **/
}
@end


@implementation ZLBaseViewController(Tool)

+ (UIViewController *)getTopViewController{
    return [self getTopViewControllerFromWindow:[UIApplication sharedApplication].keyWindow];
}

+ (UIViewController *)getTopViewControllerFromWindow:(UIWindow *) window{
    return [self getTopViewControllerFromViewController:window.rootViewController];
}


+ (UIViewController *)getTopViewControllerFromViewController:(UIViewController *)rootVC{
    
    UIViewController *currentVC = nil;
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        
        // 根视图为UITabBarController
        currentVC = [self
                     getTopViewControllerFromViewController:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        
        // 根视图为UINavigationController
        currentVC =
        [self getTopViewControllerFromViewController:[(UINavigationController *)
                                rootVC visibleViewController]];
    } else if(currentVC.presentedViewController) {
        // 视图是被presented出来的
        rootVC = [self getTopViewControllerFromViewController:rootVC.presentedViewController];
    }
    else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
