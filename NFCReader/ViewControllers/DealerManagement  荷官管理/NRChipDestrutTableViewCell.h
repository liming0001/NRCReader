//
//  NRChipDestrutTableViewCell.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/19.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRChipDestrutTableViewCell : UITableViewCell

+ (CGFloat)height;

- (void)configureWithSerialNumberText:(NSString *)serialNumberText
                         ChipTypeText:(NSString *)chipTypeText
                     DenominationText:(NSString *)denominationText
                            BatchText:(NSString *)batchText
                            StatusText:(NSString *)statusText
                        chipTypeList:(NSArray *)chiTypeList;

@end

NS_ASSUME_NONNULL_END
