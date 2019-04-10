//
//  MtcnnFaceWrapper.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "Face.h"

@interface HDFaceDetection : NSObject

/**
 检测出最大的人脸

 @param image 检测图片
 @return 2个长度  0->关键点  1->人脸框
 */
- (NSArray *)detectMaxFace:(UIImage *)image;
- (NSArray *)detectFace:(UIImage *)image;
/**
 检测是否是正脸

 @param shape 5个关键点
 @return 是否
 */
- (BOOL)faceFront:(NSArray *)shape;

@end
