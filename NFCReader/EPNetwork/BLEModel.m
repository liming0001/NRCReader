//
//  BLEModel.m
//  BLEDemo
//
//  Created by Longma on 17/5/11.
//  Copyright © 2017年 ZhangK. All rights reserved.
//

#import "BLEModel.h"
#import "BLEIToll.h"

@interface BLEModel ()<CBCentralManagerDelegate,CBPeripheralDelegate>
/**
 *  蓝牙连接必要对象
 */
@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic* writeCharacteristic;
@property (nonatomic, strong) NSMutableArray *peripheralDataArray;
@property (nonatomic,assign) BOOL isInitiativeDisconnect;//主动断开连接

@end

@implementation BLEModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        _centralMgr = centralManager;
        self.peripheralDataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

/**
 *  开始扫描
 */

- (void)startScan{
    [_centralMgr scanForPeripheralsWithServices:nil options:nil];

}

/**
 *  停止扫描
 */
-(void)stopScan
{
    [_centralMgr stopScan];
}

/**
 *  连接蓝牙
 */
-(void)connectToBLEWithPeripheral:(CBPeripheral *)curPheral
{
    self.discoveredPeripheral = curPheral;
    /**
     当扫描到服务UUID与设备UUID相等时,进行蓝牙与设备链接
     */
    if ((!self.discoveredPeripheral || (self.discoveredPeripheral.state == CBPeripheralStateDisconnected))) {
        [self.centralMgr connectPeripheral:self.discoveredPeripheral options:nil];
    }
}

#pragma mark -- CBCentralManagerDelegate 
#pragma mark- 扫描设备，连接

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    DLOG(@"发现设备广播:%@",advertisementData);
    DLOG(@"发现设备:%@",peripheral.name);
    NSString *ADUUIDSTr = [[[advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"] objectAtIndex:0] UUIDString];
    if (!([ADUUIDSTr hasPrefix:@"FFE0"]||[[advertisementData objectForKey:@"kCBAdvDataLocalName"]  hasPrefix:@"9038UBT"]||[[advertisementData objectForKey:@"kCBAdvDataLocalName"]  hasPrefix:@"9038UTB"])) {
        DLOG(@"收到不属于本公司的蓝牙4.0设备：%@",peripheral.name);
        return;
    }
    
    NSArray *peripherals = [self.peripheralDataArray valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [self.peripheralDataArray addObject:item];
        if (self.bleDevicesBlock) {
            self.bleDevicesBlock(self.peripheralDataArray);
        }
    }
}

#pragma mark - 蓝牙的状态
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStateUnknown:
        {
            //DLOG(@"无法获取设备的蓝牙状态");
            self.connectState = kCONNECTED_UNKNOWN_STATE;
        }
            break;
        case CBManagerStateResetting:
        {
            //DLOG(@"蓝牙重置");
            self.connectState = kCONNECTED_RESET;
        }
            break;
        case CBManagerStateUnsupported:
        {
            //DLOG(@"该设备不支持蓝牙");
            self.connectState = kCONNECTED_UNSUPPORTED;
        }
            break;
        case CBManagerStateUnauthorized:
        {
            //DLOG(@"未授权蓝牙权限");
            self.connectState = kCONNECTED_UNAUTHORIZED;
        }
            break;
        case CBManagerStatePoweredOff:
        {
            //DLOG(@"蓝牙已关闭");
            self.connectState = kCONNECTED_POWERED_OFF;
        }
            break;
        case CBManagerStatePoweredOn:
        {
            //DLOG(@"蓝牙已打开");
            self.connectState = kCONNECTED_POWERD_ON;
            [self startScan];
        }
            break;
            
        default:
        {
            //DLOG(@"未知的蓝牙错误");
            self.connectState = kCONNECTED_ERROR;
        }
            break;
    }
    self.linkBlcok(self.connectState);
    //[self getConnectState];
    
}
#pragma park- 连接成功,扫描services
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (!peripheral) {
        return;
    }
    [self.centralMgr stopScan];
    if (self.stateBlock) {
        self.stateBlock(BLEState_Successful);
    }
    [self.discoveredPeripheral setDelegate:self];
    [self.discoveredPeripheral discoverServices:nil];
     
}




#pragma mark - 扫描service
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray *services = nil;
    
    if (peripheral != self.discoveredPeripheral) {
        DLOG(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil) {
        DLOG(@"Error %@\n", error);
        return ;
    }
    
    services = [peripheral services];
    DLOG(@"%@",services);
    if (!services || ![services count]) {
        DLOG(@"No Services");
        return ;
    }
    
    // 遍历出外设中所有的服务
    for (CBService *service in peripheral.services) {
        DLOG(@"所有的服务：%@",service);
        // 根据UUID寻找服务中的特征 连接某个设备 serviceUUID 就只能是单个的
        if ([[service.UUID UUIDString] isEqualToString:_BLEServiceID]) {
            // characteristicUUIDs : 可以指定想要扫描的特征(传nil,扫描所有的特征)
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        DLOG(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    
    // 遍历出所需要的特征
    for (CBCharacteristic *characteristic in service.characteristics) {
        if (characteristic.properties & CBCharacteristicPropertyRead) {
            // 直接读取这个特征数据，会调用didUpdateValueForCharacteristic
            [peripheral readValueForCharacteristic:characteristic];
        }
        if ((characteristic.properties & CBCharacteristicPropertyNotify) || (characteristic.properties & CBCharacteristicPropertyIndicate)) {
            // 订阅通知
            self.writeCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            if (self.chratesBlock) {
                self.chratesBlock(YES);
            }
        }
    }
}

#pragma mark - 读取数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        return;
    }
    NSData *data = characteristic.value;
//    NSMutableArray *dataArr = [BLEIToll convertDataToHexStr:data];
    if (self.dataBlock) {
        self.dataBlock(data);
    }
    
}


#pragma mark- 外设断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    if (self.stateBlock) {
        self.stateBlock(BLEState_Disconnect);
    }
    
}
#pragma mark - 主动断开连接
-(void)cancelPeripheralConnection{
    [self.peripheralDataArray removeAllObjects];
    self.isInitiativeDisconnect = YES;
    if (self.discoveredPeripheral) {//已经连接外设，则断开
        [self.centralMgr cancelPeripheralConnection:self.discoveredPeripheral];
    }else{//未连接，则停止搜索外设
        [self.centralMgr stopScan];
    }
    
}

/**
 发送命令
 */
- (void) sendData:(NSData *)data{
    
     /**
      通过CBPeripheral 类 将数据写入蓝牙外设中,蓝牙外设所识别的数据为十六进制数据,在ios系统代理方法中将十六进制数据改为 NSData 类型 ,但是该数据形式必须为十六进制数 0*ff 0*ff格式 在iToll中有将 字符串转化为 十六进制 再转化为 NSData的方法
      
      */
    [self.discoveredPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}

//向peripheral中写入数据后的回调函数
- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //该方法可以监听到写入外设数据后的状态
    if (error) {
        DLOG(@"didWriteValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    DLOG(@"write value success : %@", characteristic);
}



@end
