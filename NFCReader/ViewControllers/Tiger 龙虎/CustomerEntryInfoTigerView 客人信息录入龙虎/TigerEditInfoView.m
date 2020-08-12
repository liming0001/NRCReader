//
//  TigerEditInfoView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "TigerEditInfoView.h"
#import "ZLKeyboard.h"
#import "CustomerInfo.h"

@interface TigerEditInfoView ()

@property (nonatomic, strong) CustomerInfo *customer;
@property (nonatomic, assign) int cashType;//
@property (nonatomic, assign) int changeStep;//操作步骤

@end

@implementation TigerEditInfoView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureEntryTigerCustomerInfo:) name:@"sureEntryCustomerInfo" object:nil];
}

#pragma mark - /---------------------- notifications ----------------------/
-(void)sureEntryTigerCustomerInfo:(NSNotification *)ntf {
    if ([self.drogenValueTF.text intValue]==0&&[self.tigerValueTF.text intValue]==0&&[self.tieValueTF.text intValue]==0&&[self.washNumberTF.text length]==0) {
        if (self.editTapCustomer) {
            self.editTapCustomer([CustomerInfo new],NO);
            [self removeFromSuperview];
        }
    }else{
        [PublicHttpTool showWaitingView];
        [PublicHttpTool getInfoByXmh:self.washNumberTF.text WithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
            [PublicHttpTool hideWaitingView];
            if (success) {
                CustomerInfo  * editCustomer = [[CustomerInfo alloc]init];
                editCustomer.washNumberValue = self.washNumberTF.text;
                editCustomer.zhuangValue = self.drogenValueTF.text;
                editCustomer.zhuangDuiValue = self.tigerValueTF.text;
                editCustomer.heValue = self.tieValueTF.text;
                editCustomer.cashType = self.cashType;
                if (self.editTapCustomer) {
                    self.editTapCustomer(editCustomer,YES);
                    [self removeFromSuperview];
                }
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
            }else{
                [PublicHttpTool showSoundMessage:@"洗码号不正确"];
            }
        }];
    }
}

- (void)editCurCustomerWithCustomerInfo:(CustomerInfo *)curCustomer{
    [ZLKeyboard bindKeyboard:self.washNumberTF];
    [ZLKeyboard bindKeyboard:self.drogenValueTF];
    [ZLKeyboard bindKeyboard:self.tigerValueTF];
    [ZLKeyboard bindKeyboard:self.tieValueTF];
    
    self.customer = curCustomer;
    self.washNumberTF.text = self.customer.washNumberValue;
    self.drogenValueTF.text = self.customer.zhuangValue;
    self.tigerValueTF.text = self.customer.zhuangDuiValue;
    self.tieValueTF.text = self.customer.heValue;
    self.cashType = self.customer.cashType;
    if (self.cashType==0) {//美金筹码
        [self.cashTypeBtn setSelected:YES];
        self.cashTypelab.text = @"USD";
        self.typeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
        self.changeStep = 1;
    }else if (self.cashType==1){//美金现金
        [self.cashTypeBtn setSelected:YES];
        self.cashTypelab.text = @"USD";
        self.chipTypeLab.text = @"CASH";
        self.typeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
        self.changeStep = 2;
    }else if (self.cashType==2){//人民币筹码
        self.typeIcon.image = [UIImage imageNamed:@"RMB_chip"];
        self.changeStep = 1;
    }else if (self.cashType==3){//人民币现金
        self.typeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.chipTypeLab.text = @"CASH";
        self.changeStep = 2;
    }else if (self.cashType==4){//美金泥码
        [self.cashTypeBtn setSelected:YES];
        self.cashTypelab.text = @"USD";
        self.chipTypeLab.text = @"MUP";
        self.typeIcon.image = [UIImage imageNamed:@"MUP_USD"];
        self.changeStep = 3;
    }else if (self.cashType==5){//人民币泥码
        self.typeIcon.image = [UIImage imageNamed:@"MUP_RMB"];
        self.chipTypeLab.text = @"MUP";
        self.changeStep = 3;
    }
    
    if ([self.washNumberTF.text length]==0) {
        [self.washNumberTF becomeFirstResponder];
    }else{
        [self.drogenValueTF becomeFirstResponder];
    }
}

- (IBAction)cashTypeAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.cashTypelab.text = @"USD";
        if (self.changeStep==1) {//筹码
            self.typeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
            self.cashType = 0;//美金筹码
        }else if (self.changeStep==2){//现金
            self.typeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
            self.cashType = 1;//美金现金
        }else{//泥码
            self.typeIcon.image = [UIImage imageNamed:@"MUP_USD"];
            self.cashType = 4;//美金泥码
        }
    }else{
        self.cashTypelab.text = @"RMB";
        if (self.changeStep==1) {//筹码
            self.typeIcon.image = [UIImage imageNamed:@"RMB_chip"];
            self.cashType = 2;//RMB筹码
        }else if (self.changeStep==2){//现金
            self.typeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
            self.cashType = 3;//RMB现金
        }else{//泥码
            self.typeIcon.image = [UIImage imageNamed:@"MUP_RMB"];
            self.cashType = 5;//RMB泥码
        }
    }
}

- (IBAction)chipTypeAction:(id)sender {
    if (self.changeStep==1) {//筹码->现金 (USD)
        self.changeStep=2;
        self.chipTypeLab.text = @"CASH";
        if ([self.cashTypelab.text isEqualToString:@"RMB"]) {
            self.typeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
            self.cashType = 3;//RMB现金
        }else{
            self.typeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
            self.cashType = 1;//美金现金
        }
    }else if (self.changeStep==2){//现金->泥码
        self.changeStep=3;
        self.chipTypeLab.text = @"MUP";
        if ([self.cashTypelab.text isEqualToString:@"RMB"]) {
            self.typeIcon.image = [UIImage imageNamed:@"MUP_RMB"];
            self.cashType = 5;//RMB泥码
        }else{
            self.typeIcon.image = [UIImage imageNamed:@"MUP_USD"];
            self.cashType = 4;//美金泥码
        }
    }else if (self.changeStep==3){//泥码->筹码
        self.changeStep=1;
        self.chipTypeLab.text = @"CHIP";
        if ([self.cashTypelab.text isEqualToString:@"RMB"]) {
            self.typeIcon.image = [UIImage imageNamed:@"RMB_chip"];
            self.cashType = 2;//RMB筹码
        }else{
            self.typeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
            self.cashType = 0;//美金筹码
        }
    }
}
- (IBAction)exitAction:(id)sender {
    if (self.editTapCustomer) {
        self.editTapCustomer([CustomerInfo new],NO);
        [self removeFromSuperview];
    }
}
- (IBAction)reputAction:(id)sender {
    self.washNumberTF.text = @"";
    self.drogenValueTF.text = @"";
    self.tigerValueTF.text = @"";
    self.tieValueTF.text = @"";
}


@end
