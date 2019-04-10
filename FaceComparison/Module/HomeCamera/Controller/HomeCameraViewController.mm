//
//  HomeCameraViewController.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

//记录代码执行时间
#define TIK CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
#define TOK CFAbsoluteTime \
linkTime = (CFAbsoluteTimeGetCurrent() - startTime);\
NSLog(@"method is %@ Linked in %f ms", NSStringFromSelector(_cmd),linkTime *1000.0);\

#import "HomeCameraViewController.h"
#import "CameraSession.h"
#import "CameraOutput.h"
#import <HDFaceDetection/HDFaceDetection.h>
#import <HDFaceDetection/HDFaceComparison.h>
#import "MaskView.h"
#import "FaceDetectionBaseTools.h"
#import "UserInfoView.h"
#import "HFJKMacro.h"
#import "UserModel.h"
#import "DataBaseManager.h"
#import "UserInfoInputViewController.h"
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "HistoryModel.h"
#import "FacePostTool.h"
#import "UserInfoListView.h"
#import "CircularCollectionViewLayout.h"
#import "PageCardFlowLayout.h"
#import "ExcelManager.h"
static NSInteger const faceMoveSpeed = 3;
#define MaxSections 100
@interface HomeCameraViewController ()<CameraOutput,UICollectionViewDelegate,UICollectionViewDataSource,UIDocumentInteractionControllerDelegate,PageCardFlowLayoutDelegate>
@property (nonatomic,strong) CameraSession *session;
@property (nonatomic,strong) AVSampleBufferDisplayLayer *cameraLayer;
@property (nonatomic,strong) HDFaceDetection *mt;
@property (nonatomic,strong) HDFaceComparison *sim;
@property (nonatomic,copy) NSArray* bounds;
@property (nonatomic,assign) BOOL isBusy;

//mask view
@property (nonatomic,strong) MaskView *maskView;

@property (nonatomic,copy) NSArray <UserModel *>*users;

@property (nonatomic,copy) NSArray *feature0;
@property (nonatomic,copy) NSArray *feature1;
@property (nonatomic,copy) NSArray *feature2;
@property (nonatomic,copy) NSArray *feature3;
@property (nonatomic,copy) NSArray *feature4;
@property (nonatomic,copy) NSArray *feature5;
@property (nonatomic,copy) NSArray *feature6;
@property (nonatomic,copy) NSArray *feature7;
@property (nonatomic,copy) NSArray *feature8;

@property (nonatomic,strong) UserInfoView *userInfoView;
@property (strong,nonatomic) UserInfoListView *userInfoListView;
@property (nonatomic,assign) NSInteger checkedOutWorkNum;
@property (nonatomic,assign) BOOL sameUser;


//
@property (nonatomic,assign) float rectCenterX;
@property (nonatomic,assign) float rectCenterY;
@property (strong,nonatomic) UIImageView *head;

@property (nonatomic,strong) NSArray *dataSourceArray;
@property (nonatomic,strong) PageCardFlowLayout *layout;

@property (nonatomic,assign) NSInteger indexPath;
@property (nonatomic,assign) BOOL showUserInfo;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation HomeCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    
//    UIImage *head = [UIImage imageNamed:@"headPose.jpg"];
//    head = [FacePostTool facePostion:nil image:head];
    
    
    
    self.view.backgroundColor = [UIColor redColor];

    self.cameraLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.cameraLayer];
    _session = [[CameraSession alloc] init];
    _session.delegate = self;

    _mt = [[HDFaceDetection alloc] init];
    _sim = [[HDFaceComparison alloc] init];


    [self.view addSubview:self.maskView];


    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"manager"] forState:UIControlStateNormal];
    button.frame = CGRectMake(HFJKSCREEN_WIDTH - 100, 50, 50, 50);
    [button addTarget:self action:@selector(managerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
     [_session run];
    UIImageView *show = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    //    show.image = head;
    _head = show;
    [self.view addSubview:show];
    
    [self.view addSubview:self.userInfoListView];
//    self.dataSourceArray = @[@(1),@(2),@(3),@(4),@(5),@(6),@(7)];
//    [self.view addSubview:self.collectionView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
    [_session run];
    
    
    NSString *path = [ExcelManager createExcelFileWithName:@"lihaidong"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _documentInteractionController = [UIDocumentInteractionController
                                      interactionControllerWithURL:url];
    [_documentInteractionController setDelegate:self];
    
    [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    
//    self.indexPath = 0;
//    [self scrollToItemAtIndexPath:0 andSection:(MaxSections/2 - 1) withAnimated:NO];
}


- (void)getData
{
    _users = [[DataBaseManager shareInstance] allUsers];
    _feature0 = [[DataBaseManager shareInstance] currentFeature0];
    _feature1 = [[DataBaseManager shareInstance] currentFeature1];
    _feature2 = [[DataBaseManager shareInstance] currentFeature2];
    _feature3 = [[DataBaseManager shareInstance] currentFeature3];
    _feature4 = [[DataBaseManager shareInstance] currentFeature4];
    _feature5 = [[DataBaseManager shareInstance] currentFeature5];
    _feature6 = [[DataBaseManager shareInstance] currentFeature6];
    _feature7 = [[DataBaseManager shareInstance] currentFeature7];
    _feature8 = [[DataBaseManager shareInstance] currentFeature8];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_session stop];
}

- (void)managerButtonClick:(UIButton *)sender
{
    UserInfoInputViewController *inputVC = [[UserInfoInputViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:inputVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer faces:(NSArray<NSValue *> *)faces
{
    
    HFJKWeakSelf
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
       
//        [[DataBaseManager shareInstance] open:[DataBaseManager shareInstance].history];
        for (NSInteger i = 0; i < _bounds.count; i++) {
            NSValue *faceRect = _bounds[i];
            float tmpArea = [faceRect CGRectValue].size.width * [faceRect CGRectValue].size.height;
            if (tmpArea > maxArea) {
                maxRect =  faceRect;
                maxArea = tmpArea;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.maskView.picSize = CGSizeMake(width, height);
            self.maskView.faces = weakSelf.bounds;
        });
    }else{
        [self clearMask];
//        [[DataBaseManager shareInstance] close:[DataBaseManager shareInstance].history];
    }
    
    CGRect re = [maxRect CGRectValue];
    
    BOOL overPostion = [self checkFaceInDetectionRect:[maxRect CGRectValue] imageSize:CGSizeMake(width, height)];
    BOOL moveFast = NO;
    BOOL faceTooSmall = NO;
    
    
    //鼻子点
    float rectCenterX = re.origin.x + (re.size.width / 2);
    float rectCenterY = re.origin.y + (re.size.height / 2);
    float distance = !self.rectCenterX ? 0 : (fabsf(rectCenterX - self.rectCenterX) + fabsf(rectCenterY - _rectCenterY)) / 2;
    
    moveFast = (distance > faceMoveSpeed) ? YES : NO;
    self.rectCenterX = rectCenterX;
    self.rectCenterY = rectCenterY;
    //facesize
    CGFloat faceSize = re.size.width * re.size.width;
    
    faceTooSmall = faceSize < 4000;
    
//    NSLog(@"size is %.2f  speed is %.2f",faceSize,distance);
    
    
    if (!self.isBusy && !overPostion && !moveFast && !faceTooSmall) {
        self.isBusy = YES;
        CFAllocatorRef allocator = CFAllocatorGetDefault();
        CMSampleBufferRef sbufCopyOut;
        CMSampleBufferCreateCopy(allocator,sampleBuffer,&sbufCopyOut);
        [self performSelectorInBackground:@selector(grepFacesForSampleBuffer:) withObject:CFBridgingRelease(sbufCopyOut)];
    }
//
//    if (!_bounds.count) {
//        [self clearMask];
//    }
//
    [self.cameraLayer enqueueSampleBuffer:sampleBuffer];
    
}

- (void)grepFacesForSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    UIImage  *image = [FaceDetectionBaseTools imageFromPixelBuffer:sampleBuffer];

    HFJKWeakSelf
    if (_bounds.count) {
        CVImageBufferRef buffer;
        buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        size_t width, height;
        width = CVPixelBufferGetWidth(buffer);
        height = CVPixelBufferGetHeight(buffer);
        
        //找出最大人脸 index 0 关键点。index 1 人脸框
//        NSArray *mtcnnResult = [wealSelf.mt detectMaxFace:image];
        NSArray *mtcnnResult = [weakSelf.mt detectFace:image];
       
        
        
        for (NSInteger i = 0; i < mtcnnResult.count; i++) {
            NSArray *faceInfo = mtcnnResult[i];
            NSArray *landmarks = faceInfo.firstObject;
            CGRect faceRect = [faceInfo.lastObject CGRectValue];
            NSInteger postion = [self postion:faceInfo.firstObject];

            dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
                [weakSelf faceComparison:postion faceRect:faceRect image:image landmarks:landmarks];
            });
        }
       
        
    }
    self.isBusy = NO;
}


- (void)faceComparison:(NSInteger)postion faceRect:(CGRect)faceRect image:(UIImage *)image landmarks:(NSArray *)landmarks
{
    HFJKWeakSelf
    NSArray *whichFeatures = nil;
    NSString *facePostion = @"";
    switch (postion) {
        case 0:
            facePostion = @"front";
            whichFeatures = self.feature0;
            break;
        case 1:
            facePostion = @"left-top";
            whichFeatures = self.feature1;
            break;
        case 2:
            facePostion = @"top";
            whichFeatures = self.feature2;
            break;
        case 3:
            facePostion = @"right-top";
            whichFeatures = self.feature3;
            break;
        case 4:
            facePostion = @"right";
            whichFeatures = self.feature4;
            break;
        case 5:
            facePostion = @"right-down";
            whichFeatures = self.feature5;
            break;
        case 6:
            facePostion = @"down";
            whichFeatures = self.feature6;
            break;
        case 7:
            facePostion = @"left-down";
            whichFeatures = self.feature7;
            break;
        case 8:
            facePostion = @"left";
            whichFeatures = self.feature8;
            break;
        default:
            break;
    }

    
    if (whichFeatures.count) {
        NSArray *feature =  [_sim getFaceFeaturesWithOriginalPic:image landmarks:landmarks];
        NSDictionary *simResult = [_sim findMostSimilarityFace:feature inDataSource:whichFeatures];
        NSInteger index = [simResult[@"index"] integerValue];
        CGFloat score = [simResult[@"score"] floatValue];
        if (index > -1 && score > 80) {
            UserModel *findResult = weakSelf.users[index];
            NSInteger workNum = [findResult.workNum integerValue];
            
//            if (weakSelf.checkedOutWorkNum == [findResult.workNum integerValue]) {
//                weakSelf.sameUser = YES;
//            }else
//            {
//                weakSelf.sameUser = NO;
//            }
            
            
//            BOOL exist = [weakSelf.userInfoListView checkUserExist:findResult];
//            if (exist) {
//                return;
//            }
            
            HistoryModel *history = [[HistoryModel alloc] init];
            history.name = findResult.name;
            history.workNum = findResult.workNum;
            history.clockTime = [FaceDetectionBaseTools getCurrentTimes];
            history.typeOfWork = findResult.typeOfWork;
            history.facePostion = facePostion;
            history.score = [NSString stringWithFormat:@"%.2f",score];
            //存储图片
            cv::Mat src,face;
            UIImageToMat(image, src);
            face = src(cv::Rect(faceRect.origin.x,faceRect.origin.y,faceRect.size.width,faceRect.size.height));
            cv::resize(face, face, cv::Size(100,100));
            [[DataBaseManager shareInstance] insertModel:history toTable:[[DataBaseManager shareInstance] currentHistoryTable] db:[DataBaseManager shareInstance].history finish:^(BOOL ret) {
                if (ret) {
                    
                    [FaceDetectionBaseTools saveImage:MatToUIImage(face) name:history.clockTime path:[[[DataBaseManager shareInstance] historyImagePath] stringByAppendingPathComponent:[DataBaseManager shareInstance].currentHistoryTable]];
                }
            }]; //>? 插入数据库
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.userInfoListView insetUserInfo:history];
            });
            
            weakSelf.checkedOutWorkNum = workNum;
        }else
        {
            
            //                NSLog(@"没有这个人 %ld",index);
        }
    }
    
}
- (void)clearMask
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.maskView.faces) {
            self.maskView.faces = nil;
        }
    });
}

- (NSInteger)postion:(NSArray *)landmarks
{
    CGFloat top = [self CalDis:[landmarks[0] CGPointValue] p2:[landmarks[1] CGPointValue] x:[landmarks[2] CGPointValue]];
    CGFloat bottom = [self CalDis:[landmarks[3] CGPointValue] p2:[landmarks[4] CGPointValue] x:[landmarks[2] CGPointValue]];
    
    CGFloat left = [self CalDis:[landmarks[0] CGPointValue] p2:[landmarks[3] CGPointValue] x:[landmarks[2] CGPointValue]];
    CGFloat right =[self CalDis:[landmarks[1] CGPointValue] p2:[landmarks[4] CGPointValue] x:[landmarks[2] CGPointValue]];
    
    CGFloat leftRight = left / right;
    CGFloat upDown = top / bottom;
    
    
    //按比例计算 最好
    if ((leftRight < 0.7) && upDown < 0.7) {
        //左上
        return 1;
    }
    
    //左右眼 距离 差不多的时候
    if (leftRight >= 0.9 && leftRight <= 1.1 && upDown < 0.4) {
        //正上
        return 2;
    }
    
    if (leftRight > 1.3 && upDown < 0.8) {
        //右上
        return 3;
    }
    
    if (leftRight >= 1.3 && upDown >= 0.7 && upDown <= 1.3) {
        //正右
        return 4;
    }
    
    //上部多 下方很少
    if (leftRight > 1.3 && upDown > 1.3) {
        //右下角
        return 5;
    }
    
    //左右眼 距离 差不多的时候
    if (leftRight > 0.9 && leftRight <= 1.1 && upDown> 2.0) {
        //正下
        return 6;
    }
    
    //上部多 下方很少
    if (leftRight < 0.8 && upDown > 1.3) {
        //左下
       return 7;
    }
    
    
    if (leftRight <= 0.5 && upDown >= 0.7 && upDown <= 1.3) {
        //正左
        return 8;
    }
    
    //越界情况
    if (upDown >= 0.7 && upDown <= 1.3) {
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 4;
        }
        
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 8;
        }
    }

    if (upDown < 0.7) {
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 3;
        }
        
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 1;
        }
    }
    
    if (upDown > 1.8) {
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 5;
        }
        
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 7;
        }
    }
    
    return 0;
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


- (CGFloat)distance:(CGPoint)pointA b:(CGPoint)pointB
{
    return sqrt(pow((pointA.x - pointB.x), 2) + pow((pointA.y - pointB.y), 2));
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
            UserInfoView *infoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, HFJKSCREEN_HEIGHT, HFJKSCREEN_WIDTH, 200)];
            UserModel *user = [[UserModel alloc] init];
            user.workNum = @"123";
            user.name = @"李海冬";
            user.typeOfWork = @"ios开发";
            [infoView loadUserInfo:user];
            [infoView show];
        };
    }
    return _maskView;
}

- (UserInfoListView *)userInfoListView
{
    if (!_userInfoListView) {
        _userInfoListView = [[UserInfoListView alloc] initWithFrame:CGRectMake(0, HFJKSCREEN_HEIGHT - 300, HFJKSCREEN_WIDTH, 300)];
        
    }
    return _userInfoListView;
}
- (void)setSameUser:(BOOL)sameUser
{
    HFJKWeakSelf
    if ((_sameUser == NO) && (sameUser == YES)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.sameUser = NO;
            weakSelf.checkedOutWorkNum = -1;
        });
    }

    _sameUser = sameUser;
}

@end
