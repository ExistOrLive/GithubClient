//
//  ZLVideoViewModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/2.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLVideoViewModel.h"

#import "ZLVideoBaseView.h"
#import "ZLVideoOverlayView.h"

#import "ZLVideoRecorder.h"

@interface ZLVideoViewModel() <ZLVideoOverlayViewDelegate>

// View
@property (weak, nonatomic) ZLVideoBaseView * view;

// recorder
@property (strong, nonatomic) ZLVideoRecorder * videoRecorder;

@end

@implementation ZLVideoViewModel

- (void) bindModel:(id)targetModel andView:(UIView *)targetView
{
    if(![targetView isKindOfClass:[ZLVideoBaseView class]])
    {
        return;
    }
    
    self.view = (ZLVideoBaseView *) targetView;
    self.view.overlayView.delegate = self;
    
    self.videoRecorder = [[ZLVideoRecorder alloc] init];
    [self.view setContentView:self.videoRecorder.videoPreviewView];
    
}


- (void) onVideoCaptureButtonClicked:(UIButton *) button
{
    switch((ZLVideoRecordButtonType) button.tag)
    {
        case ZLVideoRecordButtonType_back:
        {
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case ZLVideoRecordButtonType_record:
        {
            [self.videoRecorder startRecord];
            [self.view.overlayView setStatus:ZLVideoOverlayViewStatus_recording];
        }
            break;
        default:
            break;
    }
}

- (void) onRateButtonClicked:(UIButton *) button
{
    
}

@end
