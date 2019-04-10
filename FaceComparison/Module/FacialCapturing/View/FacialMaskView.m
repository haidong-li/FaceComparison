//
//  FacialMaskView.m
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/17.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "FacialMaskView.h"
#import "HFJKMacro.h"
#import "HexColor.h"
@implementation FacialMaskView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [HexColor colorWithHexString:@"#438AFF"];
        UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) cornerRadius:0];
        
        //贝塞尔曲线 画一个圆形
        [bpath appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x, (HFJKSCREEN_HEIGHT / 3) + 100) radius:250  startAngle:0 endAngle:2*M_PI clockwise:NO]];
        
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bpath.CGPath;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        
        self.userInteractionEnabled = NO;
        self.layer.mask = shapeLayer;
        
    }
    return self;
}



- (void)setFaces:(NSArray<NSValue *> *)faces
{
    _faces = faces;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

@end
