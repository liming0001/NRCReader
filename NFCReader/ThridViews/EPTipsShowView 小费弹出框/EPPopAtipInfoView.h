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
@interface EPPopAtipInfoView : UIView
@property (nonatomic, strong) UILabel *compensateMoneyLab;//应赔
@property (nonatomic, strong) UILabel *guestNumberLab;//客人洗码号

+ (EPPopAtipInfoView *)showInWindowWithNRCustomerInfo:(NRCustomerInfo *)customerInfo handler:(AlertbuttonClickAction)handler;

- (void)_hide;

@end
