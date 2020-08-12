//
//  TableInfoView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/6/9.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "TableInfoView.h"
#import "SFLabel.h"
#import "EPCowPointChooseShowView.h"
#import "NRThreeFairsPointShowView.h"

@interface TableInfoView ()

//台桌信息
@property (nonatomic, strong) UIImageView *tableInfoImgV;
@property (nonatomic, strong) UILabel *tableInfoLab;
@property (nonatomic, strong) UIView *tableInfoV;
@property (nonatomic, strong) SFLabel *stableIDLab;
@property (nonatomic, strong) UILabel *xueciLab;
@property (nonatomic, strong) UILabel *puciLab;
/* 龙虎信息*/
@property (nonatomic, strong) UIView *dragonBorderV;
@property (nonatomic, strong) UIButton *dragonInfoBtn;
@property (nonatomic, strong) UILabel *dragonInfoLab;
@property (nonatomic, strong) UIView *tigerBorderV;
@property (nonatomic, strong) UIButton *tigerInfoBtn;
@property (nonatomic, strong) UILabel *tigerInfoLab;
@property (nonatomic, strong) UIView *heBorderV;
@property (nonatomic, strong) UIButton *heInfoBtn;
@property (nonatomic, strong) UILabel *heInfoLab;
/* 百家乐信息*/
@property (nonatomic, strong) UIView *zhuangBorderV;
@property (nonatomic, strong) UIButton *zhuangInfoBtn;
@property (nonatomic, strong) UILabel *zhuangInfoLab;
@property (nonatomic, strong) UIView *zhuangDuiBorderV;
@property (nonatomic, strong) UIButton *zhuangDuiInfoBtn;
@property (nonatomic, strong) UILabel *zhuangDuiInfoLab;
@property (nonatomic, strong) UIView *sixWinBorderV;
@property (nonatomic, strong) UIButton *sixWinInfoBtn;
@property (nonatomic, strong) UILabel *sixWinInfoLab;
@property (nonatomic, strong) UIView *xianBorderV;
@property (nonatomic, strong) UIButton *xianInfoBtn;
@property (nonatomic, strong) UILabel *xianInfoLab;
@property (nonatomic, strong) UIView *xianDuiBorderV;
@property (nonatomic, strong) UIButton *xianDuiInfoBtn;
@property (nonatomic, strong) UILabel *xianDuiInfoLab;
/*牛牛*/
@property (nonatomic, strong) UIView *tableZhuangV;
@property (nonatomic, strong) UILabel *tableZhuangPointValueLab;
@property (nonatomic, strong) UILabel *tableZhuangPointLab;
@property (nonatomic, strong) UIButton *tableZhuangBtn;

@end

@implementation TableInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpView];
    return self;
}

- (void)_setUpView{
    //台桌信息
    self.tableInfoImgV = [UIImageView new];
    self.tableInfoImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self addSubview:self.tableInfoImgV];
    [self.tableInfoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_offset(self.frame.size.width);
    }];
    
    self.tableInfoLab = [UILabel new];
    self.tableInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tableInfoLab.font = [UIFont systemFontOfSize:12];
    self.tableInfoLab.text = @"台桌信息Table information";
    self.tableInfoLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tableInfoLab];
    [self.tableInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoImgV.mas_top).offset(3);
        make.left.equalTo(self.tableInfoImgV.mas_left).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_offset(self.frame.size.width);
    }];
    
    self.tableInfoV = [UIView new];
    self.tableInfoV.layer.cornerRadius = 2;
    self.tableInfoV.backgroundColor = [UIColor colorWithHexString:@"#3e565d"];
    [self addSubview:self.tableInfoV];
    [self.tableInfoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoImgV.mas_bottom).offset(0);
        make.left.equalTo(self.tableInfoImgV.mas_left).offset(0);
        make.height.mas_equalTo(self.frame.size.height-30);
        make.width.mas_offset(self.frame.size.width);
    }];
    
    self.stableIDLab = [SFLabel new];
    self.stableIDLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.stableIDLab.font = [UIFont systemFontOfSize:10];
    self.stableIDLab.layer.cornerRadius = 5;
    self.stableIDLab.backgroundColor = [UIColor colorWithHexString:@"#201f24"];
    [self.tableInfoV addSubview:self.stableIDLab];
    [self.stableIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoV).offset(3);
        make.left.equalTo(self.tableInfoV).offset(15);
    }];
    
    self.xueciLab = [UILabel new];
    self.xueciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xueciLab.font = [UIFont systemFontOfSize:10];
    self.xueciLab.text = @"靴次:0";
    [self.tableInfoV addSubview:self.xueciLab];
    [self.xueciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stableIDLab.mas_bottom).offset(3);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.puciLab = [UILabel new];
    self.puciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.puciLab.font = [UIFont systemFontOfSize:10];
    self.puciLab.text = @"铺次:0";
    [self.tableInfoV addSubview:self.puciLab];
    [self.puciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(3);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
}

#pragma mark -- 更新台桌信息
- (void)updateTableInfo{
    self.stableIDLab.text = [NSString stringWithFormat:@"台桌ID:%@",[PublicHttpTool shareInstance].tableName];
    self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",[PublicHttpTool shareInstance].xueciCount];
    self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",[PublicHttpTool shareInstance].puciCount];
}

#pragma mark -- 龙虎
- (void)_setUpTigerView{
    self.dragonBorderV = [UIView new];
    self.dragonBorderV.layer.cornerRadius = 2;
    self.dragonBorderV.backgroundColor = [UIColor clearColor];
    self.dragonBorderV.layer.borderWidth = 0.5;
    self.dragonBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.dragonBorderV];
    [self.dragonBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoV).offset(56);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(82);
        make.width.mas_equalTo(55);
    }];
    
    self.dragonInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dragonInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.dragonInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.dragonInfoBtn.titleLabel.numberOfLines = 0;
    self.dragonInfoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.dragonInfoBtn setBackgroundImage:[UIImage imageNamed:@"dragon_bg"] forState:UIControlStateNormal];
    [self.dragonInfoBtn setBackgroundImage:[UIImage imageNamed:@"dragon_bg"] forState:UIControlStateHighlighted];
    [self.dragonBorderV addSubview:self.dragonInfoBtn];
    [self.dragonInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.dragonBorderV).offset(0);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(52);
    }];
    
    self.dragonInfoLab = [UILabel new];
    self.dragonInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.dragonInfoLab.font = [UIFont systemFontOfSize:12];
    self.dragonInfoLab.text = @"0";
    self.dragonInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.dragonBorderV addSubview:self.dragonInfoLab];
    [self.dragonInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dragonInfoBtn.mas_bottom).offset(0);
        make.centerX.equalTo(self.dragonBorderV);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(30);
    }];
    
    self.tigerBorderV = [UIView new];
    self.tigerBorderV.layer.cornerRadius = 2;
    self.tigerBorderV.backgroundColor = [UIColor clearColor];
    self.tigerBorderV.layer.borderWidth = 0.5;
    self.tigerBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.tigerBorderV];
    [self.tigerBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoV).offset(56);
        make.left.equalTo(self.dragonBorderV.mas_right).offset(6);
        make.height.mas_equalTo(82);
        make.width.mas_equalTo(55);
    }];
    
    self.tigerInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tigerInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.tigerInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.tigerInfoBtn.titleLabel.numberOfLines = 0;
    self.tigerInfoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.tigerInfoBtn setBackgroundImage:[UIImage imageNamed:@"tiger_bg"] forState:UIControlStateNormal];
    [self.tigerInfoBtn setBackgroundImage:[UIImage imageNamed:@"tiger_bg"] forState:UIControlStateHighlighted];
    [self.tigerBorderV addSubview:self.tigerInfoBtn];
    [self.tigerInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.tigerBorderV).offset(0);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(52);
    }];
    self.tigerInfoLab = [UILabel new];
    self.tigerInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tigerInfoLab.font = [UIFont systemFontOfSize:12];
    self.tigerInfoLab.text = @"0";
    self.tigerInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.tigerBorderV addSubview:self.tigerInfoLab];
    [self.tigerInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tigerInfoBtn.mas_bottom).offset(0);
        make.centerX.equalTo(self.tigerBorderV);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(30);
    }];
    
    self.heBorderV = [UIView new];
    self.heBorderV.layer.cornerRadius = 2;
    self.heBorderV.backgroundColor = [UIColor clearColor];
    self.heBorderV.layer.borderWidth = 0.5;
    self.heBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.heBorderV];
    [self.heBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableInfoV).offset(-6);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.top.equalTo(self.tigerBorderV.mas_bottom).offset(7);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    self.heInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.heInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.heInfoBtn.titleLabel.numberOfLines = 0;
    self.heInfoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.heInfoBtn setBackgroundImage:[UIImage imageNamed:@"tie_bg"] forState:UIControlStateNormal];
    [self.heInfoBtn setBackgroundImage:[UIImage imageNamed:@"tie_bg"] forState:UIControlStateHighlighted];
    [self.heBorderV addSubview:self.heInfoBtn];
    [self.heInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.equalTo(self.heBorderV).offset(0);
        make.height.mas_equalTo(52);
    }];
    
    self.heInfoLab = [UILabel new];
    self.heInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.heInfoLab.font = [UIFont systemFontOfSize:12];
    self.heInfoLab.text = @"0";
    self.heInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.heBorderV addSubview:self.heInfoLab];
    [self.heInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heInfoBtn.mas_bottom).offset(0);
        make.centerX.equalTo(self.heBorderV);
        make.width.mas_equalTo(55);
        make.bottom.equalTo(self.heBorderV);
    }];
    [self showTableTitleInfo];
}

- (void)showTableTitleInfo{
    [self.dragonInfoBtn setTitle:[NSString stringWithFormat:@"龙\n%@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
    [self.tigerInfoBtn setTitle:[NSString stringWithFormat:@"虎\n%@",[EPStr getStr:kEPTiger note:@"虎"]] forState:UIControlStateNormal];
    [self.heInfoBtn setTitle:[NSString stringWithFormat:@"和\n%@",[EPStr getStr:kEPTigerHe note:@"和"]] forState:UIControlStateNormal];
}

- (void)updateTigerCountWithCountList:(NSArray *)countList{
    self.dragonInfoLab.text = [NSString stringWithFormat:@"%@",countList[0]];
    self.tigerInfoLab.text = [NSString stringWithFormat:@"%@",countList[1]];
    self.heInfoLab.text = [NSString stringWithFormat:@"%@",countList[2]];
}

#pragma mark -- 百家乐
- (void)_setUpBaccaratView{
    self.zhuangBorderV = [UIView new];
    self.zhuangBorderV.layer.cornerRadius = 2;
    self.zhuangBorderV.backgroundColor = [UIColor clearColor];
    self.zhuangBorderV.layer.borderWidth = 0.5;
    self.zhuangBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.zhuangBorderV];
    [self.zhuangBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.puciLab.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    CGFloat item_w = (156-40)/2+20;
    CGFloat item_w_lab = (156-40)/2-20;
    CGFloat item_result_h = 24;
    self.zhuangInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.zhuangInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.zhuangInfoBtn setTitle:@"B.庄" forState:UIControlStateNormal];
    [self.zhuangInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateNormal];
    [self.zhuangInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateHighlighted];
    [self.zhuangBorderV addSubview:self.zhuangInfoBtn];
    [self.zhuangInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.zhuangBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.zhuangInfoLab = [UILabel new];
    self.zhuangInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.zhuangInfoLab.font = [UIFont systemFontOfSize:12];
    self.zhuangInfoLab.text = @"0";
    self.zhuangInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.zhuangBorderV addSubview:self.zhuangInfoLab];
    [self.zhuangInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zhuangInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.zhuangBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    self.zhuangDuiBorderV = [UIView new];
    self.zhuangDuiBorderV.layer.cornerRadius = 2;
    self.zhuangDuiBorderV.backgroundColor = [UIColor clearColor];
    self.zhuangDuiBorderV.layer.borderWidth = 0.5;
    self.zhuangDuiBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.zhuangDuiBorderV];
    [self.zhuangDuiBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBorderV.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(item_result_h);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.zhuangDuiInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangDuiInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.zhuangDuiInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.zhuangDuiInfoBtn setTitle:@"BP.庄对" forState:UIControlStateNormal];
    [self.zhuangDuiInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateNormal];
    [self.zhuangDuiInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateHighlighted];
    [self.zhuangDuiBorderV addSubview:self.zhuangDuiInfoBtn];
    [self.zhuangDuiInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.zhuangDuiBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.zhuangDuiInfoLab = [UILabel new];
    self.zhuangDuiInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.zhuangDuiInfoLab.font = [UIFont systemFontOfSize:12];
    self.zhuangDuiInfoLab.text = @"0";
    self.zhuangDuiInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.zhuangDuiBorderV addSubview:self.zhuangDuiInfoLab];
    [self.zhuangDuiInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zhuangDuiInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.zhuangDuiBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    self.sixWinBorderV = [UIView new];
    self.sixWinBorderV.layer.cornerRadius = 2;
    self.sixWinBorderV.backgroundColor = [UIColor clearColor];
    self.sixWinBorderV.layer.borderWidth = 0.5;
    self.sixWinBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.sixWinBorderV];
    [self.sixWinBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangDuiBorderV.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(item_result_h);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.sixWinInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sixWinInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.sixWinInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    if ([PublicHttpTool shareInstance].curGameType==1) {
        [self.sixWinInfoBtn setTitle:@"B.6点赢" forState:UIControlStateNormal];
    }else{
        [self.sixWinInfoBtn setTitle:@"L.Lucky6" forState:UIControlStateNormal];
    }
    [self.sixWinInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateNormal];
    [self.sixWinInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateHighlighted];
    [self.sixWinBorderV addSubview:self.sixWinInfoBtn];
    [self.sixWinInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.sixWinBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.sixWinInfoLab = [UILabel new];
    self.sixWinInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.sixWinInfoLab.font = [UIFont systemFontOfSize:12];
    self.sixWinInfoLab.text = @"0";
    self.sixWinInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.sixWinBorderV addSubview:self.sixWinInfoLab];
    [self.sixWinInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sixWinInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.sixWinBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    self.xianBorderV = [UIView new];
    self.xianBorderV.layer.cornerRadius = 2;
    self.xianBorderV.backgroundColor = [UIColor clearColor];
    self.xianBorderV.layer.borderWidth = 0.5;
    self.xianBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.xianBorderV];
    [self.xianBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sixWinBorderV.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(item_result_h);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.xianInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.xianInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.xianInfoBtn setTitle:@"P.闲" forState:UIControlStateNormal];
    [self.xianInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_xian_bg"] forState:UIControlStateNormal];
    [self.xianInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_xian_bg"] forState:UIControlStateHighlighted];
    [self.xianBorderV addSubview:self.xianInfoBtn];
    [self.xianInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.xianBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.xianInfoLab = [UILabel new];
    self.xianInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xianInfoLab.font = [UIFont systemFontOfSize:12];
    self.xianInfoLab.text = @"0";
    self.xianInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.xianBorderV addSubview:self.xianInfoLab];
    [self.xianInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xianInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.xianBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    self.xianDuiBorderV = [UIView new];
    self.xianDuiBorderV.layer.cornerRadius = 2;
    self.xianDuiBorderV.backgroundColor = [UIColor clearColor];
    self.xianDuiBorderV.layer.borderWidth = 0.5;
    self.xianDuiBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.xianDuiBorderV];
    [self.xianDuiBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xianBorderV.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(item_result_h);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.xianDuiInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianDuiInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.xianDuiInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.xianDuiInfoBtn setTitle:@"PP.闲对" forState:UIControlStateNormal];
    [self.xianDuiInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_xian_bg"] forState:UIControlStateNormal];
    [self.xianDuiInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_xian_bg"] forState:UIControlStateHighlighted];
    [self.xianDuiBorderV addSubview:self.xianDuiInfoBtn];
    [self.xianDuiInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.xianDuiBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.xianDuiInfoLab = [UILabel new];
    self.xianDuiInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xianDuiInfoLab.font = [UIFont systemFontOfSize:12];
    self.xianDuiInfoLab.text = @"0";
    self.xianDuiInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.xianDuiBorderV addSubview:self.xianDuiInfoLab];
    [self.xianDuiInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xianDuiInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.xianDuiBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    self.heBorderV = [UIView new];
    self.heBorderV.layer.cornerRadius = 2;
    self.heBorderV.backgroundColor = [UIColor clearColor];
    self.heBorderV.layer.borderWidth = 0.5;
    self.heBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.heBorderV];
    [self.heBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xianDuiBorderV.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(item_result_h);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.heInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.heInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.heInfoBtn setTitle:@"T.和" forState:UIControlStateNormal];
    [self.heInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_he_bg"] forState:UIControlStateNormal];
    [self.heInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_he_bg"] forState:UIControlStateHighlighted];
    [self.heBorderV addSubview:self.heInfoBtn];
    [self.heInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.heBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.heInfoLab = [UILabel new];
    self.heInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.heInfoLab.font = [UIFont systemFontOfSize:12];
    self.heInfoLab.text = @"0";
    self.heInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.heBorderV addSubview:self.heInfoLab];
    [self.heInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.heBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
}

- (void)updateBaccaratCountWithCountList:(NSArray *)countList{
    self.zhuangInfoLab.text  = [NSString stringWithFormat:@"%@",countList[0]];
    self.zhuangDuiInfoLab.text = [NSString stringWithFormat:@"%@",countList[1]];
    self.xianInfoLab.text = [NSString stringWithFormat:@"%@",countList[2]];
    self.xianDuiInfoLab.text = [NSString stringWithFormat:@"%@",countList[3]];
    self.sixWinInfoLab.text = [NSString stringWithFormat:@"%@",countList[4]];
    self.heInfoLab.text = [NSString stringWithFormat:@"%@",countList[5]];
}

#pragma mark -- 牛牛
- (void)_setUpCowView{
    self.tableZhuangV = [UIView new];
    self.tableZhuangV.layer.cornerRadius = 2;
    self.tableZhuangV.backgroundColor = [UIColor whiteColor];
    [self.tableInfoV addSubview:self.tableZhuangV];
    [self.tableZhuangV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableInfoV).offset(-5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.centerX.equalTo(self.tableInfoV).offset(0);
        make.height.mas_equalTo(80);
    }];
    
    self.tableZhuangPointLab = [UILabel new];
    self.tableZhuangPointLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tableZhuangPointLab.font = [UIFont systemFontOfSize:16];
    self.tableZhuangPointLab.text = @"庄家";
    self.tableZhuangPointLab.backgroundColor = [UIColor colorWithHexString:@"#e7bb63"];
    self.tableZhuangPointLab.textAlignment = NSTextAlignmentCenter;
    [self.tableZhuangV addSubview:self.tableZhuangPointLab];
    [self.tableZhuangPointLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableZhuangV).offset(0);
        make.left.equalTo(self.tableZhuangV).offset(0);
        make.centerX.equalTo(self.tableZhuangV).offset(0);
        make.height.mas_equalTo(30);
    }];

    self.tableZhuangPointValueLab = [UILabel new];
    self.tableZhuangPointValueLab.textColor = [UIColor colorWithHexString:@"#dedede"];
    self.tableZhuangPointValueLab.font = [UIFont systemFontOfSize:24];
    self.tableZhuangPointValueLab.text = @"录入点数";
    self.tableZhuangPointValueLab.textAlignment = NSTextAlignmentCenter;
    [self.tableZhuangV addSubview:self.tableZhuangPointValueLab];
    [self.tableZhuangPointValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableZhuangV).offset(0);
        make.bottom.equalTo(self.tableZhuangPointLab.mas_top).offset(0);
        make.left.equalTo(self.tableZhuangV).offset(0);
        make.centerX.equalTo(self.tableZhuangV);
    }];
    
    self.tableZhuangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tableZhuangBtn addTarget:self action:@selector(zhuangPointChooseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableZhuangV addSubview:self.tableZhuangBtn];
    [self.tableZhuangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.tableZhuangV).offset(0);
    }];
}

#pragma mark -- 点数选择
- (void)zhuangPointChooseAction{
    __block int cowPoint = 0;
    if ([PublicHttpTool shareInstance].curGameType==4) {//牛牛
        EPCowPointChooseShowView *cowPointView = [[AppDelegate shareInstance]cowPointShowView];
        [[MJPopTool sharedInstance] popView:cowPointView animated:YES];
        @weakify(self);
        cowPointView.pointsResultBlock = ^(int curPoint) {
            @strongify(self);
            DLOG(@"curPoint===%d",curPoint);
            self.tableZhuangPointValueLab.textColor = [UIColor redColor];
            cowPoint = curPoint;
            if (curPoint==99) {
                cowPoint = 0;
                self.tableZhuangPointValueLab.text = @"没牛";
            }else if (curPoint==10){
                self.tableZhuangPointValueLab.text = @"牛牛";
            }else if (curPoint==11){
                self.tableZhuangPointValueLab.text = @"五花牛";
            }else if (curPoint==12){
                self.tableZhuangPointValueLab.text = @"炸弹";
            }else if (curPoint==13){
                self.tableZhuangPointValueLab.text = @"五小牛";
            }else{
                self.tableZhuangPointValueLab.text = [NSString stringWithFormat:@"%d",curPoint];
            }
            [PublicHttpTool shareInstance].cowPoint = cowPoint;
            [PublicHttpTool shareInstance].curupdateInfo.cp_name = self.tableZhuangPointValueLab.text;
            if (self.tableInfoBtnBlock) {
                self.tableInfoBtnBlock(0, 2);
            }
        };
    }else{
        NRThreeFairsPointShowView *fairsPointShowView = [[AppDelegate shareInstance]fairsPointShowView];
        [[MJPopTool sharedInstance] popView:fairsPointShowView animated:YES];
        @weakify(self);
        fairsPointShowView.fairsPointsResultBlock = ^(int curPoint) {
            @strongify(self);
            DLOG(@"curPoint===%d",curPoint);
            self.tableZhuangPointValueLab.textColor = [UIColor redColor];
            if (curPoint==99) {
                cowPoint = 0;
                self.tableZhuangPointValueLab.text = @"没点";
            }else if (curPoint==10){
                self.tableZhuangPointValueLab.text = @"小三公";
            }else if (curPoint==11){
                self.tableZhuangPointValueLab.text = @"大三公";
            }else{
                self.tableZhuangPointValueLab.text = [NSString stringWithFormat:@"%d",curPoint];
            }
            [PublicHttpTool shareInstance].cowPoint = cowPoint;
            [PublicHttpTool shareInstance].curupdateInfo.cp_name = self.tableZhuangPointValueLab.text;
            if (self.tableInfoBtnBlock) {
                self.tableInfoBtnBlock(0, 2);
            }
        };
    }
}

#pragma mark -- 清除牛牛庄家点数
- (void)clearCowPoint{
    [PublicHttpTool shareInstance].cowPoint = 99;
    [PublicHttpTool shareInstance].curupdateInfo.cp_name = @"";
    self.tableZhuangPointValueLab.text = @"";
}

- (void)_setPlatFormBtnNormalStatusWithResult:(NSString*)result{
    self.tableZhuangPointValueLab.textColor = [UIColor redColor];
    if ([result isEqualToString:@"没牛"]) {
        [PublicHttpTool shareInstance].cowPoint = 0;
    }else if ([result isEqualToString:@"牛牛"]){
        [PublicHttpTool shareInstance].cowPoint = 10;
    }else if ([result isEqualToString:@"五花牛"]){
        [PublicHttpTool shareInstance].cowPoint = 11;
    }else if ([result isEqualToString:@"炸弹"]){
        [PublicHttpTool shareInstance].cowPoint = 12;
    }else if ([result isEqualToString:@"五小牛"]){
        [PublicHttpTool shareInstance].cowPoint = 13;
    }else{
        [PublicHttpTool shareInstance].cowPoint = [result intValue];
    }
    self.tableZhuangPointValueLab.text = result;
}

@end
