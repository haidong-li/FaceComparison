//
//  HFJKColor.h
//  HFJKFaceDetection
//
//  Created by hfjk on 2018/6/26.
//  Copyright © 2018年 hfjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HexColor : NSObject
+ (UIColor *)colorWithHex:(int)hex;
+ (UIColor *)getColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
@end
