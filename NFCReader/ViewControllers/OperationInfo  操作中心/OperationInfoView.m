//
//  OperationInfoView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/6/9.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "OperationInfoView.h"
#import "JXButton.h"

@interface OperationInfoView ()
@property (nonatomic, strong) UIImageView *operateCenterImgV;
@property (nonatomic, strong) UILabel *operateCenterLabel;
@property (nonatomic, strong) UIView *operateCenterView;
//公用
@property (nonatomic, strong) JXButton *zhuxiaochouma_button;
@property (nonatomic, strong) JXButton *readChip_button;
@property (nonatomic, strong) JXButton *aTipRecordButton;//小费按钮
@property (nonatomic, strong) UIButton *he_button;

//龙虎
@property (nonatomic, strong) UIButton *dragon_button;
@property (nonatomic, strong) UIButton *tiger_button;

//百家乐
@property (nonatomic, strong) UIButton *zhuang_button;
@property (nonatomic, strong) UIButton *xian_button;
@property (nonatomic, strong) UIButton *zhuangduizi_button;
@property (nonatomic, strong) UIButton *xianduizi_button;
@property (nonatomic, strong) UIButton *baoxian_button;
@property (nonatomic, strong) UIButton *luckysix_button;

//牛牛
@property (nonatomic, strong) UIButton *superDouble_button;
@property (nonatomic, strong) UIButton *double_button;
@property (nonatomic, strong) UIButton *flat_button;

@property (nonatomic, strong) NSMutableArray *btnList;

@end

@implementation OperationInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.btnList = [NSMutableArray array];
    [self _setUpView];
    return self;
}

- (void)_setUpView{
    self.operateCenterImgV = [UIImageView new];
    self.operateCenterImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self addSubview:self.operateCenterImgV];
    [self.operateCenterImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self);
    }];

    self.operateCenterLabel = [UILabel new];
    self.operateCenterLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.operateCenterLabel.font = [UIFont systemFontOfSize:15];
    self.operateCenterLabel.text = @"操作中心Dew information";
    [self addSubview:self.operateCenterLabel];
    [self.operateCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self);
    }];

    self.operateCenterView = [UIView new];
    self.operateCenterView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    [self addSubview:self.operateCenterView];
    [self.operateCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operateCenterImgV.mas_bottom).offset(0);
        make.left.equalTo(self.operateCenterImgV).offset(0);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];

    CGFloat tapItem_height = 158;
    CGFloat item_fontsize = 21;
    self.aTipRecordButton = [JXButton buttonWithType:UIButtonTypeCustom];
    self.aTipRecordButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.aTipRecordButton.titleLabel.numberOfLines = 0;
    [self.aTipRecordButton setImage:[UIImage imageNamed:@"operationCenter_tipFee_p"] forState:UIControlStateNormal];
    [self.aTipRecordButton setBackgroundImage:[UIImage imageNamed:@"operationCenter_leftBtn_bg"] forState:UIControlStateNormal];
    self.aTipRecordButton.tag = 0;
    self.aTipRecordButton.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.aTipRecordButton addTarget:self action:@selector(publicBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.aTipRecordButton];
    [self.aTipRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operateCenterView).offset(15);
        make.left.equalTo(self.operateCenterView).offset(10);
        make.height.mas_equalTo(tapItem_height);
        make.width.mas_offset(160);
    }];

    self.zhuxiaochouma_button = [JXButton buttonWithType:UIButtonTypeCustom];
    self.zhuxiaochouma_button.layer.cornerRadius = 2;
    self.zhuxiaochouma_button.titleLabel.numberOfLines = 2;
    self.zhuxiaochouma_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.zhuxiaochouma_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.zhuxiaochouma_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.zhuxiaochouma_button setImage:[UIImage imageNamed:@"operationCenter_dasaiChip"] forState:UIControlStateNormal];
    [self.zhuxiaochouma_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_leftBtn_bg"] forState:UIControlStateNormal];
    self.zhuxiaochouma_button.tag = 1;
    [self.zhuxiaochouma_button addTarget:self action:@selector(publicBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.zhuxiaochouma_button];
    [self.zhuxiaochouma_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aTipRecordButton.mas_bottom).offset(22);
        make.left.equalTo(self.operateCenterView).offset(15);
        make.height.mas_equalTo(tapItem_height);
        make.width.mas_offset(160);
    }];

    self.readChip_button = [JXButton buttonWithType:UIButtonTypeCustom];
    self.readChip_button.layer.cornerRadius = 2;
    self.readChip_button.titleLabel.numberOfLines = 2;
    self.readChip_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.readChip_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.readChip_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.readChip_button setImage:[UIImage imageNamed:@"operationCenter_readChip_p"] forState:UIControlStateNormal];
    [self.readChip_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_leftBtn_bg"] forState:UIControlStateNormal];
    self.readChip_button.tag = 2;
    [self.readChip_button addTarget:self action:@selector(publicBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.readChip_button];
    [self.readChip_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuxiaochouma_button.mas_bottom).offset(22);
        make.left.equalTo(self.operateCenterView).offset(15);
        make.height.mas_equalTo(tapItem_height);
        make.width.mas_offset(160);
    }];
    
    [self showPublicBtnTitle];
}

- (void)showPublicBtnTitle{
    [self.aTipRecordButton setTitle:[NSString stringWithFormat:@"记录小费\nTip"] forState:UIControlStateNormal];
    [self.zhuxiaochouma_button setTitle:@"换钱\nChange money" forState:UIControlStateNormal];
    [self.readChip_button setTitle:@"筹码识别\nDetection chip" forState:UIControlStateNormal];
}

#pragma mark -- 龙虎
- (void)_setUpTigerView{
    self.dragon_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dragon_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.dragon_button.titleLabel.font = [UIFont systemFontOfSize:32];
    self.dragon_button.tag = 10;
    [self.dragon_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.dragon_button setImage:[UIImage imageNamed:@"operation_drogenIcon"] forState:UIControlStateNormal];
    [self.dragon_button setBackgroundImage:[UIImage imageNamed:@"longhu_unselectedIcon"] forState:UIControlStateNormal];
    [self.dragon_button setBackgroundImage:[UIImage imageNamed:@"drgon_selectedIcon"] forState:UIControlStateSelected];
    [self.operateCenterView addSubview:self.dragon_button];
    [self.dragon_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operateCenterView).offset(15);
        make.right.equalTo(self.operateCenterView).offset(-15);
        make.left.equalTo(self.aTipRecordButton.mas_right).offset(43);
        make.height.mas_equalTo(158);
    }];
    [self.btnList addObject:self.dragon_button];

    self.tiger_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tiger_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.tiger_button.titleLabel.font = [UIFont systemFontOfSize:32];
    self.tiger_button.tag = 11;
    [self.tiger_button setImage:[UIImage imageNamed:@"operation_tigerIcon"] forState:UIControlStateNormal];
    [self.tiger_button setBackgroundImage:[UIImage imageNamed:@"longhu_unselectedIcon"] forState:UIControlStateNormal];
    [self.tiger_button setBackgroundImage:[UIImage imageNamed:@"tiger_selectedIcon"] forState:UIControlStateSelected];
    [self.tiger_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.tiger_button];
    [self.tiger_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dragon_button.mas_bottom).offset(22);
        make.right.equalTo(self.operateCenterView).offset(-15);
        make.left.equalTo(self.aTipRecordButton.mas_right).offset(43);
        make.height.mas_equalTo(158);
    }];
    
    [self.btnList addObject:self.tiger_button];

    self.he_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.he_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.he_button.titleLabel.font = [UIFont systemFontOfSize:32];
    self.he_button.tag = 12;
    [self.he_button setBackgroundImage:[UIImage imageNamed:@"longhu_unselectedIcon"] forState:UIControlStateNormal];
    [self.he_button setBackgroundImage:[UIImage imageNamed:@"he_selectedIcon"] forState:UIControlStateSelected];
    [self.he_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.he_button];
    [self.he_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tiger_button.mas_bottom).offset(22);
        make.right.equalTo(self.operateCenterView).offset(-15);
        make.left.equalTo(self.aTipRecordButton.mas_right).offset(43);
        make.height.mas_equalTo(158);
    }];
    [self.btnList addObject:self.he_button];
    
    [self showBtnsTitleInfo];
}

- (void)showBtnsTitleInfo{
    [self.he_button setTitle:[NSString stringWithFormat:@"和  %@",[EPStr getStr:kEPTigerHe note:@"和"]] forState:UIControlStateNormal];
    if ([PublicHttpTool shareInstance].curGameType==1||[PublicHttpTool shareInstance].curGameType==2) {//百家乐
        [self.zhuang_button setTitle:[EPStr getStr:kEPZhuang note:@"庄"] forState:UIControlStateNormal];
        [self.xian_button setTitle:[EPStr getStr:kEPXian note:@"闲"] forState:UIControlStateNormal];
        [self.zhuangduizi_button setTitle:[EPStr getStr:kEPZhuangDuizi note:@"庄对子"] forState:UIControlStateNormal];
        [self.xianduizi_button setTitle:[EPStr getStr:kEPXianDuizi note:@"闲对子"] forState:UIControlStateNormal];
        [self.baoxian_button setTitle:[EPStr getStr:kEPBaoxian note:@"保险"] forState:UIControlStateNormal];
        [self.luckysix_button setTitle:[EPStr getStr:kEPSixWin note:@"幸运6点"] forState:UIControlStateNormal];
    }else if ([PublicHttpTool shareInstance].curGameType==3){//龙虎
        [self.dragon_button setTitle:[NSString stringWithFormat:@"龙  %@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
        [self.tiger_button setTitle:[NSString stringWithFormat:@"虎  %@",[EPStr getStr:kEPTiger note:@"虎"]] forState:UIControlStateNormal];
    }else {//牛牛,三公
        [self.superDouble_button setTitle:[EPStr getStr:kEPSuperDouble note:@"超级翻倍"] forState:UIControlStateNormal];
        [self.double_button setTitle:[EPStr getStr:kEPDouble note:@"翻倍"] forState:UIControlStateNormal];
        [self.flat_button setTitle:[EPStr getStr:kEPPingTimes note:@"平倍 Equal"] forState:UIControlStateNormal];
    }
}

#pragma mark -- 百家乐
- (void)_setUpBaccaratView{
    CGFloat item_fontsize = 21;
    CGFloat result_w = (kScreenWidth -230)/2;
    CGFloat result_h = 98;
    self.zhuang_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuang_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.zhuang_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    self.zhuang_button.tag = 10;
    [self.zhuang_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_lose_redIcon"] forState:UIControlStateSelected];
    [self.zhuang_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
    [self.zhuang_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.zhuang_button];
    [self.zhuang_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operateCenterView).offset(15);
        make.left.equalTo(self.aTipRecordButton.mas_right).offset(15);
        make.height.mas_equalTo(result_h);
        make.width.mas_offset(result_w);
    }];
    [self.btnList addObject:self.zhuang_button];
    
    self.xian_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xian_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.xian_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    self.xian_button.tag = 11;
    [self.xian_button setBackgroundImage:[UIImage imageNamed:@"tiger_selectedIcon"] forState:UIControlStateSelected];
    [self.xian_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
    [self.xian_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.xian_button];
    [self.xian_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operateCenterView).offset(15);
        make.right.equalTo(self.operateCenterView).offset(-10);
        make.height.mas_equalTo(result_h);
        make.width.mas_offset(result_w);
    }];
    [self.btnList addObject:self.xian_button];

    self.zhuangduizi_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangduizi_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.zhuangduizi_button.tag = 12;
    self.zhuangduizi_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.zhuangduizi_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_lose_redIcon"] forState:UIControlStateSelected];
    [self.zhuangduizi_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
    [self.zhuangduizi_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.zhuangduizi_button];
    [self.zhuangduizi_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuang_button.mas_bottom).offset(42);
        make.left.equalTo(self.aTipRecordButton.mas_right).offset(15);
        make.height.mas_equalTo(result_h);
        make.width.mas_offset(result_w);
    }];
    [self.btnList addObject:self.zhuangduizi_button];

    self.xianduizi_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianduizi_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.xianduizi_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    self.xianduizi_button.tag = 13;
    [self.xianduizi_button setBackgroundImage:[UIImage imageNamed:@"tiger_selectedIcon"] forState:UIControlStateSelected];
    [self.xianduizi_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
    [self.xianduizi_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.xianduizi_button];
    [self.xianduizi_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xian_button.mas_bottom).offset(42);
        make.right.equalTo(self.xian_button.mas_right).offset(0);
        make.height.mas_equalTo(result_h);
        make.width.mas_offset(result_w);
    }];
    [self.btnList addObject:self.xianduizi_button];

    self.he_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.he_button.tag = 14;
    [self.he_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.he_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.he_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_win_greenIcon"] forState:UIControlStateSelected];
    [self.he_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
    [self.he_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.he_button];
    [self.he_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangduizi_button.mas_bottom).offset(42);
        make.left.equalTo(self.aTipRecordButton.mas_right).offset(15);
        make.height.mas_equalTo(result_h);
        make.width.mas_offset(result_w);
    }];
    [self.btnList addObject:self.he_button];

    self.baoxian_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.baoxian_button.tag = 15;
    [self.baoxian_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.baoxian_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.baoxian_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_baoxian_greenIcon"] forState:UIControlStateSelected];
    [self.baoxian_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
    [self.baoxian_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.baoxian_button];
    [self.baoxian_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xianduizi_button.mas_bottom).offset(42);
        make.right.equalTo(self.xian_button.mas_right).offset(0);
        make.height.mas_equalTo(result_h);
        make.width.mas_offset(result_w);
    }];
    [self.btnList addObject:self.baoxian_button];

    self.luckysix_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.luckysix_button.tag = 16;
    [self.luckysix_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.luckysix_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.luckysix_button setBackgroundImage:[UIImage imageNamed:@"lucky_selecedIcon"] forState:UIControlStateSelected];
    [self.luckysix_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
    [self.luckysix_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.luckysix_button];
    [self.luckysix_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.he_button.mas_bottom).offset(42);
        make.left.equalTo(self.aTipRecordButton.mas_right).offset(15);
        make.right.equalTo(self.xian_button.mas_right).offset(0);
        make.height.mas_equalTo(result_h);
    }];
    [self.btnList addObject:self.luckysix_button];
    
    [self showBtnsTitleInfo];
}

#pragma mark -- 牛牛
- (void)_setUpCowView{
    CGFloat result_h = 158;
    CGFloat result_double_w = kScreenWidth-200-41;
    CGFloat item_fontsize = 21;
    self.superDouble_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.superDouble_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.superDouble_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.superDouble_button setBackgroundImage:[UIImage imageNamed:@"cow_superDouble_selectedIcon"] forState:UIControlStateSelected];
    [self.superDouble_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
    self.superDouble_button.tag  =10;
    [self.superDouble_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateCenterView addSubview:self.superDouble_button];
    [self.superDouble_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operateCenterView).offset(15);
        make.left.equalTo(self.aTipRecordButton.mas_right).offset(31);
        make.height.mas_equalTo(result_h);
        make.width.mas_offset(result_double_w);
    }];
    [self.btnList addObject:self.superDouble_button];

    self.double_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.double_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.double_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.double_button setBackgroundImage:[UIImage imageNamed:@"cow_win_selectedIcon"] forState:UIControlStateSelected];
    [self.double_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
    [self.double_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.double_button.tag  =11;
    [self.operateCenterView addSubview:self.double_button];
    [self.double_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.superDouble_button.mas_bottom).offset(22);
        make.left.equalTo(self.aTipRecordButton.mas_right).offset(31);
        make.height.mas_equalTo(result_h);
        make.width.mas_offset(result_double_w);
    }];
    [self.btnList addObject:self.double_button];

    self.flat_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flat_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.flat_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.flat_button setBackgroundImage:[UIImage imageNamed:@"tiger_selectedIcon"] forState:UIControlStateSelected];
    [self.flat_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
    [self.flat_button addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.flat_button.tag  =12;
    [self.operateCenterView addSubview:self.flat_button];
    [self.flat_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.double_button.mas_bottom).offset(22);
        make.left.equalTo(self.aTipRecordButton.mas_right).offset(31);
        make.height.mas_equalTo(result_h);
        make.width.mas_offset(result_double_w);
    }];
    [self.btnList addObject:self.flat_button];
    
    [self showBtnsTitleInfo];
}

- (void)publicBtnAction:(UIButton *)btn{
    if ([PublicHttpTool socketNoConnectedShow]) {
        [[PublicHttpTool shareInstance] clearAllCheckConditions];
        if (self.operationBtnBlock) {
            self.operationBtnBlock(btn.tag, [PublicHttpTool shareInstance].curGameType);
        }
    }
}

- (void)operationBtnAction:(UIButton *)btn{
    if ([PublicHttpTool socketNoConnectedShow]) {
        if ([PublicHttpTool commitKaipaiResult]) {
            [[PublicHttpTool shareInstance] clearAllCheckConditions];
            for (int j=0; j<self.btnList.count; j++) {
                if (btn.tag == 10+j) {
                    btn.selected = YES;
                    NSString *operation_title = btn.titleLabel.text;
                    NSString *winOrLoseStatus =  [[operation_title componentsSeparatedByString:@" "]firstObject];
                    [PublicHttpTool shareInstance].curupdateInfo.cp_Result_name = [NSString stringWithFormat:@"%@",winOrLoseStatus];
                    if (self.operationBtnBlock) {
                        self.operationBtnBlock(btn.tag, [PublicHttpTool shareInstance].curGameType);
                    }
                    continue;
                }
                UIButton *but = (UIButton *)[self viewWithTag:10+j];
                but.selected = NO;
            }
        }
    }
}

#pragma mark -- 重置按钮状态
- (void)_resetBtnStatus{
    for (int j=0; j<self.btnList.count; j++) {
        UIButton *but = (UIButton *)[self viewWithTag:10+j];
        but.selected = NO;
    }
}

@end
