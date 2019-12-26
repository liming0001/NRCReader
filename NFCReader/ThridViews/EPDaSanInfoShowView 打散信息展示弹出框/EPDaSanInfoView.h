//
//  EPPopAlertShowView.h
//  TestPopView
//
//  Created by smarter on 2018/8/6.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertbuttonClickAction) (int buttonType);

@class NRChipInfoModel;
@interface EPDaSanInfoView : UIView
@property (nonatomic, strong) UILabel *infoLab;//下注类型
@property (nonatomic, strong) UILabel *guestNumberLab;//客人洗码号
@property (nonatomic, strong) UILabel *totalMoneyLab;//总金额
@property (nonatomic, strong) UILabel *hasPayMoneyLab;//已放入金额

+ (EPDaSanInfoView *)showInWindowWithNRCustomerInfo:(NRChipInfoModel *)customerInfo handler:(AlertbuttonClickAction)handler;

- (void)_hide;

@end
