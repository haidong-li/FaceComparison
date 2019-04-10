//
//  FacialMaskView.h
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/17.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacialMaskView : UIView
@property (nonatomic,copy) NSArray <NSValue *>*faces;

@end

NS_ASSUME_NONNULL_END
