//
//  ChipInfoTableViewCell.m
//  NFCReader
//
//  Created by 李黎明 on 2019/11/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "ChipInfoTableViewCell.h"

@implementation ChipInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"#4EAC5B"].CGColor;
    self.layer.masksToBounds = YES;
}

- (void)fellCellWithChipDict:(NSDictionary *)chipDict{
    self.chipNumberLab.text = chipDict[@"chipWashNumber"];
    self.chipMoneyLab.text = chipDict[@"chipAmount"];
    if ([chipDict[@"chipType"] isEqualToString:@"01"]) {//人民币码
        self.chipTypeLab.text = @"人民币码";
    }else if ([chipDict[@"chipType"] isEqualToString:@"02"]){//美金码
        self.chipTypeLab.text = @"美金码";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
