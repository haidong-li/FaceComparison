//
//  UserListTableView.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/17.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "UserListTableView.h"
#import "HFJKMacro.h"
@implementation UserListTableView

- (void)layoutSubviews
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupSlideBtn];
    });
}

// 设置左滑菜单按钮的样式
- (void)setupSlideBtn
{
    // 判断系统是否是iOS11及以上版本
    if (SYSTEM_VERSION_GREATER_THAN(@"11")) {
        for (UIView *subView in self.superview.subviews) {
            if (![NSStringFromClass([subView class]) isEqualToString:@"UISwipeActionPullView"]) {
//                subView.backgroundColor = [UIColor greenColor];
                continue;
            }
            
            for (UIView *buttonViews in subView.subviews) {
                if (![NSStringFromClass([buttonViews class]) isEqualToString:@"UISwipeActionStandardButton"]) {
                    continue;
                }
                
                for (UIButton *btn in buttonViews.subviews) {
                    
                    if ([btn isKindOfClass:[UIButton class]]) {
                        [btn setBackgroundColor:[UIColor orangeColor]];
                        
                        
                    }
                }
            }
        }
        
    } else {
        // iOS11以下做法
        for (UIView *subView in self.subviews) {
            if(![subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
                continue;
            }
            
            // 删除
            UIView *deleteContentView = subView.subviews[0];
            deleteContentView.backgroundColor = [UIColor clearColor];
            //            [self setupRowActionView:deleteContentView imageName:@"delete_bg" width:90];
            
        }
    }
}

@end
