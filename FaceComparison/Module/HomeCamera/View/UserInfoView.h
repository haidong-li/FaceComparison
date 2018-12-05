//
//  UserInfoView.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/14.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
NS_ASSUME_NONNULL_BEGIN

@interface UserInfoView : UIView
@property (nonatomic,copy) void(^finish)(void);
- (void)loadUserInfo:(UserModel *)userInfo;
- (void)show;
@property (nonatomic,assign) NSInteger faceScore;
@end

NS_ASSUME_NONNULL_END
