//
//  CustomerEntryInfoView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/8/30.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomerInfo;
@interface CustomerEntryInfoView : UIView

@property (weak, nonatomic) IBOutlet UITextField *washNumberTF;

@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;

@property (weak, nonatomic) IBOutlet UITextField *zhuangValueTF;

@property (weak, nonatomic) IBOutlet UITextField *zhuangDuiValueTF;
@property (weak, nonatomic) IBOutlet UITextField *sixWinTF;
@property (weak, nonatomic) IBOutlet UITextField *xianTF;
@property (weak, nonatomic) IBOutlet UITextField *xianDuiValueTF;
@property (weak, nonatomic) IBOutlet UITextField *heValueTF;
@property (weak, nonatomic) IBOutlet UITextField *baoxianValueTF;

@property(nonatomic,copy)void (^editTapCustomer)(CustomerInfo *curCustomer);

- (void)editCurCustomerWithCustomerInfo:(CustomerInfo *)curCustomer;

@end

NS_ASSUME_NONNULL_END
