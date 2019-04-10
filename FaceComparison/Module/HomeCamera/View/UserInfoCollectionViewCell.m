//
//  UserInfoCollectionViewCell.m
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/25.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "UserInfoCollectionViewCell.h"
#import "HFJKMacro.h"
#import "HexColor.h"
#import "HistoryModel.h"
@interface UserInfoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *typeOfWork;
@property (weak, nonatomic) IBOutlet UILabel *workNum;
@end

@implementation UserInfoCollectionViewCell


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        self.backgroundColor = ThemeColor;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadUserInfo:(HistoryModel *)model
{
    self.name.text = model.name;
    self.typeOfWork.text = model.typeOfWork;
    self.workNum.text = model.workNum;
//    self.jobNum.text = userInfo.workNum;
    self.head.image = model.imageSrc;
    self.score.text = [NSString stringWithFormat:@"%@%%",model.score];
}

@end
