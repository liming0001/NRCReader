//
//  ChipInfoTableViewCell.h
//  NFCReader
//
//  Created by 李黎明 on 2019/11/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChipInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chipTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *chipMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *chipNumberLab;

- (void)fellCellWithChipDict:(NSDictionary *)chipDict;

@end

NS_ASSUME_NONNULL_END
