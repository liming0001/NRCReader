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
    self.dragonValueLab.text = curCustomer.zhuangValue;
    self.tigerValueLab.text = curCustomer.zhuangDuiValue;
    self.tieValueLab.text = curCustomer.heValue;
}

@end
