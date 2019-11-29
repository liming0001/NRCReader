//
//  NRCustomerInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/18.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRCustomerInfo : NSObject

@property (nonatomic, strong) NSString *tipsTitle;
@property (nonatomic, strong) NSString *guestNumber;
@property (nonatomic, strong) NSString *winStatus;
@property (nonatomic, strong) NSString *principalMoney;
@property (nonatomic, strong) NSString *compensateCode;
@property (nonatomic, strong) NSString *drawWaterMoney;
@property (nonatomic, strong) NSString *compensateMoney;
@property (nonatomic, strong) NSString *tipsMoney;//小费
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSString *chipType;//筹码类型
@property (nonatomic, strong) NSString *tipsInfo;
@property (nonatomic, strong) NSString *add_chipMoney;
@property (nonatomic, strong) NSString *xiazhu;
@property (nonatomic, strong) NSString *shazhu;
@property (nonatomic, strong) NSArray *chipInfoList;
@property (nonatomic, assign) BOOL isWinOrLose;
@property (nonatomic, assign) CGFloat odds;//b倍数
@property (nonatomic, assign) BOOL hasDashui;//是否有打水
@property (nonatomic, assign) BOOL isCow;//是否牛牛
@property (nonatomic, assign) BOOL isTiger;//是否龙虎
@property (nonatomic, assign) BOOL isCash;//是否现金

@end

NS_ASSUME_NONNULL_END
