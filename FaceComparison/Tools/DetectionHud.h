//
//  DetectionHud.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/15.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>



@interface DetectionHud : NSObject

+ (MBProgressHUD *)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;

+ (MBProgressHUD *)showSuccess:(NSString *)text view:(UIView *)view;

+ (MBProgressHUD *)showFail:(NSString *)text view:(UIView *)view;
@end

