//
//  FacePostionView.h
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/17.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacePostionView : UIView

@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) BOOL wrongPostion;


@end

NS_ASSUME_NONNULL_END
