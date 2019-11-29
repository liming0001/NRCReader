//
//  BLEIToll.h
//  BLEDemo
//
//  Created by Longma on 17/5/11.
//  Copyright © 2017年 ZhangK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^BLEProcessBLock)(NSMutableArray *dataArr);


@interface BLEIToll : NSObject

@property (nonatomic,copy) BLEProcessBLock processsBlock;

/**
 十六进制数据转化为数组
 @param data 十六进制数据
 @return 转化后的数组
 */
+ (NSMutableArray *)convertDataToHexStr:(NSData *)data;

/**
 *  设备给蓝牙传输数据 必须以十六进制数据传给蓝牙 蓝牙设备才会执行
 因为iOS 蓝牙库中方法 传输书记是以NSData形式 这个方法 字符串 ---> 十六进制数据 ---> NSData数据
 *
 *  @param string 传入字符串命令
 *
 *  @return 将字符串 ---> 十六进制数据 ---> NSData数据
 */

-(NSData*)stringToByte:(NSString*)string;

- (NSString *)dataStringFromArray:(NSMutableArray *)bleDataList;

//解析筹码个数
- (int)chipNumbersWithBLEString:(NSString *)bleString;
//获取读写器上小费筹码的UID
- (NSArray *)getDeviceALlShuiqianChipUIDWithBLEString:(NSString *)bleString WithUidList:(NSArray *)UIDList;
- (NSArray *)getDeviceRealShuiqianChipUIDWithBLEString:(NSString *)bleString WithUidList:(NSArray *)UIDList WithPayUidList:(NSArray *)payUidList;
//存贮筹码的UID
- (NSArray *)cacheChipUIDWithBLEString:(NSString *)bleString WithOldUidList:(NSArray *)oldUIDList;
//获取当前读写器上素有筹码的UID
- (NSArray *)getDeviceAllChipUIDWithBLEString:(NSString *)bleString;
//获取读写器上赔付筹码的UID
- (NSArray *)getDeviceALlPayChipUIDWithBLEString:(NSString *)bleString WithUidList:(NSArray *)UIDList WithShuiqianUidList:(NSArray *)shuiqianUIDList;
//存贮筹码的UID
- (NSDictionary *)updatePaycacheChipUIDWithBLEString:(NSString *)bleString WithPayUidList:(NSArray *)payUIDList WithBenjinUidList:(NSArray *)benjinUIDList;
//获取读写器上小费筹码的UID
- (NSArray *)getDeviceALlTipsChipUIDWithBLEString:(NSString *)bleString;
//解析筹码信息
- (NSArray *)chipInfoWithBLEString:(NSString *)bleString;
//解析百家乐筹码信息
- (NSArray *)chipInfoBaccrarWithBLEString:(NSString *)bleString WithSplitSize:(int)splitSize;
+ (NSArray *)shaiXuanShazhuListWithOriginalList:(NSArray *)list;

@end
