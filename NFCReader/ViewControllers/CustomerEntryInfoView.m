//
//  CustomerEntryInfoView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/8/30.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "CustomerEntryInfoView.h"
#import "ZLKeyboard.h"
#import "IQKeyboardManager.h"
#import "CustomerInfo.h"

@interface CustomerEntryInfoView ()

@property (nonatomic, strong) CustomerInfo *customer;
@property (nonatomic, assign) int cashType;//
@property (nonatomic, strong) NSString *curLoginToken;

@end

@implementation CustomerEntryInfoView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [ZLKeyboard bindKeyboard:self.washNumberTF];
    [ZLKeyboard bindKeyboard:self.zhuangValueTF];
    [ZLKeyboard bindKeyboard:self.zhuangDuiValueTF];
    [ZLKeyboard bindKeyboard:self.sixWinTF];
    [ZLKeyboard bindKeyboard:self.xianTF];
    [ZLKeyboard bindKeyboard:self.xianDuiValueTF];
    [ZLKeyboard bindKeyboard:self.heValueTF];
    [ZLKeyboard bindKeyboard:self.baoxianValueTF];
    [self.washNumberTF becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureEntryCustomerInfo:) name:@"sureEntryCustomerInfo" object:nil];
}

- (void)editLoginInfoWithLoginID:(NSString *)loginID{
    self.curLoginToken = loginID;
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

- (void)showWaitingView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.layer.zPosition = 100;
}

- (void)hideWaitingView {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

#pragma mark - /---------------------- notifications ----------------------/
-(void)sureEntryCustomerInfo:(NSNotification *)ntf {
    if ([self.washNumberTF.text intValue]==0&&[self.zhuangValueTF.text intValue]==0&&[self.zhuangDuiValueTF.text intValue]==0&&[self.sixWinTF.text intValue]==0&&[self.xianTF.text intValue]==0&&[self.xianDuiValueTF.text intValue]==0&&[self.heValueTF.text intValue]==0&&[self.baoxianValueTF.text intValue]==0) {
        [self removeFromSuperview];
    }else{
        [self showWaitingView];
        [self getInfoByXmhWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
            [self hideWaitingView];
            if (success) {
                CustomerInfo  * editCustomer = [[CustomerInfo alloc]init];
                editCustomer.washNumberValue = self.washNumberTF.text;
                editCustomer.zhuangValue = self.zhuangValueTF.text;
                editCustomer.zhuangDuiValue = self.zhuangDuiValueTF.text;
                editCustomer.sixWinValue = self.sixWinTF.text;
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
                [[EPToast makeText:@"洗码号不正确" WithError:YES]showWithType:ShortTime];
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
            }
        }];
    }
}

- (void)editCurCustomerWithCustomerInfo:(CustomerInfo *)curCustomer{
    self.customer = curCustomer;
    self.washNumberTF.text = self.customer.washNumberValue;
    self.zhuangValueTF.text = self.customer.zhuangValue;
    self.zhuangDuiValueTF.text = self.customer.zhuangDuiValue;
    self.sixWinTF.text = self.customer.sixWinValue;
    self.xianTF.text = self.customer.xianValue;
    self.xianDuiValueTF.text = self.customer.xianDuiValue;
    self.heValueTF.text = self.customer.heValue;
    self.baoxianValueTF.text = self.customer.baoxianValue;
    self.cashType = self.customer.cashType;
    if (self.cashType==0) {
        [self.cashTypeBtn setSelected:YES];
        self.cashTypeLab.text = @"USD";
        self.typeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
    }else if (self.cashType==1){
        [self.cashTypeBtn setSelected:YES];
        [self.chipTypeBtn setSelected:YES];
        self.cashTypeLab.text = @"USD";
        self.chipTypeLab.text = @"CASH";
        self.typeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
    }else if (self.cashType==3){
        [self.chipTypeBtn setSelected:YES];
        self.typeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.chipTypeLab.text = @"CASH";
    }else if (self.cashType==2){
        self.typeIcon.image = [UIImage imageNamed:@"RMB_chip"];
    }
}

- (IBAction)RMBChangeAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.cashTypeLab.text = @"USD";
        if ([self.chipTypeLab.text isEqualToString:@"CHIP"]) {
            self.typeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
            self.cashType = 0;//美金筹码
        }else{
            self.typeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
            self.cashType = 1;//美金现金
        }
        
    }else{
       self.cashTypeLab.text = @"RMB";
        if ([self.chipTypeLab.text isEqualToString:@"CHIP"]) {
            self.typeIcon.image = [UIImage imageNamed:@"RMB_chip"];
            self.cashType = 2;//RMB筹码
        }else{
            self.typeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
            self.cashType = 3;//RMB现金
        }
    }
}
- (IBAction)CHIPChangeAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.chipTypeLab.text = @"CASH";
        if ([self.cashTypeLab.text isEqualToString:@"RMB"]) {
            self.typeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
            self.cashType = 3;//RMB现金
        }else{
            self.typeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
            self.cashType = 1;//美金现金
        }
    }else{
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
    self.sixWinTF.text = @"";
    self.xianTF.text = @"";
    self.xianDuiValueTF.text = @"";
    self.heValueTF.text = @"";
    self.baoxianValueTF.text = @"";
}

@end
