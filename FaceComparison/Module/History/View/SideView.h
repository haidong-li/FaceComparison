//
//  SideView.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/19.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SideView : NSObject

@property (nonatomic,copy) NSArray <NSString *>*histortList;
@property (nonatomic,copy) void(^selectDate)(NSString *date);
@property (nonatomic,copy) void(^reloadData)(void);
- (void)show;
@end

NS_ASSUME_NONNULL_END
