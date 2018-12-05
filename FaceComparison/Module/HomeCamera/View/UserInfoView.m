//
//  UserInfoView.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/14.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "UserInfoView.h"
#import <Masonry/Masonry.h>
#import "UserModel.h"
#import "HFJKMacro.h"
#import "HFJKColor.h"

@interface UserInfoView ()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *jobNum;
@property (nonatomic,strong) UILabel *typeOfWork;

@property (nonatomic,strong) UILabel *nameTap;
@property (nonatomic,strong) UILabel *jobNumTap;
@property (nonatomic,strong) UILabel *typeOfWorkTap;
@property (nonatomic,strong) UILabel *score;

@end


@implementation UserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeConstraints];
    }
    return self;
}

- (void)loadUserInfo:(UserModel *)userInfo
{
    self.name.text = userInfo.name;
    self.typeOfWork.text = userInfo.typeOfWork;
    self.jobNum.text = userInfo.workNum;
    self.headImg.image = userInfo.imageSrc;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, HFJKSCREEN_HEIGHT - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        if (self.finish) {
            self.finish();
        }
    });
}

- (void)makeConstraints
{
    
    self.layer.cornerRadius = 7;
    self.backgroundColor = [HFJKColor HF_ColorWithHexString:@"#40476C"];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
        make.width.equalTo(self.headImg.mas_height);
    }];
    
    [self.nameTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg.mas_top);
        make.left.equalTo(self.headImg.mas_right).offset(15);
    }];
    
    [self.jobNumTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.headImg.mas_right).offset(15);
    }];
    
    [self.typeOfWorkTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImg.mas_bottom);
        make.left.equalTo(self.headImg.mas_right).offset(15);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg.mas_top);
        make.left.equalTo(self.nameTap.mas_right).offset(20);
    }];
    
    [self.jobNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.jobNumTap.mas_right).offset(20);
    }];
    
    [self.typeOfWork mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImg.mas_bottom);
        make.left.equalTo(self.typeOfWorkTap.mas_right).offset(20);
    }];
    
    [self.score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
}

- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_headImg];
    }
    return _headImg;
}

- (UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont systemFontOfSize:20];
        _name.textColor = [UIColor whiteColor];
        [self addSubview:_name];
    }
    return _name;
}

- (UILabel *)typeOfWork
{
    if (!_typeOfWork) {
        _typeOfWork = [[UILabel alloc] init];
        _typeOfWork.font = [UIFont systemFontOfSize:20];
        _typeOfWork.textColor = [UIColor whiteColor];
        [self addSubview:_typeOfWork];
    }
    return _typeOfWork;
}

- (UILabel *)jobNum
{
    if (!_jobNum) {
        _jobNum = [[UILabel alloc] init];
        _jobNum.font = [UIFont systemFontOfSize:20];
        _jobNum.textColor = [UIColor whiteColor];
        [self addSubview:_jobNum];
    }
    return _jobNum;
}

- (UILabel *)nameTap
{
    if (!_nameTap) {
        _nameTap = [[UILabel alloc] init];
        _nameTap.font = [UIFont systemFontOfSize:20];
        _nameTap.text = @"姓名 :";
        _nameTap.textColor = [UIColor whiteColor];
        [self addSubview:_nameTap];
    }
    return _nameTap;
}

- (UILabel *)typeOfWorkTap
{
    if (!_typeOfWorkTap) {
        _typeOfWorkTap = [[UILabel alloc] init];
        _typeOfWorkTap.font = [UIFont systemFontOfSize:20];
        _typeOfWorkTap.text = @"职位 :";
        _typeOfWorkTap.textColor = [UIColor whiteColor];
        [self addSubview:_typeOfWorkTap];
    }
    return _typeOfWorkTap;
}

- (UILabel *)jobNumTap
{
    if (!_jobNumTap) {
        _jobNumTap = [[UILabel alloc] init];
        _jobNumTap.font = [UIFont systemFontOfSize:20];
        _jobNumTap.text = @"工号 :";
        _jobNumTap.textColor = [UIColor whiteColor];
        [self addSubview:_jobNumTap];
    }
    return _jobNumTap;
}

- (UILabel *)score
{
    if (!_score) {
        _score = [[UILabel alloc] init];
        _score.font = [UIFont fontWithName:@"DIN Condensed" size:60];
        _score.textColor = [HFJKColor HF_ColorWithHexString:@"#00FF89"];
        [self addSubview:_score];
        
    }
    return _score;
}

- (void)setFaceScore:(NSInteger)faceScore
{
    _faceScore = faceScore;
    
    self.score.text = [NSString stringWithFormat:@"%ld%%",_faceScore];
}
@end
