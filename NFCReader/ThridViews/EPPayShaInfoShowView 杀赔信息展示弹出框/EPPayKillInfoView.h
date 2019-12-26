//
//  EPPopAlertShowView.h
//  TestPopView
//
//  Created by smarter on 2018/8/6.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertbuttonClickAction) (int buttonType);

@class CustomerInfo;
@interface EPPayKillInfoView : UIView
@property (nonatomic, strong) UILabel *guestNumberLab;//客人洗码号
@property (nonatomic, strong) UILabel *payTypeLab;//下注类型
@property (nonatomic, strong) UILabel *resultLab;//开牌结果
@property (nonatomic, strong) UILabel *totalMoneyLab;//总金额

+ (EPPayKillInfoView *)showInWindowWithNRCustomerInfo:(CustomerInfo *)customerInfo handler:(AlertbuttonClickAction)handler;

- (void)fellPayKillInfoWithCustomerInfo:(CustomerInfo *)customerInfo;

- (void)_hide;

@end
