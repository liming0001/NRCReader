//
//  TigerEditInfoView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomerInfo;
@interface TigerEditInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *cashTypelab;
@property (weak, nonatomic) IBOutlet UIButton *cashTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *chipTypeLab;
@property (weak, nonatomic) IBOutlet UIButton *chipTypeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;


@property (weak, nonatomic) IBOutlet UITextField *washNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *drogenValueTF;
@property (weak, nonatomic) IBOutlet UIImageView *chipTypeIcon;
@property (weak, nonatomic) IBOutlet UITextField *tigerValueTF;
@property (weak, nonatomic) IBOutlet UITextField *tieValueTF;

@property(nonatomic,copy)void (^editTapCustomer)(CustomerInfo * curCustomer,BOOL hasEntry);

- (void)editCurCustomerWithCustomerInfo:(CustomerInfo *)curCustomer;

- (void)editLoginInfoWithLoginID:(NSString *)loginID;

@end

NS_ASSUME_NONNULL_END
