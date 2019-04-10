//
//  ExcelManager.m
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/27.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "ExcelManager.h"
#import <xlsxwriter/xlsxwriter.h>

@interface ExcelManager ()

@end


@implementation ExcelManager

    
    
+ (NSString *)createExcelFileWithName:(NSString *)name
{
    // 文件保存的路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xlsx",name]];
    // 创建新xlsx文件，路径需要转成c字符串
    lxw_workbook  *workbook  = workbook_new([filename UTF8String]);
    // 创建sheet
    lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
    
    workbook_close(workbook);
    return documentPath;
}
@end
