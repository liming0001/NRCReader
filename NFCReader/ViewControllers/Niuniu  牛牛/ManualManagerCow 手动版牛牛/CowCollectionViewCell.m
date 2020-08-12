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
- (IBAction)winOrLoseAction:(id)sender {
}
- (IBAction)cow_pointsAction:(id)sender {
    if (_pointChooseBlock) {
        _pointChooseBlock(self.cellIndex);
    }
}
- (IBAction)headIconAction:(id)sender {
    if (_headInfoBlock) {
        _headInfoBlock(self.cellIndex);
    }
}


- (void)fellCellWithCustomerInfo:(CustomerInfo *)curCustomer{
    self.washNumberValueLab.text = curCustomer.washNumberValue;
    self.winVauleLab.text = curCustomer.superValue;
    self.loseValueLab.text = curCustomer.doubleValue;
    self.normalValueLab.text = curCustomer.normalValue;
    
    self.super_benjinValueLab.text = curCustomer.zhuangValue;
    self.double_benjinValueLab.text = curCustomer.zhuangDuiValue;
    self.normal_benjinValueLab.text = curCustomer.xianValue;
    if (curCustomer.cowPoint ==99) {
        [self.cow_points setTitle:@"录入点数" forState:UIControlStateNormal];
        [self.cow_points setTitleColor:[UIColor colorWithHexString:@"#dedede"] forState:UIControlStateNormal];
    }else{
        [self.cow_points setTitle:curCustomer.cowPointValue forState:UIControlStateNormal];
        [self.cow_points setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    if (curCustomer.isCow_customerWin) {//闲家赢
        [self.winOrLose_Btn setTitle:@"WIN" forState:UIControlStateNormal];
        [self.winOrLose_Btn setBackgroundImage:[UIImage imageNamed:@"customer_zhuang_bg"] forState:UIControlStateNormal];
    }else{
        [self.winOrLose_Btn setTitle:@"LOSE" forState:UIControlStateNormal];
        [self.winOrLose_Btn setBackgroundImage:[UIImage imageNamed:@"customer_xian_bg"] forState:UIControlStateNormal];
    }
    
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
    self.winCashTypeIcon.image = [UIImage imageNamed:imageIcon];
    self.loseCashTypeIcon.image = [UIImage imageNamed:imageIcon];
    self.normalTypeIcon.image = [UIImage imageNamed:imageIcon];
}

@end
