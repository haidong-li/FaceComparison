//
//  FacialCapturingViewController.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/17.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "FacialCapturingViewController.h"
#import "CameraSession.h"
#import "CameraOutput.h"
#import "MtcnnFaceWrapper.h"
#import "SimilarityDetection.h"
#import "FaceDetectionBaseTools.h"
#import "HFJKMacro.h"
#import <Masonry/Masonry.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "DetectionHud.h"
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/imgcodecs/ios.h>
#import "HFJKColor.h"
#import "MaskView.h"

@interface FacialCapturingViewController ()<CameraOutput>
@property (nonatomic,strong) CameraSession *session;
@property (nonatomic,strong) AVSampleBufferDisplayLayer *cameraLayer;
@property (nonatomic,strong) MtcnnFaceWrapper *mt;
@property (nonatomic,strong) SimilarityDetection *sim;

@property (nonatomic,copy) NSArray* bounds;
@property (nonatomic,assign) BOOL isBusy;

@property (nonatomic,copy) NSArray *p0; //>? 正脸
@property (nonatomic,copy) NSArray *p1; //>? 左上
@property (nonatomic,copy) NSArray *p2; //>? 正上
@property (nonatomic,copy) NSArray *p3; //>? 右上
@property (nonatomic,copy) NSArray *p4; //>? 正右
@property (nonatomic,copy) NSArray *p5; //>? 右下
@property (nonatomic,copy) NSArray *p6; //>? 正下
@property (nonatomic,copy) NSArray *p7; //>? 左下
@property (nonatomic,copy) NSArray *p8; //>? 正左


@property (nonatomic,strong) UIImage *p0Image;
@property (nonatomic,strong) UIImage *p1Image;
@property (nonatomic,strong) UIImage *p2Image;
@property (nonatomic,strong) UIImage *p3Image;
@property (nonatomic,strong) UIImage *p4Image;
@property (nonatomic,strong) UIImage *p5Image;
@property (nonatomic,strong) UIImage *p6Image;
@property (nonatomic,strong) UIImage *p7Image;
@property (nonatomic,strong) UIImage *p8Image;

@property (nonatomic,assign) float rectCenterX;
@property (nonatomic,assign) float rectCenterY;

@property (nonatomic,assign) float noseCenterX;
@property (nonatomic,assign) float noseCenterY;

@property (nonatomic,copy) NSArray *buttons;

@property (nonatomic,assign) BOOL start;
@property (nonatomic,strong) MaskView *maskView;
@property (nonatomic,strong) UILabel *notic;
@end

@implementation FacialCapturingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cameraLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.cameraLayer];
    _session = [[CameraSession alloc] init];
    _session.delegate = self;
    
    _mt = [[MtcnnFaceWrapper alloc] init];
    _sim = [[SimilarityDetection alloc] init];
    
    [_session run];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    UIButton *p0Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [p0Button setTitle:@"正面" forState:UIControlStateNormal];
    p0Button.layer.cornerRadius = 5;
    p0Button.layer.borderColor = [HFJKColor HF_ColorWithHexString:@"#40476C"].CGColor;
    p0Button.layer.borderWidth = 2;
    p0Button.titleLabel.font = [UIFont systemFontOfSize:30 weight:10];
    [self.view addSubview:p0Button];
    
    UIButton *p1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [p1Button setTitle:@"左上" forState:UIControlStateNormal];
    p1Button.layer.cornerRadius = 5;
    p1Button.layer.borderColor = [HFJKColor HF_ColorWithHexString:@"#40476C"].CGColor;
    p1Button.layer.borderWidth = 2;
    p1Button.titleLabel.font = [UIFont systemFontOfSize:30 weight:10];
    [self.view addSubview:p1Button];
    
    UIButton *p2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [p2Button setTitle:@"正上" forState:UIControlStateNormal];
    p2Button.layer.cornerRadius = 5;
    p2Button.layer.borderColor = [HFJKColor HF_ColorWithHexString:@"#40476C"].CGColor;
    p2Button.layer.borderWidth = 2;
    p2Button.titleLabel.font = [UIFont systemFontOfSize:30 weight:10];
    [self.view addSubview:p2Button];
    
    UIButton *p3Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [p3Button setTitle:@"右上" forState:UIControlStateNormal];
    p3Button.layer.cornerRadius = 5;
    p3Button.layer.borderColor = [HFJKColor HF_ColorWithHexString:@"#40476C"].CGColor;
    p3Button.layer.borderWidth = 2;
    p3Button.titleLabel.font = [UIFont systemFontOfSize:30 weight:10];
    [self.view addSubview:p3Button];
    
    UIButton *p4Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [p4Button setTitle:@"正右" forState:UIControlStateNormal];
    p4Button.layer.cornerRadius = 5;
    p4Button.layer.borderColor = [HFJKColor HF_ColorWithHexString:@"#40476C"].CGColor;
    p4Button.layer.borderWidth = 2;
    p4Button.titleLabel.font = [UIFont systemFontOfSize:30 weight:10];
    [self.view addSubview:p4Button];
    
    UIButton *p5Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [p5Button setTitle:@"右下" forState:UIControlStateNormal];
    p5Button.layer.cornerRadius = 5;
    p5Button.layer.borderColor = [HFJKColor HF_ColorWithHexString:@"#40476C"].CGColor;
    p5Button.layer.borderWidth = 2;
    p5Button.titleLabel.font = [UIFont systemFontOfSize:30 weight:10];
    [self.view addSubview:p5Button];
    
    UIButton *p6Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [p6Button setTitle:@"正下" forState:UIControlStateNormal];
    p6Button.layer.cornerRadius = 5;
    p6Button.layer.borderColor = [HFJKColor HF_ColorWithHexString:@"#40476C"].CGColor;
    p6Button.layer.borderWidth = 2;
    p6Button.titleLabel.font = [UIFont systemFontOfSize:30 weight:10];
    [self.view addSubview:p6Button];
    
    UIButton *p7Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [p7Button setTitle:@"左下" forState:UIControlStateNormal];
    p7Button.layer.cornerRadius = 5;
    p7Button.layer.borderColor = [HFJKColor HF_ColorWithHexString:@"#40476C"].CGColor;
    p7Button.layer.borderWidth = 2;
    p7Button.titleLabel.font = [UIFont systemFontOfSize:30 weight:10];
    [self.view addSubview:p7Button];
    
    UIButton *p8Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [p8Button setTitle:@"正左" forState:UIControlStateNormal];
    p8Button.layer.cornerRadius = 5;
    p8Button.layer.borderColor = [HFJKColor HF_ColorWithHexString:@"#40476C"].CGColor;
    p8Button.layer.borderWidth = 2;
    p8Button.titleLabel.font = [UIFont systemFontOfSize:30 weight:10];
    [self.view addSubview:p8Button];
    
    [p0Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [p1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(p0Button.mas_top).offset(-100);
        make.right.equalTo(p0Button.mas_left).offset(-100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [p2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(p1Button);
        make.centerX.equalTo(p0Button);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [p3Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(p1Button);
        make.left.equalTo(p0Button.mas_right).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [p4Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(p3Button);
        make.centerY.equalTo(p0Button);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [p5Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(p4Button);
        make.top.equalTo(p4Button.mas_bottom).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [p6Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(p5Button);
        make.centerX.equalTo(p0Button);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [p7Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(p1Button);
        make.centerY.equalTo(p6Button);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [p8Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(p0Button);
        make.centerX.equalTo(p1Button);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    
   
    [self.view addSubview:self.maskView];

    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setTitle:@"开始采集" forState:UIControlStateNormal];
    [start setTitle:@"采集中" forState:UIControlStateSelected];
    start.backgroundColor = [UIColor redColor];
    [start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    start.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    start.layer.cornerRadius = 50;
    start.clipsToBounds = YES;
    [start addTarget:self action:@selector(startCapturing:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    
    [start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    
    
    UILabel *notic = [[UILabel alloc] init];
    [notic setTextColor:[HFJKColor HF_ColorWithHexString:@"#FFFFFF"]];
    notic.backgroundColor = [HFJKColor HF_ColorWithHexString:@"#40476C"];
    notic.hidden = YES;
    notic.font = [UIFont systemFontOfSize:60];
    notic.textAlignment = NSTextAlignmentCenter;
    notic.layer.cornerRadius = 7;
    notic.clipsToBounds = YES;
    [notic setText:@"请缓慢的旋转面部"];
    [notic.layer addAnimation:[self opacityForever_Animation:1.0] forKey:@"animation"];
    [self.view addSubview:notic];
    [notic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(start);
        make.top.equalTo(start.mas_bottom).offset(10);
    }];
    _notic = notic;
    
    _buttons = @[p0Button,p1Button,p2Button,p3Button,p4Button,p5Button,p6Button,p7Button,p8Button];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.facialFinish) {
        self.facialFinish(@[self.p0,self.p1,self.p2,self.p3,self.p4,self.p5,self.p6,self.p7,self.p8],
                          @[self.p0Image,self.p1Image,self.p2Image,self.p3Image,self.p4Image,self.p5Image,self.p6Image,self.p7Image,self.p8Image]);
    }
}


- (void)startCapturing:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _start = sender.selected;
    _notic.hidden = !sender.selected;
}

- (void)reloadButtons
{
    HFJKWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < weakSelf.buttons.count; i++) {
            UIButton *button =  weakSelf.buttons[i];
            
            if (i == 0 &&  weakSelf.p0Image) {
                [button setImage: weakSelf.p0Image forState:UIControlStateNormal];
                [button setTitle:nil forState:UIControlStateNormal];
            }
            
            if (i == 1 &&  weakSelf.p1Image) {
                [button setImage: weakSelf.p1Image forState:UIControlStateNormal];
                [button setTitle:nil forState:UIControlStateNormal];
            }
            if (i == 2 &&  weakSelf.p2Image) {
                [button setImage: weakSelf.p2Image forState:UIControlStateNormal];
                [button setTitle:nil forState:UIControlStateNormal];
            }
            if (i == 3 &&  weakSelf.p3Image) {
                [button setImage: weakSelf.p3Image forState:UIControlStateNormal];
                [button setTitle:nil forState:UIControlStateNormal];
            }
            if (i == 4 &&  weakSelf.p4Image) {
                [button setImage: weakSelf.p4Image forState:UIControlStateNormal];
                [button setTitle:nil forState:UIControlStateNormal];
            }
            if (i == 5 &&  weakSelf.p5Image) {
                [button setImage: weakSelf.p5Image forState:UIControlStateNormal];
                [button setTitle:nil forState:UIControlStateNormal];
            }
            if (i == 6 &&  weakSelf.p6Image) {
                [button setImage: weakSelf.p6Image forState:UIControlStateNormal];
                [button setTitle:nil forState:UIControlStateNormal];
            }
            if (i == 7 &&  weakSelf.p7Image) {
                [button setImage: weakSelf.p7Image forState:UIControlStateNormal];
                [button setTitle:nil forState:UIControlStateNormal];
            }
            if (i == 8 &&  weakSelf.p8Image) {
                [button setImage: weakSelf.p8Image forState:UIControlStateNormal];
                [button setTitle:nil forState:UIControlStateNormal];
            }
        }
        
        if (weakSelf.p0Image && weakSelf.p1Image &&weakSelf.p2Image  &&weakSelf.p3Image  &&weakSelf.p4Image &&weakSelf.p5Image &&weakSelf.p6Image &&weakSelf.p7Image &&weakSelf.p8Image) {
            [DetectionHud showSuccess:@"采集完成" view:self.view];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    });
    
}

- (void)grepFacesForSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    UIImage  *image = [FaceDetectionBaseTools imageFromPixelBuffer:sampleBuffer];
    __weak typeof(self) wealSelf = self;
    HFJKWeakSelf
    if (_bounds.count && _start) {
        CVImageBufferRef buffer;
        buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        size_t width, height;
        width = CVPixelBufferGetWidth(buffer);
        height = CVPixelBufferGetHeight(buffer);
        
        //找出最大人脸 index 0 关键点。index 1 人脸框
        NSArray *mtcnnResult = [wealSelf.mt detectMaxFace:image];
        
        BOOL moveFast = NO;
        //鼻子点
        float noseCenterX = [mtcnnResult.firstObject[2] CGPointValue].x;
        float noseCenterY = [mtcnnResult.firstObject[2] CGPointValue].x;
        float distance = !self.noseCenterX ? 0 : (fabsf(noseCenterX - self.noseCenterX) + fabsf(noseCenterY - self.noseCenterY)) / 2;
        
        moveFast = (distance > 3) ? YES : NO;
        self.noseCenterX = noseCenterX;
        self.noseCenterY = noseCenterY;
//        NSLog(@"distance is %.2f",distance);
//        if (moveFast) {
//            self.isBusy = NO;
//            return;
//        }
        
        
        CGRect faceRect = [mtcnnResult.lastObject CGRectValue];
        NSArray *landmarks = mtcnnResult.firstObject;
        cv::Mat src,face;
        UIImageToMat(image, src);
        face = src(cv::Rect(faceRect.origin.x,faceRect.origin.y,faceRect.size.width,faceRect.size.height));
       

        CGFloat top = [self CalDis:[landmarks[0] CGPointValue] p2:[landmarks[1] CGPointValue] x:[landmarks[2] CGPointValue]];
        CGFloat bottom = [self CalDis:[landmarks[3] CGPointValue] p2:[landmarks[4] CGPointValue] x:[landmarks[2] CGPointValue]];
        
        CGFloat left = [self CalDis:[landmarks[0] CGPointValue] p2:[landmarks[3] CGPointValue] x:[landmarks[2] CGPointValue]];
        CGFloat right =[self CalDis:[landmarks[1] CGPointValue] p2:[landmarks[4] CGPointValue] x:[landmarks[2] CGPointValue]];
        
        CGFloat leftRight = left / right;
        CGFloat upDown = top / bottom;
        
        NSLog(@"%.4f   %.4f",leftRight,upDown);

        //按比例计算 最好
        if ((leftRight < 0.5 && leftRight > 0.1) && upDown < 0.5 && upDown > 0.2 && !self.p1Image) {
            //左上
            self.p1 = [_sim getMainFaceFeaturesWithOriginalPic:image landmarks:mtcnnResult.firstObject];
            self.p1Image = MatToUIImage(face);
            [self reloadButtons];
        }
        
        //左右眼 距离 差不多的时候
        if (leftRight >= 0.9 && leftRight <= 1.1 && upDown < 0.75 && upDown <= 0.2&& !self.p2Image) {
            //正上
            self.p2 = [_sim getMainFaceFeaturesWithOriginalPic:image landmarks:mtcnnResult.firstObject];
            self.p2Image = MatToUIImage(face);
            [self reloadButtons];
        }
        
        if (leftRight > 1.4  && upDown < 0.6 && !self.p3Image) {
            //右上
            self.p3 = [_sim getMainFaceFeaturesWithOriginalPic:image landmarks:mtcnnResult.firstObject];
            self.p3Image = MatToUIImage(face);
            [self reloadButtons];
        }
        
        if (leftRight > 1.35 && upDown >= 1.0 && upDown <= 1.1 && !self.p4Image) {
            //正右
            self.p4 = [_sim getMainFaceFeaturesWithOriginalPic:image landmarks:mtcnnResult.firstObject];
            self.p4Image = MatToUIImage(face);
            [self reloadButtons];
        }
        
        //上部多 下方很少
        if (leftRight > 1.3 && upDown > 1.55 && !self.p5Image) {
            //右下
            self.p5 = [_sim getMainFaceFeaturesWithOriginalPic:image landmarks:mtcnnResult.firstObject];
            self.p5Image = MatToUIImage(face);
            [self reloadButtons];
        }

        //左右眼 距离 差不多的时候
        if (leftRight >= 0.95 && leftRight <= 1.1 && upDown> 1.95 && !self.p6Image) {
            //正下
            self.p6 = [_sim getMainFaceFeaturesWithOriginalPic:image landmarks:mtcnnResult.firstObject];
            self.p6Image = MatToUIImage(face);
            [self reloadButtons];
        }
        
        //上部多 下方很少
        if (leftRight < 0.55 && upDown > 1.3 && !self.p7Image) {
            //左下
            self.p7 = [_sim getMainFaceFeaturesWithOriginalPic:image landmarks:mtcnnResult.firstObject];
            self.p7Image = MatToUIImage(face);
            [self reloadButtons];
        }
        
        
        if (leftRight < 0.65 && upDown >= 1.0 && upDown <= 1.1 && !self.p8Image) {
            //正左
            self.p8 = [_sim getMainFaceFeaturesWithOriginalPic:image landmarks:mtcnnResult.firstObject];
            self.p8Image = MatToUIImage(face);
            [self reloadButtons];
        }
        
        if ((leftRight >= 0.95) && (leftRight <= 1.1) && upDown >= 0.95 && upDown <= 1.1 && !self.p0Image) {
            //正脸
            self.p0 = [_sim getMainFaceFeaturesWithOriginalPic:image landmarks:mtcnnResult.firstObject];
            self.p0Image = MatToUIImage(face);
            [self reloadButtons];
        }
        
        

    }
    
    self.isBusy = NO;
}
- (CGFloat)distance:(CGPoint)pointA b:(CGPoint)pointB
{
    return sqrt(pow((pointA.x - pointB.x), 2) + pow((pointA.y - pointB.y), 2));
}
- (CGFloat)slope:(CGPoint)pointA b:(CGPoint)pointB
{
    if (!CGPointEqualToPoint(pointA, pointB)) {
        return 0.;
    }
    CGFloat k;
    CGFloat v1 = pointB.x - pointA.x;
    CGFloat v2 = pointB.y - pointA.y;
    k = v1 / v2;
    return k;
}

- (CGFloat)CalDis:(CGPoint)p1 p2:(CGPoint)p2 x:(CGPoint)p3
{
    CGFloat px = p2.x - p1.x;
    CGFloat py = p2.y - p1.y;
    CGFloat som = px * px + py * py;
    CGFloat u = ((p3.x - p1.x) * px + (p3.y - p1.y) * py) / som;
    if (u > 1) {
        u = 1;
    }
    if (u < 0) {
        u = 0;
    }
    //the closest point
    CGFloat x = p1.x + u * px;
    CGFloat y = p1.y + u * py;
    CGFloat dx = x - p3.x;
    CGFloat dy = y - p3.y;
    CGFloat dist = sqrt(dx*dx + dy*dy);
    
    return dist;
}


- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer faces:(NSArray<NSValue *> *)faces
{
    if (self.cameraLayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
        [self.cameraLayer flush];
    }
    
    CVImageBufferRef buffer;
    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t width, height;
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    _bounds = [NSArray arrayWithArray:faces];
    
    NSValue *maxRect;
    CGFloat maxArea = 0;

    //画图
    if (_bounds.count) {
        
        for (NSInteger i = 0; i < _bounds.count; i++) {
            NSValue *faceRect = _bounds[i];
            float tmpArea = [faceRect CGRectValue].size.width * [faceRect CGRectValue].size.height;
            if (tmpArea > maxArea) {
                maxRect =  faceRect;
                maxArea = tmpArea;
            }
        }
    }
    CGRect re = [maxRect CGRectValue];
    
    BOOL overPostion = [self checkFaceInDetectionRect:[maxRect CGRectValue] imageSize:CGSizeMake(width, height)];
    BOOL moveFast = NO;
    BOOL faceTooSmall = NO;
    
    
    //鼻子点
    float rectCenterX = re.origin.x + (re.size.width / 2);
    float rectCenterY = re.origin.y + (re.size.height / 2);
    float distance = !self.rectCenterX ? 0 : (fabsf(rectCenterX - self.rectCenterX) + fabsf(rectCenterY - _rectCenterY)) / 2;
    
    moveFast = (distance > 3) ? YES : NO;
    self.rectCenterX = rectCenterX;
    self.rectCenterY = rectCenterY;
    //facesize
    CGFloat faceSize = re.size.width * re.size.width;
    
    faceTooSmall = faceSize < 8000;
    
    
    
    if (!self.isBusy && !overPostion && !moveFast && !faceTooSmall) {
        self.isBusy = YES;
        CFAllocatorRef allocator = CFAllocatorGetDefault();
        CMSampleBufferRef sbufCopyOut;
        CMSampleBufferCreateCopy(allocator,sampleBuffer,&sbufCopyOut);
        [self performSelectorInBackground:@selector(grepFacesForSampleBuffer:) withObject:CFBridgingRelease(sbufCopyOut)];
    }
    
    [self.cameraLayer enqueueSampleBuffer:sampleBuffer];

}
//检测脸部是否在 检测的区域内 是否出了检测的区域
- (BOOL)checkFaceInDetectionRect:(CGRect)re imageSize:(CGSize)size
{
    CGFloat threshold = 10;
    
    CGFloat x1 = re.origin.x;
    CGFloat y1 = re.origin.y;
    CGFloat x2 = re.origin.x + re.size.width;
    CGFloat y2 = re.origin.y + re.size.height;
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    BOOL overX1 = NO;
    BOOL overY1 = NO;
    BOOL overX2 = NO;
    BOOL overY2 = NO;
    
    if (x1 < threshold) {
        overX1 = YES;
    }
    if (y1 < threshold) {
        overY1 = YES;
    }
    if ((width - x2) < threshold) {
        overX2 = YES;
    }
    if ((height - y2) < threshold) {
        overY2 = YES;
    }
    return (overX1 || overX2 || overY1 || overY2);
}

- (CABasicAnimation *)opacityForever_Animation:(CGFloat)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(1.0);
    animation.toValue = @(0.0);
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}

- (AVSampleBufferDisplayLayer *)cameraLayer
{
    if (!_cameraLayer) {
        _cameraLayer = [[AVSampleBufferDisplayLayer alloc] init];
    }
    return _cameraLayer;
    
}

- (MaskView *)maskView
{
    if (!_maskView) {
        _maskView = [[MaskView alloc] initWithFrame:self.view.bounds];
        _maskView.tap = ^{
//            UserInfoView *infoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, HFJKSCREEN_HEIGHT, HFJKSCREEN_WIDTH, 200)];
//            UserModel *user = [[UserModel alloc] init];
//            user.workNum = @"123";
//            user.name = @"李海冬";
//            user.typeOfWork = @"ios开发";
//            [infoView loadUserInfo:user];
//            [infoView show];
        };
    }
    return _maskView;
}

@end
