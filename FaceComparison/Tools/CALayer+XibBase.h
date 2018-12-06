//
//  CALayer+XibBase.h
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/6.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CALayer (XibBase)
- (void)setBorderColorFromUIColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
