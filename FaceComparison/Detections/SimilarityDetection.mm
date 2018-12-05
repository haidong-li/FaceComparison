//
//  SimilarityDetection.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "SimilarityDetection.h"
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/imgcodecs/ios.h>
#import "Face.h"
#include <opencv2/opencv.hpp>
#import "NcnnNet.hpp"
#import "UserModel.h"

using namespace cv;
using namespace std;

@implementation SimilarityDetection
{
    NCNNNet ncnn_net;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        const char *param = [[[NSBundle mainBundle] pathForResource:@"mobilefacenet" ofType:@"param"] cStringUsingEncoding:NSASCIIStringEncoding];
        const char *bin = [[[NSBundle mainBundle] pathForResource:@"mobilefacenet" ofType:@"bin"] cStringUsingEncoding:NSASCIIStringEncoding];
        ncnn_net.LoadFeaturesModel(param,bin);
    }
    return self;
}

- (CGFloat)detectionSimilarityWithFirstFeatures:(NSArray *)firstFaceFeatures second:(NSArray *)secondFaceFeatures
{
    //对比出结果
    
    CGFloat distance = [self getFeatureDistanceWithFirstFeatures:firstFaceFeatures second:secondFaceFeatures];
    //相似度
    CGFloat similarity = (1 - pow(distance / 2, 2)) * 100;
    return similarity;
}


- (NSArray *)getMainFaceFeaturesWithOriginalPic:(UIImage *)pic landmarks:(NSArray *)landmarks
{

    cv::Mat faceMat,temp,input;
    UIImageToMat(pic, temp);
    faceMat = [self getAlignMat:temp landmarks:landmarks];
    
    cv::cvtColor(faceMat, input, cv::COLOR_RGB2BGR);
    //通过ncnn 获取面部的特征点
    ncnn::Mat faceFeatureMat = ncnn_net.getFaceFeatures(input);
    //将ncnn mat 转换成 NSArray
    NSArray *featuresArr = [self turnNCNNMat:faceFeatureMat];
    //归一特征点
    NSArray *fixFeaturesArr = [self normalizeFeature:featuresArr];
    
    //释放 资源
    
    return fixFeaturesArr;
}

// 计算特征的 distance
- (CGFloat)getFeatureDistanceWithFirstFeatures:(NSArray *)firstFeature second:(NSArray *)secondFeature
{
    if (!firstFeature.count || !secondFeature.count) return 0;
    float distance = 0;
    for (int i = 0; i < firstFeature.count && i < firstFeature.count; ++i) {
        distance += ([firstFeature[i] floatValue] - [secondFeature[i] floatValue]) * ([firstFeature[i] floatValue]- [secondFeature[i] floatValue]);
    }
    distance = sqrt(distance);
    return distance;
}


- (UIImage *)getMainFace:(UIImage *)pic landmarks:(NSArray *)landmarks
{
    cv::Mat temp;
    UIImageToMat(pic, temp);
    
    return MatToUIImage([self getAlignMat:temp landmarks:landmarks]);
}

- (NSDictionary *)findMostSimilarityFace:(NSArray *)feature inDataSource:(NSArray *)dataSource
{
    CGFloat distance = 0.0;
    NSInteger index = -1;
    for (NSInteger i = 0; i < dataSource.count; i++) {
        NSArray *target = dataSource[i];
        CGFloat tDistance = [self detectionSimilarityWithFirstFeatures:feature second:target];
        if (tDistance > distance) {
            distance = tDistance;
            index = i;
        }
    }
    return @{@"index":@(index),@"score":@(distance)};
}

- (Mat)getAlignMat:(Mat)bgrmat landmarks:(NSArray *)landmarks
{
    //left eye
    float left_eye_x = [landmarks[0] CGPointValue].x;
    float left_eye_y = [landmarks[0] CGPointValue].y;
    //right eye
    float right_eye_x = [landmarks[1] CGPointValue].x;
    float right_eye_y = [landmarks[1] CGPointValue].y;
    //nose
    float nose_x = [landmarks[2] CGPointValue].x;
    float nose_y = [landmarks[2] CGPointValue].y;
    //mouth left
    float mouth_left_x = [landmarks[3] CGPointValue].x;
    float mouth_left_y = [landmarks[3] CGPointValue].y;
    //mouth right
    float mouth_right_x = [landmarks[4] CGPointValue].x;
    float mouth_right_y = [landmarks[4] CGPointValue].y;
    //mouth center
    float mouth_center_x = (mouth_left_x + mouth_right_x) / 2;
    float mouth_center_y = (mouth_left_y + mouth_right_y) / 2;
    
    cv::Mat affineMat;
    std::vector<cv::Point2f> src_pts ;
    src_pts.push_back(cv::Point2f(left_eye_x, left_eye_y));
    src_pts.push_back(cv::Point2f(right_eye_x, right_eye_y));
    src_pts.push_back(cv::Point2f(mouth_center_x, mouth_center_y));
    
    
    cv::Point2f left_eye(38, 52);
    cv::Point2f right_eye(74, 52);
    cv::Point2f mouth_center(56, 92);
    cv::Size dsize(112, 112);
    
    std::vector<cv::Point2f> dst_pts;
    dst_pts.push_back(left_eye);
    dst_pts.push_back(right_eye);
    dst_pts.push_back(mouth_center);
    
    affineMat = cv::getAffineTransform(src_pts, dst_pts);
    
    cv::Mat alignedImg;
    cv::warpAffine(bgrmat, alignedImg, affineMat, dsize, cv::INTER_CUBIC, cv::BORDER_REPLICATE);
    
    return alignedImg;
    
}
- (NSArray *)normalizeFeature:(NSArray <NSNumber *>*)feature
{
    NSMutableArray *fixFArr = [NSMutableArray arrayWithCapacity:0];
    if (!feature.count) return nil;
    float norm = 0;
    for (int i = 0; i < feature.count; i++) {
        norm += [feature[i] floatValue] * [feature[i] floatValue];
    }
    norm = sqrt(norm);
    if (norm == 0) return feature;
    for (int i = 0; i < feature.count; i++) {
        float newFeature = [feature[i] floatValue] / norm;
        [fixFArr addObject:@(newFeature)];
    }
    return fixFArr;
}

- (NSArray <NSNumber *>*)turnNCNNMat:(ncnn::Mat)feature
{
    NSMutableArray *features = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < feature.w; i++) {
        [features addObject:@((float)feature[i])];
    }
    return features;
}

@end
