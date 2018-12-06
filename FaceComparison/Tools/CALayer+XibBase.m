//
//  CALayer+XibBase.m
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/6.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "CALayer+XibBase.h"

@implementation CALayer (XibBase)
- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end
