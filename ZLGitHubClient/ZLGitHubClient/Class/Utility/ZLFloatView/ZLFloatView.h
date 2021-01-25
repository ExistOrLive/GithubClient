//
//  ZLFloatView.h
//  chengyu
//
//  Created by BeeCloud on 2020/1/2.
//  Copyright © 2020 BeeCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ZLFloatViewType_OverAllWindow,  // 新建window，悬浮在所有已存在window之上
    ZLFloatViewType_OverCurrentWindow,  // 作为当前window的子视图，在所有已存在的view之上
    ZLFloatViewType_OverCurrentView,  // 作为当前view的子视图
} ZLFloatViewType;

@interface ZLFloatViewConfig : NSObject

@property(nonatomic, assign)
    ZLFloatViewType viewType;  // 默认 ZLFloatViewType_OverAllWindow

@property(nonatomic, assign) UIEdgeInsets margin;  // 默认 {0，0，0，0}

@property(nonatomic, weak)
    UIView* superView;  // ZLFloatViewType_OverCurrentView 必填

@property(nonatomic, assign) BOOL bounces;

@property(nonatomic, assign) BOOL canPan;

@end

@interface ZLFloatViewController : UIViewController

@end


@interface ZLFloatWindow : UIWindow

@property(nonatomic,assign) BOOL forceKey;

@end


@interface ZLFloatView : UIView

@property(nonatomic, strong) ZLFloatViewConfig* config;

@end

NS_ASSUME_NONNULL_END
