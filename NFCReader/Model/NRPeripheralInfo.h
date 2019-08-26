//
//  NRPeripheralInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/14.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRPeripheralInfo : NSObject

@property (nonatomic,strong) CBUUID *serviceUUID;
@property (nonatomic,strong) NSMutableArray *characteristics;

@end

NS_ASSUME_NONNULL_END
