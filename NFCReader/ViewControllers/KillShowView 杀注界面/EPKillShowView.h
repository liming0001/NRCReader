//
//  EPKillShowView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NRCustomerInfo;
@interface EPKillShowView : UIView
@property (weak, nonatomic) IBOutlet UILabel *winOrLostStatusLab;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UILabel *totalUSDValueLab;
@property (weak, nonatomic) IBOutlet UILabel *totalRMBValueLab;
@property (weak, nonatomic) IBOutlet UILabel *havepayChipLab;
@property (weak, nonatomic) IBOutlet UIView *cowAddMoneyView;
@property (weak, nonatomic) IBOutlet UILabel *cowShouldMoneylab;
@property (weak, nonatomic) IBOutlet UILabel *cowHadMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *cowShouldZhaoHuiValueLab;

@property (weak, nonatomic) IBOutlet UILabel *cowZhaohuiMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *zhaoHuiBtn;

@property(nonatomic,copy)void (^sureActionBlock)(NSInteger killConfirmType);

- (void)fellViewDataNRCustomerInfo:(NRCustomerInfo *)customerInfo;
- (void)clearKillShowView;
#pragma mark--根据找回筹码计算总码金额
- (void)calculateTotalMoneyWithJiapei_UsdValue:(int)Jiapei_UsdValue jiaPei_rmbValue:(int)jiaPei_rmbValue;
- (int)calculateZhaoHuiMoneyWithRealJaiPeiMoney:(int)jiaPeiMoney;
@end

NS_ASSUME_NONNULL_END
