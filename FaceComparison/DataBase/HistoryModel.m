//
//  HistotyModel.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/19.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "HistoryModel.h"
#import "DataBaseManager.h"

@implementation HistoryModel
- (UIImage *)imageSrc
{
    NSString *imagePath = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_0.jpg",self.workNum]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
    
}

- (UIImage *)historyImage
{
    NSString *imagePath = [[[DataBaseManager shareInstance].historyImagePath stringByAppendingPathComponent:self.tableName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.clockTime]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}
@end
