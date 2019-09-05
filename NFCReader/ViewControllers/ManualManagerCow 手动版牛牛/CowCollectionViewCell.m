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
    self.winVauleLab.text = curCustomer.zhuangValue;
    self.loseValueLab.text = curCustomer.zhuangDuiValue;
}

@end
