//
//  CowCollectionViewCell.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomerInfo;
@interface CowCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *number_customer;
@property (weak, nonatomic) IBOutlet UIImageView *customerHeadImgV;
@property (weak, nonatomic) IBOutlet UIImageView *customerHeadIcon;
@property (weak, nonatomic) IBOutlet UILabel *washNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *washNumberValueLab;
@property (weak, nonatomic) IBOutlet UILabel *winVauleLab;
@property (weak, nonatomic) IBOutlet UILabel *loseValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *winCashTypeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *loseCashTypeIcon;

@property (nonatomic, assign) NSInteger cellIndex;

@property(nonatomic,copy)void (^deleteCustomer)(NSInteger curCellIndex);

- (void)fellCellWithCustomerInfo:(CustomerInfo *)curCustomer;

@end

NS_ASSUME_NONNULL_END
