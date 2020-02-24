//
//  JiaJianCaiCellView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/1/3.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "JiaJianCaiCellView.h"
#import "ZLKeyboard.h"

@interface JiaJianCaiCellView ()

@property (nonatomic, strong) UIView *bottomLineV;
@property (nonatomic, strong) UIView *leftLineV;
@property (nonatomic, strong) UIView *rightLineV;

@end

@implementation JiaJianCaiCellView

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
    self.chipNumberLab.text = @"100000";
    self.chipNumberLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.chipNumberLab];
    [self.chipNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(4);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self.leftLineV.mas_left).offset(5);
        make.bottom.equalTo(self.bottomLineV.mas_top).offset(0);
    }];
    
    self.chipNumberEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chipNumberEditBtn setImage:[UIImage imageNamed:@"entry_Icon"] forState:UIControlStateNormal];
    [self.chipNumberEditBtn addTarget:self action:@selector(chipNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.chipNumberEditBtn];
    [self.chipNumberEditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLineV.mas_left).offset(-5);
        make.width.height.mas_equalTo(25);
        make.centerY.equalTo(self);
    }];
    
    self.chipNumberTF = [UITextField new];
    self.chipNumberTF.font = [UIFont systemFontOfSize:14];
    self.chipNumberTF.textColor = [UIColor colorWithHexString:@"#474747"];
    self.chipNumberTF.enabled = NO;
    [ZLKeyboard bindKeyboard:self.chipNumberTF];
    [self addSubview:self.chipNumberTF];
    [self.chipNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(4);
        make.left.equalTo(self.leftLineV.mas_right).offset(5);
        make.right.equalTo(self.chipNumberEditBtn.mas_left).offset(-5);
        make.bottom.equalTo(self.bottomLineV.mas_top).offset(-4);
    }];
    
    self.chipMoneyValueLab = [UILabel new];
    self.chipMoneyValueLab.textColor = [UIColor colorWithHexString:@"#474747"];
    self.chipMoneyValueLab.font = [UIFont systemFontOfSize:16];
    self.chipMoneyValueLab.text = @"0";
    self.chipMoneyValueLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.chipMoneyValueLab];
    [self.chipMoneyValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(4);
        make.left.equalTo(self.rightLineV.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self.bottomLineV.mas_top).offset(0);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureEntryTigerCustomerInfo:) name:@"sureEntryCustomerInfo" object:nil];
    return self;
}

- (void)chipNumberAction:(UIButton *)btn{
    if (_editBtnBock) {
        _editBtnBock(btn.tag);
    }
}

#pragma mark - /---------------------- notifications ----------------------/
-(void)sureEntryTigerCustomerInfo:(NSNotification *)ntf {
    [self.chipNumberTF resignFirstResponder];
}

@end
