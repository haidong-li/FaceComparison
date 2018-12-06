//
//  UserInfoTableViewCell.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/15.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
NS_ASSUME_NONNULL_BEGIN

@interface UserInfoTableViewCell : UITableViewCell
- (void)loadUserModel:(UserModel *)model;
@end

NS_ASSUME_NONNULL_END
