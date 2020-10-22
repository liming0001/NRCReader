//
//  NRChipSingleCell.h
//  NFCReader
//
//  Created by 李黎明 on 2020/9/20.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRChipSingleCell : UITableViewCell

- (void)configureWithChipTypeLabText:(NSString *)chipTypeLabText
                        ChipNumsText:(NSString *)chipNumsText
                    DenominationText:(NSString *)denominationText;
+ (CGFloat)height;
@end

NS_ASSUME_NONNULL_END
