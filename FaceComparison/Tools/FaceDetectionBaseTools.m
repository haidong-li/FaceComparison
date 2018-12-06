//
//  FaceDetectionBaseTools.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/14.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "FaceDetectionBaseTools.h"

@implementation FaceDetectionBaseTools

+ (void)saveImage:(UIImage *)image name:(NSString *)picName path:(NSString *)path{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *filePath = [path stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@.jpg",picName]];  // 保存文件的名称
        [UIImageJPEGRepresentation(image,0.5) writeToFile:filePath   atomically:YES];
    });
    
}


+ (UIImage*)imageFromPixelBuffer:(CMSampleBufferRef)p {
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(p);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
}

+ (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    
    return currentTimeString;
    
}
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

+ (NSString *)getNowTimeTimestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval curentTime = [dat timeIntervalSince1970]*1000;
    
    return [NSString stringWithFormat:@"%.f",curentTime];
    
}
/**返回一张指定大小,指定颜色的图片*/
+ (UIImage *)newImageWithSize:(CGSize) size color:(UIColor *)color
{
    // UIGrphics
    // 设置一个frame
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // 开启图形绘制
    UIGraphicsBeginImageContext(size);
    
    // 获取当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置填充颜色
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    // 填充
    CGContextFillRect(context, rect);
    
    // 从当前图形上下文中获取一张透明图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形绘制
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIViewController *)topViewController {
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (topWindow in windows) {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIViewController *topVC = (UIViewController *) topWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *mainview = (UITabBarController *) topVC;
        UINavigationController *selectView = [mainview.viewControllers objectAtIndex:mainview.selectedIndex];
        if (selectView) {
            return selectView.visibleViewController;
        }
    } else if ([topVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *selectView = (UINavigationController *) topVC;
        return selectView.visibleViewController;
    } else if (topVC && [topVC isKindOfClass:[UIViewController class]]) {
        return topVC;
    }else {
        NSAssert(NO, @"Could not find a root view controller.");
    }
    return result;
    
}

@end
