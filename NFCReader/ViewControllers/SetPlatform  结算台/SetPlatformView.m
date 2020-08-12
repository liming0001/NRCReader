//
//  SetPlatformView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/6/9.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "SetPlatformView.h"

@interface SetPlatformView ()
//结算台
@property (nonatomic, strong) UIImageView *settlementImgV;
@property (nonatomic, strong) UILabel *settlementLab;
@property (nonatomic, strong) UIView *settlementV;
@property (nonatomic, strong) UIButton *heBtn;
@property (nonatomic, strong) UIButton *setmentOKBtn;
/*龙虎*/
@property (nonatomic, strong) UIButton *dragonBtn;
@property (nonatomic, strong) UIButton *tigerBtn;
/*百家乐*/
@property (nonatomic, strong) UIButton *zhuangBtn;
@property (nonatomic, strong) UIButton *zhuangDuiBtn;
@property (nonatomic, strong) UIButton *sixWinBtn;
@property (nonatomic, strong) UIButton *xianBtn;
@property (nonatomic, strong) UIButton *xianDuiBtn;
/*牛牛*/
@property (nonatomic, strong) UIImageView *cowIcon;

@property (nonatomic, strong) NSMutableArray *btnList;
@property (nonatomic, strong) NSMutableArray *resultList;

@end

@implementation SetPlatformView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.btnList = [NSMutableArray array];
    self.resultList = [NSMutableArray array];
    [self _setUpView];
    return self;
}

- (void)_setUpView{
    self.settlementImgV = [UIImageView new];
    self.settlementImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self addSubview:self.settlementImgV];
    [self.settlementImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_offset(self.frame.size.width);
    }];
    
    self.settlementLab = [UILabel new];
    self.settlementLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.settlementLab.font = [UIFont systemFontOfSize:12];
    self.settlementLab.textAlignment = NSTextAlignmentCenter;
    self.settlementLab.text = @"结算台Settlement Desk";
    [self addSubview:self.settlementLab];
    [self.settlementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_top).offset(3);
        make.left.equalTo(self.settlementImgV.mas_left).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_offset(self.frame.size.width);
    }];
    
    self.settlementV = [UIView new];
    self.settlementV.layer.cornerRadius = 2;
    self.settlementV.backgroundColor = [UIColor colorWithHexString:@"#3e565d"];
    [self addSubview:self.settlementV];
    [self.settlementV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_bottom).offset(0);
        make.left.equalTo(self).offset(0);
        make.height.mas_equalTo(232);
        make.width.mas_offset(self.frame.size.width);
    }];
    
    self.setmentOKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setmentOKBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.setmentOKBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.setmentOKBtn setTitle:@"OK.录入开牌结果" forState:UIControlStateNormal];
    [self.setmentOKBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateNormal];
    [self.setmentOKBtn addTarget:self action:@selector(resultEntryAction:) forControlEvents:UIControlEventTouchUpInside];
    self.setmentOKBtn.tag = 10;
    [self.settlementV addSubview:self.setmentOKBtn];
    [self.setmentOKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self.settlementV).offset(10);
        make.centerX.equalTo(self.settlementV);
        make.height.mas_equalTo(41);
    }];
}

#pragma mark -- 龙虎
- (void)_setUpTigerView{
    CGFloat setBtn_w = 249-42*2;
    CGFloat setBtn_h = 45;
    self.dragonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dragonBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.dragonBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.dragonBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.dragonBtn.tag = 11;
    [self.dragonBtn setImage:[UIImage imageNamed:@"dragon_unSelectIcon"] forState:UIControlStateNormal];
    [self.dragonBtn setImage:[UIImage imageNamed:@"dragon_selectIcon"] forState:UIControlStateSelected];
    [self.dragonBtn setBackgroundImage:[UIImage imageNamed:@"setment_dragon_bg"] forState:UIControlStateNormal];
    [self.dragonBtn setBackgroundImage:[UIImage imageNamed:@"seltment_select_bg"] forState:UIControlStateSelected];
    [self.dragonBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.dragonBtn];
    [self.dragonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(10);
        make.centerX.equalTo(self.settlementV).offset(0);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    [self.btnList addObject:self.dragonBtn];
    
    self.tigerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tigerBtn setTitleColor:[UIColor colorWithHexString:@"#1d3edd"] forState:UIControlStateNormal];
    [self.tigerBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.tigerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.tigerBtn.tag = 12;
    [self.tigerBtn setImage:[UIImage imageNamed:@"tiger_unselect_icon"] forState:UIControlStateNormal];
    [self.tigerBtn setImage:[UIImage imageNamed:@"seltment_tiger_selectIcon"] forState:UIControlStateSelected];
    [self.tigerBtn setBackgroundImage:[UIImage imageNamed:@"setment_dragon_bg"] forState:UIControlStateNormal];
    [self.tigerBtn setBackgroundImage:[UIImage imageNamed:@"tiger_bg_seltment"] forState:UIControlStateSelected];
    [self.tigerBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.tigerBtn];
    [self.tigerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dragonBtn.mas_bottom).offset(15);
        make.centerX.equalTo(self.settlementV).offset(0);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    [self.btnList addObject:self.tigerBtn];
    
    self.heBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#75e65c"] forState:UIControlStateNormal];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.heBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.heBtn.tag = 13;
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"setment_dragon_bg"] forState:UIControlStateNormal];
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"tie_bg_seltment"] forState:UIControlStateSelected];
    [self.heBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.heBtn];
    [self.heBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tigerBtn.mas_bottom).offset(15);
        make.centerX.equalTo(self.settlementV).offset(0);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    [self.btnList addObject:self.heBtn];
    
    [self showBtnsTitleInfo];
}

- (void)showBtnsTitleInfo{
    [self.dragonBtn setTitle:[NSString stringWithFormat:@"  龙 %@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
    [self.tigerBtn setTitle:[NSString stringWithFormat:@"  虎 %@",[EPStr getStr:kEPTiger note:@"虎"]] forState:UIControlStateNormal];
    [self.heBtn setTitle:[NSString stringWithFormat:@"和 %@",[EPStr getStr:kEPTigerHe note:@"和"]] forState:UIControlStateNormal];
}

#pragma mark -- 百家乐
- (void)_setUpBaccaratView{
    CGFloat setBtn_w = (240-30)/3;
    CGFloat setBtn_h = 50;
    self.zhuangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.zhuangBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.zhuangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.zhuangBtn setTitle:@"B.庄" forState:UIControlStateNormal];
    self.zhuangBtn.tag = 11;
    [self.zhuangBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.zhuangBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuangdui_p"] forState:UIControlStateSelected];
    [self.zhuangBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.zhuangBtn];
    [self.zhuangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(27);
        make.left.equalTo(self.settlementV).offset(10);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    [self.btnList addObject:self.zhuangBtn];
    
    self.zhuangDuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangDuiBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.zhuangDuiBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.zhuangDuiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.zhuangDuiBtn setTitle:@"BP.庄对" forState:UIControlStateNormal];
    self.zhuangDuiBtn.tag = 12;
    [self.zhuangDuiBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.zhuangDuiBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuangdui_p"] forState:UIControlStateSelected];
    [self.zhuangDuiBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.zhuangDuiBtn];
    [self.zhuangDuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(27);
        make.left.equalTo(self.zhuangBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    [self.btnList addObject:self.zhuangDuiBtn];
    
    self.sixWinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sixWinBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.sixWinBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.sixWinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    if ([PublicHttpTool shareInstance].curGameType==1) {
        [self.sixWinBtn setTitle:@"B.6点赢" forState:UIControlStateNormal];
    }else{
        [self.sixWinBtn setTitle:@"L.Lucky6" forState:UIControlStateNormal];
    }
    self.sixWinBtn.tag = 13;
    [self.sixWinBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.sixWinBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuangdui_p"] forState:UIControlStateSelected];
    [self.sixWinBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.sixWinBtn];
    [self.sixWinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(27);
        make.left.equalTo(self.zhuangDuiBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    [self.btnList addObject:self.sixWinBtn];
    
    self.xianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianBtn setTitleColor:[UIColor colorWithHexString:@"#2749f5"] forState:UIControlStateNormal];
    [self.xianBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.xianBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.xianBtn setTitle:@"P.闲" forState:UIControlStateNormal];
    self.xianBtn.tag = 14;
    [self.xianBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.xianBtn setBackgroundImage:[UIImage imageNamed:@"settlement_xian_p"] forState:UIControlStateSelected];
    [self.xianBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.xianBtn];
    [self.xianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBtn.mas_bottom).offset(20);
        make.left.equalTo(self.settlementV).offset(10);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    [self.btnList addObject:self.xianBtn];
    
    self.xianDuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianDuiBtn setTitleColor:[UIColor colorWithHexString:@"#2749f5"] forState:UIControlStateNormal];
    [self.xianDuiBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.xianDuiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.xianDuiBtn setTitle:@"PP.闲对" forState:UIControlStateNormal];
    self.xianDuiBtn.tag = 15;
    [self.xianDuiBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.xianDuiBtn setBackgroundImage:[UIImage imageNamed:@"settlement_xian_p"] forState:UIControlStateSelected];
    [self.xianDuiBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.xianDuiBtn];
    [self.xianDuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBtn.mas_bottom).offset(20);
        make.left.equalTo(self.xianBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    [self.btnList addObject:self.xianDuiBtn];
    
    self.heBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.heBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.heBtn setTitle:@"T.和" forState:UIControlStateNormal];
    self.heBtn.tag = 16;
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"settlement_Tbtn_n"] forState:UIControlStateSelected];
    [self.heBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.heBtn];
    [self.heBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBtn.mas_bottom).offset(20);
        make.left.equalTo(self.xianDuiBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    [self.btnList addObject:self.heBtn];
}

#pragma mark -- 牛牛
- (void)_setUpCowView{
    self.cowIcon = [UIImageView new];
    if ([PublicHttpTool shareInstance].curGameType==4) {
        self.cowIcon.image = [UIImage imageNamed:@"setment_cowIcon"];
    }else{
        self.cowIcon.image = [UIImage imageNamed:@"sangong"];
    }
    [self.settlementV addSubview:self.cowIcon];
    [self.cowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.setmentOKBtn.mas_top).offset(-15);
        make.centerX.equalTo(self.settlementV).offset(-15);
        make.height.mas_equalTo(154);
        make.width.mas_offset(176);
    }];
}

- (void)resultAction:(UIButton *)btn{
    if ([PublicHttpTool shareInstance].curGameType<3) {//百家乐
        int winType = (int)btn.tag-10;
        if (winType==1) {//庄
            if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//是否包含“闲，和”
                [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                return;
            }else{
                self.zhuangBtn.selected = !self.zhuangBtn.selected;
                if (self.zhuangBtn.selected) {
                    if (![self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
                        [self.resultList addObject:[NSNumber numberWithInteger:1]];
                    }
                }else{
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
                        [self.resultList removeObject:[NSNumber numberWithInteger:1]];
                    }
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {//庄对
                        [self.zhuangDuiBtn setSelected:NO];
                        [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                    }
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {//6点赢
                        [self.sixWinBtn setSelected:NO];
                        [self.resultList removeObject:[NSNumber numberWithInteger:3]];
                    }
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {//闲对
                        [self.xianDuiBtn setSelected:NO];
                        [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                    }
                }
            }
        }else if (winType==2){//庄对
            if (!([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]])) {
                [[EPToast makeText:@"请先选择庄或闲或和"]showWithType:ShortTime];
                return;
            }else{
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]) {//已经选择了庄
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                        [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                        return;
                    }else{
                        btn.selected = !btn.selected;
                        if (btn.selected) {
                            if (![self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                                [self.resultList addObject:[NSNumber numberWithInteger:2]];
                            }
                        }else{
                            if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                                [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                            }
                        }
                    }
                }else if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]){//已经选择了闲
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                        [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                        return;
                    }else{
                        btn.selected = !btn.selected;
                        if (btn.selected) {
                            if (![self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                                [self.resultList addObject:[NSNumber numberWithInteger:2]];
                            }
                        }else{
                            if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                                [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                            }
                        }
                    }
                }else if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]){//已经选择了和
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                        [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                        return;
                    }else{
                        btn.selected = !btn.selected;
                        if (btn.selected) {
                            if (![self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                                [self.resultList addObject:[NSNumber numberWithInteger:2]];
                            }
                        }else{
                            if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                                [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                            }
                        }
                    }
                }
            }
        }else if (winType==3){//幸运6点
            if (![self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
                [[EPToast makeText:@"请先选择庄"]showWithType:ShortTime];
                return;
            }else{
                if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                    [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                    return;
                }else{
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        if (![self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                            [self.resultList addObject:[NSNumber numberWithInteger:3]];
                        }
                    }else{
                        if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                            [self.resultList removeObject:[NSNumber numberWithInteger:3]];
                        }
                    }
                    
                }
            }
        }else if (winType==4){//闲
            if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//是否包含“庄，和”
                [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                return;
            }else{
                btn.selected = !btn.selected;
                if (btn.selected) {
                    if (![self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                        [self.resultList addObject:[NSNumber numberWithInteger:4]];
                    }
                }else{
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {//庄对
                        [self.zhuangDuiBtn setSelected:NO];
                        [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                    }
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {//闲对
                        [self.xianDuiBtn setSelected:NO];
                        [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                    }
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                        [self.resultList removeObject:[NSNumber numberWithInteger:4]];
                    }
                }
            }
        }else if (winType==5){//闲对
            if (!([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]])) {
                [[EPToast makeText:@"请先选择庄或闲或和"]showWithType:ShortTime];
                return;
            }else{
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]) {//已经选择了庄
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                        [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                        return;
                    }else{
                        btn.selected = !btn.selected;
                        if (btn.selected) {
                            if (![self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                                [self.resultList addObject:[NSNumber numberWithInteger:5]];
                            }
                        }else{
                            if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                                [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                            }
                        }
                    }
                }else if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]){//已经选择了闲
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]||[self.resultList containsObject:[NSNumber numberWithInteger:7]]) {
                        [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                        return;
                    }else{
                        btn.selected = !btn.selected;
                        if (btn.selected) {
                            if (![self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                                [self.resultList addObject:[NSNumber numberWithInteger:5]];
                            }
                        }else{
                            if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                                [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                            }
                        }
                    }
                }else if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]){//已经选择了和
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:7]]) {
                        [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                        return;
                    }else{
                        btn.selected = !btn.selected;
                        if (btn.selected) {
                            if (![self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                                [self.resultList addObject:[NSNumber numberWithInteger:5]];
                            }
                        }else{
                            if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                                [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                            }
                        }
                    }
                }
            }
        }else if (winType==6){//和
            if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]) {//是否包含“闲，和”
                [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                return;
            }else{
                self.heBtn.selected = !self.heBtn.selected;
                if (self.heBtn.selected) {
                    if (![self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                        [self.resultList addObject:[NSNumber numberWithInteger:6]];
                    }
                }else{
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {//庄对
                        [self.zhuangDuiBtn setSelected:NO];
                        [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                    }
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {//闲对
                        [self.xianDuiBtn setSelected:NO];
                        [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                    }
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                        [self.resultList removeObject:[NSNumber numberWithInteger:6]];
                    }
                }
            }
        }else if (winType==7){//6点赢
            if (![self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
                [[EPToast makeText:@"请先选择庄"]showWithType:ShortTime];
                return;
            }else{
                if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                    [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                    return;
                }else{
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        if (![self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                            [self.resultList addObject:[NSNumber numberWithInteger:3]];
                        }
                    }else{
                        if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                            [self.resultList removeObject:[NSNumber numberWithInteger:3]];
                        }
                    }
                    
                }
            }
        }
        [PublicHttpTool shareInstance].resultList = self.resultList;
        if (self.platformBtnBlock) {
            self.platformBtnBlock(btn.tag-10, [PublicHttpTool shareInstance].curGameType);
        }
    }else if ([PublicHttpTool shareInstance].curGameType==3){//龙虎
        for (int j=0; j<self.btnList.count; j++) {
            if (btn.tag == 11+j) {
                btn.selected = YES;
                if (self.platformBtnBlock) {
                    self.platformBtnBlock(btn.tag-10, [PublicHttpTool shareInstance].curGameType);
                }
                continue;
            }
            UIButton *but = (UIButton *)[self viewWithTag:11+j];
            but.selected = NO;
        }
    }else if ([PublicHttpTool shareInstance].curGameType==4){//牛牛
        
    }
}

- (void)resultEntryAction:(UIButton *)btn{
    if (self.platformBtnBlock) {
        self.platformBtnBlock(btn.tag-10, [PublicHttpTool shareInstance].curGameType);
    }
}

- (void)_setPlatFormBtnNormalStatusWithResult:(NSString*)result{
    if ([PublicHttpTool shareInstance].curGameType<3) {//百家乐
        [self.resultList removeAllObjects];
        for (int j=0; j<self.btnList.count; j++) {
            UIButton *but = (UIButton *)[self viewWithTag:11+j];
            but.selected = NO;
        }
        NSArray *resultList = [result componentsSeparatedByString:@","];
        if ([resultList containsObject:@"庄"]) {
            [self.resultList addObject:[NSNumber numberWithInt:1]];
            [self.zhuangBtn setSelected:YES];
        }
        if ([resultList containsObject:@"庄对"]) {
            [self.resultList addObject:[NSNumber numberWithInt:2]];
            [self.zhuangDuiBtn setSelected:YES];
        }
        if (([resultList containsObject:@"6点赢"]||[resultList containsObject:@"Lucky6"])) {
            [self.resultList addObject:[NSNumber numberWithInt:3]];
            [self.sixWinBtn setSelected:YES];
        }
        if ([resultList containsObject:@"闲"]) {
            [self.resultList addObject:[NSNumber numberWithInt:4]];
            [self.xianBtn setSelected:YES];
        }
        if ([resultList containsObject:@"闲对"]) {
            [self.resultList addObject:[NSNumber numberWithInt:5]];
            [self.xianDuiBtn setSelected:YES];
        }
        if ([resultList containsObject:@"和"]) {
            [self.resultList addObject:[NSNumber numberWithInt:6]];
            [self.heBtn setSelected:YES];
        }
        [PublicHttpTool shareInstance].resultList = self.resultList;
    }else if ([PublicHttpTool shareInstance].curGameType==3){//龙虎
       int resultStatus = 0;
       if ([result isEqualToString:@"龙"]) {
           resultStatus=11;
       }else if ([result isEqualToString:@"虎"]){
           resultStatus=12;
       }else if ([result isEqualToString:@"和"]){
           resultStatus=13;
       }
        [PublicHttpTool shareInstance].tiger_resultTag = resultStatus-10;
       for (int j=0; j<self.btnList.count; j++) {
           if (resultStatus == 11+j) {
               UIButton *btn = (UIButton *)[self viewWithTag:resultStatus];
               btn.selected = YES;
               continue;
           }
           UIButton *but = (UIButton *)[self viewWithTag:11+j];
           but.selected = NO;
       }
    }else if ([PublicHttpTool shareInstance].curGameType==4){
       
    }
}

@end
