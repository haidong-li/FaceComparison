//
//  ExcelManager.h
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/27.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExcelManager : NSObject
+ (NSString *)createExcelFileWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
