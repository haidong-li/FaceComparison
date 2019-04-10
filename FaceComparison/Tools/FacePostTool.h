//
//  FacePostTool.h
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/19.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FacePostTool : NSObject
+ (UIImage *)facePostion:(NSArray <NSValue *>*)landmarks image:(UIImage *)image faceRect:(CGRect)faceRect;
@end

NS_ASSUME_NONNULL_END
