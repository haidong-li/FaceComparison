//
//  SimilarityDetection.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDFaceComparison : NSObject

/**
 1:N 中计算出距离最小的元素

 @param feature 128特征点
 @param dataSource 128 * N 个数据
 @return 返回 score index
 */
- (NSDictionary *)findMostSimilarityFace:(NSArray *)feature inDataSource:(NSArray *)dataSource;

/**
 人脸对齐

 @param pic 源图片
 @param landmarks 5 个关键点
 @return 对齐后的人脸图片
 */
- (UIImage *)getAlignFace:(UIImage *)pic landmarks:(NSArray *)landmarks;

/**
 获取人脸特征

 @param pic 源图片
 @param landmarks 5 个关键点
 @return 128 人脸特征
 */
- (NSArray *)getFaceFeaturesWithOriginalPic:(UIImage *)pic landmarks:(NSArray *)landmarks;


/**
 1:1 人脸对比

 @param firstFaceFeatures 第一个人脸特征
 @param secondFaceFeatures 第二个人脸特征
 @return 分数
 */
- (CGFloat)detectionSimilarityWithFirstFeatures:(NSArray *)firstFaceFeatures second:(NSArray *)secondFaceFeatures;

NS_ASSUME_NONNULL_END
@end
