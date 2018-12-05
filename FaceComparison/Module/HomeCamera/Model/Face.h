//
//  Face.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Face : NSObject

@property (nonatomic,assign) CGRect rect;
@property (nonatomic,assign) NSArray *landmarks;


@property (nonatomic,assign) CGPoint leftEye;
@property (nonatomic,assign) CGPoint rightEye;
@property (nonatomic,assign) CGPoint mouthCenter;

@end
