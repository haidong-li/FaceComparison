//
//  HistoryDetailTableViewCell.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/19.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistotyModel;
NS_ASSUME_NONNULL_BEGIN

@interface HistoryDetailTableViewCell : UITableViewCell
- (void)loadHistoryInfo:(HistotyModel *)history;
@end

NS_ASSUME_NONNULL_END
