//
//  UserListViewController.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/15.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "UserListViewController.h"
#import "DataBaseManager.h"
#import "UserModel.h"
#import "UserInfoTableViewCell.h"
#import <AMSmoothAlert/AMSmoothAlertView.h>
#import <Masonry/Masonry.h>
#import "HFJKColor.h"
#import "FaceDetectionBaseTools.h"
#import <Masonry/Masonry.h>
#import "HFJKMacro.h"
#import "HFJKColor.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
@interface UserListViewController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//    [self.tableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    _dataSource = [NSMutableArray arrayWithArray:[[DataBaseManager shareInstance] allUsers]];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    bg.image = [UIImage imageNamed:@"bg"];
    self.tableView.backgroundView =bg;
    self.tableView.backgroundColor = [UIColor clearColor];
    
//    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HFJKSCREEN_WIDTH, 64)];
//    nav.backgroundColor = [HFJKColor HF_GetColorWithHexString:@"#55BED4" alpha:0.7];
//    
//    [self.view addSubview:nav];
//    
//    UILabel *title = [[UILabel alloc] init];
//    title.text = @"员工列表";
//    title.font = [UIFont systemFontOfSize:20];
//    title.textColor = [UIColor whiteColor];
//    [nav addSubview:title];
//    [title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(nav);
//    }];
//    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    [back setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
//    [back addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [nav addSubview:back];
//    
//    [back mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(nav);
//        make.size.mas_equalTo(CGSizeMake(44, 44));
//        make.left.equalTo(nav).offset(15);
//    }];
}



- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return _dataSource.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _dataSource.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UserModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    [cell loadUserModel:model];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
//        UserModel *user = self.dataSource[indexPath.row];
//        BOOL ret = [[DataBaseManager shareInstance] deleteUser:user];
//        if (ret) {
//            [self.dataSource removeObject:user];
//            [self.tableView reloadData];
//            [self showAlert:@"删除成功" success:YES];
//
//        }else
//        {
//            [self showAlert:@"删除失败" success:NO];
//        }
    }
}


- (void)showAlert:(NSString *)content success:(BOOL)success{
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:nil andText:content andCancelButton:NO forAlertType:success ? AlertSuccess : AlertFailure];
    alert.cornerRadius = 6;
    alert.titleFont = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    alert.textFont = [UIFont systemFontOfSize:22];
    alert.textLabel.frame = CGRectMake(alert.textLabel.frame.origin.x, alert.textLabel.frame.origin.y - 5, 180, 30);
    [alert show];
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                         title:@"删除"
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           [tableView setEditing:NO animated:YES];
                                                                           UserModel *user = self.dataSource[indexPath.row];
                                                                                   BOOL ret = [[DataBaseManager shareInstance] deleteUser:user];
                                                                                   if (ret) {
                                                                                       [self.dataSource removeObject:user];
                                                                                       [self.tableView reloadData];
                                                                                       [self showAlert:@"删除成功" success:YES];
                                                                           
                                                                                   }else
                                                                                   {
                                                                                       [self showAlert:@"删除失败" success:NO];
                                                                                   }
                                                                           
                                                                           
                                                                       }];
    rowAction.backgroundColor = [UIColor clearColor];
    
    return @[rowAction];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
API_AVAILABLE(ios(11.0)){
    // delete action
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        UserModel *user = self.dataSource[indexPath.row];
        BOOL ret = [[DataBaseManager shareInstance] deleteUser:user];
        if (ret) {
            [self.dataSource removeObject:user];
            [self.tableView reloadData];
            [self showAlert:@"删除成功" success:YES];
            
        }else
        {
            [self showAlert:@"删除失败" success:NO];
        }
        
    }];
    
    
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    
    actions.performsFirstActionWithFullSwipe = NO;
    

    return actions;
    
}

- (void)customDeleteBtnAfteriOS11:(UITableView *)tableView {
    for (UIView *subview in tableView.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UISwipeActionPullView"]) {
            UIButton *btn = [subview.subviews objectAtIndex:0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setBackgroundColor:[UIColor clearColor]];
            subview.backgroundColor = [UIColor clearColor];
            
            for (UIView *sub in subview.subviews) {
                if ([NSStringFromClass([sub class]) isEqualToString:@"UISwipeActionStandardButton"]) {
                    // 删除
                    UIView *deleteContentView = sub.subviews[0];
                    sub.backgroundColor = [UIColor clearColor];
                    deleteContentView.backgroundColor = [UIColor redColor];
                    deleteContentView.layer.cornerRadius = 10;
                    [sub mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(sub.superview).offset(10);
                        make.bottom.equalTo(sub.superview).equalTo(@(-10));
                    }];
                }
            }
            
        }
        
        
        
        
    }
}


- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (@available(iOS 11.0, *)) {
        [self customDeleteBtnAfteriOS11:tableView];
    }
    
    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    // disable button touch event during swipe
    for (UIView *view in [tableCell.contentView subviews])
    {
        if ([view isKindOfClass:[UIButton class]]) {
            [view setUserInteractionEnabled:NO];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIView *view in [tableCell.contentView subviews])
    {
        if ([view isKindOfClass:[UIButton class]]) {
            [view setUserInteractionEnabled:YES];
        }
    }
}

@end
