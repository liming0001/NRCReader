//
//  NRChipManagerInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/18.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRChipManagerInfo : NSObject

@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSString *chipType;
@property (nonatomic, strong) NSString *denomination;
@property (nonatomic, strong) NSString *batch;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *washNumber;
@property (nonatomic, assign) BOOL isChoosed;

@end

NS_ASSUME_NONNULL_END
