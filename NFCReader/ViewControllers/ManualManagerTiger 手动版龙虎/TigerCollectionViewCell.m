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

- (void)fellCellWithCustomerInfo:(CustomerInfo *)curCustomer{
    self.washNumberValueLab.text = curCustomer.washNumberValue;
    self.dragonValueLab.text = curCustomer.zhuangValue;
    self.tigerValueLab.text = curCustomer.zhuangDuiValue;
    self.tieValueLab.text = curCustomer.heValue;
    if (curCustomer.cashType==0) {//美金筹码
        self.dragonTypIcon.image = [UIImage imageNamed:@"customer_dollar"];
        self.tigerTypIcon.image = [UIImage imageNamed:@"customer_dollar"];
        self.tieTypeIcon.image = [UIImage imageNamed:@"customer_dollar"];
        
    }else if (curCustomer.cashType==1){//美金现金
        self.dragonTypIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
        self.tigerTypIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
        self.tieTypeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
    }else if (curCustomer.cashType==2){//RMB筹码
        self.dragonTypIcon.image = [UIImage imageNamed:@"RMB_chip"];
        self.tigerTypIcon.image = [UIImage imageNamed:@"RMB_chip"];
        self.tieTypeIcon.image = [UIImage imageNamed:@"RMB_chip"];
    }else if (curCustomer.cashType==3){//RMB现金
        self.dragonTypIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.tigerTypIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.tieTypeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
    }
}

@end
