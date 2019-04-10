//
//  UserInfoListView.h
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/24.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryModel;
NS_ASSUME_NONNULL_BEGIN

@interface UserInfoListView : UIView

- (void)insetUserInfo:(HistoryModel *)model;

@property (copy,nonatomic) void(^finish)(void);
- (void)clear;
- (BOOL)checkUserExist:(HistoryModel *)model;
@end

NS_ASSUME_NONNULL_END
