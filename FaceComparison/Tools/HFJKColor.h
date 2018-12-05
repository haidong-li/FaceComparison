//
//  HFJKColor.h
//  HFJKFaceDetection
//
//  Created by hfjk on 2018/6/26.
//  Copyright © 2018年 hfjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HFJKColor : NSObject
+ (UIColor *)HF_ColorWithHex:(int)hex;
+ (UIColor *)HF_GetColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)HF_ColorWithHexString:(NSString *)hexString;
@end
