//
//  UserModel.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,strong) UIImage *imageSrc;
@property (nonatomic,copy,nonnull) NSString *name;
@property (nonatomic,copy,nonnull) NSString *workNum;
@property (nonatomic,copy,nonnull) NSString *department;
@property (nonatomic,copy,nonnull) NSString *phone;
@property (nonatomic,copy,nonnull) NSString *company;
@property (nonatomic,copy,nonnull) NSString *idCard;
@property (nonatomic,copy,nonnull) NSString *typeOfWork;
@property (nonatomic,copy,nonnull) NSString *startTime;
@property (nonatomic,copy,nonnull) NSString *endTime;
@property (nonatomic,copy,nonnull) NSString *role; //?< 角色 管理员之类
@property (nonatomic,copy,nonnull) NSString *riskLevel;//?< 风险等级
@property (nonatomic,copy,nonnull) NSString *feature0;
@property (nonatomic,copy,nonnull) NSString *feature1;
@property (nonatomic,copy,nonnull) NSString *feature2;
@property (nonatomic,copy,nonnull) NSString *feature3;
@property (nonatomic,copy,nonnull) NSString *feature4;
@property (nonatomic,copy,nonnull) NSString *feature5;
@property (nonatomic,copy,nonnull) NSString *feature6;
@property (nonatomic,copy,nonnull) NSString *feature7;
@property (nonatomic,copy,nonnull) NSString *feature8;

@property (nonatomic,copy,nonnull) NSString *headImage;
@property (nonatomic,copy,nonnull) NSString *createTime;
@property (nonatomic,copy,nonnull) NSString *updateTime;

@end
