//
//  FacialCapturingViewController.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/17.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacialCapturingViewController : UIViewController

@property (nonatomic,copy) void(^facialFinish)(NSArray *features,NSArray *facesImage);

@end

NS_ASSUME_NONNULL_END
