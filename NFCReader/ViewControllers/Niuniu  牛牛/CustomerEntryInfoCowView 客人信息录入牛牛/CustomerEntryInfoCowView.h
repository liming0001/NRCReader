//
//  CustomerEntryInfoCowView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/4.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomerInfo;
@interface CustomerEntryInfoCowView : UIView
@property (weak, nonatomic) IBOutlet UILabel *cashTypelab;
@property (weak, nonatomic) IBOutlet UIButton *cashTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *chipTypeLab;
@property (weak, nonatomic) IBOutlet UIButton *chipTypeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *customerHeadIcon;
@property (weak, nonatomic) IBOutlet UITextField *washNumberTF;
@property (weak, nonatomic) IBOutlet UIImageView *chipTypeIcon;
@property (weak, nonatomic) IBOutlet UITextField *winValueTF;
@property (weak, nonatomic) IBOutlet UITextField *loseValueTF;
@property (weak, nonatomic) IBOutlet UITextField *superValueTF;

@property(nonatomic,copy)void (^editTapCustomer)(CustomerInfo * curCustomer,BOOL hasEntry);

- (void)editCurCustomerWithCustomerInfo:(CustomerInfo *)curCustomer;

@end

NS_ASSUME_NONNULL_END
