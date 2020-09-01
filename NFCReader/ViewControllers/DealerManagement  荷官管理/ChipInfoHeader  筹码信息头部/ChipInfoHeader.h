//
//  ChipInfoHeader.h
//  NFCReader
//
//  Created by 李黎明 on 2020/7/28.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChipInfoHeader : UIView

- (void)_setUpChipHeaderWithType:(int)type;
- (void)fellInfoWithDict:(NSDictionary *)dict;
- (void)fellTakeOutMoney;

@end

NS_ASSUME_NONNULL_END
