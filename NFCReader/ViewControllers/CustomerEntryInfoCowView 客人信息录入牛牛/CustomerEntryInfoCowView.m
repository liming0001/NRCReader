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

@interface CustomerEntryInfoCowView ()

@property (nonatomic, strong) CustomerInfo *customer;

@end

@implementation CustomerEntryInfoCowView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [ZLKeyboard bindKeyboard:self.washNumberTF];
    [ZLKeyboard bindKeyboard:self.winValueTF];
    [ZLKeyboard bindKeyboard:self.loseValueTF];
    [self.washNumberTF becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureEntryTigerCustomerInfo:) name:@"sureEntryCustomerInfo" object:nil];
}

#pragma mark - /---------------------- notifications ----------------------/
-(void)sureEntryTigerCustomerInfo:(NSNotification *)ntf {
    CustomerInfo  * editCustomer = [[CustomerInfo alloc]init];
    editCustomer.washNumberValue = self.washNumberTF.text;
    editCustomer.zhuangValue = self.winValueTF.text;
    editCustomer.zhuangDuiValue = self.loseValueTF.text;
    if (_editTapCustomer) {
        _editTapCustomer(editCustomer);
        [self removeFromSuperview];
    }
}

- (void)editCurCustomerWithCustomerInfo:(CustomerInfo *)curCustomer{
    self.customer = curCustomer;
    self.washNumberTF.text = self.customer.washNumberValue;
    self.winValueTF.text = self.customer.zhuangValue;
    self.loseValueTF.text = self.customer.zhuangDuiValue;
}

- (IBAction)rmbChangeAction:(id)sender {
}

- (IBAction)chipChangeAction:(id)sender {
}
- (IBAction)exitAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)reputAction:(id)sender {
    self.washNumberTF.text = @"";
    self.winValueTF.text = @"";
    self.loseValueTF.text = @"";
}

@end
