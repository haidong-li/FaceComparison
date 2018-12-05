//
//  SimilarityDetection.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Face;
@interface SimilarityDetection : NSObject
- (NSDictionary *)findMostSimilarityFace:(NSArray *)feature inDataSource:(NSArray *)dataSource;
- (UIImage *)getMainFace:(UIImage *)pic landmarks:(NSArray *)landmarks;
- (NSArray *)getMainFaceFeaturesWithOriginalPic:(UIImage *)pic landmarks:(NSArray *)landmarks;
- (CGFloat)detectionSimilarityWithFirstFeatures:(NSArray *)firstFaceFeatures second:(NSArray *)secondFaceFeatures;
@end
