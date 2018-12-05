//
//  MaskView.h
//  CatchPicture
//
//  Created by hfjk on 2018/10/11.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIView
@property (nonatomic,copy) NSArray <NSValue *>*faces;
@property (nonatomic,assign) CGSize picSize;
@property (nonatomic,copy) void(^tap)(void);
@end
