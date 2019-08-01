//
//  ZLVideoOverlayView.h
//  BiPinHui
//
//  Created by 朱猛 on 2019/6/27.
//  Copyright © 2019 SuzhouFugu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZLVideoOverlayViewStatus) {
    ZLVideoOverlayViewStatus_beforeRecord,
    ZLVideoOverlayViewStatus_recording,
    ZLVideoOverlayViewStatus_AfterRecord
};

typedef NS_ENUM(NSUInteger, ZLVideoRecordButtonType) {
    ZLVideoRecordButtonType_back,                        // 返回
    ZLVideoRecordButtonType_switchCamera,                // 切换摄像头
    ZLVideoRecordButtonType_record,                      // 开始或者暂停录制
    ZLVideoRecordButtonType_composition,                 // 合成
    ZLVideoRecordButtonType_import,                      // 导入
    ZLVideoRecordButtonType_cancel,                      // 放弃当前录制
    ZLVideoRecordButtonType_end                          // 完成录制，下一步
};


@protocol ZLVideoOverlayViewDelegate <NSObject>

- (void) onVideoCaptureButtonClicked:(UIButton *) button;

- (void) onRateButtonClicked:(UIButton *) button;

@end

@interface ZLVideoOverlayView : ZLBaseView

@property (nonatomic, weak) id<ZLVideoOverlayViewDelegate> delegate;

@property (assign, nonatomic) ZLVideoOverlayViewStatus status;

@property (weak, nonatomic) IBOutlet UIProgressView *recordProcess;



@end

NS_ASSUME_NONNULL_END
