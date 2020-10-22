//
//  NRAddOrMinusCell.h
//  NFCReader
//
//  Created by 李黎明 on 2020/9/6.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRAddOrMinusCell : UITableViewCell

+ (CGFloat)height;
- (void)configureWithTableNameText:(NSString *)tableNameText
                    ChipTypeText:(NSString *)chipTypeText
                DenominationText:(NSString *)denominationText
                       TimeText:(NSString *)timeText;

@end

NS_ASSUME_NONNULL_END
