//
//  MtcnnFaceWrapper.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Face.h"

@interface MtcnnFaceWrapper : NSObject
- (NSArray *)detectMaxFace:(UIImage *)image;
- (BOOL)faceFront:(NSArray *)shape;
- (NSDictionary *)facePose:(NSArray *)shape;
@end
