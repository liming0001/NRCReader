//
//  CustomerEntryInfoCowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/4.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "CustomerEntryInfoCowView.h"
#import "CustomerInfo.h"
#import "ZLKeyboard.h"
#import "IQKeyboardManager.h"

@interface CustomerEntryInfoCowView ()

@property (nonatomic, strong) CustomerInfo *customer;
@property (nonatomic, assign) int cashType;//
@property (nonatomic, strong) NSString *curLoginToken;

@end

@implementation CustomerEntryInfoCowView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureEntryTigerCustomerInfo:) name:@"sureEntryCustomerInfo" object:nil];
    
    UITapGestureRecognizer *rmbClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rmbClickAction)];
    [_cashTypelab addGestureRecognizer:rmbClick];
    
    UITapGestureRecognizer *chipClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chipClickAction)];
    [_chipTypeLab addGestureRecognizer:chipClick];
}


- (void)showWaitingView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.layer.zPosition = 100;
}

- (void)hideWaitingView {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

#pragma mark - /---------------------- notifications ----------------------/
-(void)sureEntryTigerCustomerInfo:(NSNotification *)ntf {
    if ([self.winValueTF.text intValue]==0&&[self.loseValueTF.text intValue]==0&&[self.washNumberTF.text length]==0) {
        if (self.editTapCustomer) {
            self.editTapCustomer([CustomerInfo new],NO);
            [self removeFromSuperview];
        }
    }else{
        [self showWaitingView];
        [self getInfoByXmhWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
            [self hideWaitingView];
            if (success) {
                CustomerInfo  * editCustomer = [[CustomerInfo alloc]init];
                editCustomer.washNumberValue = self.washNumberTF.text;
                editCustomer.zhuangValue = self.winValueTF.text;
                editCustomer.zhuangDuiValue = self.loseValueTF.text;
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
    [ZLKeyboard bindKeyboard:self.washNumberTF];
    [ZLKeyboard bindKeyboard:self.winValueTF];
    [ZLKeyboard bindKeyboard:self.loseValueTF];
    
    self.customer = curCustomer;
    self.washNumberTF.text = self.customer.washNumberValue;
    self.winValueTF.text = self.customer.zhuangValue;
    self.loseValueTF.text = self.customer.zhuangDuiValue;
    self.cashType = self.customer.cashType;
    if (self.cashType==0) {
        [self.cashTypeBtn setSelected:YES];
        self.cashTypelab.text = @"USD";
        self.chipTypeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
    }else if (self.cashType==1){
        [self.cashTypeBtn setSelected:YES];
        [self.chipTypeBtn setSelected:YES];
        self.cashTypelab.text = @"USD";
        self.chipTypeLab.text = @"CASH";
        self.chipTypeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
    }else if (self.cashType==3){
        [self.chipTypeBtn setSelected:YES];
        self.chipTypeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
        self.chipTypeLab.text = @"CASH";
    }else if (self.cashType==2){
        self.chipTypeIcon.image = [UIImage imageNamed:@"RMB_chip"];
    }
    
    if ([self.washNumberTF.text length]==0) {
        [self.washNumberTF becomeFirstResponder];
    }else{
        [self.winValueTF becomeFirstResponder];
    }
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

- (void)rmbClickAction{
    self.cashTypeBtn.selected = !self.cashTypeBtn.selected;
    if (self.cashTypeBtn.selected) {
        self.cashTypelab.text = @"USD";
        if ([self.chipTypeLab.text isEqualToString:@"CHIP"]) {
            self.chipTypeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
            self.cashType = 0;//美金筹码
        }else{
            self.chipTypeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
            self.cashType = 1;//美金现金
        }
    }else{
        self.cashTypelab.text = @"RMB";
        if ([self.chipTypeLab.text isEqualToString:@"CHIP"]) {
            self.chipTypeIcon.image = [UIImage imageNamed:@"RMB_chip"];
            self.cashType = 2;//RMB筹码
        }else{
            self.chipTypeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
            self.cashType = 3;//RMB现金
        }
    }
}

- (void)chipClickAction{
    self.chipTypeBtn.selected = !self.chipTypeBtn.selected;
    if (self.chipTypeBtn.selected) {
        self.chipTypeLab.text = @"CASH";
        if ([self.cashTypelab.text isEqualToString:@"RMB"]) {
            self.chipTypeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
            self.cashType = 3;//RMB现金
        }else{
            self.chipTypeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
            self.cashType = 1;//美金现金
        }
    }else{
        self.chipTypeLab.text = @"CHIP";
        if ([self.cashTypelab.text isEqualToString:@"RMB"]) {
            self.chipTypeIcon.image = [UIImage imageNamed:@"RMB_chip"];
            self.cashType = 2;//RMB筹码
        }else{
            self.chipTypeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
            self.cashType = 0;//美金筹码
        }
    }
}

- (IBAction)rmbChangeAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.cashTypelab.text = @"USD";
        if ([self.chipTypeLab.text isEqualToString:@"CHIP"]) {
            self.chipTypeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
            self.cashType = 0;//美金筹码
        }else{
            self.chipTypeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
            self.cashType = 1;//美金现金
        }
        
    }else{
        self.cashTypelab.text = @"RMB";
        if ([self.chipTypeLab.text isEqualToString:@"CHIP"]) {
            self.chipTypeIcon.image = [UIImage imageNamed:@"RMB_chip"];
            self.cashType = 2;//RMB筹码
        }else{
            self.chipTypeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
            self.cashType = 3;//RMB现金
        }
    }
}

- (IBAction)chipChangeAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.chipTypeLab.text = @"CASH";
        if ([self.cashTypelab.text isEqualToString:@"RMB"]) {
            self.chipTypeIcon.image = [UIImage imageNamed:@"customer_RMBCash"];
            self.cashType = 3;//RMB现金
        }else{
            self.chipTypeIcon.image = [UIImage imageNamed:@"customer_dollarCash"];
            self.cashType = 1;//美金现金
        }
    }else{
        self.chipTypeLab.text = @"CHIP";
        if ([self.cashTypelab.text isEqualToString:@"RMB"]) {
            self.chipTypeIcon.image = [UIImage imageNamed:@"RMB_chip"];
            self.cashType = 2;//RMB筹码
        }else{
            self.chipTypeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
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
    self.winValueTF.text = @"";
    self.loseValueTF.text = @"";
}

@end
