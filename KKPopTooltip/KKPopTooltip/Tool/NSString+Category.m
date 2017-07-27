//
//  NSString+Category.m
//  KenDoz
//
//  Created by 刘继新 on 16/9/14.
//  Copyright © 2016年 刘继新. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (CGSize)kk_getStringSizeWithStringFont:(UIFont *)font withWidthOrHeight:(CGFloat)fixedSize isWidthFixed:(BOOL)isWidth {
    CGSize   sizeC;
    if (isWidth) {
        sizeC = CGSizeMake(fixedSize ,MAXFLOAT);
    }else{
        sizeC = CGSizeMake(MAXFLOAT ,fixedSize);
    }
    CGSize   sizeFileName = [self boundingRectWithSize:sizeC
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:font}
                                                     context:nil].size;
    return sizeFileName;
}

- (BOOL)kk_isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)kk_isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (NSDate *)kk_stringToDateFormat:(NSString *)format {
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    dataFormatter.dateFormat = format;
    NSDate *date = [dataFormatter dateFromString:self];
    return date;
}

- (NSString *)kk_pinyinInitials {
    NSMutableString *source = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *entryStr = [NSString stringWithFormat:@"%@",source];
    if ( entryStr.length  > 1 ) {
        entryStr = [entryStr substringToIndex:1];
    }
    entryStr = [entryStr uppercaseString]; // 大写
    return entryStr;
}

- (int)kk_calculateSubStringCount:(NSString *)str {
    
    int count = 0;
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound) {
        return count;
    }
    NSString * subStr = self;
    
    while (range.location != NSNotFound) {
        //只要进入循环就要count++
        count++;
        //每次记录之后,把找到的字串截取掉
        //range.location + range.length 得出的结果就是我们要截取的字符串起始索引的位置
        subStr = [subStr substringFromIndex:range.location + range.length];
        //每一次截取之后,要判断一些,截取完成剩余部分字符串,是否还有子串存在
        //如果存在,我们的while循环会继续运行,如果不存在while循环结束
        range = [subStr rangeOfString:str];
    }
    
    return count;
}

+ (NSString *)kk_encodingURL:(NSString *)str {
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}


@end
