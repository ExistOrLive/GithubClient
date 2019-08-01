//
//  ZLVideoView.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/2.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZLVideoOverlayView;

@interface ZLVideoBaseView : ZLBaseView

@property (strong, nonatomic) ZLVideoOverlayView * overlayView;

@property (strong, nonatomic) UIView * contentView;

@end

NS_ASSUME_NONNULL_END
