//
//  FacePostionView.m
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/17.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "FacePostionView.h"
#import "HFJKMacro.h"
#import "HexColor.h"

@implementation FacePostionView

- (void)drawRect:(CGRect)rect
{
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake(self.bounds.size.width / 2.0 , (HFJKSCREEN_HEIGHT / 3) + 100 - 250)];//设置初始点
    //终点  controlPoint:切点（并不是拐弯处的高度，不懂的同学可以去看三角函数）
    [aPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width / 2.0 , (HFJKSCREEN_HEIGHT / 3) + 100 + 250) controlPoint:CGPointMake((HFJKSCREEN_WIDTH / 2) + (self.left - self.right) * 5, (HFJKSCREEN_HEIGHT / 3) + 100)];
    
    UIColor *color = [HexColor colorWithHexString:@"#438AFF"];;
    [color set];
    [aPath stroke];
    
    
    [self drawVerticalLine];
}

- (void)drawVerticalLine
{
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake((self.bounds.size.width - 500) / 2, (HFJKSCREEN_HEIGHT / 3) + 100 )];//设置初始点
    //终点  controlPoint:切点（并不是拐弯处的高度，不懂的同学可以去看三角函数）
    [aPath addQuadCurveToPoint:CGPointMake((self.bounds.size.width - 500) / 2 + 500, (HFJKSCREEN_HEIGHT / 3) + 100 ) controlPoint:CGPointMake(self.bounds.size.width / 2, (HFJKSCREEN_HEIGHT / 3) + 100 + (self.top - self.bottom + 20) * 5)];
    
    UIColor *color = [HexColor colorWithHexString:@"#438AFF"];;
    [color set];
    [aPath stroke];
}
- (void)setLeft:(CGFloat)left
{
    _left = ceilf(left);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)setRight:(CGFloat)right
{
    _right = ceilf(right);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}
@end
