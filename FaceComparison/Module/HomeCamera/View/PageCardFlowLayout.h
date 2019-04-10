//
//  PageCardFlowLayout.h
//  PageCardDemo
//
//  Created by lly on 16/9/1.
//  Copyright © 2016年 lly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageCardFlowLayoutDelegate <NSObject>

- (void)scrollToPageIndex:(NSInteger)index;

@end


@interface PageCardFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat previousOffsetX;
@property (nonatomic,weak) id<PageCardFlowLayoutDelegate> delegate;
@end
