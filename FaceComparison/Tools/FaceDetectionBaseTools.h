//
//  FaceDetectionBaseTools.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/14.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface FaceDetectionBaseTools : NSObject
+ (NSString*)getCurrentTimes;
+ (NSString *)getNowTimeTimestamp;
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
+ (UIImage*)imageFromPixelBuffer:(CMSampleBufferRef)p;
+ (void)saveImage:(UIImage *)image name:(NSString *)picName path:(NSString *)path;
+ (UIViewController *)topViewController;
+ (UIImage *)newImageWithSize:(CGSize) size color:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
