//
//  HistotyModel.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/19.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HistoryModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,strong) UIImage *imageSrc;
@property (nonatomic,strong) UIImage *historyImage;
@property (nonatomic,copy,nonnull) NSString *name;
@property (nonatomic,copy,nonnull) NSString *workNum;
@property (nonatomic,copy,nonnull) NSString *typeOfWork;
@property (nonatomic,copy,nonnull) NSString *clockTime;
@property (nonatomic,copy,nonnull) NSString *score;
@property (nonatomic,copy,nonnull) NSString *facePostion;
@property (nonatomic,copy,nonnull) NSString *tableName;
@property (nonatomic,copy,nonnull) NSString *minClockTime;
@property (nonatomic,copy,nonnull) NSString *maxClockTime;
@property (nonatomic,copy,nonnull) NSString *maxScore;
@end

