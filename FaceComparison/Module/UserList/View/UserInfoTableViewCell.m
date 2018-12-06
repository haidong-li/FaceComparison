//
//  UserInfoTableViewCell.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/15.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "UserModel.h"
#import <Masonry/Masonry.h>
#import "HFJKMacro.h"
#import "DataBaseManager.h"

@interface UserInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *workNum;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *startWorkTime;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIImageView *p1;
@property (weak, nonatomic) IBOutlet UIImageView *p2;
@property (weak, nonatomic) IBOutlet UIImageView *p3;
@property (weak, nonatomic) IBOutlet UIImageView *p4;
@property (weak, nonatomic) IBOutlet UIImageView *p5;
@property (weak, nonatomic) IBOutlet UIImageView *p6;
@property (weak, nonatomic) IBOutlet UIImageView *p7;
@property (weak, nonatomic) IBOutlet UIImageView *p9;


@end


@implementation UserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadUserModel:(UserModel *)model
{
    self.name.text = model.name;
    self.workNum.text = model.workNum;
    self.phone.text = model.phone;
    self.startWorkTime.text = model.startTime;
    self.head.image = model.imageSrc;
    
    NSString *p1ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_1.jpg",model.workNum]];
    NSString *p2ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_2.jpg",model.workNum]];
    NSString *p3ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_3.jpg",model.workNum]];
    NSString *p4ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_4.jpg",model.workNum]];
    NSString *p5ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_5.jpg",model.workNum]];
    NSString *p6ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_6.jpg",model.workNum]];
    NSString *p7ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_7.jpg",model.workNum]];
    NSString *p8ImageP = [[DataBaseManager shareInstance].imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_8.jpg",model.workNum]];
    UIImage *p1Image = [UIImage imageWithContentsOfFile:p1ImageP];
    UIImage *p2Image = [UIImage imageWithContentsOfFile:p2ImageP];
    UIImage *p3Image = [UIImage imageWithContentsOfFile:p3ImageP];
    UIImage *p4Image = [UIImage imageWithContentsOfFile:p4ImageP];
    UIImage *p5Image = [UIImage imageWithContentsOfFile:p5ImageP];
    UIImage *p6Image = [UIImage imageWithContentsOfFile:p6ImageP];
    UIImage *p7Image = [UIImage imageWithContentsOfFile:p7ImageP];
    UIImage *p8Image = [UIImage imageWithContentsOfFile:p8ImageP];
    
    self.p1.image = p1Image;
    self.p2.image = p2Image;
    self.p3.image = p3Image;
    self.p4.image = p4Image;
    self.p5.image = p5Image;
    self.p6.image = p6Image;
    self.p7.image = p7Image;
    self.p9.image = p8Image;
    
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [super insertSubview:view atIndex:index];
    
    if ([view isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
        
        for (UIButton *btn in view.subviews) {
            
            if ([btn isKindOfClass:[UIButton class]]) {
                
                [btn setBackgroundColor:[UIColor redColor]];
                
                [btn setTintColor:[UIColor whiteColor]];
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(btn.superview).offset(10);
                    make.bottom.equalTo(btn.superview).equalTo(@(-10));
                }];
                
            }
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
