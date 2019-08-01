//
//  ZMRefreshView.h
//  iCenter
//
//  Created by panzhengwei on 2018/9/25.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ZMRefreshState_Init,
    ZMRefreshState_Drag,
    ZMRefreshState_willRefreshing,
    ZMRefreshState_Refreshing,
    ZMRefreshState_NoMoreRefresh
    
}ZMRefreshState;


@interface ZMRefreshView : UIView

@property(nonatomic,assign) ZMRefreshState refreshState;

@property(nonatomic,assign) BOOL isHeadView;


- (instancetype) initWithFrame:(CGRect)frame IsHeaderView:(BOOL) isHeaderView;

- (void) updateRefreshState:(ZMRefreshState) state;

@end
