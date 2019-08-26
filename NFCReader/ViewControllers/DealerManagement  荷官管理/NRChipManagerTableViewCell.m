//
//  NRChipManagerTableViewCell.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/18.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRChipManagerTableViewCell.h"

@interface NRChipManagerTableViewCell ()

@property (nonatomic, strong) UILabel *serialNumberLab;
@property (nonatomic, strong) UILabel *chipTypeLab;
@property (nonatomic, strong) UILabel *denominationLab;
@property (nonatomic, strong) UILabel *batchLab;
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) UIImageView *statusIcon;
@property (nonatomic, strong) UIView *lineV;

@end

@implementation NRChipManagerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat cell_size = 16;
    CGFloat cell_width = (kScreenWidth - 200)/5;
    self.serialNumberLab = [UILabel new];
    self.serialNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.serialNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.serialNumberLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.serialNumberLab];
    [self.serialNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.chipTypeLab = [UILabel new];
    self.chipTypeLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.chipTypeLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.chipTypeLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.chipTypeLab];
    [self.chipTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self.serialNumberLab.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.denominationLab = [UILabel new];
    self.denominationLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.denominationLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.denominationLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.denominationLab];
    [self.denominationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self.chipTypeLab.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.batchLab = [UILabel new];
    self.batchLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.batchLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.batchLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.batchLab];
    [self.batchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self.denominationLab.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.statusLab = [UILabel new];
    self.statusLab.font = [UIFont fontWithName:@"PingFang SC" size:cell_size];
    self.statusLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.statusLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.statusLab];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.width.height.mas_equalTo(cell_width);
        make.left.equalTo(self.batchLab.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.statusIcon = [UIImageView new];
    self.statusIcon.contentMode = UIViewContentModeScaleToFill;
    self.statusIcon.image = [UIImage imageNamed:@"lose_icon"];
    [self.contentView addSubview:self.statusIcon];
    [self.statusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.lineV = [UIView new];
    self.lineV.backgroundColor = [UIColor colorWithHexString:@"#959595"];
    [self.contentView addSubview:self.lineV];
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.height.mas_offset(1);
        make.centerX.equalTo(self.contentView);
    }];
    
    return self;
}

+ (CGFloat)height{
    return 51;
}

- (void)configureWithSerialNumberText:(NSString *)serialNumberText
                         ChipTypeText:(NSString *)chipTypeText
                     DenominationText:(NSString *)denominationText
                            BatchText:(NSString *)batchText
                           StatusText:(NSString *)statusText{
    self.serialNumberLab.text = serialNumberText;
    if ([chipTypeText isEqualToString:@"01"]) {
        self.chipTypeLab.text = @"现金码";
    }else{
        if (![chipTypeText isEqualToString:@"筹码类型"]) {
            self.chipTypeLab.text = @"其它码";
        }else{
            self.chipTypeLab.text = chipTypeText;
        }
    }
    self.denominationLab.text = denominationText;
    self.batchLab.text = batchText;
    self.statusLab.text = statusText;
    if ([statusText isEqualToString:@"状态"]) {
        self.statusIcon.hidden = YES;
    }else{
        self.statusIcon.hidden = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
