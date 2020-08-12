//
//  ManualManagerCow.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManualManagerCow : UIView

#pragma mark --清除金额
- (void)clearMoney;
- (BOOL)fengzhuangCustomerInfo;
#pragma mark -- 根据庄点数重新计算客人输赢
- (void)calculateCustomerMoneyWithZhuangCowPoint;

@end

NS_ASSUME_NONNULL_END
