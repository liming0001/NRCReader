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
@interface ThreeFairsManualCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *number_customer;
@property (weak, nonatomic) IBOutlet UIImageView *customerHeadImgV;
@property (weak, nonatomic) IBOutlet UIImageView *customerHeadIcon;
@property (weak, nonatomic) IBOutlet UILabel *washNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *washNumberValueLab;
@property (weak, nonatomic) IBOutlet UILabel *winVauleLab;
@property (weak, nonatomic) IBOutlet UILabel *loseValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *winCashTypeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *loseCashTypeIcon;
@property (weak, nonatomic) IBOutlet UIButton *winOrLose_Btn;
@property (weak, nonatomic) IBOutlet UIButton *cow_points;

@property (weak, nonatomic) IBOutlet UIImageView *normalTypeIcon;
@property (weak, nonatomic) IBOutlet UILabel *normalValueLab;

@property (weak, nonatomic) IBOutlet UILabel *super_benjinValueLab;
@property (weak, nonatomic) IBOutlet UILabel *double_benjinValueLab;
@property (weak, nonatomic) IBOutlet UILabel *normal_benjinValueLab;


@property (nonatomic, assign) NSInteger cellIndex;

@property(nonatomic,copy)void (^deleteCustomer)(NSInteger curCellIndex);
@property(nonatomic,copy)void (^pointChooseBlock)(NSInteger curCellIndex);
@property(nonatomic,copy)void (^headInfoBlock)(NSInteger curCellIndex);

- (void)fellCellWithCustomerInfo:(CustomerInfo *)curCustomer;

@end

NS_ASSUME_NONNULL_END
