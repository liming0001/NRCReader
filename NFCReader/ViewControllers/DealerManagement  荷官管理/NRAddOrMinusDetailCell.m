//
//  NRAddOrMinusDetailCell.m
//  NFCReader
//
//  Created by 李黎明 on 2020/9/19.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRAddOrMinusDetailCell.h"

@interface NRAddOrMinusDetailCell ()

@property (nonatomic, strong) UILabel *chipTypeLab;
@property (nonatomic, strong) UILabel *chipMoneyLab;
@property (nonatomic, strong) UILabel *chipNumLab;
@property (nonatomic, strong) UIView *lineV;

@end

@implementation NRAddOrMinusDetailCell

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
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    //金额
    self.chipMoneyLab = [UILabel new];
    self.chipMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.chipMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.chipMoneyLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.chipMoneyLab];
    [self.chipMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self.chipTypeLab.mas_right);
        make.centerY.equalTo(self);
    }];
    //筹码面额
    self.chipNumLab = [UILabel new];
    self.chipNumLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.chipNumLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.chipNumLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.chipNumLab];
    [self.chipNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self.chipMoneyLab.mas_right);
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

- (void)configureWithChipTypeText:(NSString *)chipTypeText
                    ChipMoneyText:(NSString *)chipMoneyText
                ChipNumText:(NSString *)chipNumText{
    self.chipMoneyLab.text = chipMoneyText;
    self.chipTypeLab.text = chipTypeText;
    self.chipNumLab.text = chipNumText;
}

@end
