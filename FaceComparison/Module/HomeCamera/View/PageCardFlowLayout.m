//
//  PageCardFlowLayout.m
//  PageCardDemo
//
//  Created by lly on 16/9/1.
//  Copyright © 2016年 lly. All rights reserved.
//

#define kPageCardWidth 250
#define kLineSpace 10
#define kPageCardHeight 250

#import "PageCardFlowLayout.h"

@interface PageCardFlowLayout()
@property (nonatomic,assign) int pageNum;
@end


@implementation PageCardFlowLayout

- (void)prepareLayout{
    
    [super prepareLayout];
    //滑动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //两个cell的间距
    self.minimumLineSpacing = kLineSpace;
    //计算cell超出显示的宽度
    CGFloat width = ((self.collectionView.frame.size.width - kPageCardWidth)-(kLineSpace*2))/2;
    //每个section的间距
//    self.sectionInset = UIEdgeInsetsMake(0, kLineSpace, 0, 0);
    //每个cell实际的大小
    self.itemSize = CGSizeMake(kPageCardWidth,kPageCardHeight);
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    self.collectionView.frame.size.width,
                                    self.collectionView.frame.size.height);
    CGFloat offset = CGRectGetMinX(visibleRect);
    
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat distance = offset - attribute.frame.origin.x;
        // 越往中心移动，值越小，那么缩放就越小，从而显示就越大
        // 同样，超过中心后，越往左、右走，缩放就越大，显示就越小
        CGFloat scaleForDistance = distance / self.itemSize.width;
        // 0.1可调整，值越大，显示就越大
        CGFloat scaleForCell = 1 + 0.05 * (1 - fabs(scaleForDistance));
        
        //只在Y轴方向做缩放
        attribute.transform3D =  CATransform3DMakeScale(1, scaleForCell, 1);
        attribute.zIndex = 1;
        
        //渐变
        CGFloat scaleForAlpha = 1 - fabs(scaleForDistance)*0.2;
        attribute.alpha = scaleForAlpha;
    }];
    
    return attributes;
}
// 初始状态
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];

    if (itemIndexPath.item == 0) {
        attr.center = CGPointMake(kPageCardWidth/2, -20);
        attr.alpha = 0.0;
//        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
    }
    
    return attr;
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
//    for (UICollectionViewUpdateItem *item in updateItems) {
//        switch (item.updateAction) {
//            case UICollectionUpdateActionInsert:
//
//                break;
//
//            default:
//                break;
//        }
//    }
}

// 终结状态
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attr.alpha = 0.0f;
    
    return attr;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
//    // 分页以1/3处
////    if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 3.0) {
////        self.previousOffsetX += kPageCardWidth+kLineSpace ;
////        self.pageNum = self.previousOffsetX/(kPageCardWidth+kLineSpace);
////        if ([self.delegate respondsToSelector:@selector(scrollToPageIndex:)]) {
////            [self.delegate scrollToPageIndex:self.pageNum];
////        }
////    } else if (proposedContentOffset.x < self.previousOffsetX  - self.itemSize.width / 3.0) {
////        self.previousOffsetX -= kPageCardWidth+kLineSpace;
////        self.pageNum = self.previousOffsetX/(kPageCardWidth+kLineSpace);
////        if ([self.delegate respondsToSelector:@selector(scrollToPageIndex:)]) {
////            [self.delegate scrollToPageIndex:self.pageNum];
////        }
////    }
//    //将当前cell移动到屏幕中间位置
////    proposedContentOffset.x = self.previousOffsetX;
//
//    return proposedContentOffset;
//}

@end
