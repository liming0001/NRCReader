//
//  CustomerEntryInfoView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/8/30.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "CustomerEntryInfoView.h"
#import "ZLKeyboard.h"
#import "CustomerInfo.h"

@interface CustomerEntryInfoView ()

@property (nonatomic, strong) CustomerInfo *customer;
@property (nonatomic, assign) int cashType;//
@property (nonatomic, assign) int sixType;//
@property (nonatomic, strong) NSString *curLoginToken;
@property (nonatomic, assign) int changeStep;//操作步骤

@end

@implementation CustomerEntryInfoView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureEntryCustomerInfo:) name:@"sureEntryCustomerInfo" object:nil];
}

#pragma mark - 根据洗码号获取用户信息
- (void)getInfoByXmhWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"fxmh":self.washNumberTF.text
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Customer_getInfoByXmh",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

#pragma mark - /---------------------- notifications ----------------------/
-(void)sureEntryCustomerInfo:(NSNotification *)ntf {
    if ([self.zhuangValueTF.text intValue]==0&&[self.zhuangDuiValueTF.text intValue]==0&&[self.xianTF.text intValue]==0&&[self.xianDuiValueTF.text intValue]==0&&[self.heValueTF.text intValue]==0&&[self.baoxianValueTF.text intValue]==0&&[self.luckyValueTF.text intValue]==0&&[self.washNumberTF.text intValue]==0) {
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
                editCustomer.zhuangValue = self.zhuangValueTF.text;
                editCustomer.zhuangDuiValue = self.zhuangDuiValueTF.text;
                editCustomer.luckyValue = self.luckyValueTF.text;
                editCustomer.xianValue = self.xianTF.text;
                editCustomer.xianDuiValue = self.xianDuiValueTF.text;
                editCustomer.heValue = self.heValueTF.text;
                editCustomer.baoxianValue = self.baoxianValueTF.text;
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
    [ZLKeyboard bindKeyboard:self.zhuangValueTF];
    [ZLKeyboard bindKeyboard:self.zhuangDuiValueTF];
    [ZLKeyboard bindKeyboard:self.luckyValueTF];
    [ZLKeyboard bindKeyboard:self.xianTF];
    [ZLKeyboard bindKeyboard:self.xianDuiValueTF];
    [ZLKeyboard bindKeyboard:self.heValueTF];
    [ZLKeyboard bindKeyboard:self.baoxianValueTF];
    
    self.customer = curCustomer;
    self.washNumberTF.text = self.customer.washNumberValue;
    self.zhuangValueTF.text = self.customer.zhuangValue;
    self.zhuangDuiValueTF.text = self.customer.zhuangDuiValue;
    self.luckyValueTF.text = self.customer.luckyValue;
    self.xianTF.text = self.customer.xianValue;
    self.xianDuiValueTF.text = self.customer.xianDuiValue;
    self.heValueTF.text = self.customer.heValue;
    self.baoxianValueTF.text = self.customer.baoxianValue;
    self.cashType = self.customer.cashType;
     self.sixType = self.customer.sixValueType;
    if (self.cashType==0) {//美金筹码
        [self.cashTypeBtn setSelected:YES];
        self.cashTypeLab.text = @"USD";
        self.typeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
        self.changeStep = 1;
    }else if (self.cashType==1){//美金现金
        [self.cashTypeBtn setSelected:YES];
        self.cashTypeLab.text = @"USD";
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
        self.cashTypeLab.text = @"USD";
        self.chipTypeLab.text = @"MUP";
        self.typeIcon.image = [UIImage imageNamed:@"MUP_USD"];
        self.changeStep = 3;
    }else if (self.cashType==5){//人民币泥码
        self.typeIcon.image = [UIImage imageNamed:@"MUP_RMB"];
        self.chipTypeLab.text = @"MUP";
        self.changeStep = 3;
    }
    if (self.sixType==1) {
        [self.twoPageBtn setSelected:YES];
        [self.threePageBtn setSelected:NO];
    }else{
        [self.twoPageBtn setSelected:NO];
        [self.threePageBtn setSelected:YES];
    }
    
    if ([self.washNumberTF.text length]==0) {
        [self.washNumberTF becomeFirstResponder];
    }else{
        [self.zhuangValueTF becomeFirstResponder];
    }
}
- (IBAction)twoPageAction:(id)sender {
    self.sixType = 1;
    [self.twoPageBtn setSelected:YES];
    [self.threePageBtn setSelected:NO];
}
- (IBAction)threePageAction:(id)sender {
    self.sixType = 2;
    [self.twoPageBtn setSelected:NO];
    [self.threePageBtn setSelected:YES];
}

- (IBAction)RMBChangeAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.cashTypeLab.text = @"USD";
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
        self.cashTypeLab.text = @"RMB";
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
- (IBAction)CHIPChangeAction:(id)sender {
    if (self.changeStep==1) {//筹码->现金 (USD)
        self.changeStep=2;
        self.chipTypeLab.text = @"CASH";
        if ([self.cashTypeLab.text isEqualToString:@"RMB"]) {
            self.typeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
            self.cashType = 3;//RMB现金
        }else{
            self.typeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
            self.cashType = 1;//美金现金
        }
    }else if (self.changeStep==2){//现金->泥码
        self.changeStep=3;
        self.chipTypeLab.text = @"MUP";
        if ([self.cashTypeLab.text isEqualToString:@"RMB"]) {
            self.typeIcon.image = [UIImage imageNamed:@"MUP_RMB"];
            self.cashType = 5;//RMB泥码
        }else{
            self.typeIcon.image = [UIImage imageNamed:@"MUP_USD"];
            self.cashType = 4;//美金泥码
        }
    }else if (self.changeStep==3){//泥码->筹码
        self.changeStep=1;
        self.chipTypeLab.text = @"CHIP";
        if ([self.cashTypeLab.text isEqualToString:@"RMB"]) {
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
- (IBAction)reInputAction:(id)sender {
    self.washNumberTF.text = @"";
    self.zhuangValueTF.text = @"";
    self.zhuangDuiValueTF.text = @"";
    self.xianTF.text = @"";
    self.xianDuiValueTF.text = @"";
    self.heValueTF.text = @"";
    self.baoxianValueTF.text = @"";
    self.luckyValueTF.text = @"";
}

@end
