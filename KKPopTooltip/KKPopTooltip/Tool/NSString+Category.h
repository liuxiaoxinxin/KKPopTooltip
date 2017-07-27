//
//  NSString+Category.h
//  KenDoz
//
//  Created by 刘继新 on 16/9/14.
//  Copyright © 2016年 刘继新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)
/*
 * @param  isWidth 是否是宽固定(用于区别宽/高).
 * @param fixedSize 固定尺寸
 */
- (CGSize)kk_getStringSizeWithStringFont:(UIFont *)font withWidthOrHeight:(CGFloat)fixedSize isWidthFixed:(BOOL)isWidth;
///判断字符串是否为整型
- (BOOL)kk_isPureInt;
///判断字符串是否为浮点数
- (BOOL)kk_isPureFloat;
///字符串大写首字母
- (NSString *)kk_pinyinInitials;
///含有多少个字符串
- (int)kk_calculateSubStringCount:(NSString *)str;
@end
