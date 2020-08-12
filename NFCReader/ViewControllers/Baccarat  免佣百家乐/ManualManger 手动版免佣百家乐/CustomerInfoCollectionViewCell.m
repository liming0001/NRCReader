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
- (IBAction)headInfoAction:(id)sender {
    if (_customerHeadInfoBlock) {
        _customerHeadInfoBlock(self.cellIndex);
    }
}

- (void)fellCellWithCustomerInfo:(CustomerInfo *)curCustomer{
    self.washNumberValueLab.text = curCustomer.washNumberValue;
    self.moneyValueLab.text = curCustomer.zhuangValue;
    self.zhuangDuiValueLab.text = curCustomer.zhuangDuiValue;
    self.xianValueLab.text = curCustomer.xianValue;
    self.xianDuiValueLab.text = curCustomer.xianDuiValue;
    self.heValueLab.text = curCustomer.heValue;
    self.INSValueLab.text = curCustomer.baoxianValue;
    self.luckyValueLab.text = curCustomer.luckyValue;
    if (curCustomer.cashType==0) {//美金筹码
        [self fellValueIcon:@"customer_dollar"];
    }else if (curCustomer.cashType==1){//美金现金
        [self fellValueIcon:@"customer_dollarCash"];
    }else if (curCustomer.cashType==2){//RMB筹码
        [self fellValueIcon:@"RMB_chip"];
    }else if (curCustomer.cashType==3){//RMB现金
        [self fellValueIcon:@"customer_RMBCash"];
    }else if (curCustomer.cashType==4){//美金泥码
        [self fellValueIcon:@"MUP_USD"];
    }else if (curCustomer.cashType==5){//RMB泥码
        [self fellValueIcon:@"MUP_RMB"];
    }
}

- (void)fellValueIcon:(NSString *)imageIcon{
    self.zhuangTypeImg.image = [UIImage imageNamed:imageIcon];
    self.zhuangDuiTypeImg.image = [UIImage imageNamed:imageIcon];
    self.sixWinTypeImg.image = [UIImage imageNamed:imageIcon];
    self.xianTypeImg.image = [UIImage imageNamed:imageIcon];
    self.xianDuiTypeImg.image = [UIImage imageNamed:imageIcon];
    self.heTypeImg.image = [UIImage imageNamed:imageIcon];
    self.INSTypeImg.image = [UIImage imageNamed:imageIcon];
}

@end
