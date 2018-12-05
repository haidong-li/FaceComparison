//
//  UserInfoInputViewController.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/15.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "UserInfoInputViewController.h"
#import "UserModel.h"
#import "DataBaseManager.h"
#import "DetectionHud.h"
#import "SimilarityDetection.h"
#import "MtcnnFaceWrapper.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/imgcodecs/ios.h>
#import "FaceDetectionBaseTools.h"
#import "UserListViewController.h"
#import "FacialCapturingViewController.h"
#import "HFJKMacro.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "HistoryListTableViewController.h"
#import <YYKit/YYTextView.h>
#import <Masonry/Masonry.h>
#import "WSDatePickerView.h"
#import "HFJKColor.h"

@interface UserInfoInputViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *workNum;
@property (weak, nonatomic) IBOutlet UITextField *typeOfWork;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (nonatomic,strong) MtcnnFaceWrapper *mt;
@property (nonatomic,strong) SimilarityDetection *sim;

@property (nonatomic,strong) UIImage *p0Image;
@property (nonatomic,strong) UIImage *p1Image;
@property (nonatomic,strong) UIImage *p2Image;
@property (nonatomic,strong) UIImage *p3Image;
@property (nonatomic,strong) UIImage *p4Image;
@property (nonatomic,strong) UIImage *p5Image;
@property (nonatomic,strong) UIImage *p6Image;
@property (nonatomic,strong) UIImage *p7Image;
@property (nonatomic,strong) UIImage *p8Image;


@property (nonatomic,copy) NSArray *features;
@property (nonatomic,strong) YYTextView *startTimeText;
@end

@implementation UserInfoInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [IQKeyboardManager sharedManager].enable = YES;
    _mt = [[MtcnnFaceWrapper alloc] init];
    _sim = [[SimilarityDetection alloc] init];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    [_imageView addGestureRecognizer:tap];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    close.frame = CGRectMake(50, 50, 40, 40);
    [close addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
    self.fd_prefersNavigationBarHidden = YES;
   
//    [self.startTimeText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.phone.mas_bottom).offset(20);
//        make.left.right.equalTo(self.phone);
//        make.height.equalTo(self.phone);
//    }];
    
}

- (void)closeButtonClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
- (IBAction)checkHistories:(UIButton *)sender {
    
    HistoryListTableViewController *historyListVC = [[HistoryListTableViewController alloc] init];
    [self.navigationController pushViewController:historyListVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)imageViewTap:(UIGestureRecognizer *)tap
{
    HFJKWeakSelf
    FacialCapturingViewController *facialVC = [[FacialCapturingViewController alloc] init];
    [self.navigationController pushViewController:facialVC animated:YES];
    facialVC.facialFinish = ^(NSArray * _Nonnull features, NSArray * _Nonnull facesImage) {
        weakSelf.imageView.image = facesImage[0];
        weakSelf.p0Image =  facesImage[0];
        weakSelf.p1Image =  facesImage[1];
        weakSelf.p2Image =  facesImage[2];
        weakSelf.p3Image =  facesImage[3];
        weakSelf.p4Image =  facesImage[4];
        weakSelf.p5Image =  facesImage[5];
        weakSelf.p6Image =  facesImage[6];
        weakSelf.p7Image =  facesImage[7];
        weakSelf.p8Image =  facesImage[8];
        weakSelf.features = features;
    };
    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
//        pickerVC.delegate = self;
//        pickerVC.allowsEditing = YES;
////        pickerVC.showsCameraControls = YES;
//        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:pickerVC animated:YES completion:nil];
//    }
    
}



- (IBAction)userListClick:(UIButton *)sender {
    UserListViewController *userList = [[UserListViewController alloc] init];
    [self.navigationController pushViewController:userList animated:YES];
}

    

- (IBAction)enterUserInfo:(UIButton *)sender {
    
    if (_features.count < 9) {
        [DetectionHud show:@"未完成脸部采集" icon:nil view:self.view];
        return;
    }
    
    BOOL fullInfo = (self.workNum.text.length && self.workNum.text.length && self.typeOfWork.text.length && self.phone.text.length && self.startTime.text.length && self.p0Image);
    if (!fullInfo)
    {
        [DetectionHud show:@"信息不完整" icon:nil view:self.view];
        return;
    }
    
    UserModel *user = [[UserModel alloc] init];
    user.workNum = self.workNum.text;
    user.name = self.name.text;
    user.typeOfWork = self.typeOfWork.text;
    user.phone = self.phone.text;
    user.startTime = self.startTime.text;
    
    user.feature0 = [(NSArray *)_features[0] componentsJoinedByString:@","]; //>? 正脸
    user.feature1 = [(NSArray *)_features[1] componentsJoinedByString:@","]; //>? 左上
    user.feature2 = [(NSArray *)_features[2] componentsJoinedByString:@","]; //>? 正上
    user.feature3 = [(NSArray *)_features[3] componentsJoinedByString:@","]; //>? 右上
    user.feature4 = [(NSArray *)_features[4] componentsJoinedByString:@","]; //>? 正右
    user.feature5 = [(NSArray *)_features[5] componentsJoinedByString:@","]; //>? 右下
    user.feature6 = [(NSArray *)_features[6] componentsJoinedByString:@","]; //>? 正下
    user.feature7 = [(NSArray *)_features[7] componentsJoinedByString:@","]; //>? 左下
    user.feature8 = [(NSArray *)_features[8] componentsJoinedByString:@","]; //>? 正左
    
    NSArray *selectModels = [[DataBaseManager shareInstance] selecetUserWithKey:@"workNum" value:user.workNum fromTable:@"Users" className:@"UserModel"];
    
    if (selectModels.count) {
        [DetectionHud showFail:@"已存在用户" view:self.view];
        return;
    }
    //存储头像
    
    [FaceDetectionBaseTools saveImage:self.p0Image name:[NSString stringWithFormat:@"%@_0",user.workNum]  path:[DataBaseManager shareInstance].imagePath];;
    [FaceDetectionBaseTools saveImage:self.p1Image name:[NSString stringWithFormat:@"%@_1",user.workNum]  path:[DataBaseManager shareInstance].imagePath];
    [FaceDetectionBaseTools saveImage:self.p2Image name:[NSString stringWithFormat:@"%@_2",user.workNum]  path:[DataBaseManager shareInstance].imagePath];
    [FaceDetectionBaseTools saveImage:self.p3Image name:[NSString stringWithFormat:@"%@_3",user.workNum]  path:[DataBaseManager shareInstance].imagePath];
    [FaceDetectionBaseTools saveImage:self.p4Image name:[NSString stringWithFormat:@"%@_4",user.workNum]  path:[DataBaseManager shareInstance].imagePath];
    [FaceDetectionBaseTools saveImage:self.p5Image name:[NSString stringWithFormat:@"%@_5",user.workNum]  path:[DataBaseManager shareInstance].imagePath];
    [FaceDetectionBaseTools saveImage:self.p6Image name:[NSString stringWithFormat:@"%@_6",user.workNum]  path:[DataBaseManager shareInstance].imagePath];
    [FaceDetectionBaseTools saveImage:self.p7Image name:[NSString stringWithFormat:@"%@_7",user.workNum]  path:[DataBaseManager shareInstance].imagePath];
    [FaceDetectionBaseTools saveImage:self.p8Image name:[NSString stringWithFormat:@"%@_8",user.workNum]  path:[DataBaseManager shareInstance].imagePath];
    
//    user.feature = [features componentsJoinedByString:@","];
   
    [[DataBaseManager shareInstance] insertModel:user toTable:@"Users" db:[DataBaseManager shareInstance].user finish:^(BOOL ret) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ret) {
                [DetectionHud showSuccess:@"录入成功" view:self.view];
            }else
            {
                [DetectionHud showFail:@"录入失败" view:self.view];
                
            }
        });
        
    }];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.startTime) {
        [self showDatePicker];
        return NO;
    }
    return YES;
}

- (void)showDatePicker
{
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        
        NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        self.startTime.text = date;
        NSLog(@"选择的日期：%@",date);
    }];
    datepicker.dateLabelColor = [HFJKColor HF_ColorWithHexString:@"#009CE2"];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = [HFJKColor HF_ColorWithHexString:@"#009CE2"];//确定按钮的颜色
    [datepicker show];
}
@end
