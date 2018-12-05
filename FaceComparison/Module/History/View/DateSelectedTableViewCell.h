//
//  DateSelectedTableViewCell.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/20.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateSelectedTableViewCell : UITableViewCell

@property (nonatomic,copy) void(^deleteButtonClick)(void);

@end

NS_ASSUME_NONNULL_END
