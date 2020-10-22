//
//  NRAddOrMinusCell.m
//  NFCReader
//
//  Created by 李黎明 on 2020/9/6.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRAddOrMinusCell.h"

@interface NRAddOrMinusCell ()

@property (nonatomic, strong) UILabel *tableNameLab;
@property (nonatomic, strong) UILabel *chipTypeLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *denominationLab;
@property (nonatomic, strong) UIView *lineV;

@end

@implementation NRAddOrMinusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat cell_size = 16;
    CGFloat cell_width = (kScreenWidth - 200)/3;
//    台桌名称
    self.tableNameLab = [UILabel new];
    self.tableNameLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.tableNameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tableNameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tableNameLab];
    [self.tableNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
//    //筹码类型
//    self.chipTypeLab = [UILabel new];
//    self.chipTypeLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
//    self.chipTypeLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
//    self.chipTypeLab.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:self.chipTypeLab];
//    [self.chipTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.width.mas_equalTo(cell_width);
//        make.left.equalTo(self.tableNameLab.mas_right);
//        make.centerY.equalTo(self);
//    }];
    //时间
    self.timeLab = [UILabel new];
    self.timeLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.timeLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self.tableNameLab.mas_right);
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
        make.left.equalTo(self.timeLab.mas_right);
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

- (void)configureWithTableNameText:(NSString *)tableNameText
                         ChipTypeText:(NSString *)chipTypeText
                     DenominationText:(NSString *)denominationText
                            TimeText:(NSString *)timeText{
    self.tableNameLab.text = tableNameText;
    self.chipTypeLab.text = chipTypeText;
    self.denominationLab.text = denominationText;
    if (timeText.length>11) {
        self.timeLab.text = [timeText substringToIndex:10];
    }else{
        self.timeLab.text = timeText;
    }
}

@end
