//
//  BLEIToll.m
//  BLEDemo
//
//  Created by Longma on 17/5/11.
//  Copyright © 2017年 ZhangK. All rights reserved.
//

#import "BLEIToll.h"
#import "NRChipInfoModel.h"

@interface BLEIToll ()

@property (nonatomic,strong) NSMutableArray *BLEFistArr;
@property (nonatomic,strong) NSMutableArray *BLETwoArr;

@end


@implementation BLEIToll

-(NSMutableArray *)BLETwoArr{
    if (!_BLETwoArr) {
        _BLETwoArr = [NSMutableArray array];
    }
    return _BLETwoArr;
}


-(NSMutableArray *)BLEFistArr{
    if (!_BLEFistArr) {
        _BLEFistArr = [NSMutableArray array];
    }
    return _BLEFistArr;
}

#pragma mark -- 计算个数
+ (NSInteger)calculateNumberWithHexData:(NSData *)data{
    NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:data];
    NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"040000525a" withString:@"040000525a"
       options:NSLiteralSearch
         range:NSMakeRange(0, [chipNumberdataHexStr length])];
    return count;
}

+ (NSInteger)calculateChipNumberWithHexData:(NSData *)data{
    NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:data];
    chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"04000e2cb3" withString:@""];
    chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"040000525a" withString:@""];
    NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"0d000000" withString:@"0d000000"
       options:NSLiteralSearch
         range:NSMakeRange(0, [chipNumberdataHexStr length])];
    return count;
}

/**
 十六进制数据转化为数组
 
 @param data 十六进制数据
 @return 转化后的数组
 */
+ (NSMutableArray *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return nil;
    }
    // NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    /**
     将切割好的十六进制数塞入一个可变数组
     */
    NSMutableArray *dataArr = [NSMutableArray new];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        
        for (NSInteger i = 0; i < byteRange.length; i++) {
            
            /**
             将byte数组切割成一个个字符串
             */
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            // DLOG(@"%@",hexStr);
            /**
             因十六进制数据为 0X XXXX 以两字节为一位数,所以需要在切割出来的数据进行补零操作
             */
            
            if ([hexStr length] == 2) {
                // [string appendString:hexStr];
                [dataArr addObject:hexStr];
            } else {
                //[string appendFormat:@"0%@", hexStr];
                
                [dataArr addObject:[NSString stringWithFormat:@"0%@",hexStr]];
            }
        }
    }];
    // DLOG(@"-------->%@",dataArr);
    
    
    return dataArr;
}

/**
 *  设备给蓝牙传输数据 必须以十六进制数据传给蓝牙 蓝牙设备才会执行
 因为iOS 蓝牙库中方法 传输书记是以NSData形式 这个方法 字符串 ---> 十六进制数据 ---> NSData数据
 *
 *  @param string 传入字符串命令
 *
 *  @return 将字符串 ---> 十六进制数据 ---> NSData数据
 */

-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

-(NSString*)getCurrentTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYYMMdd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

//获取当前读写器上所有筹码的UID
- (NSArray *)getDeviceAllChipUIDWithBLEString:(NSString *)bleString{
    NSMutableArray *chipUIDList = [NSMutableArray arrayWithCapacity:0];
    NSArray * separatedStrArr = [bleString componentsSeparatedByString:@"0d000000"];
    for (int i=0; i<separatedStrArr.count; i++) {
        NSString *infoString = separatedStrArr[i];
        if (infoString.length!=0) {
            //UID
            NSString *chipUIDString = [infoString substringToIndex:16];
            if (![chipUIDList containsObject:chipUIDString]) {
                [chipUIDList addObject:chipUIDString];
            }
        }
    }
    return chipUIDList;
}

//获取读写器上小费筹码的UID
- (NSArray *)getDeviceALlShuiqianChipUIDWithBLEString:(NSString *)bleString WithUidList:(NSArray *)UIDList{
    NSMutableArray *chipUIDList = [NSMutableArray arrayWithCapacity:0];
    NSArray * separatedStrArr = [bleString componentsSeparatedByString:@"0d000000"];
    for (int i=0; i<separatedStrArr.count; i++) {
        NSString *infoString = separatedStrArr[i];
        if (infoString.length!=0) {
            //UID
            NSString *chipUIDString = [infoString substringToIndex:16];
            if (![UIDList containsObject:chipUIDString]) {
                if (![chipUIDList containsObject:chipUIDString]) {
                    [chipUIDList addObject:chipUIDString];
                }
            }
        }
    }
    return chipUIDList;
}

- (NSArray *)getDeviceRealShuiqianChipUIDWithBLEString:(NSString *)bleString WithUidList:(NSArray *)UIDList WithPayUidList:(NSArray *)payUidList{
    NSMutableArray *chipUIDList = [NSMutableArray arrayWithCapacity:0];
    NSArray * separatedStrArr = [bleString componentsSeparatedByString:@"0d000000"];
    for (int i=0; i<separatedStrArr.count; i++) {
        NSString *infoString = separatedStrArr[i];
        if (infoString.length!=0) {
            //UID
            NSString *chipUIDString = [infoString substringToIndex:16];
            if (![UIDList containsObject:chipUIDString]) {
                if (![payUidList containsObject:chipUIDString]) {
                    if (![chipUIDList containsObject:chipUIDString]) {
                        [chipUIDList addObject:chipUIDString];
                    }
                }
            }
        }
    }
    return chipUIDList;
}

//获取读写器上赔付筹码的UID
- (NSArray *)getDeviceALlPayChipUIDWithBLEString:(NSString *)bleString WithUidList:(NSArray *)UIDList WithShuiqianUidList:(NSArray *)shuiqianUIDList{
    NSMutableArray *chipUIDList = [NSMutableArray arrayWithCapacity:0];
    NSArray * separatedStrArr = [bleString componentsSeparatedByString:@"0d000000"];
    for (int i=0; i<separatedStrArr.count; i++) {
        NSString *infoString = separatedStrArr[i];
        if (infoString.length!=0) {
            //UID
            NSString *chipUIDString = [infoString substringToIndex:16];
            if (![UIDList containsObject:chipUIDString]) {
                if (![shuiqianUIDList containsObject:chipUIDString]) {
                    if (![chipUIDList containsObject:chipUIDString]) {
                        [chipUIDList addObject:chipUIDString];
                    }
                }
            }
        }
    }
    return chipUIDList;
}

//获取读写器上赔付筹码的UID
- (NSArray *)getDeviceCow_ALlPayChipUIDWithBLEString:(NSString *)bleString WithUidList:(NSArray *)UIDList WithShuiqianUidList:(NSArray *)shuiqianUIDList WithZhaoHuiUidList:(NSArray *)zhaoHuiUIDList{
    NSMutableArray *chipUIDList = [NSMutableArray arrayWithCapacity:0];
    NSArray * separatedStrArr = [bleString componentsSeparatedByString:@"0d000000"];
    for (int i=0; i<separatedStrArr.count; i++) {
        NSString *infoString = separatedStrArr[i];
        if (infoString.length!=0) {
            //UID
            NSString *chipUIDString = [infoString substringToIndex:16];
            if (![UIDList containsObject:chipUIDString]) {
                if (![shuiqianUIDList containsObject:chipUIDString]) {
                    if (![zhaoHuiUIDList containsObject:chipUIDString]) {
                        if (![chipUIDList containsObject:chipUIDString]) {
                            [chipUIDList addObject:chipUIDString];
                        }
                    }
                }
            }
        }
    }
    return chipUIDList;
}

//获取读写器上小费筹码的UID
- (NSArray *)getDeviceALlTipsChipUIDWithBLEString:(NSString *)bleString {
    NSMutableArray *chipUIDList = [NSMutableArray arrayWithCapacity:0];
    NSArray * separatedStrArr = [bleString componentsSeparatedByString:@"0d000000"];
    for (int i=0; i<separatedStrArr.count; i++) {
        NSString *infoString = separatedStrArr[i];
        if (infoString.length!=0) {
            //UID
            NSString *chipUIDString = [infoString substringToIndex:16];
            if (![chipUIDList containsObject:chipUIDString]) {
                [chipUIDList addObject:chipUIDString];
            }
        }
    }
    return chipUIDList;
}


// 十六进制转换为普通字符串
- (NSString *)stringFromHexString:(NSString *)hexString {
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
 
    return unicodeString;
}

//解析百家乐筹码信息
- (NSArray *)chipInfoBaccrarWithBLEString:(NSString *)bleString{
    
    NSMutableArray *chipList = [NSMutableArray arrayWithCapacity:0];
    NSArray * separatedStrArr = [bleString componentsSeparatedByString:@"1d000000"];
    if (separatedStrArr.count != 0) {
        for (int i=1; i<separatedStrArr.count; i++) {
            NSMutableArray *infoList = [NSMutableArray arrayWithCapacity:0];
            NSString *infoString = separatedStrArr[i];
            //序号
            NSString *xuhao = [infoString substringToIndex:6];
            NSString * realxuhao = [NSString stringWithFormat:@"%lu",strtoul([xuhao UTF8String],0,16)];
            //类型
            NSString *type = @"";
            if (infoString.length>8) {
                type = [infoString substringWithRange:NSMakeRange(6, 2)];
            }
            //金额
            NSString *money = @"";
            if (infoString.length>18) {
                money = [infoString substringWithRange:NSMakeRange(10, 8)];
            }
            [infoList addObject:realxuhao];
            [infoList addObject:type];
            [infoList addObject:money];
            
            //批次
            NSString *batch = @"";
            if (infoString.length>=28) {
                batch = [infoString substringWithRange:NSMakeRange(20, 8)];
            }
            [infoList addObject:batch];
           
            //洗码号1;
            NSString *ximahao1 = @"";
            if (infoString.length>38) {
                ximahao1 = [infoString substringWithRange:NSMakeRange(30, 8)];
                ximahao1 = [ximahao1 stringByReplacingOccurrencesOfString:@"00" withString:@""];
            }
            //洗码号2;
            NSString *ximahao2 = @"";
            if (infoString.length>48) {
                ximahao2 = [infoString substringWithRange:NSMakeRange(40, 8)];
                ximahao2 = [ximahao2 stringByReplacingOccurrencesOfString:@"00" withString:@""];
            }
            NSString *ximahao = [NSString stringWithFormat:@"%@%@",ximahao1,ximahao2];
            if (ximahao.length!=0) {
                ximahao = [self stringFromHexString:ximahao];
                if (!ximahao) {//兼容老筹码
                    ximahao = [NSString stringWithFormat:@"%@%@",ximahao1,ximahao2];
                }
            }else{
                ximahao = @"0";
            }
            [infoList addObject:ximahao];
            [chipList addObject:infoList];
        }
    }
    return chipList;
}



- (NSArray *)splitArray:(NSArray *)array withSubSize:(int)subSize{
    unsigned long count = array.count % subSize == 0? (array.count/subSize):(array.count/subSize+1);
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<count; i++) {
        int index = i*subSize;
        NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
        [arr1 removeAllObjects];
        int j=index;
        while (j<subSize*(i+1)&&j<array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j+=1;
        }
        [arr addObject:[arr1 copy]];
    }
    return [arr copy];
}

/**
 查找子字符串在父字符串中的所有位置
 @param content 父字符串
 @param tab 子字符串
 @return 返回位置数组
 */

- (NSMutableArray*)calculateSubStringCount:(NSString *)content str:(NSString *)tab {
    int location = 0;
    NSMutableArray *locationArr = [NSMutableArray new];
    NSRange range = [content rangeOfString:tab];
    if (range.location == NSNotFound){
        return locationArr;
    }
    //声明一个临时字符串,记录截取之后的字符串
    NSString * subStr = content;
    while (range.location != NSNotFound) {
        if (location == 0) {
            location += range.location;
        } else {
            location += range.location + tab.length;
        }
        //记录位置
        NSNumber *number = [NSNumber numberWithUnsignedInteger:location];
        [locationArr addObject:number];
        //每次记录之后,把找到的字串截取掉
        subStr = [subStr substringFromIndex:range.location + range.length];
        range = [subStr rangeOfString:tab];
    }
    return locationArr;
}

+ (NSArray *)shaiXuanShazhuListWithOriginalList:(NSArray *)list{
    NSMutableArray *array = [NSMutableArray arrayWithArray:list];
    NSMutableArray *dateMutablearray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i ++) {
        NSArray *infoList = array[i];
        NSString *chipWashNumber = infoList[4];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        [tempArray addObject:infoList];
        for (int j = i+1; j < array.count; j ++) {
            NSArray *jInfoList = array[j];
            NSString *jChipWashNumber = jInfoList[4];
            if([chipWashNumber isEqualToString:jChipWashNumber]){
                [tempArray addObject:jInfoList];
                [array removeObjectAtIndex:j];
                j -= 1;
            }
        }
        [dateMutablearray addObject:tempArray];
    }
    return dateMutablearray;
}

@end
