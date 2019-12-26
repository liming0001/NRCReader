//
//  NRCommand.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/28.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRCommand.h"

#define POLYNOMIAL 0X8408
#define PRESET_VALUE 0xFFFF

@implementation NRCommand

unsigned int uiCrc16Cal(unsigned char const  * pucY,int length)
{
    unsigned char ucI,ucJ;
    unsigned short int  uiCrcValue = PRESET_VALUE;
    
    for(ucI = 0; ucI < length; ucI++)
    {
        uiCrcValue = uiCrcValue ^ *(pucY + ucI);
        for(ucJ = 0; ucJ < 8; ucJ++)
        {
            if(uiCrcValue & 0x0001)
            {
                uiCrcValue = (uiCrcValue >> 1) ^ POLYNOMIAL;
            }
            else
            {
                uiCrcValue = (uiCrcValue >> 1);
            }
        }
    }
    return uiCrcValue;
}

+ (NSString *)hexStringFromData:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+ (NSString *)countSucceedFromData:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
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
            // NSLog(@"%@",hexStr);
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
    // NSLog(@"-------->%@",dataArr);
    
    
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

+(NSData*)stringToByte:(NSString*)string
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

+(NSString*)getCurrentTimes
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

+(NSString*)getCurrentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertStringToHexStr:(NSString *)str {
    NSData *myD = [str dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
+(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    return from + (arc4random() % (to - from + 1));
}

#pragma mark -- 获取一个随机字符串
+(NSString *)randomStringWithLength:(NSInteger)len {
     NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}

/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", (long)number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}

+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

+(NSData *)getSendBlockDataWithHexString:(NSString *)hexString{
    NSData *hexData = [self stringToByte:hexString];
    int uiCrcValue = uiCrc16Cal([hexData bytes], (int)hexString.length/2);
    NSString *jiaoyanHex = [NSString stringWithFormat:@"%x",uiCrcValue];
    if (jiaoyanHex.length==3) {
        jiaoyanHex = [NSString stringWithFormat:@"0%@",jiaoyanHex];
    }else if (jiaoyanHex.length==2){
        jiaoyanHex = [NSString stringWithFormat:@"00%@",jiaoyanHex];
    }else if (jiaoyanHex.length==1){
        jiaoyanHex = [NSString stringWithFormat:@"000%@",jiaoyanHex];
    }
    NSString *hightHex = [jiaoyanHex substringToIndex:2];
    NSString *lowHex = [jiaoyanHex substringFromIndex:2];
    NSString *realCheckHex = [NSString stringWithFormat:@"%@%@",lowHex,hightHex];
    NSString *commandS = [NSString stringWithFormat:@"%@%@",hexString,realCheckHex];
    DLOG(@"commandS = %@",commandS);
    NSData *bleData = [self stringToByte:commandS];
    return bleData;
}

#pragma mark -声光设置命令
+(NSData *)controlLED{
    NSString *soundHex = @"0c00B1f00001014a01014a";
    return [self getSendBlockDataWithHexString:soundHex];
}

+(NSData *)controlShortLED{
    NSString *soundHex = @"0c00B1f000010105010105";
    return [self getSendBlockDataWithHexString:soundHex];
}

#pragma mark - 读取序列号
+ (NSData *)readDeviceSerialNumber{
    NSString *deviceSerialNumber = @"050002f0";
    return [self getSendBlockDataWithHexString:deviceSerialNumber];
}

#pragma mark - 写入序列号
+ (NSData *)writeDeviceSerialNumberWithNumber:(NSString *)number{
    NSString *deviceSerialNumber = [NSString stringWithFormat:@"0900B2f0%@",number];
    return [self getSendBlockDataWithHexString:deviceSerialNumber];
}

#pragma mark - 查询感应盘中的筹码
+ (NSData *)queryChipNumbers{
    NSString *hexString = @"05000100";
    return [self getSendBlockDataWithHexString:hexString];
}

+ (NSData *)resturtDevice{
    NSString *hexString = @"05004bf0";
    return [self getSendBlockDataWithHexString:hexString];
}

+ (NSData *)nextQueryChipNumbers{
    NSString *hexString = @"05000106";
    return [self getSendBlockDataWithHexString:hexString];
}

+ (NSData *)QueryChipInfo{
    NSString *hexString = @"0600200104";
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 向筹码数据块1中写入序号66，01类型，1000面值
+ (NSData *)writeInfoToChip1WithChipInfo:(NRChipInfoModel *)chipInfo{
    NSString *cashValue = [self getHexByDecimal:[chipInfo.chipDenomination integerValue]];
    if (cashValue.length==1) {
        cashValue = [NSString stringWithFormat:@"000%@",cashValue];
    }else if (cashValue.length==2){
        cashValue = [NSString stringWithFormat:@"00%@",cashValue];
    }else if (cashValue.length==3){
        cashValue = [NSString stringWithFormat:@"0%@",cashValue];
    }
    NSString *hexString = [NSString stringWithFormat:@"12002108%@01%@%@%@",chipInfo.chipUID,chipInfo.chipSerialNumber,chipInfo.chipType,cashValue];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 向筹筹码数据块2中写入批次（当前日期）
+ (NSData *)writeInfoToChip2WithChipInfo:(NRChipInfoModel *)chipInfo{
    NSString *betchInfo = chipInfo.chipBatch;
    NSString *preInfo = [betchInfo substringToIndex:6];
    NSString *lastInfo = [betchInfo substringFromIndex:6];
    if ([lastInfo isEqualToString:@"13"]) {//13号不能发布，与13000000冲突
        lastInfo = @"14";
    }
    NSString *realBatch = [NSString stringWithFormat:@"%@%@",preInfo,lastInfo];
    NSString *hexString = [NSString stringWithFormat:@"12002108%@02%@",chipInfo.chipUID,realBatch];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 向筹筹码数据块3中写入客人洗码号
+ (NSData *)writeInfoToChip3WithChipInfo:(NRChipInfoModel *)chipInfo{
    NSString *washNumber = chipInfo.guestWashesNumber;
    NSString *numberString = @"";
    NSString *codeString = @"";
    NSArray *numberList = [washNumber componentsSeparatedByString:@"-"];
    if (numberList.count==1) {
        numberString = numberList[0];
    }else if (numberList.count==2){
        numberString = numberList[0];
        codeString = numberList[1];
    }
    if (codeString.length>0) {
        if ([codeString intValue]<10) {
            codeString = [NSString stringWithFormat:@"0%d",[codeString intValue]];
        }
    }else{
        codeString = @"00";
    }
    NSString *guestNumber = numberString;
    for (int i=0; i<8-numberString.length-codeString.length; i++) {
        guestNumber = [guestNumber stringByAppendingString:@"0"];
    }
    NSString *hexString = [NSString stringWithFormat:@"12002108%@03%@%@",chipInfo.chipUID,guestNumber,codeString];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 销毁筹码数据块1中的数值
+ (NSData *)destructInfoToChip1WithChipUID:(NSString *)chipUID{
    NSString *hexString = [NSString stringWithFormat:@"12002108%@0100990000",chipUID];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 读取数据块1中的数据（序号，金额，类型）
+ (NSData *)readSelectNumbersInfo1WithChipUID:(NSString *)chipUID{
    NSString *hexString = [NSString stringWithFormat:@"0e002000%@01",chipUID];
    return [self getSendBlockDataWithHexString:hexString];
}
#pragma mark - q读取数据块2中的数据（批次）
+ (NSData *)readSelectNumbersInfo2WithChipUID:(NSString *)chipUID{
    NSString *hexString = [NSString stringWithFormat:@"0e002000%@02",chipUID];
    return [self getSendBlockDataWithHexString:hexString];
}
#pragma mark - q读取数据块3中的数据（客人洗码号）
+ (NSData *)readSelectNumbersInfo3WithChipUID:(NSString *)chipUID{
    NSString *hexString = [NSString stringWithFormat:@"0e002000%@03",chipUID];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 读取所有数据块中的数据
+ (NSData *)readAllSelectNumbersInfoWithChipUID:(NSString *)chipUID{
    NSString *hexString = [NSString stringWithFormat:@"0f002300%@0103",chipUID];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 清空客人洗码号
+ (NSData *)clearWashNumberWithChipInfo:(NSString *)chipUid{
    NSString *numberString = @"";
    NSString *guestNumber = numberString;
    for (int i=0; i<8; i++) {
        guestNumber = [guestNumber stringByAppendingString:@"0"];
    }
    NSString *hexString = [NSString stringWithFormat:@"12002100%@03%@",chipUid,guestNumber];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 设置感应盘工作模式
+ (NSData *)setDeviceWorkModel{
    NSString *hexString = [NSString stringWithFormat:@"0D00B4f00010010000000000"];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 设置感应盘工作模式
+ (NSData *)setDeviceWorkModel_auto{
    NSString *hexString = [NSString stringWithFormat:@"0D00B4f00110010000000000"];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 清除缓存标签
+ (NSData *)clearDeviceCacheChip{
    NSString *hexString = [NSString stringWithFormat:@"0500B6f0"];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 发送心跳指令
+ (NSData *)keepDeviceAlive{
    NSString *hexString = [NSString stringWithFormat:@"070065f0a0a0"];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark - 设置设备功率
+ (NSData *)setDeviceWorkPower{
    NSString *hexString = [NSString stringWithFormat:@"060021f005"];
    return [self getSendBlockDataWithHexString:hexString];
}

#pragma mark -- 统计标签写入返回指令
+ (int)showBackStatusCountWithHexStatus:(NSString *)hexNumber AllChipCount:(int)chipCount{
    NSInteger count = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"040000525a" withString:@"040000525a"
       options:NSLiteralSearch
         range:NSMakeRange(0, [hexNumber length])];
    NSInteger count1 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"040001" withString:@"040001"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger count2 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"040002" withString:@"040002"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger count3 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"040003" withString:@"040003"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger count4 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"040004" withString:@"040004"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger count5 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"040005" withString:@"040005"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger count6 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"040006" withString:@"040006"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger count7 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"04000a" withString:@"04000a"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger count8 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"04000b" withString:@"04000b"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger count9 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"04000c" withString:@"04000c"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger count10 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"04000e" withString:@"04000e"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger count11 = [[hexNumber mutableCopy] replaceOccurrencesOfString:@"05000f" withString:@"05000f"
    options:NSLiteralSearch
      range:NSMakeRange(0, [hexNumber length])];
    NSInteger realCount = count+count1+count2+count3+count4+count5+count6+count7+count8+count9+count10+count11;
    if (count==chipCount) {
        return 1;
    }else if (realCount == chipCount){
        return 2;
    }else{
        return 0;
    }
}

@end
