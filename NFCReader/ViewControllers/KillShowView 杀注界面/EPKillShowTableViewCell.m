//
//  EPKillShowTableViewCell.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "EPKillShowTableViewCell.h"

@implementation EPKillShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)fellCellWithChipDict:(NSDictionary *)chipDict{
    self.washNumberlab.text = chipDict[@"chipWashNumber"];
    self.betValueLab.text = chipDict[@"chipAmount"];
    self.payValueLab.text = chipDict[@"shoudPayValue"];
    if ([chipDict[@"chipType"] isEqualToString:@"01"]) {//人民币码
        self.moneyValuelab.image = [UIImage imageNamed:@"RMBICO"];
    }else if ([chipDict[@"chipType"] isEqualToString:@"02"]){//美金码
        self.moneyValuelab.image = [UIImage imageNamed:@"USDICO"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
