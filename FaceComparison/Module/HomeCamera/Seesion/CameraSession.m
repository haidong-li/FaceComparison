//
//  CameraSession.m
//  FaceCam
//
//  Created by hfjk on 2018/7/24.
//  Copyright © 2018年 Huafu. All rights reserved.
//

#import "CameraSession.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface CameraSession ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,strong) dispatch_queue_t sample;
@property (nonatomic,strong) dispatch_queue_t faceQueue;
@property (nonatomic,copy) NSArray *currentMetadata;
@property (nonatomic,strong) AVCaptureDevice *device;

@end

@implementation CameraSession

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sample = dispatch_queue_create("com.hfkj.wwww.sample", NULL);
        _faceQueue = dispatch_queue_create("com.hfkj.wwww.face", NULL);
        
        
        
        AVCaptureDeviceInput*input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        output.alwaysDiscardsLateVideoFrames = YES;
        [output setSampleBufferDelegate:self queue:_sample];
        
        AVCaptureMetadataOutput *metaout = [[AVCaptureMetadataOutput alloc] init];
        [metaout setMetadataObjectsDelegate:self queue:_faceQueue];
        self.session = [[AVCaptureSession alloc] init];
        [self.session beginConfiguration];
        if ([self.session canAddInput:input]) {
            [self.session addInput:input];
        }
        
        if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            _session.sessionPreset = AVCaptureSessionPresetHigh;
        }
        if ([self.session canAddOutput:output]) {
            [self.session addOutput:output];
        }
        
        if ([self.session canAddOutput:metaout]) {
            [self.session addOutput:metaout];
        }
        [self.session commitConfiguration];
        
        NSString     *key           = (NSString *)kCVPixelBufferPixelFormatTypeKey;
        NSNumber     *value         =  @(kCVPixelFormatType_32BGRA);
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        
        [output setVideoSettings:videoSettings];
        [metaout setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
        
        [self videoMirored];

    }
    return self;
}

- (void)run
{
    [self.session startRunning];
}

- (void)stop
{
    [self.session stopRunning];
}
#pragma mark - AVCaptureSession Delegate -

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(captureOutput:didOutputSampleBuffer:faces:)]) {
        NSMutableArray *bounds = [NSMutableArray arrayWithCapacity:0];
        for (AVMetadataFaceObject *faceobject in self.currentMetadata) {
            AVMetadataObject *face = [output transformedMetadataObjectForMetadataObject:faceobject connection:connection];
            [bounds addObject:[NSValue valueWithCGRect:face.bounds]];
        }
        
        [self.delegate captureOutput:output didOutputSampleBuffer:sampleBuffer faces:bounds];

    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //当检测到了人脸会走这个回调
    _currentMetadata = metadataObjects;
}


- (void)videoMirored {
    AVCaptureSession* session = (AVCaptureSession *)self.session;
    for (AVCaptureVideoDataOutput* output in session.outputs) {
        for (AVCaptureConnection * av in output.connections) {
            //判断是否是前置摄像头状态
            if (av.supportsVideoMirroring) {
                //镜像设置
                av.videoOrientation = AVCaptureVideoOrientationPortrait;
                av.videoMirrored = YES;
            }
        }
    }
}


-(AVCaptureDevice *)device {
    if (_device == nil) {
        
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices )
        {
            if ( device.position == AVCaptureDevicePositionFront )
            {
                _device = device;
                break;
            }
        }
        
        NSError *error = nil;
        if ([_device lockForConfiguration:&error]) {
            if ([_device isSmoothAutoFocusSupported]) {// 平滑对焦
                _device.smoothAutoFocusEnabled = YES;
            }
            
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {// 自动持续对焦
                _device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            }
            
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure ]) {// 自动持续曝光
                _device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            }
            
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {// 自动持续白平衡
                _device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
            }
            
            //            NSError *error1;
            //            CMTime frameDuration = CMTimeMake(1, 30); // 默认是1秒30帧
            //            NSArray *supportedFrameRateRanges = [_device.activeFormat videoSupportedFrameRateRanges];
            //            BOOL frameRateSupported = NO;
            //            for (AVFrameRateRange *range in supportedFrameRateRanges) {
            //                if (CMTIME_COMPARE_INLINE(frameDuration, >=, range.minFrameDuration) && CMTIME_COMPARE_INLINE(frameDuration, <=, range.maxFrameDuration)) {
            //                    frameRateSupported = YES;
            //                }
            //            }
            //
            //            if (frameRateSupported && [self.device lockForConfiguration:&error1]) {
            //                [_device setActiveVideoMaxFrameDuration:frameDuration];
            //                [_device setActiveVideoMinFrameDuration:frameDuration];
            ////                [self.device unlockForConfiguration];
            //            }
            
            [_device unlockForConfiguration];
        }
    }
    
    return _device;
}


-(NSNumber *)outPutSetting {
    if (_outPutSetting == nil) {
        _outPutSetting = @(kCVPixelFormatType_32BGRA);
    }
    
    return _outPutSetting;
}

- (void)dealloc
{
    NSLog(@".....");
    
}
@end
