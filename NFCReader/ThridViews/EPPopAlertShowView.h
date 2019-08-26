//
//  EPPopAlertShowView.h
//  TestPopView
//
//  Created by smarter on 2018/8/6.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AlertbuttonAction) (void);
typedef void(^AlertbuttonClickAction) (int buttonType);

@class NRCustomerInfo;
@interface EPPopAlertShowView : UIView
@property (nonatomic, strong) UILabel *havepayChipLab;//已赔付
@property (nonatomic, strong) UILabel *drawWaterMoneyLab;//打水
@property (nonatomic, strong) UILabel *compensateMoneyLab;//应赔
@property (nonatomic, strong) UILabel *compensateCodeLab;//赔码
@property (nonatomic, strong) UILabel *totalMoneyLab;//总码

+ (EPPopAlertShowView *)showInWindowWithNRCustomerInfo:(NRCustomerInfo *)customerInfo handler:(AlertbuttonClickAction)handler;
- (void)_hide;
//+ (void)changeInfoWithPayMoney:(NSString *)payMoney;

@end
