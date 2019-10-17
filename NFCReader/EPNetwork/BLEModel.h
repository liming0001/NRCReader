//
//  BLEModel.h
//  BLEDemo
//
//  Created by Longma on 17/5/11.
//  Copyright © 2017年 ZhangK. All rights reserved.
//

#import <Foundation/Foundation.h>
//BLIE4.0 蓝牙库
#import <CoreBluetooth/CoreBluetooth.h>


/**
 蓝牙链接状态

 @param state 状态
 */
typedef void (^BLELinkBlock)(NSString *state);

/**
 蓝牙返回数据

 @param data 返回数据
 */
typedef void (^BLEDataBlock)(NSData *data);

typedef enum BLEState_NOW{
    
    BLEState_Successful = 0,//连接成功
    BLEState_Disconnect = 1, // 失败
    BLEState_Normal,         // 未知
    
}BLEState_NOW;


/**
 蓝牙连接成功 或者断开

 */
typedef void(^BLEStateBlcok)(int number);

/**
 搜索到的设备数
 
 */
typedef void(^BLEDevicesBlcok)(NSArray * BLEDevices);

typedef void(^BLEHasCratesBlcok)(BOOL isCharetes);


@interface BLEModel : NSObject


/**
 外设名称 外设UUID 外设读取数据 UUID 外设写入UUID
 */
@property (nonatomic,strong) NSString *BLEName;
@property (nonatomic,strong) NSString *BLEServiceID;
@property (nonatomic,strong) NSString *BLEServiceReadID;
@property (nonatomic,strong) NSString *BLEServiceWriteID;


@property (nonatomic,copy) NSString *connectState;//蓝牙连接状态
@property (nonatomic,copy) BLELinkBlock linkBlcok;
@property (nonatomic,copy) BLEDataBlock dataBlock;
@property (nonatomic,copy) BLEStateBlcok stateBlock;
@property (nonatomic,copy) BLEHasCratesBlcok chratesBlock;
@property (nonatomic,copy) BLEDevicesBlcok bleDevicesBlock;


/**
 *  开始扫描
 */
-(void)startScan;

/**
 *  连接蓝牙
 */
-(void)connectToBLEWithPeripheral:(CBPeripheral *)curPheral;

/**
 主动断开链接
 */
-(void)cancelPeripheralConnection;

/**
 发送命令
 */
- (void) sendData:(NSData *)data;



@end
