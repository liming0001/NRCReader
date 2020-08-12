//
//  TigerCollectionViewCell.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomerInfo;
@interface TigerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *number_lab;
@property (weak, nonatomic) IBOutlet UIImageView *customerHeadImgV;
@property (weak, nonatomic) IBOutlet UIImageView *customerHeadIcon;
@property (weak, nonatomic) IBOutlet UILabel *washNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *washNumberValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *dragonTypIcon;
@property (weak, nonatomic) IBOutlet UILabel *dragonValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *tigerTypIcon;
@property (weak, nonatomic) IBOutlet UILabel *tigerValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *tieTypeIcon;
@property (weak, nonatomic) IBOutlet UILabel *tieValueLab;

@property (nonatomic, assign) NSInteger cellIndex;

@property(nonatomic,copy)void (^deleteCustomer)(NSInteger curCellIndex);
@property(nonatomic,copy)void (^headInfoBlock)(NSInteger curCellIndex);

- (void)fellCellWithCustomerInfo:(CustomerInfo *)curCustomer;

@end

NS_ASSUME_NONNULL_END
