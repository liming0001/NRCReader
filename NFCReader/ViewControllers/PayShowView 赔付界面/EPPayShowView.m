//
//  EPPayShowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/14.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "EPPayShowView.h"
#import "NRCustomerInfo.h"

@interface EPPayShowView ()

@property (nonatomic, strong) NRCustomerInfo *curInfo;

@end

@implementation EPPayShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)confirmAction:(id)sender {
//    [self removeFromSuperview];
    if (_sureActionBlock) {
        _sureActionBlock(1);
    }
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
    if (_sureActionBlock) {
        _sureActionBlock(2);
    }
    
}
- (IBAction)dashuiAction:(id)sender {
    if (_sureActionBlock) {
        _sureActionBlock(3);
    }
}

- (void)fellViewDataNRCustomerInfo:(NRCustomerInfo *)customerInfo{
    self.curInfo = customerInfo;
    self.winStatuslab.text = self.curInfo.winStatus;
    self.washNumber.text = self.curInfo.guestNumber;
    self.benjinLab.text = self.curInfo.principalMoney;
    self.payLab.text = self.curInfo.compensateCode;
    self.dashuiLab.text = self.curInfo.drawWaterMoney;
    self.payOutLab.text = self.curInfo.compensateMoney;
    self.totalValueLab.text = self.curInfo.totalMoney;
    if (self.curInfo.hasDashui) {
        self.shuiQianBtn.hidden = NO;
    }else{
        self.shuiQianBtn.hidden = YES;
    }
    if ([self.curInfo.chipType isEqualToString:@"01"]) {//人民币码
        self.benjinType.image = [UIImage imageNamed:@"RMBICO"];
        self.payType.image = [UIImage imageNamed:@"RMBICO"];
        self.dashuiType.image = [UIImage imageNamed:@"RMBICO"];
        self.payOutType.image = [UIImage imageNamed:@"RMBICO"];
    }else if ([self.curInfo.chipType isEqualToString:@"02"]){//美金码
        self.benjinType.image = [UIImage imageNamed:@"USDICO"];
        self.payType.image = [UIImage imageNamed:@"USDICO"];
        self.dashuiType.image = [UIImage imageNamed:@"USDICO"];
        self.payOutType.image = [UIImage imageNamed:@"USDICO"];
    }
}

- (void)clearPayShowInfo{
    self.winStatuslab.text = @"";
    self.washNumber.text = @"";
    self.benjinLab.text = @"0";
    self.payLab.text = @"0";
    self.dashuiLab.text = @"0";
    self.totalValueLab.text = @"0";
}

@end
