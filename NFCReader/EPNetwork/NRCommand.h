//
//  NRCommand.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/28.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRCommand : NSObject

/**
 十六进制数据转化为数组
 
 @param data 十六进制数据
 @return 转化后的数组
 */
+ (NSMutableArray *)convertDataToHexStr:(NSData *)data;
+ (NSString *)hexStringFromData:(NSData *)data;
/**
 *  设备给蓝牙传输数据 必须以十六进制数据传给蓝牙 蓝牙设备才会执行
 因为iOS 蓝牙库中方法 传输书记是以NSData形式 这个方法 字符串 ---> 十六进制数据 ---> NSData数据
 *
 *  @param string 传入字符串命令
 *
 *  @return 将字符串 ---> 十六进制数据 ---> NSData数据
 */

+(NSData*)stringToByte:(NSString*)string;
//获取一个随机整数，范围在[from,to），包括from，不包括to
+(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to;
+ (NSData *)convertHexStrToData:(NSString *)str;

#pragma mark -声光设置命令
+(NSData *)controlLED;
+(NSData *)controlShortLED;

#pragma mark - 读取序列号
+ (NSData *)readDeviceSerialNumber;
#pragma mark - 写入序列号
+ (NSData *)writeDeviceSerialNumberWithNumber:(NSString *)number;
+(NSString*)getCurrentTimes;
+(NSString*)getCurrentDate;

#pragma mark - 查询感应盘中的筹码
+ (NSData *)queryChipNumbers;
+ (NSData *)nextQueryChipNumbers;
+ (NSData *)QueryChipInfo;
+ (NSData *)resturtDevice;
/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal;
+ (NSData *)writeInfoToChip1WithChipInfo:(NRChipInfoModel *)chipInfo;
#pragma mark - 向筹筹码数据块2中写入批次2019
+ (NSData *)writeInfoToChip2WithChipInfo:(NRChipInfoModel *)chipInfo;
#pragma mark - 向筹筹码数据块3中写入客人洗码号
+ (NSData *)writeInfoToChip3WithChipInfo:(NRChipInfoModel *)chipInfo;
#pragma mark - 销毁筹码数据块1中的数值
+ (NSData *)destructInfoToChip1WithChipUID:(NSString *)chipUID;
#pragma mark - 读取数据块1中的数据（序号，金额，类型）
+ (NSData *)readSelectNumbersInfo1WithChipUID:(NSString *)chipUID;
#pragma mark - q读取数据块2中的数据（批次）
+ (NSData *)readSelectNumbersInfo2WithChipUID:(NSString *)chipUID;
#pragma mark - q读取数据块3中的数据（客人洗码号）
+ (NSData *)readSelectNumbersInfo3WithChipUID:(NSString *)chipUID;
#pragma mark - 读取所有数据块中的数据
+ (NSData *)readAllSelectNumbersInfoWithChipUID:(NSString *)chipUID;
#pragma mark - 清空客人洗码号
+ (NSData *)clearWashNumberWithChipInfo:(NSString *)chipUid;

#pragma mark - 设置感应盘工作模式
+ (NSData *)setDeviceWorkModel;
@end

NS_ASSUME_NONNULL_END
