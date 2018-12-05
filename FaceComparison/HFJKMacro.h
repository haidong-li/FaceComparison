//
//  HFJKMacro.h
//  DLibTest
//
//  Created by hfjk on 2018/6/19.
//  Copyright © 2018年 hfjk. All rights reserved.
//

#ifndef HFJKMacro_h
#define HFJKMacro_h

#define HFJK_IS_IPHONE_X (HFJKSCREEN_HEIGHT == 812.0f) ? YES : NO


#define HFJKWeakSelf __weak typeof(self) weakSelf = self;

//记录代码执行时间
#define TIK CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
#define TOK CFAbsoluteTime \
linkTime = (CFAbsoluteTimeGetCurrent() - startTime);\
NSLog(@"method is %@ Linked in %f ms", NSStringFromSelector(_cmd),linkTime *1000.0);\

//屏幕宽高
#define HFJKSCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define HFJKSCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)


#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif /* HFJKMacro_h */
