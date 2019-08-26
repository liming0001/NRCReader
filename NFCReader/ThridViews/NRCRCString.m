//
//  NRCRCString.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/20.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRCRCString.h"

@implementation NRCRCString

#pragma mark - 将字典转字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        DLOG(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

#pragma mark - 检测洗码号是否正确
+(BOOL)isWashCodeValidWithWashNumber:(NSString *)washNumber{
    // 6位数字
    NSString *verifyAccountNameRegex = @"^[\\d-]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",verifyAccountNameRegex];
    return [predicate evaluateWithObject:washNumber];
}

@end
