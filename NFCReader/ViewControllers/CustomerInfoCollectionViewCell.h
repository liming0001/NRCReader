//
//  CustomerInfoCollectionViewCell.h
//  NFCReader
//
//  Created by 李黎明 on 2019/8/29.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomerInfo;
@interface CustomerInfoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *number_customer;
@property (weak, nonatomic) IBOutlet UIImageView *customerHeadImgV;
@property (weak, nonatomic) IBOutlet UIImageView *customerHeadIcon;
@property (weak, nonatomic) IBOutlet UILabel *washNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *washNumberValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *zhuangTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *moneyValueLab;

@property (weak, nonatomic) IBOutlet UIImageView *zhuangDuiTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *zhuangDuiValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *sixWinTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *sixWinValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *xianTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *xianValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *xianDuiTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *xianDuiValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *heTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *heValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *INSTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *INSValueLab;
@property (weak, nonatomic) IBOutlet UILabel *sixWinLab;
@property (weak, nonatomic) IBOutlet UIButton *sixWInBtn;

@property (nonatomic, assign) NSInteger cellIndex;

@property(nonatomic,copy)void (^deleteCustomer)(NSInteger curCellIndex);

- (void)fellCellWithCustomerInfo:(CustomerInfo *)curCustomer;

@end

NS_ASSUME_NONNULL_END
