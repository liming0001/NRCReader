//
//  NSString+EPExtention.m
//  Ellipal_update
//
//  Created by smarter on 2018/8/23.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "NSString+EPExtention.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (EPExtention)

- (NSString *) stringPaddedForBase64 {
    NSUInteger paddedLength = self.length + (self.length % 3);
    return [self stringByPaddingToLength:paddedLength withString:@"=" startingAtIndex:0];
}

#pragma mark - 时间戳转换日期
-(NSString *)UTCchangeWithFormant:(NSString *)formant{

    long time =[self longLongValue];
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setTimeZone:[NSTimeZone systemTimeZone]];
    [objDateformat setDateFormat:formant];
    NSString *dateStr = [objDateformat stringFromDate:myDate];
    return dateStr;
}

- (NSString *)getTimeFromTimestamp{
    long time =[self longLongValue];
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

- (int)countNumberDecmb{
    NSRange range = [self rangeOfString:@"."];
    if (range.location == NSNotFound) {//整型数，直接返回
        return 0;
    }else{
        //去掉多余的0
        NSString * astring = self;
        NSRange range = [astring rangeOfString:@"."];
        if (range.location != NSNotFound) {
            NSArray *numberList = [astring componentsSeparatedByString:@"."];
            if (numberList.count>1) {
                NSString *seconddecm = numberList[1];
                NSString * s = nil;
                NSInteger offset = seconddecm.length - 1;
                while (offset){
                    s = [seconddecm substringWithRange:NSMakeRange(offset, 1)];
                    if ([s isEqualToString:@"0"] || [s isEqualToString:@"."]){
                        offset--;
                    }else{
                        break;
                    }
                }
                seconddecm = [seconddecm substringToIndex:offset+1];
                return (int)seconddecm.length;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }
}

- (NSString *)formartLongScientificNotation{
    NSString * orgstring = self;
    NSString * astring = orgstring;
    NSRange range = [astring rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSArray *numberList = [astring componentsSeparatedByString:@"."];
        if (numberList.count>1) {
            NSString *firstdecm = numberList[0];
            NSString *seconddecm = numberList[1];
            NSString * s = nil;
            NSInteger offset = seconddecm.length - 1;
            while (offset){
                s = [seconddecm substringWithRange:NSMakeRange(offset, 1)];
                if ([s isEqualToString:@"0"] || [s isEqualToString:@"."]){
                    offset--;
                }else{
                    break;
                }
            }
            seconddecm = [seconddecm substringToIndex:offset+1];
            NSString *returnString = [NSString stringWithFormat:@"%@.%@",firstdecm,seconddecm];
            return returnString;
        }else{
            return astring;
        }
    }else{
        return astring;
    }
    
    
}

- (NSString *)formartTrueAmountScientificNotation{
    if ([self hasPrefix:@"*****"]) {
        return self;
    }
    if ([self floatValue]<=0) {
        return @"0";
    }
    
    NSString * orgstring = self;
    NSString *realString = orgstring;
    NSRange eSite = [orgstring rangeOfString:@"E"];
    NSRange eSite_los = [orgstring rangeOfString:@"e"];
    if (eSite.location != NSNotFound) {
        NSArray *numberList = [realString componentsSeparatedByString:@"E"];
        NSString *firstdecm = numberList[0];
        NSString *seconddecm = numberList[1];
        double fund = [firstdecm floatValue];  //把E前面的数截取下来当底数
        double top = [seconddecm floatValue];   //把E后面的数截取下来当指数
        double result = fund * pow(10.0, top);
        realString = [NSString stringWithFormat:@"%.6f",result];
    }
    if (eSite_los.location != NSNotFound) {
        NSArray *numberList = [realString componentsSeparatedByString:@"e"];
        NSString *firstdecm = numberList[0];
        NSString *seconddecm = numberList[1];
        double fund = [firstdecm floatValue];  //把E前面的数截取下来当底数
        double top = [seconddecm floatValue];   //把E后面的数截取下来当指数
        double result = fund * pow(10.0, top);
        realString = [NSString stringWithFormat:@"%.6f",result];
    }
    NSRange range = [realString rangeOfString:@"."];
    if (range.location != NSNotFound) {//有小数点
        NSArray *numberList = [realString componentsSeparatedByString:@"."];
        if (numberList.count>1) {
            NSString *firstdecm = numberList[0];
            NSString *seconddecm = numberList[1];
            if ([firstdecm intValue]>0) {
                if (seconddecm.length>2) {
                    seconddecm = [seconddecm substringToIndex:2];
                }
            }else{
                if (seconddecm.length>6) {
                    seconddecm = [seconddecm substringToIndex:6];
                }
            }
            NSString * s = nil;
            NSInteger offset = seconddecm.length - 1;
            while (offset){
                s = [seconddecm substringWithRange:NSMakeRange(offset, 1)];
                if ([s isEqualToString:@"0"] || [s isEqualToString:@"."]){
                    offset--;
                }else{
                    break;
                }
            }
            seconddecm = [seconddecm substringToIndex:offset+1];
            NSString *returnString = [NSString stringWithFormat:@"%@.%@",firstdecm,seconddecm];
            if ([seconddecm isEqualToString:@"0"]) {
                returnString = [NSString stringWithFormat:@"%@",firstdecm];
            }
            return returnString;
        }else{
            return realString;
        }
    }else{
        return realString;
    }
}

- (NSString *)formartScientificNotation{
    if ([self hasPrefix:@"*****"]) {
        return self;
    }
    if ([self floatValue]<=0) {
        return @"0";
    }
    
    NSString * orgstring = self;
    NSString *realString = orgstring;
    NSRange eSite = [orgstring rangeOfString:@"E"];
    NSRange eSite_los = [orgstring rangeOfString:@"e"];
    if (eSite.location != NSNotFound) {
        NSArray *numberList = [realString componentsSeparatedByString:@"E"];
        NSString *firstdecm = numberList[0];
        NSString *seconddecm = numberList[1];
        double fund = [firstdecm floatValue];  //把E前面的数截取下来当底数
        double top = [seconddecm floatValue];   //把E后面的数截取下来当指数
        double result = fund * pow(10.0, top);
        realString = [NSString stringWithFormat:@"%.6f",result];
    }
    if (eSite_los.location != NSNotFound) {
        NSArray *numberList = [realString componentsSeparatedByString:@"e"];
        NSString *firstdecm = numberList[0];
        NSString *seconddecm = numberList[1];
        double fund = [firstdecm floatValue];  //把E前面的数截取下来当底数
        double top = [seconddecm floatValue];   //把E后面的数截取下来当指数
        double result = fund * pow(10.0, top);
        realString = [NSString stringWithFormat:@"%.6f",result];
    }
    NSRange range = [realString rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSArray *numberList = [realString componentsSeparatedByString:@"."];
        if (numberList.count>1) {
            NSString *firstdecm = numberList[0];
            NSString *seconddecm = numberList[1];
            if (seconddecm.length>6) {
                seconddecm = [seconddecm substringToIndex:6];
            }
            NSString * s = nil;
            NSInteger offset = seconddecm.length - 1;
            while (offset){
                s = [seconddecm substringWithRange:NSMakeRange(offset, 1)];
                if ([s isEqualToString:@"0"] || [s isEqualToString:@"."]){
                    offset--;
                }else{
                    break;
                }
            }
            seconddecm = [seconddecm substringToIndex:offset+1];
            NSString *returnString = [NSString stringWithFormat:@"%@.%@",firstdecm,seconddecm];
            if ([seconddecm isEqualToString:@"0"]) {
                returnString = [NSString stringWithFormat:@"%@",firstdecm];
            }
            return returnString;
        }else{
           return realString;
        }
    }else{
        return realString;
    }
}

- (NSString *)formartEightScientificNotation{
    if ([self hasPrefix:@"*****"]) {
        return self;
    }
    if ([self floatValue]<=0) {
        return @"0";
    }
    
    NSString * orgstring = self;
    NSString *realString = orgstring;
    NSRange eSite = [orgstring rangeOfString:@"E"];
    NSRange eSite_los = [orgstring rangeOfString:@"e"];
    if (eSite.location != NSNotFound) {
        NSArray *numberList = [realString componentsSeparatedByString:@"E"];
        NSString *firstdecm = numberList[0];
        NSString *seconddecm = numberList[1];
        double fund = [firstdecm floatValue];  //把E前面的数截取下来当底数
        double top = [seconddecm floatValue];   //把E后面的数截取下来当指数
        double result = fund * pow(10.0, top);
        realString = [NSString stringWithFormat:@"%.8f",result];
    }
    if (eSite_los.location != NSNotFound) {
        NSArray *numberList = [realString componentsSeparatedByString:@"e"];
        NSString *firstdecm = numberList[0];
        NSString *seconddecm = numberList[1];
        double fund = [firstdecm floatValue];  //把E前面的数截取下来当底数
        double top = [seconddecm floatValue];   //把E后面的数截取下来当指数
        double result = fund * pow(10.0, top);
        realString = [NSString stringWithFormat:@"%.8f",result];
    }
    NSRange range = [realString rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSArray *numberList = [realString componentsSeparatedByString:@"."];
        if (numberList.count>1) {
            NSString *firstdecm = numberList[0];
            NSString *seconddecm = numberList[1];
            if (seconddecm.length>8) {
                seconddecm = [seconddecm substringToIndex:8];
                
            }
            NSString * s = nil;
            NSInteger offset = seconddecm.length - 1;
            while (offset){
                s = [seconddecm substringWithRange:NSMakeRange(offset, 1)];
                if ([s isEqualToString:@"0"] || [s isEqualToString:@"."]){
                    offset--;
                }else{
                    break;
                }
            }
            seconddecm = [seconddecm substringToIndex:offset+1];
            NSString *returnString = [NSString stringWithFormat:@"%@.%@",firstdecm,seconddecm];
            if ([seconddecm isEqualToString:@"0"]) {
                returnString = [NSString stringWithFormat:@"%@",firstdecm];
            }
            return returnString;
        }else{
            return realString;
        }
    }else{
        return realString;
    }
}

- (NSString *)NullToBlankString{
    if (self == nil || self == NULL ||[self isEqual:[NSNull null]]) {
        return @"";
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([self isEqualToString:@"(null)"]) {
        return @"";
    }
    if ([self isEqualToString:@"<null>"]) {
        return @"";
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return @"";
    }
    return self;
}

- (NSString *)SHA256

{
    
    const char *s = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    
    NSString *hash = [out description];
    
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hash;
    
}


//编码
- (NSString *)base64Encode {
    
    //1.转化为二进制数据
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    //2.对数据进行编码

    return [data base64EncodedStringWithOptions:0];
    
}





- (NSString *)to32BitString{
    NSString *newString = self;
    if (newString.length<32) {
        for (int i =0; i<32-newString.length; i++) {
            newString = [newString stringByAppendingString:@"0"];
        }
    }
    return newString;
}

// 将数字转为每隔3位整数由逗号“,”分隔的字符串
- (NSString *)separateNumberUseComma {
    // 前缀
    NSString *prefix = @"";
    // 后缀
    NSString *suffix = @"";
    // 分隔符
    NSString *divide = @",";
    
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([self containsString:@"."]) {
        contains = YES;
        // 若传入浮点数，则需要将小数点后的数字分离出来
        NSArray *comArray = [self componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = self;
    }
    // 将整数按各个字符为一组拆分成数组
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // 将整数数组倒序每隔3个字符添加一个逗号“,”
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    if (contains) {
        newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
    }
    if (![prefix isEqualToString:@""]) {
        newNumber = [NSString stringWithFormat:@"%@%@",prefix,newNumber];
    }
    if (![suffix isEqualToString:@""]) {
        newNumber = [NSString stringWithFormat:@"%@%@",newNumber,suffix];
    }
    
    return newNumber;
}


- (NSString *)URLEncodedString
{
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedString;
}
@end
