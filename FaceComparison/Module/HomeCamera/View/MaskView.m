//
//  MaskView.m
//  CatchPicture
//
//  Created by hfjk on 2018/10/11.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "MaskView.h"
#import "HexColor.h"
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


@interface MaskView ()

@property (nonatomic,assign) CGRect lastRect;

@end

@implementation MaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tripleFinger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleFingerTap:)];
        tripleFinger.numberOfTouchesRequired = 3;
        tripleFinger.numberOfTapsRequired = 3;
        [self addGestureRecognizer:tripleFinger];
        
    }
    return self;
}
- (void)tripleFingerTap:(UIGestureRecognizer *)tap
{
    if (self.tap) {
        self.tap();
    }
    NSLog(@"点击了");
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.backgroundColor = [UIColor clearColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    
    //矩形，并填弃颜色
    UIColor *aColor = [HexColor colorWithHexString:@"#438AFF"];
   
    
    

    CGFloat scale =  self.frame.size.width / self.picSize.width ;
    for (NSValue *value in _faces) {
        CGContextSetLineWidth(context, 2.0);//线的宽度

        CGRect r = [value CGRectValue];
        
        CGFloat space = 0.0;
        if (KIsiPhoneX) {
            space = 64;
        }
        CGFloat width = r.size.width;
        CGFloat height = r.size.height;
        CGFloat x = r.origin.x;
        CGFloat y = r.origin.y;
        //防抖
        CGFloat pThreshold = 2;
        CGFloat sThreshold = 20;
        if (self.lastRect.size.width && self.lastRect.size.height && ((self.lastRect.size.width * self.lastRect.size.height) > 50)) {
            CGFloat widthDif = (CGFloat)fabs(r.size.width - self.lastRect.size.width);
            CGFloat heightDif = (CGFloat)fabs(r.size.width - self.lastRect.size.width);
            CGFloat xDif = (CGFloat)fabs(r.origin.x - self.lastRect.origin.x);
            CGFloat yDif = (CGFloat)fabs(r.origin.y - self.lastRect.origin.y);
            if (widthDif < sThreshold) {
                width = self.lastRect.size.width;
            }
            if (heightDif < sThreshold) {
                height = self.lastRect.size.height;
            }
            
            if (xDif < pThreshold) {
                x = self.lastRect.origin.x;
            }
            if (yDif < pThreshold) {
                y = self.lastRect.origin.y;
            }
        }
        CGRect face = CGRectMake(x * scale , y * scale + space, width * scale, height * scale);
        self.lastRect = CGRectMake(x, y, width, height);
        CGContextStrokeRect(context,face);//画方框
        CGContextFillRect(context,face);//填充框
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
        CGContextAddRect(context,face);//画方框
        
       
        
        
        CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
//        self.layer.cornerRadius = 7;
        CGFloat cornerW = face.size.width / 8;
        CGFloat lineW = 6;
        CGFloat lineSpace = lineW / 2;
        //left top
        CGContextMoveToPoint(context, face.origin.x - lineSpace, face.origin.y+cornerW - lineSpace);
        CGContextAddLineToPoint(context,  face.origin.x- lineSpace, face.origin.y - lineSpace);
        CGContextAddLineToPoint(context, face.origin.x - lineSpace + cornerW, face.origin.y - lineSpace);
        
        //right top
        CGContextMoveToPoint(context, face.origin.x + face.size.width - cornerW + lineSpace, face.origin.y - lineSpace);
        CGContextAddLineToPoint(context,  face.origin.x + face.size.width + lineSpace, face.origin.y - lineSpace);
        CGContextAddLineToPoint(context, face.origin.x + face.size.width + lineSpace, face.origin.y + cornerW - lineSpace);
        
        //right bottom
        CGContextMoveToPoint(context, face.origin.x + face.size.width + lineSpace, face.origin.y + face.size.height - cornerW + lineSpace);
        CGContextAddLineToPoint(context,  face.origin.x + face.size.width + lineSpace, face.origin.y + face.size.height + lineSpace);
        CGContextAddLineToPoint(context, face.origin.x + face.size.width - cornerW + lineSpace, face.origin.y + face.size.height + lineSpace);
        
        //left bottom
        CGContextMoveToPoint(context, face.origin.x  - lineSpace, face.origin.y + face.size.height - cornerW + lineSpace);
        CGContextAddLineToPoint(context,  face.origin.x  - lineSpace, face.origin.y + face.size.height + lineSpace);
        CGContextAddLineToPoint(context, face.origin.x + cornerW  - lineSpace, face.origin.y + face.size.height + lineSpace);
//        CGContextSetStrokeColorWithColor(context,aColor.CGColor);
        CGContextSetLineWidth(context, lineW);
        CGContextSetLineCap(context, kCGLineCapButt);
        CGContextSetLineJoin(context, kCGLineJoinMiter);
        CGContextStrokePath(context);
        
    }
}

- (void)setFaces:(NSArray<NSValue *> *)faces
{
    _faces = faces;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

@end
