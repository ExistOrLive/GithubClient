
//
//  ZMRefreshManager.m
//  iCenter
//
//  Created by panzhengwei on 2018/9/26.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import "ZMRefreshManager.h"
#import "ZMRefreshView.h"
#import "ZMRefreshConfig.h"




@interface ZMRefreshManager()

@property(nonatomic,weak) UIScrollView * scrollView;

@property(nonatomic,strong) ZMRefreshView * headerView;

@property(nonatomic,strong) ZMRefreshView * footerView;

@property(nonatomic,assign) CGPoint initScrollViewOffset;

@end

@implementation ZMRefreshManager

#pragma mark - 初始化和释放
- (instancetype) initWithScrollView:(UIScrollView *) scrollView addHeaderView:(BOOL) addHeaderView addFooterView:(BOOL)addFooterView
{
    if(self = [super init])
    {
        _scrollView = scrollView;
        
        if(!_scrollView)
        {
            return nil;
        }
        
        _initScrollViewOffset = _scrollView.contentOffset;
        
        CGRect scrollViewRect = scrollView.frame;
        
        if(addHeaderView)
        {
            _headerView = [[ZMRefreshView alloc] initWithFrame:CGRectMake(0,0 - ZMRefreshViewHeight, scrollViewRect.size.width, ZMRefreshViewHeight) IsHeaderView:YES];
            [_scrollView addSubview:_headerView];
        }
        
        if(addFooterView)
        {
            _footerView = [[ZMRefreshView alloc] initWithFrame:CGRectMake(0, scrollViewRect.size.height, scrollViewRect.size.width, ZMRefreshViewHeight) IsHeaderView:NO];
            [_scrollView addSubview:_footerView];
        }
        
        [_scrollView addObserver:self forKeyPath:KVOContentSize options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
        [_scrollView addObserver:self forKeyPath:KVOContentOffset options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
        
   
        
    }
    
    return self;
    
}

- (void) freeFooterView
{
    [_footerView removeFromSuperview];
    _footerView = nil;
}

- (void) freeHeaderView
{
    [_headerView removeFromSuperview];
    _headerView = nil;
}


- (void) free
{
    [_headerView removeFromSuperview];
    [_footerView removeFromSuperview];
    _headerView = nil;
    _footerView = nil;

    [_scrollView removeObserver:self forKeyPath:KVOContentSize];
    [_scrollView removeObserver:self forKeyPath:KVOContentOffset];

    _scrollView = nil;
    _delegate = nil;
}

#pragma mark - 管理刷新状态
- (void) setHeaderViewRefreshing
{
    if(_headerView.refreshState != ZMRefreshState_Refreshing)
    {
        [_headerView updateRefreshState:ZMRefreshState_Refreshing];    // 刷新
        [UIView animateWithDuration:0.1 animations:^{
            _scrollView.contentInset = UIEdgeInsetsMake(ZMRefreshViewHeight, 0, 0, 0);
        }];
    }
}

- (void) setFooterViewRefreshing
{
    if(_footerView.refreshState != ZMRefreshState_Refreshing)
    {
        [_footerView updateRefreshState:ZMRefreshState_Refreshing];    // 刷新
        [UIView animateWithDuration:0.1 animations:^{
            _scrollView.contentInset = UIEdgeInsetsMake(0, 0, ZMRefreshViewHeight, 0);
        }];
    }
}

- (void) setHeaderViewRefreshEnd
{
    if(_headerView.refreshState ==  ZMRefreshState_Refreshing)
    {
        [_headerView updateRefreshState:ZMRefreshState_Init];
        [self resetScrollViewContentInset];
    }
}

- (void) setFooterViewRefreshEnd
{
    if(_footerView.refreshState ==  ZMRefreshState_Refreshing)
    {
        [_footerView updateRefreshState:ZMRefreshState_Init];
        [self resetScrollViewContentInset];
    }
}

- (void) setHeaderViewNoMoreFresh
{
    if(_headerView.refreshState ==  ZMRefreshState_Refreshing)
    {
       [_headerView updateRefreshState:ZMRefreshState_NoMoreRefresh];
        [self performSelector:@selector(resetScrollViewContentInset) withObject:nil afterDelay:1.0];
    }
    else
    {
        [_headerView updateRefreshState:ZMRefreshState_NoMoreRefresh];
    }
}

- (void) setFooterViewNoMoreFresh
{
   
    if(_footerView.refreshState ==  ZMRefreshState_Refreshing)
    {
        [_footerView updateRefreshState:ZMRefreshState_NoMoreRefresh];
        [self performSelector:@selector(resetScrollViewContentInset) withObject:nil afterDelay:1.0];
    }
    else
    {
        [_footerView updateRefreshState:ZMRefreshState_NoMoreRefresh];
    }
}

- (void) resetScrollViewContentInset
{
    [UIView animateWithDuration:0.1 animations:^{
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}




#pragma mark - KVO

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([KVOContentOffset isEqualToString:keyPath])
    {
        CGFloat scrollViewHeight = _scrollView.frame.size.height;
        NSValue * oldValue = [change objectForKey:@"old"];
        NSValue * newValue = [change objectForKey:@"new"];
        
        CGFloat oldoffsetY = [oldValue CGPointValue].y;
        CGFloat newoffsetY = [newValue CGPointValue].y;
        
        if(_headerView)
        {
            ZMRefreshState oldState = _headerView.refreshState;
            
            if(newoffsetY >= 0)        // headerView没有显示
            {
                if(oldState != ZMRefreshState_Init && oldState!= ZMRefreshState_NoMoreRefresh)
                {
                    [_headerView updateRefreshState:ZMRefreshState_Init];
                    if(oldState == ZMRefreshState_Refreshing)
                    {
                        [self resetScrollViewContentInset];
                    }
                }
            }
            else                     // headerView显示
            {
                if(newoffsetY < oldoffsetY )  // 在下拉
                {
                    if(oldState == ZMRefreshState_Init)
                    {
                        [_headerView updateRefreshState:ZMRefreshState_Drag];
                    }
                    else if(0 - newoffsetY > ZMRefreshContentOffsetY  && oldState == ZMRefreshState_Drag)  // 下拉超过headerView
                    {
                        [_headerView updateRefreshState:ZMRefreshState_willRefreshing];
                    }
                }
                else if(newoffsetY > oldoffsetY )  // 停止下拉
                {
                    if(oldState == ZMRefreshState_willRefreshing && _scrollView.isDecelerating) // 松手
                    {
                        [_headerView updateRefreshState:ZMRefreshState_Refreshing];    // 刷新
                        [UIView animateWithDuration:0.1 animations:^{
                            _scrollView.contentInset = UIEdgeInsetsMake(ZMRefreshViewHeight, 0, 0, 0);
                        }
                        completion:^(BOOL finish)
                        {
                            if(_delegate && [_delegate respondsToSelector:@selector(ZMRefreshIsDragUp:refreshView:)])
                            {
                                [_delegate ZMRefreshIsDragUp:NO refreshView:_headerView];
                            }
                            
                        }];
                    }
                }
            }
        }
        
        
        if(_footerView)
        {
            ZMRefreshState oldState = _footerView.refreshState;
            
            if(newoffsetY + scrollViewHeight <= _footerView.frame.origin.y)        // footerView没有显示
            {
                if(oldState != ZMRefreshState_Init && oldState!= ZMRefreshState_NoMoreRefresh)
                {
                    [_footerView updateRefreshState:ZMRefreshState_Init];
                    if(oldState == ZMRefreshState_Refreshing)
                    {
                         [self resetScrollViewContentInset];
                    }
                }
            }
            else                     // footerView显示
            {
                if(newoffsetY > oldoffsetY )  // 在上拉
                {
                    if(oldState == ZMRefreshState_Init)
                    {
                        [_footerView updateRefreshState:ZMRefreshState_Drag];
                        
                    }
                    else if(newoffsetY + scrollViewHeight >_footerView.frame.origin.y + ZMRefreshContentOffsetY  && oldState == ZMRefreshState_Drag)  // 下拉超过footerView
                    {
                        [_footerView updateRefreshState:ZMRefreshState_willRefreshing];
                        return;
                    }
                }
                else if(newoffsetY < oldoffsetY )  // 停止上拉
                {
                    if(oldState == ZMRefreshState_willRefreshing && _scrollView.isDecelerating)
                    {
                        [_footerView updateRefreshState:ZMRefreshState_Refreshing];    // 刷新
                        
                        [UIView animateWithDuration:0.1 animations:^{
                            _scrollView.contentInset = UIEdgeInsetsMake(0, 0, _scrollView.contentSize.height < _scrollView.frame.size.height ? ZMRefreshViewHeight + _scrollView.frame.size.height - _scrollView.contentSize.height : ZMRefreshViewHeight , 0);
                        }
                        completion:^(BOOL finish)
                        {
                             if(_delegate && [_delegate respondsToSelector:@selector(ZMRefreshIsDragUp:refreshView:)])
                             {
                                 [_delegate ZMRefreshIsDragUp:YES refreshView:_footerView];
                             }
                             
                        }];
                    }
                    
                    
                }
            }
            
        }
        return;
    }
    else if([KVOContentSize isEqualToString:keyPath])
    {
        CGSize scrollViewSize = _scrollView.bounds.size;
        CGSize contentSize = _scrollView.contentSize;
        
        if(_footerView)
        {
            CGFloat maxY = MAX(scrollViewSize.height,contentSize.height);
            
            CGRect oldRect = _footerView.frame;
            CGRect newRect = CGRectMake(oldRect.origin.x, maxY, contentSize.width, oldRect.size.height);
            _footerView.frame = newRect;
  
        }
        
        if(_headerView)
        {
            CGRect oldRect = _headerView.frame;
            CGRect newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y, contentSize.width, oldRect.size.height);
            
            _headerView.frame = newRect;
        }
        

    }

}


@end
