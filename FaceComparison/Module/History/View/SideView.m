//
//  SideView.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/19.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "SideView.h"
#import "HFJKMacro.h"
#import <Masonry/Masonry.h>
#import "DateSelectedTableViewCell.h"
#import "FaceDetectionBaseTools.h"
#import "DataBaseManager.h"
#import "DetectionHud.h"

#define kViewWidth 200

@interface SideView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *backView;

@end


@implementation SideView

- (void)show
{
    UIView *view = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].windows.lastObject.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    view.userInteractionEnabled = YES;
    tap.delegate = self;
    [view addGestureRecognizer:tap];
    _backView = view;
    [[UIApplication sharedApplication].windows.lastObject addSubview:_backView];
    [view addSubview:self.tableView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(HFJKSCREEN_WIDTH - kViewWidth, 50, kViewWidth, HFJKSCREEN_HEIGHT - 100);
    }];
}

- (void)viewTap:(UITapGestureRecognizer *)tap
{
    [self.backView removeFromSuperview];
    self.tableView = nil;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _histortList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HFJKWeakSelf
    DateSelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *tableName = _histortList[indexPath.row];
    
    cell.deleteButtonClick = ^{
        [weakSelf showAlertView:tableName];
    };

    cell.textLabel.text = tableName;
    return cell;
}

- (void)showAlertView:(NSString *)date
{
    HFJKWeakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除当前本月的所有数据么？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        BOOL ret = [[DataBaseManager shareInstance] deleteHistoryTable:date];
        if ([date isEqualToString:[DataBaseManager shareInstance].currentHistoryTable]) {
            [DataBaseManager shareInstance].currentHistoryTable = nil;
        }
        if (ret) {
            [DetectionHud showSuccess:@"删除成功" view:weakSelf.backView];
            weakSelf.histortList = [[DataBaseManager shareInstance] historyList];
            [weakSelf.tableView reloadData];
            
            if (self.reloadData) {
                self.reloadData();
            }
        }else
        {
            [DetectionHud showFail:@"删除失败" view:weakSelf.backView];
        }
    }];

    [alert addAction:action1];
    [alert addAction:action2];
    
    [[FaceDetectionBaseTools topViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectDate = _histortList[indexPath.row];
    if (self.selectDate) {
        self.selectDate(selectDate);
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(HFJKSCREEN_WIDTH, 50, kViewWidth, HFJKSCREEN_HEIGHT - 100) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.layer.cornerRadius = 5;
//        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = 50;
        [_tableView registerNib:[UINib nibWithNibName:@"DateSelectedTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
