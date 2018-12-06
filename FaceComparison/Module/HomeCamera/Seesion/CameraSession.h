//
//  CameraSession.h
//  FaceCam
//
//  Created by hfjk on 2018/7/24.
//  Copyright © 2018年 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraOutput.h"
#import <UIKit/UIKit.h>

@interface CameraSession : NSObject

@property (nonatomic,weak) id <CameraOutput>delegate;
@property (nonatomic,strong) AVCaptureSession *session;

@property (nonatomic,strong) NSNumber *outPutSetting;
- (void)run;
- (void)stop;
@end


