//
//  EPPayShowView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/14.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NRCustomerInfo;
@interface EPPayShowView : UIView
@property (weak, nonatomic) IBOutlet UILabel *winStatuslab;
@property (weak, nonatomic) IBOutlet UILabel *washNumber;
@property (weak, nonatomic) IBOutlet UILabel *benjinLab;
@property (weak, nonatomic) IBOutlet UILabel *payLab;
@property (weak, nonatomic) IBOutlet UILabel *dashuiLab;
@property (weak, nonatomic) IBOutlet UILabel *payOutLab;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *benjinType;
@property (weak, nonatomic) IBOutlet UIImageView *payType;
@property (weak, nonatomic) IBOutlet UIImageView *dashuiType;
@property (weak, nonatomic) IBOutlet UIImageView *payOutType;
@property (weak, nonatomic) IBOutlet UILabel *havPayedAmountLab;
@property (weak, nonatomic) IBOutlet UIButton *shuiQianBtn;

@property(nonatomic,copy)void (^sureActionBlock)(NSInteger payConfirmType);

- (void)fellViewDataNRCustomerInfo:(NRCustomerInfo *)customerInfo;
- (void)clearPayShowInfo;

@end

NS_ASSUME_NONNULL_END
