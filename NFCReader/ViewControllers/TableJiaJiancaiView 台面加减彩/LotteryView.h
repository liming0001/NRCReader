//
//  LotteryView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/6.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryView : UIView
@property (weak, nonatomic) IBOutlet UILabel *USDChipValueLav;
@property (weak, nonatomic) IBOutlet UILabel *RMBChipValueLab;
@property (weak, nonatomic) IBOutlet UILabel *USDCashValueLab;
@property (weak, nonatomic) IBOutlet UILabel *RMBCashValueLab;
@property (weak, nonatomic) IBOutlet UILabel *VIPCashValueLab;
@property (weak, nonatomic) IBOutlet UILabel *VIPChipValueLab;

@end

NS_ASSUME_NONNULL_END
