//
//  ZLVideoRecorder.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/3.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLVideoRecorder : NSObject

@property(nonatomic, strong) UIView * videoPreviewView;

@property(nonatomic, assign, readonly, getter=isRecording) BOOL recording;

- (void) startRecord;
@end

NS_ASSUME_NONNULL_END
