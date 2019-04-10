//
//  CircularCollectionViewLayout.h
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/24.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PageCardFlowLayoutDelegate <NSObject>

- (void)scrollToPageIndex:(NSInteger)index;

@end

@interface CircularCollectionViewLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat previousOffsetX;
@property (nonatomic,weak) id<PageCardFlowLayoutDelegate> delegate;
@end





NS_ASSUME_NONNULL_END
