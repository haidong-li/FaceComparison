//
//  CameraOutput.h
//  FaceCam
//
//  Created by hfjk on 2018/7/24.
//  Copyright © 2018年 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraOutput <NSObject>

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer faces:(NSArray <NSValue *>*)faces;
@end
