//
//  ZLVideoPreviewView.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/9.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLVideoPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation ZLVideoPreviewView

- (void) setPreviewLayer:(AVCaptureVideoPreviewLayer *)previewLayer
{
    [_previewLayer removeFromSuperlayer];
    _previewLayer = previewLayer;
    _previewLayer.frame = self.bounds;
    [self.layer addSublayer:_previewLayer];
}

- (void)layoutSubviews
{
    self.previewLayer.frame = self.bounds;
}

@end
