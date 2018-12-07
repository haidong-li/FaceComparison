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
 获取人脸特征

 @param pic 源图片
 @param landmarks 5 个关键点
 @return 128 人脸特征
 */
- (NSArray *)getFaceFeaturesWithOriginalPic:(UIImage *)pic landmarks:(NSArray *)landmarks;



NS_ASSUME_NONNULL_END
@end
