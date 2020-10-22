//
//  NRAddOrMinusDetailCell.h
//  NFCReader
//
//  Created by 李黎明 on 2020/9/19.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRAddOrMinusDetailCell : UITableViewCell

+ (CGFloat)height;
- (void)configureWithChipTypeText:(NSString *)chipTypeText
                    ChipMoneyText:(NSString *)chipMoneyText
                ChipNumText:(NSString *)chipNumText;


@end

NS_ASSUME_NONNULL_END
