//
//  MtcnnFaceWrapper.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "MtcnnFaceWrapper.h"
#import "mtcnn.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation MtcnnFaceWrapper
{
    MTCNN *new_mtcnn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        new_mtcnn = new MTCNN("");
        new_mtcnn->SetMinFace(40);
    }
    return self;
}


- (NSArray *)detectMaxFace:(UIImage *)image
{
    
    int w = image.size.width;
    int h = image.size.height;
    unsigned char* rgba = new unsigned char[w*h*4];
    {
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
        CGContextRef contextRef = CGBitmapContextCreate(rgba, w, h, 8, w*4,
                                                        colorSpace,
                                                        kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
        
        CGContextDrawImage(contextRef, CGRectMake(0, 0, w, h), image.CGImage);
        CGContextRelease(contextRef);
    }

    ncnn::Mat ncnn_img;
    ncnn_img = ncnn::Mat::from_pixels(rgba, ncnn::Mat::PIXEL_RGBA2RGB, w, h);
    
    std::vector<Bbox> finalBbox;
    //    new_mtcnn->detect(ncnn_img, finalBbox);
    cv::Mat temp;
    UIImageToMat(image, temp);
    //    float cost;
    new_mtcnn->detectMaxFace(ncnn_img, finalBbox);
    int32_t num_face = static_cast<int32_t>(finalBbox.size());
    
    int out_size = 1+num_face*14;
    
    NSMutableArray *faceInfoArr = [NSMutableArray arrayWithCapacity:0];
    //
    int *faceInfo = new int[out_size];
    faceInfo[0] = num_face;
    for(int i=0;i<num_face;i++){
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:0];
        
        CGRect rect = CGRectMake(finalBbox[i].x1, finalBbox[i].y1, finalBbox[i].x2 - finalBbox[i].x1, finalBbox[i].y2 - finalBbox[i].y1);
        
        for (int j =0;j<5;j++){
            CGPoint point = CGPointMake(finalBbox[i].ppoint[j], finalBbox[i].ppoint[j + 5]);
            [points addObject:[NSValue valueWithCGPoint:point]];
        }

        [faceInfoArr addObject:points];
        [faceInfoArr addObject:[NSValue valueWithCGRect:rect]];
    }
    
    delete [] rgba;
    delete [] faceInfo;
    finalBbox.clear();
    return faceInfoArr;
}


//正脸检测
- (BOOL)faceFront:(NSArray *)shape
{
    int mStartNumRightTemp = 0;
    int mStartNumLeftTemp = 0;
    
    CGPoint right_pupil;
    CGPoint left_pupil;
    left_pupil.x = [shape[0] CGPointValue].x ;  //左眼瞳孔坐标x
    left_pupil.y = [shape[0] CGPointValue].y ;  //左眼瞳孔坐标y
    
    right_pupil.x = [shape[1] CGPointValue].x  ;  //右眼瞳孔坐标x
    right_pupil.y = [shape[1] CGPointValue].y ;  //右眼瞳孔坐标y
    
    mStartNumRightTemp = abs(right_pupil.x - [shape[2] CGPointValue].x);  //到鼻子中间的距离
    mStartNumLeftTemp = abs([shape[2] CGPointValue].x  - left_pupil.x);
    
    float tempp1 = mStartNumRightTemp / (float)mStartNumLeftTemp;
    float tempp2 = mStartNumLeftTemp / (float)mStartNumRightTemp;
    NSLog(@"%.2f---%.2f",tempp1,tempp2);
    if (tempp1 > 0.7 && tempp2>0.7)
        return YES;
    else
        return NO;
    
}


//姿态检测
- (NSDictionary *)facePose:(NSArray *)shape
{
    int mStartNumRightTemp = 0;
    int mStartNumLeftTemp = 0;
    
    CGPoint right_pupil;
    CGPoint left_pupil;
    left_pupil.x = [shape[0] CGPointValue].x ;  //左眼瞳孔坐标x
    left_pupil.y = [shape[0] CGPointValue].y ;  //左眼瞳孔坐标y
    
    right_pupil.x = [shape[1] CGPointValue].x  ;  //右眼瞳孔坐标x
    right_pupil.y = [shape[1] CGPointValue].y ;  //右眼瞳孔坐标y
    
    mStartNumRightTemp = right_pupil.x - [shape[2] CGPointValue].x;  //到鼻子中间的距离
    mStartNumLeftTemp = [shape[2] CGPointValue].x  - left_pupil.x;
    
    float tempp1 = mStartNumRightTemp / (float)mStartNumLeftTemp;
    float tempp2 = mStartNumLeftTemp / (float)mStartNumRightTemp;
    return @{@"right":@(tempp1),@"left":@(tempp2)};
    
}
@end
