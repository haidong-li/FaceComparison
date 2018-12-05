//
//  DateSelectedTableViewCell.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/20.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "DateSelectedTableViewCell.h"

@implementation DateSelectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteButtonClick:(UIButton *)sender {
    if (self.deleteButtonClick) {
        self.deleteButtonClick();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
