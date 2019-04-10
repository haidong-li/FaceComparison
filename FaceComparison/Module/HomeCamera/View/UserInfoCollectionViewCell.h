//
//  UserInfoCollectionViewCell.h
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/25.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HistoryModel;
@interface UserInfoCollectionViewCell : UICollectionViewCell
- (void)loadUserInfo:(HistoryModel *)model;
@end

NS_ASSUME_NONNULL_END
