//
//  ZLVideoRecorder.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/3.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLVideoRecorder.h"

#import "ZLVideoPreviewView.h"

#import <VideoToolbox/VideoToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface ZLVideoRecorder() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, strong) AVCaptureDeviceInput * captureInput;

@property(nonatomic, strong) AVCaptureVideoDataOutput * captureOutput;

@property(nonatomic, strong) AVCaptureSession * captureSession;

@property(nonatomic, strong) AVCaptureConnection * captureConnection;

@property(nonatomic, strong) dispatch_queue_t sampleQueue;                  // 采样回调线程


@end

@implementation ZLVideoRecorder

- (instancetype) init
{
    if(self = [super init])
    {
       BOOL result1 = [self initializeVideoCaptureInput];
       BOOL result2 =  [self initializeVideoCaptureOutput];
       BOOL result3 =  [self initializeVideoCaptureSession];
       
       if(!(result1 && result2 && result3))
       {
           return nil;
       }
    }
    
    return self;
}

// 初始化输入设备
- (BOOL) initializeVideoCaptureInput
{
    NSArray * deviceArray =  [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    // 获取前置摄像头
    AVCaptureDevice * frontCamera = nil;
    for(AVCaptureDevice * device in deviceArray)
    {
        if(AVCaptureDevicePositionFront == device.position)
        {
            frontCamera = device;
        }
    }
    if(!frontCamera)
    {
        ZLLog_Error(@"无法获取前置摄像头");
        return NO;
    }
    
    NSError * error = nil;
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    if(error)
    {
        ZLLog_Error(@"get AVCaptureDeviceInput failed [%@]",error.localizedDescription);
        return NO;
    }
    
    return YES;
}

// 初始化视频输出，并设置视频数据格式 设置采集回调线程
- (BOOL) initializeVideoCaptureOutput
{
    self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // 设置视频数据格式 设置每一帧中每一个像素的物理存储格式 （ARGB，YUV等）
    NSDictionary *  videoSetting =[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange], kCVPixelBufferPixelFormatTypeKey, nil];
    [self.captureOutput setVideoSettings:videoSetting];
    
    self.sampleQueue =  dispatch_queue_create("video capture queue", DISPATCH_QUEUE_SERIAL);
    [self.captureOutput setSampleBufferDelegate:self queue: self.sampleQueue];
    
    // 丢弃延迟的帧
    self.captureOutput.alwaysDiscardsLateVideoFrames = YES;

    return YES;
}


- (BOOL) initializeVideoCaptureSession
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    if([self.captureSession canAddInput:self.captureInput])
    {
        [self.captureSession addInput:self.captureInput];
    }
    
    if([self.captureSession canAddOutput:self.captureOutput])
    {
        [self.captureSession addOutput:self.captureOutput];
    }
    
    // 设置输出的分辨率 1280*720
    if([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        [self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720];
    }
    
    // AVCaptureConnection  是指多个采集输入(音频输入和视频输入)和一个采集输出之间连接； connection 和 output是一对一的
    self.captureConnection = [self.captureOutput connectionWithMediaType:AVMediaTypeVideo];
    self.captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    if(self.captureConnection.supportsVideoMirroring)
    {
        self.captureConnection.videoMirrored = YES;
    }
    
    // 这里videoPreviewLayer 属于另一个采集输出，对应另一个connection，与上面的不是一个，需要单独设置
    AVCaptureVideoPreviewLayer * videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    ZLVideoPreviewView * preview = [[ZLVideoPreviewView alloc] init];
    preview.previewLayer = videoPreviewLayer;
    self.videoPreviewView = preview;
    
    return YES;
}


- (void) startRecord
{
    if(_recording)
    {
        return;
    }
    
    // 摄像头权限判断
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoAuthStatus != AVAuthorizationStatusAuthorized)
    {
        return;
    }
    
    [self.captureSession startRunning];
    _recording = YES;
}
#pragma mark -

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
//    VTCompressionSessionCreate(NULL, 720, 1080, CMVideoCodecType codecType, <#CFDictionaryRef  _Nullable encoderSpecification#>, <#CFDictionaryRef  _Nullable sourceImageBufferAttributes#>, <#CFAllocatorRef  _Nullable compressedDataAllocator#>, <#VTCompressionOutputCallback  _Nullable outputCallback#>, <#void * _Nullable outputCallbackRefCon#>, <#VTCompressionSessionRef  _Nullable * _Nonnull compressionSessionOut#>)
}

- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
}
@end
