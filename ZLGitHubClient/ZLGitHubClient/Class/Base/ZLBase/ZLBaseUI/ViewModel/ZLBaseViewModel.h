//
//  ZLBaseViewModel.h
//  BiPinHui
//
//  Created by 朱猛 on 2019/6/26.
//  Copyright © 2019 zm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLBaseViewModel : NSObject

// VC 的直接VM用这个方法初始化
- (instancetype) initWithViewController:(UIViewController *) controller;


@property (nonatomic, weak, readonly) UIViewController * viewController;     // viewModel对应View所在的VC

@property (nonatomic, weak, readonly) ZLBaseViewModel * superViewModel;      // 父亲viewModel

@property (nonatomic, readonly) NSArray * subViewModels;      // 所有的子viewModel


/**
 * 添加子viewModel， 建立父子关系
 * @param subViewModel        子viewModel
 **/
- (void) addSubViewModel:(ZLBaseViewModel *) subViewModel;

- (void) removeFromSuperViewModel;

/**
 * 绑定 viewModel,View,model, 由superViewModel或者VC调用
 * @param targetModel        model
 * @param targetView         view
 **/
- (void) bindModel:(id _Nullable) targetModel andView:(UIView *) targetView;


/**
 * 子ViewModel给父vViewModel上报事件
 * @param event             事件内容
 * @param subViewModel      子viewModel
 **/
- (void) getEvent:(id _Nullable)event  fromSubViewModel:(ZLBaseViewModel *) subViewModel;

#pragma mark - VCLifeCycle

- (void) VCLifeCycle_viewWillAppear;

- (void) VCLifeCycle_viewDidAppear;

- (void) VCLifeCycle_viewWillDisappear;

- (void) VCLifeCycle_viewDidDisappear;

- (void) VCLifeCycle_didReceiveMemoryWarning;

@end

NS_ASSUME_NONNULL_END
