//
//  CustomerInfoCollectionViewCell.m
//  NFCReader
//
//  Created by 李黎明 on 2019/8/29.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "CustomerInfoCollectionViewCell.h"
#import "CustomerInfo.h"

@implementation CustomerInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)existAction:(id)sender {
    if (_deleteCustomer) {
        _deleteCustomer(self.cellIndex);
    }
}

- (void)fellCellWithCustomerInfo:(CustomerInfo *)curCustomer{
    self.washNumberValueLab.text = curCustomer.washNumberValue;
    self.moneyValueLab.text = curCustomer.zhuangValue;
    self.zhuangDuiValueLab.text = curCustomer.zhuangDuiValue;
    self.sixWinValueLab.text = curCustomer.sixWinValue;
    self.xianValueLab.text = curCustomer.xianValue;
    self.xianDuiValueLab.text = curCustomer.xianDuiValue;
    self.heValueLab.text = curCustomer.heValue;
    self.INSValueLab.text = curCustomer.baoxianValue;
    self.luckyValueLab.text = curCustomer.luckyValue;
    if (curCustomer.cashType==0) {//美金筹码
        self.zhuangTypeImg.image = [UIImage imageNamed:@"customer_dollar"];
        self.zhuangDuiTypeImg.image = [UIImage imageNamed:@"customer_dollar"];
        self.sixWinTypeImg.image = [UIImage imageNamed:@"customer_dollar"];
        self.xianTypeImg.image = [UIImage imageNamed:@"customer_dollar"];
        self.xianDuiTypeImg.image = [UIImage imageNamed:@"customer_dollar"];
        self.heTypeImg.image = [UIImage imageNamed:@"customer_dollar"];
        self.INSTypeImg.image = [UIImage imageNamed:@"customer_dollar"];
        
    }else if (curCustomer.cashType==1){//美金现金
        self.zhuangTypeImg.image = [UIImage imageNamed:@"customer_dollarCash"];
        self.zhuangDuiTypeImg.image = [UIImage imageNamed:@"customer_dollarCash"];
        self.sixWinTypeImg.image = [UIImage imageNamed:@"customer_dollarCash"];
        self.xianTypeImg.image = [UIImage imageNamed:@"customer_dollarCash"];
        self.xianDuiTypeImg.image = [UIImage imageNamed:@"customer_dollarCash"];
        self.heTypeImg.image = [UIImage imageNamed:@"customer_dollarCash"];
        self.INSTypeImg.image = [UIImage imageNamed:@"customer_dollarCash"];
    }else if (curCustomer.cashType==2){//RMB筹码
        self.zhuangTypeImg.image = [UIImage imageNamed:@"RMB_chip"];
        self.zhuangDuiTypeImg.image = [UIImage imageNamed:@"RMB_chip"];
        self.sixWinTypeImg.image = [UIImage imageNamed:@"RMB_chip"];
        self.xianTypeImg.image = [UIImage imageNamed:@"RMB_chip"];
        self.xianDuiTypeImg.image = [UIImage imageNamed:@"RMB_chip"];
        self.heTypeImg.image = [UIImage imageNamed:@"RMB_chip"];
        self.INSTypeImg.image = [UIImage imageNamed:@"RMB_chip"];
    }else if (curCustomer.cashType==3){//RMB现金
        self.zhuangTypeImg.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.zhuangDuiTypeImg.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.sixWinTypeImg.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.xianTypeImg.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.xianDuiTypeImg.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.heTypeImg.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.INSTypeImg.image = [UIImage imageNamed:@"customer_RMBCash"];
    }
}

@end
