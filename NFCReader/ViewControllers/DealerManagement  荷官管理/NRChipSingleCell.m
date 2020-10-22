//
//  NRChipSingleCell.m
//  NFCReader
//
//  Created by 李黎明 on 2020/9/20.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRChipSingleCell.h"

@interface NRChipSingleCell ()

@property (nonatomic, strong) UILabel *chipTypeLab;
@property (nonatomic, strong) UILabel *denominationLab;
@property (nonatomic, strong) UILabel *chipNumsLab;
@property (nonatomic, strong) UIView *lineV;

@end

@implementation NRChipSingleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat cell_size = 16;
    CGFloat cell_width = kScreenWidth /3;
    //筹码类型
    self.chipTypeLab = [UILabel new];
    self.chipTypeLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.chipTypeLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.chipTypeLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.chipTypeLab];
    [self.chipTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self).offset(0);
        make.centerY.equalTo(self);
    }];
    //筹码个数
    self.chipNumsLab = [UILabel new];
    self.chipNumsLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.chipNumsLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.chipNumsLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.chipNumsLab];
    [self.chipNumsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self.chipTypeLab.mas_right);
        make.centerY.equalTo(self);
    }];
    //筹码面额
    self.denominationLab = [UILabel new];
    self.denominationLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.denominationLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.denominationLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.denominationLab];
    [self.denominationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self.chipNumsLab.mas_right);
        make.centerY.equalTo(self);
    }];
    
    self.lineV = [UIView new];
    self.lineV.backgroundColor = [UIColor colorWithHexString:@"#959595"];
    [self addSubview:self.lineV];
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self);
        make.height.mas_offset(1);
        make.centerX.equalTo(self);
    }];
    
    return self;
}

+ (CGFloat)height{
    return 61;
}

- (void)configureWithChipTypeLabText:(NSString *)chipTypeLabText
                         ChipNumsText:(NSString *)chipNumsText
                     DenominationText:(NSString *)denominationText{
    self.chipTypeLab.text = chipTypeLabText;
    self.chipNumsLab.text = chipNumsText;
    self.denominationLab.text = denominationText;
}

@end
