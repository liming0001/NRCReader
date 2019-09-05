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

@end

@implementation CustomerEntryInfoView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
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
#pragma mark - /---------------------- notifications ----------------------/
-(void)sureEntryCustomerInfo:(NSNotification *)ntf {
    CustomerInfo  * editCustomer = [[CustomerInfo alloc]init];
    editCustomer.washNumberValue = self.washNumberTF.text;
    editCustomer.zhuangValue = self.zhuangValueTF.text;
    editCustomer.zhuangDuiValue = self.zhuangDuiValueTF.text;
    editCustomer.sixWinValue = self.sixWinTF.text;
    editCustomer.xianValue = self.xianTF.text;
    editCustomer.xianDuiValue = self.xianDuiValueTF.text;
    editCustomer.heValue = self.heValueTF.text;
    editCustomer.baoxianValue = self.baoxianValueTF.text;
    if (_editTapCustomer) {
        _editTapCustomer(editCustomer);
        [self removeFromSuperview];
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
}

- (IBAction)RMBChangeAction:(id)sender {
    self.typeIcon.image = [UIImage imageNamed:@"RMB_chip"];
}
- (IBAction)CHIPChangeAction:(id)sender {
    self.typeIcon.image = [UIImage imageNamed:@"dolllar_chip"];
}
- (IBAction)exitAction:(id)sender {
    [self removeFromSuperview];
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
