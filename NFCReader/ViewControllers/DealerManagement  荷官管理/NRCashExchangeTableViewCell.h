//
//  NRCashExchangeTableViewCell.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/20.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRCashExchangeTableViewCell : UITableViewCell

+ (CGFloat)height;

- (void)configureWithBatchText:(NSString *)batchText
              SerialNumberText:(NSString *)serialNumberText
                  ChipTypeText:(NSString *)chipTypeText
              DenominationText:(NSString *)denominationText
                WashNumberText:(NSString *)washNumberText
                    StatusText:(NSString *)statusText
                chipTypeList:(NSArray *)chiTypeList;

@end

NS_ASSUME_NONNULL_END
