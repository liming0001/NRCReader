//
//  DenominationView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/6.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "DenominationView.h"
#import "JiaJianCaiCellView.h"
#import "ZLKeyboard.h"

@interface DenominationView ()

@property (nonatomic, strong) UIView *bottomLineV;
@property (nonatomic, strong) UIView *leftLineV;
@property (nonatomic, strong) UIView *rightLineV;

@end

@implementation DenominationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.bottomLineV = [UIView new];
    self.bottomLineV.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
    [self addSubview:self.bottomLineV];
    [self.bottomLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    self.leftLineV = [UIView new];
    self.leftLineV.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
    [self addSubview:self.leftLineV];
    [self.leftLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self.bottomLineV.mas_top).offset(0);
        make.left.equalTo(self).offset(150);
        make.width.mas_equalTo(0.5);
    }];
    
    self.rightLineV = [UIView new];
    self.rightLineV.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
    [self addSubview:self.rightLineV];
    [self.rightLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self.bottomLineV.mas_top).offset(0);
        make.right.equalTo(self).offset(-150);
        make.width.mas_equalTo(0.5);
    }];
    
    self.chipNumberLab = [UILabel new];
    self.chipNumberLab.textColor = [UIColor colorWithHexString:@"#474747"];
    self.chipNumberLab.font = [UIFont systemFontOfSize:16];
    self.chipNumberLab.text = @"面额/Denomination";
    self.chipNumberLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.chipNumberLab];
    [self.chipNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(4);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self.leftLineV.mas_left).offset(5);
        make.bottom.equalTo(self.bottomLineV.mas_top).offset(0);
    }];
    
    self.chipFmValueLab = [UILabel new];
    self.chipFmValueLab.textColor = [UIColor colorWithHexString:@"#474747"];
    self.chipFmValueLab.font = [UIFont systemFontOfSize:16];
    self.chipFmValueLab.text = @"数量/Number";
    self.chipFmValueLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.chipFmValueLab];
    [self.chipFmValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(4);
        make.left.equalTo(self.leftLineV.mas_right).offset(5);
        make.right.equalTo(self.rightLineV.mas_left).offset(5);
        make.bottom.equalTo(self.bottomLineV.mas_top).offset(0);
    }];
    
    self.chipMoneyValueLab = [UILabel new];
    self.chipMoneyValueLab.textColor = [UIColor colorWithHexString:@"#474747"];
    self.chipMoneyValueLab.font = [UIFont systemFontOfSize:16];
    self.chipMoneyValueLab.text = @"总额/Total";
    self.chipMoneyValueLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.chipMoneyValueLab];
    [self.chipMoneyValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(4);
        make.left.equalTo(self.rightLineV.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self.bottomLineV.mas_top).offset(0);
    }];
    
    return self;
}

@end
