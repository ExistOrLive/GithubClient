//
//  ZLVideoPreviewView.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/9.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVCaptureVideoPreviewLayer;

NS_ASSUME_NONNULL_BEGIN

@interface ZLVideoPreviewView : UIView

@property (strong, nonatomic) AVCaptureVideoPreviewLayer * previewLayer;

@end

NS_ASSUME_NONNULL_END
