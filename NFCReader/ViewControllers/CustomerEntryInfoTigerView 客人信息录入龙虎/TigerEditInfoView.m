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

@end

@implementation TigerEditInfoView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [ZLKeyboard bindKeyboard:self.washNumberTF];
    [ZLKeyboard bindKeyboard:self.drogenValueTF];
    [ZLKeyboard bindKeyboard:self.tigerValueTF];
    [ZLKeyboard bindKeyboard:self.tieValueTF];
    [self.washNumberTF becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureEntryTigerCustomerInfo:) name:@"sureEntryCustomerInfo" object:nil];
}

#pragma mark - /---------------------- notifications ----------------------/
-(void)sureEntryTigerCustomerInfo:(NSNotification *)ntf {
    CustomerInfo  * editCustomer = [[CustomerInfo alloc]init];
    editCustomer.washNumberValue = self.washNumberTF.text;
    editCustomer.zhuangValue = self.drogenValueTF.text;
    editCustomer.zhuangDuiValue = self.tigerValueTF.text;
    editCustomer.heValue = self.tieValueTF.text;
    if (_editTapCustomer) {
        _editTapCustomer(editCustomer);
        [self removeFromSuperview];
    }
}

- (void)editCurCustomerWithCustomerInfo:(CustomerInfo *)curCustomer{
    self.customer = curCustomer;
    self.washNumberTF.text = self.customer.washNumberValue;
    self.drogenValueTF.text = self.customer.zhuangValue;
    self.tigerValueTF.text = self.customer.zhuangDuiValue;
    self.tieValueTF.text = self.customer.heValue;
}

- (IBAction)cashTypeAction:(id)sender {
}
- (IBAction)chipTypeAction:(id)sender {
}
- (IBAction)exitAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)reputAction:(id)sender {
    self.washNumberTF.text = @"";
    self.drogenValueTF.text = @"";
    self.tigerValueTF.text = @"";
    self.tieValueTF.text = @"";
}


@end
