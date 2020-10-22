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
    if ([chipDict valueForKey:@"chipWashNumber"]) {
        self.chipNumberLab.text = chipDict[@"chipWashNumber"];
    }else{
        self.chipNumberLab.text = [NSString stringWithFormat:@"%@",chipDict[@"chipNumber"]];
    }
    self.chipMoneyLab.text = [NSString stringWithFormat:@"%@",chipDict[@"chipAmount"]];
    if ([chipDict[@"chipType"] intValue]==1) {//人民币码
        self.chipTypeLab.text = @"人民币码";
    }else if ([chipDict[@"chipType"] intValue]==2){//美金码
        self.chipTypeLab.text = @"美金码";
    }else if ([chipDict[@"chipType"] intValue]==6){//人民币
        self.chipTypeLab.text = @"人民币";
    }else if ([chipDict[@"chipType"] intValue]==7){//美金
        self.chipTypeLab.text = @"美金";
    }else if ([chipDict[@"chipType"] intValue]==8){//RMB贵宾码
        self.chipTypeLab.text = @"RMB贵宾码";
    }else if ([chipDict[@"chipType"] intValue]==9){//USD贵宾码
        self.chipTypeLab.text = @"USD贵宾码";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
