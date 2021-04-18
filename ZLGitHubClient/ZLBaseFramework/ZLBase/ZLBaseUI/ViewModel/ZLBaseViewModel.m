//
//  ZLBaseViewModel.m
//  BiPinHui
//
//  Created by 朱猛 on 2019/6/26.
//  Copyright © 2019 zm. All rights reserved.
//

#import "ZLBaseViewModel.h"

@interface ZLBaseViewModel()

@property(nonatomic, strong) NSMutableSet * realSubViewModels;

@property(nonatomic, weak) ZLBaseViewModel * realSuperViewModel;

@end

@implementation ZLBaseViewModel

@dynamic subViewModels;
@dynamic viewController;
@dynamic superViewModel;

- (instancetype) init
{
    if(self = [super init])
    {
        _realSubViewModels = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark -

- (ZLBaseViewController *) viewController{
    return self.superViewModel.viewController;
}

- (id<ZLBaseViewModel>) superViewModel
{
    return _realSuperViewModel;
}

- (NSArray *) subViewModels
{
    return [_realSubViewModels allObjects];
}



/**
 * 添加子viewModel， 建立父子关系
 * @param subViewModel        子viewModel
 **/
- (void) addSubViewModel:(ZLBaseViewModel *) subViewModel
{
    if(!subViewModel)
    {
        return;
    }
    subViewModel.realSuperViewModel = self;
    [self.realSubViewModels addObject:subViewModel];
}

- (void) addSubViewModels:(NSArray<ZLBaseViewModel *> *) subViewModels{
    if(!subViewModels){
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
        subViewModel.realSuperViewModel = nil;
        [self.realSubViewModels removeObject:subViewModel];
    }
}

/**
 * 解除与父ViewModel之间的关系
 */
- (void) removeFromSuperViewModel{
    id<ZLBaseViewModel>  superViewModel = [self superViewModel];
    [superViewModel removeSubViewModel:self];
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
    // MARK: To do
    
    // [targetView fillWithData:self];
}


/**
 * 更新viewmodel 中绑定的model
 * @param targetModel        model
 * @param targetView         view
 **/
- (void) updateModel:(id _Nullable) targetModel{
    // MARK: To do
    // updateModel
    // [targetView reloadData];
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


#pragma mark - VCLifeCycle_viewWillAppear

- (void) VCLifeCycle_viewWillAppear
{
    for(id viewModel in self.subViewModels)
    {
        if([viewModel respondsToSelector:@selector(VCLifeCycle_viewWillAppear)])
        {
            [viewModel VCLifeCycle_viewWillAppear];
        }
    }
}

- (void) VCLifeCycle_viewDidAppear
{
    for(id viewModel in self.subViewModels)
    {
        if([viewModel respondsToSelector:@selector(VCLifeCycle_viewDidAppear)])
        {
            [viewModel VCLifeCycle_viewDidAppear];
        }
    }
}

- (void) VCLifeCycle_viewWillDisappear
{
    for(id viewModel in self.subViewModels)
    {
        if([viewModel respondsToSelector:@selector(VCLifeCycle_viewWillDisappear)])
        {
            [viewModel VCLifeCycle_viewWillDisappear];
        }
    }
}

- (void) VCLifeCycle_viewDidDisappear
{
    for(id viewModel in self.subViewModels)
    {
        if([viewModel respondsToSelector:@selector(VCLifeCycle_viewDidDisappear)])
        {
            [viewModel VCLifeCycle_viewDidDisappear];
        }
    }
}

- (void) VCLifeCycle_didReceiveMemoryWarning
{
    for(id viewModel in self.subViewModels)
    {
        if([viewModel respondsToSelector:@selector(VCLifeCycle_didReceiveMemoryWarning)])
        {
            [viewModel VCLifeCycle_didReceiveMemoryWarning];
        }
    }
}
@end
