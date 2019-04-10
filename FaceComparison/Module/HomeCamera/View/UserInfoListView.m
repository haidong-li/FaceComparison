//
//  UserInfoListView.m
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/24.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "UserInfoListView.h"
#import "CircularCollectionViewLayout.h"
#import "HFJKMacro.h"
#import "PageCardFlowLayout.h"
#import "UserInfoCollectionViewCell.h"
#import "HistoryModel.h"

#define MaxxSections 1
@interface UserInfoListView ()<UICollectionViewDelegate,UICollectionViewDataSource,PageCardFlowLayoutDelegate>

@property (strong,nonatomic) UICollectionView *colletionView;

@property (nonatomic,assign) NSInteger indexPath;

@property (strong,nonatomic) NSMutableArray *caseArray;
@property (strong,nonatomic) PageCardFlowLayout *layout;
@property (strong,nonatomic) NSLock *lock;
@end

@implementation UserInfoListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.colletionView];
        self.caseArray = [NSMutableArray arrayWithCapacity:0];
        self.indexPath = 0;
        
        [self scrollToItemAtIndexPath:0 andSection:(MaxxSections/2 - 1) withAnimated:NO];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.colletionView reloadData];
            });
        });
        
        _lock = [[NSLock alloc] init];
    }
    return self;
}


#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return MaxxSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.caseArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//    [cell.contentView addSubview:label];
//    label.text = [self.caseArray[indexPath.row] stringValue];
    
    HistoryModel *model = self.caseArray[indexPath.row];
    [cell loadUserInfo:model];
    return cell;
}


////定义每个Section的四边间距
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    CGFloat width = ((collectionView.frame.size.width - 280)-(10*2))/2;
//    
//    if (section == 0) {
//        return UIEdgeInsetsMake(0, width + 10, 0, 0);//分别为上、左、下、右
//    }
//    else if(section == (MaxxSections - 1)){
//        return UIEdgeInsetsMake(0, 0, 0, width + 10);//分别为上、左、下、右
//    }
//    else{
//        return UIEdgeInsetsMake(0, 10, 0, 0);//分别为上、左、下、右
//    }
//}

#pragma mark - PageCardFlowLayoutDelegate
- (void)scrollToPageIndex:(NSInteger)index{
    
    NSInteger curIdx = index ;
    
    if(curIdx == 0 && self.indexPath == 7){
        NSLog(@"左滑 且section++");
    }
    else if (curIdx == 7 && self.indexPath == 0){
        NSLog(@"右滑 且section--");
    }
    
    self.indexPath = curIdx;
    
    NSLog(@"当前选择的是第%ld页",curIdx);
    
}



- (void)scrollToItemAtIndexPath:(NSInteger)indexPath andSection:(NSInteger)section withAnimated:(BOOL)animated{
    
//    UICollectionViewLayoutAttributes *attr = [self.colletionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath inSection:section]];
//    [self.colletionView scrollToItemAtIndexPath:attr.indexPath
//                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
//                                        animated:animated];
//    
//    self.layout.previousOffsetX = (indexPath + section * self.caseArray.count) * 290;
}



- (UICollectionView *)colletionView
{
    if (!_colletionView) {
     
        self.layout = [[PageCardFlowLayout alloc]init];
        self.layout.delegate = self;
        _colletionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        [self.colletionView registerNib:[UINib nibWithNibName:@"UserInfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        self.colletionView.decelerationRate = 0;
        self.colletionView.delegate = self;
        self.colletionView.dataSource = self;
        self.colletionView.collectionViewLayout = _layout;
        self.colletionView.showsHorizontalScrollIndicator = NO;
        self.colletionView.backgroundColor = [UIColor clearColor];
        self.colletionView.contentInset = UIEdgeInsetsMake(0, 10, 0, -10); 
    }
    return _colletionView;
}

- (BOOL)checkUserExist:(HistoryModel *)model
{
    for (HistoryModel *userInfo in self.caseArray) {
        if (model.workNum == userInfo.workNum) {
            return YES;
        }
    }
    return NO;
}

- (void)insetUserInfo:(HistoryModel *)model
{
    
    NSInteger showIndex = 1;
    
    
    for (HistoryModel *userInfo in self.caseArray) {
        if (model.workNum == userInfo.workNum) {
            return;
        }
    }
    
    [_lock lock];
    [self.caseArray insertObject:model atIndex:0];
    
    [_lock unlock];
    if (self.caseArray.count == 1) {
        showIndex = 0;
    }
    HFJKWeakSelf
   
    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIView transitionWithView:weakSelf.colletionView duration:0.35f options:UIViewAnimationOptionTransitionFlipFromTop animations:^(void) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
////            [weakSelf.colletionView deleteItemsAtIndexPaths:@[indexPath]];
//            [self.colletionView insertItemsAtIndexPaths:@[indexPath]];
//        }  completion: ^(BOOL isFinished) {
//
//        }];
//        [self scrollToItemAtIndexPath:self.caseArray.count - 1 andSection:(MaxxSections/2 - 1) withAnimated:YES];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [weakSelf.colletionView insertItemsAtIndexPaths:@[indexPath]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.caseArray.count) {
            [self.caseArray removeLastObject];
            
            NSLog(@"data count is %ld",self.caseArray.count);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.caseArray.count inSection:0];
            [weakSelf.colletionView deleteItemsAtIndexPaths:@[indexPath]];

        }
    });
}

- (void)clear
{
    [self.caseArray removeAllObjects];
}
@end
