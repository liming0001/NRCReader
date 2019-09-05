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
    self.moneyValueLab.text = curCustomer.zhuangValue;
    self.zhuangDuiValueLab.text = curCustomer.zhuangDuiValue;
    self.sixWinValueLab.text = curCustomer.sixWinValue;
    self.xianValueLab.text = curCustomer.xianValue;
    self.xianDuiValueLab.text = curCustomer.xianDuiValue;
    self.heValueLab.text = curCustomer.heValue;
    self.INSValueLab.text = curCustomer.baoxianValue;
}

@end
