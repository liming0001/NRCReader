//
//  TigerCollectionViewCell.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "TigerCollectionViewCell.h"
#import "CustomerInfo.h"

@implementation TigerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)exitAction:(id)sender {
    if (_deleteCustomer) {
        _deleteCustomer(self.cellIndex);
    }
}
- (IBAction)headInfoAction:(id)sender {
    if (_headInfoBlock) {
        _headInfoBlock(self.cellIndex);
    }
}

- (void)fellCellWithCustomerInfo:(CustomerInfo *)curCustomer{
    self.washNumberValueLab.text = curCustomer.washNumberValue;
    self.dragonValueLab.text = curCustomer.zhuangValue;
    self.tigerValueLab.text = curCustomer.zhuangDuiValue;
    self.tieValueLab.text = curCustomer.heValue;
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
    self.dragonTypIcon.image = [UIImage imageNamed:imageIcon];
    self.tigerTypIcon.image = [UIImage imageNamed:imageIcon];
    self.tieTypeIcon.image = [UIImage imageNamed:imageIcon];
}

@end
