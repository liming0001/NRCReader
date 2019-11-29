//
//  EPKillShowTableViewCell.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPKillShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *washNumberlab;
@property (weak, nonatomic) IBOutlet UILabel *betValueLab;
@property (weak, nonatomic) IBOutlet UILabel *payValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *moneyValuelab;

- (void)fellCellWithChipDict:(NSDictionary *)chipDict;

@end

NS_ASSUME_NONNULL_END
