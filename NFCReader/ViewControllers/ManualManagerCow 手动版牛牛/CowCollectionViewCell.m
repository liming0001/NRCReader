//
//  CowCollectionViewCell.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "CowCollectionViewCell.h"
#import "CustomerInfo.h"

@implementation CowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (IBAction)exitAction:(id)sender {
    if (_deleteCustomer) {
        _deleteCustomer(self.cellIndex);
    }
}


- (void)fellCellWithCustomerInfo:(CustomerInfo *)curCustomer{
    self.washNumberValueLab.text = curCustomer.washNumberValue;
    self.winVauleLab.text = curCustomer.zhuangValue;
    self.loseValueLab.text = curCustomer.zhuangDuiValue;
    if (curCustomer.cashType==0) {//美金筹码
        self.winCashTypeIcon.image = [UIImage imageNamed:@"customer_dollar"];
        self.loseCashTypeIcon.image = [UIImage imageNamed:@"customer_dollar"];
        
    }else if (curCustomer.cashType==1){//美金现金
        self.winCashTypeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
        self.loseCashTypeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
    }else if (curCustomer.cashType==2){//RMB筹码
        self.winCashTypeIcon.image = [UIImage imageNamed:@"RMB_chip"];
        self.loseCashTypeIcon.image = [UIImage imageNamed:@"RMB_chip"];
    }else if (curCustomer.cashType==3){//RMB现金
        self.winCashTypeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.loseCashTypeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
    }
}

@end
