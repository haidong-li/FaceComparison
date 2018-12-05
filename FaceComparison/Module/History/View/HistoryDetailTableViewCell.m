//
//  HistoryDetailTableViewCell.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/19.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "HistoryDetailTableViewCell.h"
#import "HistoryModel.h"
#import "DataBaseManager.h"
#import <Masonry/Masonry.h>
#import "HFJKColor.h"

@interface HistoryDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *workNum;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *clockTime;
@property (weak, nonatomic) IBOutlet UIImageView *scrImage;
@property (weak, nonatomic) IBOutlet UIImageView *historyImage;

@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *postion;
@end

@implementation HistoryDetailTableViewCell

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    
//    UIView *bottom = [UIView new];
//    [self.contentView addSubview:bottom];
//    bottom.backgroundColor = [HFJKColor HF_ColorWithHexString:@"#E2E2E2"];
//    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.equalTo(self.contentView);
//        make.height.equalTo(@(1 / [UIScreen mainScreen].scale));
//        make.left.equalTo(self.contentView).offset(20);
//    }];
//}

- (void)loadHistoryInfo:(HistoryModel *)history
{
    _workNum.text = [NSString stringWithFormat:@"工号 : %@",history.workNum];
    _name.text = [NSString stringWithFormat:@"姓名 : %@",history.name];
    _clockTime.text = [NSString stringWithFormat:@"打卡时间 : %@",history.clockTime];
   
    _historyImage.image = history.historyImage;
    _score.text = [NSString stringWithFormat:@"%.f%%",[history.score floatValue]];
    _postion.text = history.facePostion;
    
    NSString *p1ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_1.jpg",history.workNum]];
    NSString *p2ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_2.jpg",history.workNum]];
    NSString *p3ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_3.jpg",history.workNum]];
    NSString *p4ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_4.jpg",history.workNum]];
    NSString *p5ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_5.jpg",history.workNum]];
    NSString *p6ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_6.jpg",history.workNum]];
    NSString *p7ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_7.jpg",history.workNum]];
    NSString *p8ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_8.jpg",history.workNum]];
    UIImage *p1Image = [UIImage imageWithContentsOfFile:p1ImageP];
    UIImage *p2Image = [UIImage imageWithContentsOfFile:p2ImageP];
    UIImage *p3Image = [UIImage imageWithContentsOfFile:p3ImageP];
    UIImage *p4Image = [UIImage imageWithContentsOfFile:p4ImageP];
    UIImage *p5Image = [UIImage imageWithContentsOfFile:p5ImageP];
    UIImage *p6Image = [UIImage imageWithContentsOfFile:p6ImageP];
    UIImage *p7Image = [UIImage imageWithContentsOfFile:p7ImageP];
    UIImage *p8Image = [UIImage imageWithContentsOfFile:p8ImageP];
    
    UIImage *showImage = nil;
    
    if ([history.facePostion isEqualToString:@"left-top"]) {
        showImage = p1Image;
    }else if ([history.facePostion isEqualToString:@"top"]){
        showImage = p2Image;
    }else if ([history.facePostion isEqualToString:@"right-top"]){
        showImage = p3Image;
    }else if ([history.facePostion isEqualToString:@"right"]){
        showImage = p4Image;
    }else if ([history.facePostion isEqualToString:@"right-down"]){
        showImage = p5Image;
    }else if ([history.facePostion isEqualToString:@"down"]){
        showImage = p6Image;
    }else if ([history.facePostion isEqualToString:@"left-down"]){
        showImage = p7Image;
    }else if ([history.facePostion isEqualToString:@"left"]){
        showImage = p8Image;
    }
    else
    {
        showImage = history.imageSrc;
    }
    _scrImage.image = showImage ?: history.imageSrc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
