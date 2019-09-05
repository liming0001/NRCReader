//
//  CustomerInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/2.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerInfo : NSObject

@property (nonatomic, strong) NSString *headUrlString;
@property (nonatomic, strong) NSString *washNumberValue;
@property (nonatomic, strong) NSString *headbgImgName;
@property (nonatomic, strong) NSString *zhuangValue;
@property (nonatomic, strong) NSString *zhuangDuiValue;
@property (nonatomic, strong) NSString *sixWinValue;
@property (nonatomic, strong) NSString *xianValue;
@property (nonatomic, strong) NSString *xianDuiValue;
@property (nonatomic, strong) NSString *heValue;
@property (nonatomic, strong) NSString *baoxianValue;
@property (nonatomic, assign) int cashType;

@end

NS_ASSUME_NONNULL_END