//
//  HFJKColor.m
//  HFJKFaceDetection
//
//  Created by hfjk on 2018/6/26.
//  Copyright © 2018年 hfjk. All rights reserved.
//

#import "HFJKColor.h"

@implementation HFJKColor
+(UIColor *)HF_ColorWithHex:(int)hex
{
    
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

#pragma mark - 根据16进制色值字符串生成颜色
+(UIColor *)HF_ColorWithHexString:(NSString *)hexString
{
    return [self HF_GetColorWithHexString:hexString alpha:1.0];
}

#pragma mark - 根据16进制色值字符串和透明度生成颜色
+(UIColor *)HF_ColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    return [self HF_GetColorWithHexString:hexString alpha:alpha];
}

#pragma mark - 根据16进制色值字符串和透明度生成颜色
+ (UIColor *)HF_GetColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    float red ,blue,green;
    NSMutableString * colorString = [hexString mutableCopy];
    if ([colorString hasPrefix:@"0x"]||[colorString hasPrefix:@"0X"]) {
        [colorString replaceCharactersInRange:NSMakeRange(0, 2) withString:@""];
    }
    
    if ([colorString hasPrefix:@"#"]) {
        [colorString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    if ([colorString length]>=2) {
        NSString * oneString  = [colorString substringWithRange:NSMakeRange(0, 1)];
        NSString * towString  = [colorString substringWithRange:NSMakeRange(1, 1)];
        red =  [self hexString:oneString]*16+ [self hexString:towString];
    }
    else
    {
        red = 0;
    }
    
    
    if ([colorString length]>=4) {
        NSString * oneString  = [colorString substringWithRange:NSMakeRange(2, 1)];
        NSString * towString  = [colorString substringWithRange:NSMakeRange(3, 1)];
        green =  [self hexString:oneString]*16+ [self hexString:towString];
    }
    else
    {
        green = 0;
    }
    
    if ([colorString length]>=6) {
        NSString * oneString  = [colorString substringWithRange:NSMakeRange(4, 1)];
        NSString * towString  = [colorString substringWithRange:NSMakeRange(5, 1)];
        blue =  [self hexString:oneString]*16+ [self hexString:towString];
    }
    else
    {
        blue = 0;
    }
    
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
}

#pragma mark - 根据16进制色值字符串转成数值
+(int)hexString:(NSString *)charString
{
    if ([charString isEqualToString:@"0"]) {
        return 0;
    }
    if ([charString isEqualToString:@"1"]) {
        return 1;
    }
    if ([charString isEqualToString:@"2"]) {
        return 2;
    }
    if ([charString isEqualToString:@"3"]) {
        return 3;
    }
    if ([charString isEqualToString:@"4"]) {
        return 4;
    }
    if ([charString isEqualToString:@"5"]) {
        return 5;
    }
    if ([charString isEqualToString:@"6"]) {
        return 6;
    }
    if ([charString isEqualToString:@"7"]) {
        return 7;
    }
    if ([charString isEqualToString:@"8"]) {
        return 8;
    }
    if ([charString isEqualToString:@"9"]) {
        return 9;
    }
    
    if ([charString isEqualToString:@"a"] ||[charString isEqualToString:@"A"]) {
        return 10;
    }
    if ([charString isEqualToString:@"b"]||[charString isEqualToString:@"B"]) {
        return 11;
    }
    if ([charString isEqualToString:@"c"]||[charString isEqualToString:@"C"]) {
        return 12;
    }
    if ([charString isEqualToString:@"d"]||[charString isEqualToString:@"D"]) {
        return 13;
    }
    if ([charString isEqualToString:@"e"]||[charString isEqualToString:@"E"]) {
        return 14;
    }
    
    if ([charString isEqualToString:@"f"]||[charString isEqualToString:@"F"]) {
        return 15;
    }
    return 0;
}
@end
