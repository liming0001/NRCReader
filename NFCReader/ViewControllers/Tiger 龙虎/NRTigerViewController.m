//
//  NRBaccaratViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRTigerViewController.h"
#import "EPPopAlertShowView.h"
#import "NRCustomerInfo.h"
#import "EPPopView.h"
#import "JXButton.h"
#import "EPService.h"
#import "NRLoginInfo.h"
#import "NRTigerViewModel.h"
#import "NRChipResultInfo.h"
#import "NRTableInfo.h"
#import "NRGameInfo.h"
#import "NRUpdateInfo.h"
#import "EPTigerShowView.h"
#import "EPPopAtipInfoView.h"
#import "EPTigerResultShowView.h"
#import "EPAppData.h"

#import "JhPageItemView.h"
#import "JhPageItemModel.h"
#import "NFPopupContainView.h"
#import "NFPopupTextContainView.h"

#import "GCDAsyncSocket.h"
#import "BLEIToll.h"
#import "SFLabel.h"
#import "ManualManagerTigerView.h"
#import "IQKeyboardManager.h"

#import "TableDataInfoView.h"
#import "EmpowerView.h"
#import "ModificationResultsView.h"
#import "TableJiaJiancaiView.h"

#import "EPKillShowView.h"
#import "EPPayShowView.h"

#import "EPWebViewController.h"

@interface NRTigerViewController ()<GCDAsyncSocketDelegate>

//台桌数据
@property (nonatomic, strong) TableDataInfoView *tableDataInfoV;

//授权验证
@property (nonatomic, strong) EmpowerView *empowerView;

//修改露珠
@property (nonatomic, strong) ModificationResultsView *modifyResultsView;

//加减彩
@property (nonatomic, strong) TableJiaJiancaiView *addOrMinusView;
//
//顶部选项卡
@property (nonatomic, strong) UIImageView *topBarImageV;
@property (nonatomic, strong) UIButton *moreOptionButton;
@property (nonatomic, strong) UIImageView *optionArrowImg;
@property (nonatomic, strong) UIButton *changexueci_button;
@property (nonatomic, strong) UIButton *updateLuzhu_button;
@property (nonatomic, strong) UIButton *daily_button;
@property (nonatomic, strong) UIButton *nextGame_button;
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, strong) NSString *resultNameString;
//更多选项
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIButton *changeChipBtn;
@property (nonatomic, strong) UIButton *changeLanguageBtn;
@property (nonatomic, strong) UIButton *huanbanBtn;
@property (nonatomic, strong) UIButton *changeTableBtn;
@property (nonatomic, strong) UIButton *queryNoteBtn;
@property (nonatomic, strong) UIButton *queryTableInfoBtn;
@property (nonatomic, strong) UIButton *dianmaBtn;
@property (nonatomic, strong) UIButton *jiaCaiBtn;
@property (nonatomic, strong) UIButton *openTableBtn;

//自动版视图
@property (nonatomic, strong) UIView *automaticShowView;
@property (nonatomic, strong) JXButton *zhuxiaochouma_button;
@property (nonatomic, strong) JXButton *aTipRecordButton;//小费按钮

//杀注界面
@property (nonatomic, strong) EPKillShowView *killShowView;
//赔付界面
@property (nonatomic, strong) EPPayShowView *payShowView;

//露珠信息
@property (nonatomic, strong) UIImageView *luzhuImgV;
@property (nonatomic, strong) UILabel *luzhuInfoLab;
@property (nonatomic, strong) UIView *luzhuCollectionView;
/** item数组 */
@property (nonatomic, strong) JhPageItemView *solidItemView;

//结算台
@property (nonatomic, strong) UIImageView *settlementImgV;
@property (nonatomic, strong) UILabel *settlementLab;
@property (nonatomic, strong) UIView *settlementV;
@property (nonatomic, strong) UIButton *dragonBtn;
@property (nonatomic, strong) UIButton *tigerBtn;
@property (nonatomic, strong) UIButton *heBtn;
@property (nonatomic, strong) UIButton *setmentOKBtn;
@property (nonatomic, strong) NSString *result_string;
//台桌信息
@property (nonatomic, strong) UIImageView *tableInfoImgV;
@property (nonatomic, strong) UILabel *tableInfoLab;
@property (nonatomic, strong) UIView *tableInfoV;
@property (nonatomic, strong) SFLabel *stableIDLab;
@property (nonatomic, strong) UILabel *xueciLab;
@property (nonatomic, strong) UILabel *puciLab;
@property (nonatomic, strong) UIView *dragonBorderV;
@property (nonatomic, strong) UIButton *dragonInfoBtn;
@property (nonatomic, strong) UILabel *dragonInfoLab;
@property (nonatomic, strong) UIView *tigerBorderV;
@property (nonatomic, strong) UIButton *tigerInfoBtn;
@property (nonatomic, strong) UILabel *tigerInfoLab;
@property (nonatomic, strong) UIView *heBorderV;
@property (nonatomic, strong) UIButton *heInfoBtn;
@property (nonatomic, strong) UILabel *heInfoLab;
@property (nonatomic, assign) int xueciCount;//靴次
@property (nonatomic, assign) int puciCount;//铺次
@property (nonatomic, assign) int prePuciCount;
//赢
@property (nonatomic, assign) BOOL winOrLose;
//输
@property (nonatomic, strong) UIButton *dragon_button;
@property (nonatomic, strong) UIButton *tiger_button;
@property (nonatomic, strong) UIButton *he_button;
@property (nonatomic, strong) NRCustomerInfo *customerInfo;
@property (nonatomic, strong) NSMutableArray *BLEUIDDataList;
@property (nonatomic, strong) NSMutableArray *BLEDataList;
@property (nonatomic, assign) NSInteger chipCount;
@property (nonatomic, strong) NSArray *chipUIDList;
@property (nonatomic, strong) NRChipInfoModel *curChipInfo;
@property (nonatomic, strong) NSMutableArray *BLEUIDDataHasPayList;//
@property (nonatomic, strong) NSMutableArray *BLEDataHasPayList;//
@property (nonatomic, assign) NSInteger payChipCount;
@property (nonatomic, strong) NSArray *payChipUIDList;
@property (nonatomic, assign) BOOL isShowingResult;//是否展示结果
@property (nonatomic, strong) NSMutableArray *BLEUIDDataTipList;//
@property (nonatomic, strong) NSMutableArray *BLEDataTipList;//
@property (nonatomic, assign) NSInteger tipChipCount;
@property (nonatomic, strong) NSArray *tipChipUIDList;
@property (nonatomic, assign) BOOL isRecordTipMoney;//是否记录小费
@property (nonatomic, strong) NRChipResultInfo *resultInfo;
@property (nonatomic, assign) BOOL hasChipRead;//是否有可用筹码被识别
@property (nonatomic, strong) NSString *serialnumber;//流水号
@property (nonatomic, assign) CGFloat odds;//倍数
@property (nonatomic, assign) CGFloat yj;//佣金
@property (nonatomic, assign) BOOL hasPayMoneyShow;//是否已经显示找回
@property (nonatomic, strong) EPPopAlertShowView *resultShowView;
@property (nonatomic, strong) EPPopAtipInfoView *recordTipShowView;//识别小费
@property (nonatomic, assign) CGFloat zhaohuiMoney;//找回筹码金额
@property (nonatomic, assign) CGFloat benjinMoney;//找回筹码金额
@property (nonatomic, assign) int resultInt;//结果

//操作中心
@property (nonatomic, strong) UIImageView *operateCenterImgV;
@property (nonatomic, strong) UILabel *operateCenterLabel;
@property (nonatomic, strong) UIView *operateCenterView;

// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSMutableData *chipUIDData;
@property (nonatomic, assign) BOOL isResultAction;//是否

@property (nonatomic, strong) ManualManagerTigerView *manuaManagerView;
@property (nonatomic, assign) BOOL isAutomicGame;//是否手动版

@end

@implementation NRTigerViewController

#pragma mark - 设置顶部top
- (void)topBarSetUp{
    UIImageView *bgImg = [UIImageView new];
    bgImg.image = [UIImage imageNamed:@"NRbg"];
    [self.view addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverBtn];
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
    
    self.topBarImageV = [UIImageView new];
    self.topBarImageV.image = [UIImage imageNamed:@"bar_bg"];
    [self.view addSubview:self.topBarImageV];
    [self.topBarImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    CGFloat button_w = (kScreenWidth -20)/5;
    self.moreOptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreOptionButton.titleLabel.numberOfLines = 2;
    self.moreOptionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.moreOptionButton setBackgroundImage:[UIImage imageNamed:@"topMenu_selBtn"] forState:UIControlStateSelected];
    [self.moreOptionButton setTitleColor:[UIColor colorWithHexString:@"#274560"] forState:UIControlStateSelected];
    [self.moreOptionButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.moreOptionButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.moreOptionButton addTarget:self action:@selector(moreOptionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.moreOptionButton];
    [self.moreOptionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.height.mas_equalTo(55);
        make.width.mas_offset(button_w);
    }];
    
    self.optionArrowImg = [UIImageView new];
    self.optionArrowImg.image = [UIImage imageNamed:@"moreOptionsArrow"];
    [self.moreOptionButton addSubview:self.optionArrowImg];
    [self.optionArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moreOptionButton).offset(0);
        make.right.equalTo(self.moreOptionButton.mas_right).offset(-10);
        make.height.mas_equalTo(11);
        make.width.mas_equalTo(15);
    }];
    
    self.changexueci_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changexueci_button.titleLabel.numberOfLines = 2;
    self.changexueci_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.changexueci_button setBackgroundImage:[UIImage imageNamed:@"topMenu_selBtn"] forState:UIControlStateSelected];
    [self.changexueci_button setTitleColor:[UIColor colorWithHexString:@"#274560"] forState:UIControlStateSelected];
    [self.changexueci_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.changexueci_button.titleLabel.font = [UIFont systemFontOfSize:16];
    self.changexueci_button.tag = 1;
    [self.changexueci_button addTarget:self action:@selector(topBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changexueci_button];
    [self.changexueci_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.moreOptionButton.mas_right).offset(0);
        make.height.mas_equalTo(55);
        make.width.mas_offset(button_w);
    }];
    
    self.updateLuzhu_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.updateLuzhu_button.titleLabel.numberOfLines = 2;
    self.updateLuzhu_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.updateLuzhu_button setBackgroundImage:[UIImage imageNamed:@"topMenu_selBtn"] forState:UIControlStateSelected];
    [self.updateLuzhu_button setTitleColor:[UIColor colorWithHexString:@"#274560"] forState:UIControlStateSelected];
    [self.updateLuzhu_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.updateLuzhu_button.titleLabel.font = [UIFont systemFontOfSize:16];
    self.updateLuzhu_button.tag = 2;
    [self.updateLuzhu_button addTarget:self action:@selector(topBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.updateLuzhu_button];
    [self.updateLuzhu_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.changexueci_button.mas_right).offset(0);
        make.height.mas_equalTo(55);
        make.width.mas_offset(button_w);
    }];
    
    self.daily_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.daily_button.titleLabel.numberOfLines = 2;
    self.daily_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.daily_button setBackgroundImage:[UIImage imageNamed:@"topMenu_selBtn"] forState:UIControlStateSelected];
    [self.daily_button setTitleColor:[UIColor colorWithHexString:@"#274560"] forState:UIControlStateSelected];
    [self.daily_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.daily_button.titleLabel.font = [UIFont systemFontOfSize:16];
    self.daily_button.tag = 3;
    [self.daily_button addTarget:self action:@selector(topBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.daily_button];
    [self.daily_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.updateLuzhu_button.mas_right).offset(0);
        make.height.mas_equalTo(55);
        make.width.mas_offset(button_w);
    }];
    
    self.nextGame_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextGame_button.titleLabel.numberOfLines = 2;
    self.nextGame_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.nextGame_button setBackgroundImage:[UIImage imageNamed:@"topMenu_selBtn"] forState:UIControlStateSelected];
    [self.nextGame_button setTitleColor:[UIColor colorWithHexString:@"#274560"] forState:UIControlStateSelected];
    [self.nextGame_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.nextGame_button.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.nextGame_button.tag = 4;
    [self.nextGame_button addTarget:self action:@selector(topBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextGame_button];
    [self.nextGame_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.daily_button.mas_right).offset(0);
        make.height.mas_equalTo(55);
        make.width.mas_offset(button_w);
    }];
}

- (UIView *)menuView{
    if (!_menuView) {
        CGFloat button_w = (kScreenWidth -20)/5;
        _menuView = [[UIView alloc]initWithFrame:CGRectMake(10, 75, button_w-10, 0)];
        _menuView.backgroundColor = [UIColor colorWithRed:102/255.0 green:111/255.0 blue:121/255.0 alpha:0.9];
        
        self.changeChipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.changeChipBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.changeChipBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.changeChipBtn setTitle:@"切换手动版" forState:UIControlStateNormal];
        self.changeChipBtn.tag = 1;
        [self.changeChipBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.changeChipBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.changeChipBtn];
        [self.changeChipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menuView).offset(5);
            make.left.equalTo(self.menuView).offset(5);
            make.centerX.equalTo(self.menuView);
            make.height.mas_equalTo(30);
        }];
        
        UIView *lineV1 = [UIView new];
        lineV1.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
        lineV1.alpha = 0.8;
        [self.changeChipBtn addSubview:lineV1];
        [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.changeChipBtn).offset(0);
            make.left.equalTo(self.changeChipBtn).offset(5);
            make.centerX.equalTo(self.changeChipBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.changeLanguageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.changeLanguageBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.changeLanguageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.changeLanguageBtn setTitle:@"切换柬文界面" forState:UIControlStateNormal];
        self.changeLanguageBtn.tag = 2;
        [self.changeLanguageBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.changeLanguageBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.changeLanguageBtn];
        [self.changeLanguageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.changeChipBtn.mas_bottom).offset(5);
            make.left.equalTo(self.menuView).offset(5);
            make.centerX.equalTo(self.menuView);
            make.height.mas_equalTo(30);
        }];
        
        UIView *lineV2 = [UIView new];
        lineV2.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
        lineV2.alpha = 0.8;
        [self.changeLanguageBtn addSubview:lineV2];
        [lineV2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.changeLanguageBtn).offset(0);
            make.left.equalTo(self.changeLanguageBtn).offset(5);
            make.centerX.equalTo(self.changeLanguageBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.huanbanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.huanbanBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.huanbanBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.huanbanBtn setTitle:@"换班" forState:UIControlStateNormal];
        self.huanbanBtn.tag = 3;
        [self.huanbanBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.huanbanBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.huanbanBtn];
        [self.huanbanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.changeLanguageBtn.mas_bottom).offset(5);
            make.left.equalTo(self.menuView).offset(5);
            make.centerX.equalTo(self.menuView);
            make.height.mas_equalTo(30);
        }];
        
        UIView *lineV3 = [UIView new];
        lineV3.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
        lineV3.alpha = 0.8;
        [self.huanbanBtn addSubview:lineV3];
        [lineV3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.huanbanBtn).offset(0);
            make.left.equalTo(self.huanbanBtn).offset(5);
            make.centerX.equalTo(self.huanbanBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.changeTableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.changeTableBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.changeTableBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.changeTableBtn setTitle:@"换桌" forState:UIControlStateNormal];
        self.changeTableBtn.tag = 4;
        [self.changeTableBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.changeTableBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.changeTableBtn];
        [self.changeTableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.huanbanBtn.mas_bottom).offset(5);
            make.left.equalTo(self.menuView).offset(5);
            make.centerX.equalTo(self.menuView);
            make.height.mas_equalTo(30);
        }];
        
        UIView *lineV4 = [UIView new];
        lineV4.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
        lineV4.alpha = 0.8;
        [self.changeTableBtn addSubview:lineV4];
        [lineV4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.changeTableBtn).offset(0);
            make.left.equalTo(self.changeTableBtn).offset(5);
            make.centerX.equalTo(self.changeTableBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.queryNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.queryNoteBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.queryNoteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.queryNoteBtn setTitle:@"查看注单" forState:UIControlStateNormal];
        self.queryNoteBtn.tag = 5;
        [self.queryNoteBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.queryNoteBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.queryNoteBtn];
        [self.queryNoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.changeTableBtn.mas_bottom).offset(5);
            make.left.equalTo(self.menuView).offset(5);
            make.centerX.equalTo(self.menuView);
            make.height.mas_equalTo(30);
        }];
        
        UIView *lineV5 = [UIView new];
        lineV5.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
        lineV5.alpha = 0.8;
        [self.queryNoteBtn addSubview:lineV5];
        [lineV5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.queryNoteBtn).offset(0);
            make.left.equalTo(self.queryNoteBtn).offset(5);
            make.centerX.equalTo(self.queryNoteBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.queryTableInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.queryTableInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.queryTableInfoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.queryTableInfoBtn setTitle:@"查看台面数据" forState:UIControlStateNormal];
        self.queryTableInfoBtn.tag = 6;
        [self.queryTableInfoBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.queryTableInfoBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.queryTableInfoBtn];
        [self.queryTableInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.queryNoteBtn.mas_bottom).offset(5);
            make.left.equalTo(self.menuView).offset(5);
            make.centerX.equalTo(self.menuView);
            make.height.mas_equalTo(30);
        }];
        
        UIView *lineV6 = [UIView new];
        lineV6.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
        lineV6.alpha = 0.8;
        [self.queryTableInfoBtn addSubview:lineV6];
        [lineV6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.queryTableInfoBtn).offset(0);
            make.left.equalTo(self.queryTableInfoBtn).offset(5);
            make.centerX.equalTo(self.queryTableInfoBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.dianmaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dianmaBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.dianmaBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.dianmaBtn setTitle:@"点码" forState:UIControlStateNormal];
        self.dianmaBtn.tag = 7;
        [self.dianmaBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.dianmaBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.dianmaBtn];
        [self.dianmaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.queryTableInfoBtn.mas_bottom).offset(5);
            make.left.equalTo(self.menuView).offset(5);
            make.centerX.equalTo(self.menuView);
            make.height.mas_equalTo(30);
        }];
        
        UIView *lineV7 = [UIView new];
        lineV7.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
        lineV7.alpha = 0.8;
        [self.dianmaBtn addSubview:lineV7];
        [lineV7 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.dianmaBtn).offset(0);
            make.left.equalTo(self.dianmaBtn).offset(5);
            make.centerX.equalTo(self.dianmaBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.jiaCaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.jiaCaiBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.jiaCaiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.jiaCaiBtn setTitle:@"台面加减彩" forState:UIControlStateNormal];
        self.jiaCaiBtn.tag = 8;
        [self.jiaCaiBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.jiaCaiBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.jiaCaiBtn];
        [self.jiaCaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dianmaBtn.mas_bottom).offset(5);
            make.left.equalTo(self.menuView).offset(5);
            make.centerX.equalTo(self.menuView);
            make.height.mas_equalTo(30);
        }];
        
        UIView *lineV8 = [UIView new];
        lineV8.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
        lineV8.alpha = 0.8;
        [self.jiaCaiBtn addSubview:lineV8];
        [lineV8 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.jiaCaiBtn).offset(0);
            make.left.equalTo(self.jiaCaiBtn).offset(5);
            make.centerX.equalTo(self.jiaCaiBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.openTableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.openTableBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.openTableBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.openTableBtn setTitle:@"开台和收台" forState:UIControlStateNormal];
        self.openTableBtn.tag = 9;
        [self.openTableBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.openTableBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.openTableBtn];
        [self.openTableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.jiaCaiBtn.mas_bottom).offset(5);
            make.left.equalTo(self.menuView).offset(5);
            make.centerX.equalTo(self.menuView);
            make.height.mas_equalTo(30);
        }];
        
        [self hideOrShowMenuButton:YES];
    }
    return _menuView;
}

- (UIButton *)coverBtn{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _coverBtn.hidden = YES;
        [_coverBtn addTarget:self action:@selector(coverAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}

#pragma mark - 自动版视图
- (UIView *)automaticShowView{
    if (!_automaticShowView) {
        _automaticShowView = [[UIView alloc]initWithFrame:CGRectMake(0, 84, kScreenWidth, kScreenHeight-84)];
        _automaticShowView.backgroundColor = [UIColor clearColor];
        
        [self _setup];
        
        //操作中心
        self.operateCenterImgV = [UIImageView new];
        self.operateCenterImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
        [self.automaticShowView addSubview:self.operateCenterImgV];
        [self.operateCenterImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.luzhuCollectionView.mas_bottom).offset(20);
            make.left.equalTo(self.automaticShowView).offset(10);
            make.height.mas_equalTo(30);
            make.centerX.equalTo(self.automaticShowView);
        }];
        
        self.operateCenterLabel = [UILabel new];
        self.operateCenterLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.operateCenterLabel.font = [UIFont systemFontOfSize:15];
        self.operateCenterLabel.text = @"操作中心Dew information";
        [self.automaticShowView addSubview:self.operateCenterLabel];
        [self.operateCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.luzhuCollectionView.mas_bottom).offset(20);
            make.left.equalTo(self.automaticShowView).offset(20);
            make.height.mas_equalTo(30);
            make.centerX.equalTo(self.automaticShowView);
        }];
        
        self.operateCenterView = [UIView new];
        self.operateCenterView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        [self.automaticShowView addSubview:self.operateCenterView];
        [self.operateCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.operateCenterImgV.mas_bottom).offset(0);
            make.left.equalTo(self.operateCenterImgV).offset(0);
            make.bottom.equalTo(self.automaticShowView);
            make.centerX.equalTo(self.automaticShowView);
        }];
        
        CGFloat tapItem_height = 158;
        CGFloat item_fontsize = 21;
        self.aTipRecordButton = [JXButton buttonWithType:UIButtonTypeCustom];
        self.aTipRecordButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.aTipRecordButton.titleLabel.numberOfLines = 0;
        [self.aTipRecordButton setImage:[UIImage imageNamed:@"operationCenter_tipFee_p"] forState:UIControlStateNormal];
        [self.aTipRecordButton setBackgroundImage:[UIImage imageNamed:@"operationCenter_leftBtn_bg"] forState:UIControlStateNormal];
        self.aTipRecordButton.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        [self.aTipRecordButton addTarget:self action:@selector(recordTipMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
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
        [self.zhuxiaochouma_button addTarget:self action:@selector(zhuxiaoAction) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.zhuxiaochouma_button];
        [self.zhuxiaochouma_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.aTipRecordButton.mas_bottom).offset(44+tapItem_height);
            make.left.equalTo(self.operateCenterView).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(160);
        }];
        
        self.dragon_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dragon_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.dragon_button.titleLabel.font = [UIFont systemFontOfSize:32];
        [self.dragon_button addTarget:self action:@selector(dragonAction) forControlEvents:UIControlEventTouchUpInside];
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

        self.tiger_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tiger_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.tiger_button.titleLabel.font = [UIFont systemFontOfSize:32];
        [self.tiger_button setImage:[UIImage imageNamed:@"operation_tigerIcon"] forState:UIControlStateNormal];
        [self.tiger_button setBackgroundImage:[UIImage imageNamed:@"longhu_unselectedIcon"] forState:UIControlStateNormal];
        [self.tiger_button setBackgroundImage:[UIImage imageNamed:@"tiger_selectedIcon"] forState:UIControlStateSelected];
        [self.tiger_button addTarget:self action:@selector(tigerAction) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.tiger_button];
        [self.tiger_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dragon_button.mas_bottom).offset(22);
            make.right.equalTo(self.operateCenterView).offset(-15);
            make.left.equalTo(self.aTipRecordButton.mas_right).offset(43);
            make.height.mas_equalTo(158);
        }];

        self.he_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.he_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.he_button.titleLabel.font = [UIFont systemFontOfSize:32];
        [self.he_button setBackgroundImage:[UIImage imageNamed:@"longhu_unselectedIcon"] forState:UIControlStateNormal];
        [self.he_button setBackgroundImage:[UIImage imageNamed:@"he_selectedIcon"] forState:UIControlStateSelected];
        [self.he_button addTarget:self action:@selector(heAction) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.he_button];
        [self.he_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tiger_button.mas_bottom).offset(22);
            make.right.equalTo(self.operateCenterView).offset(-15);
            make.left.equalTo(self.aTipRecordButton.mas_right).offset(43);
            make.height.mas_equalTo(158);
        }];
    }
    return _automaticShowView;
}

- (void)_setup{
    //结算台
    self.settlementImgV = [UIImageView new];
    self.settlementImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self.automaticShowView addSubview:self.settlementImgV];
    [self.settlementImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.automaticShowView).offset(20);
        make.right.equalTo(self.automaticShowView).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_offset(249);
    }];
    
    self.settlementLab = [UILabel new];
    self.settlementLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.settlementLab.font = [UIFont systemFontOfSize:12];
    self.settlementLab.textAlignment = NSTextAlignmentCenter;
    self.settlementLab.text = @"结算台Settlement Desk";
    [self.automaticShowView addSubview:self.settlementLab];
    [self.settlementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_top).offset(3);
        make.left.equalTo(self.settlementImgV.mas_left).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_offset(249);
    }];
    
    self.settlementV = [UIView new];
    self.settlementV.layer.cornerRadius = 2;
    self.settlementV.backgroundColor = [UIColor colorWithHexString:@"#3e565d"];
    [self.automaticShowView addSubview:self.settlementV];
    [self.settlementV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_bottom).offset(0);
        make.right.equalTo(self.automaticShowView).offset(-10);
        make.height.mas_equalTo(232);
        make.width.mas_offset(249);
    }];
    
    CGFloat setBtn_w = 249-42*2;
    CGFloat setBtn_h = 35;
    self.dragonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dragonBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.dragonBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.dragonBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.dragonBtn.tag = 1;
    [self.dragonBtn setImage:[UIImage imageNamed:@"结算台-龙ICON-未选中"] forState:UIControlStateNormal];
    [self.dragonBtn setImage:[UIImage imageNamed:@"结算台-龙ICON-选中"] forState:UIControlStateSelected];
    [self.dragonBtn setBackgroundImage:[UIImage imageNamed:@"结算台-龙虎和-未选中底色"] forState:UIControlStateNormal];
    [self.dragonBtn setBackgroundImage:[UIImage imageNamed:@"结算台-龙-已选中底色"] forState:UIControlStateSelected];
    [self.dragonBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.dragonBtn];
    [self.dragonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(20);
        make.centerX.equalTo(self.settlementV).offset(0);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.tigerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tigerBtn setTitleColor:[UIColor colorWithHexString:@"#1d3edd"] forState:UIControlStateNormal];
    [self.tigerBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.tigerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.tigerBtn.tag = 2;
    [self.tigerBtn setImage:[UIImage imageNamed:@"结算台-虎ICON-未选中"] forState:UIControlStateNormal];
    [self.tigerBtn setImage:[UIImage imageNamed:@"结算台-虎ICON-选中"] forState:UIControlStateSelected];
    [self.tigerBtn setBackgroundImage:[UIImage imageNamed:@"结算台-龙虎和-未选中底色"] forState:UIControlStateNormal];
    [self.tigerBtn setBackgroundImage:[UIImage imageNamed:@"结算台-虎-已选中底色"] forState:UIControlStateSelected];
    [self.tigerBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.tigerBtn];
    [self.tigerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dragonBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.settlementV).offset(0);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.heBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#75e65c"] forState:UIControlStateNormal];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.heBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.heBtn.tag = 3;
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"结算台-龙虎和-未选中底色"] forState:UIControlStateNormal];
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"结算台-和-已选中底色"] forState:UIControlStateSelected];
    [self.heBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.heBtn];
    [self.heBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tigerBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.settlementV).offset(0);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.setmentOKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setmentOKBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.setmentOKBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.setmentOKBtn setTitle:@"OK.录入开牌结果" forState:UIControlStateNormal];
    [self.setmentOKBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateNormal];
    [self.setmentOKBtn addTarget:self action:@selector(resultEntryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.setmentOKBtn];
    [self.setmentOKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heBtn.mas_bottom).offset(23);
        make.left.equalTo(self.settlementV).offset(10);
        make.centerX.equalTo(self.settlementV);
        make.height.mas_equalTo(41);
    }];
    
    //台桌信息
    self.tableInfoImgV = [UIImageView new];
    self.tableInfoImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self.automaticShowView addSubview:self.self.tableInfoImgV];
    [self.tableInfoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.automaticShowView).offset(20);
        make.right.equalTo(self.settlementV.mas_left).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_offset(156);
    }];
    
    self.tableInfoLab = [UILabel new];
    self.tableInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tableInfoLab.font = [UIFont systemFontOfSize:12];
    self.tableInfoLab.text = @"台桌信息Table information";
    self.tableInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.automaticShowView addSubview:self.tableInfoLab];
    [self.tableInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoImgV.mas_top).offset(3);
        make.left.equalTo(self.tableInfoImgV.mas_left).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_offset(156);
    }];
    
    self.tableInfoV = [UIView new];
    self.tableInfoV.layer.cornerRadius = 2;
    self.tableInfoV.backgroundColor = [UIColor colorWithHexString:@"#3e565d"];
    [self.automaticShowView addSubview:self.tableInfoV];
    [self.tableInfoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoImgV.mas_bottom).offset(0);
        make.left.equalTo(self.tableInfoImgV.mas_left).offset(0);
        make.height.mas_equalTo(232);
        make.width.mas_offset(156);
    }];
    
    self.stableIDLab = [SFLabel new];
    self.stableIDLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.stableIDLab.font = [UIFont systemFontOfSize:10];
    self.stableIDLab.text = [NSString stringWithFormat:@"台桌ID:%@",self.viewModel.curTableInfo.fid];
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
    self.xueciLab.text = @"靴次:1";
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
    [self.dragonInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-龙Dragonbg"] forState:UIControlStateNormal];
    [self.dragonInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-龙Dragonbg"] forState:UIControlStateHighlighted];
    [self.dragonBorderV addSubview:self.dragonInfoBtn];
    [self.dragonInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.dragonBorderV).offset(0);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(52);
    }];
    
    self.dragonInfoLab = [UILabel new];
    self.dragonInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.dragonInfoLab.font = [UIFont systemFontOfSize:12];
    self.dragonInfoLab.text = @"6";
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
    [self.tigerInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-虎_bg"] forState:UIControlStateNormal];
    [self.tigerInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-虎_bg"] forState:UIControlStateHighlighted];
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
    [self.heInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-和tie_bg"] forState:UIControlStateNormal];
    [self.heInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-和tie_bg"] forState:UIControlStateHighlighted];
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
    
    //露珠信息
    self.luzhuImgV = [UIImageView new];
    self.luzhuImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self.automaticShowView addSubview:self.self.luzhuImgV];
    [self.luzhuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.automaticShowView).offset(20);
        make.right.equalTo(self.tableInfoImgV.mas_left).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_offset(kScreenWidth-30-156-249);
    }];
    
    self.luzhuInfoLab = [UILabel new];
    self.luzhuInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.luzhuInfoLab.font = [UIFont systemFontOfSize:14];
    self.luzhuInfoLab.text = @"露珠信息Dew information";
    self.luzhuInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.automaticShowView addSubview:self.luzhuInfoLab];
    [self.luzhuInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luzhuImgV.mas_top).offset(3);
        make.left.equalTo(self.luzhuImgV.mas_left).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_offset(kScreenWidth-30-156-249);
    }];
    
    self.luzhuCollectionView = [UIView new];
    self.luzhuCollectionView.backgroundColor = [UIColor whiteColor];
    [self.automaticShowView addSubview:self.luzhuCollectionView];
    [self.luzhuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luzhuImgV.mas_bottom).offset(0);
        make.left.right.equalTo(self.luzhuImgV).offset(0);
        make.height.mas_equalTo(232);
    }];
    [self.luzhuCollectionView addSubview:self.solidItemView];
}

#pragma mark - 手动版视图
- (ManualManagerTigerView *)manuaManagerView{
    if (!_manuaManagerView) {
        _manuaManagerView = [[ManualManagerTigerView alloc]initWithFrame:CGRectMake(0, 94, kScreenWidth, kScreenHeight-94)];
        _manuaManagerView.hidden = YES;
    }
    return _manuaManagerView;
}

- (TableDataInfoView *)tableDataInfoV{
    if (!_tableDataInfoV) {
        _tableDataInfoV = [[[NSBundle mainBundle]loadNibNamed:@"TableDataInfoView" owner:nil options:nil]lastObject];
        _tableDataInfoV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _tableDataInfoV;
}

- (EmpowerView *)empowerView{
    if (!_empowerView) {
        _empowerView = [[[NSBundle mainBundle]loadNibNamed:@"EmpowerView" owner:nil options:nil]lastObject];
        _empowerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _empowerView;
}

- (EPKillShowView *)killShowView{
    if (!_killShowView) {
        _killShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPKillShowView" owner:nil options:nil]lastObject];
        _killShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _killShowView;
}

- (EPPayShowView *)payShowView{
    if (!_payShowView) {
        _payShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPPayShowView" owner:nil options:nil]lastObject];
        _payShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _payShowView;
}

- (ModificationResultsView *)modifyResultsView{
    if (!_modifyResultsView) {
        _modifyResultsView = [[[NSBundle mainBundle]loadNibNamed:@"ModificationResultsView" owner:nil options:nil]lastObject];
        _modifyResultsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [_modifyResultsView updateBottomViewBtnWithTag:YES];
    }
    return _modifyResultsView;
}

- (TableJiaJiancaiView *)addOrMinusView{
    if (!_addOrMinusView) {
        _addOrMinusView = [[TableJiaJiancaiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _addOrMinusView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self topBarSetUp];
    NSNumber *xueciNumber = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@_Xueci",self.viewModel.curTableInfo.fid]];
    if (xueciNumber.intValue!=0) {
        self.viewModel.curXueci = xueciNumber.intValue;
    }
    
    self.navigationController.navigationBar.hidden = YES;
    self.resultInt=99;
    self.xueciCount = 1;
    self.puciCount = 0;
    self.prePuciCount = 1;
    self.isAutomicGame = NO;
    self.chipUIDData = [NSMutableData data];
    self.BLEDataList = [NSMutableArray arrayWithCapacity:0];
    self.BLEUIDDataList = [NSMutableArray arrayWithCapacity:0];
    self.BLEUIDDataHasPayList = [NSMutableArray array];
    self.BLEDataHasPayList = [NSMutableArray array];
    self.BLEUIDDataTipList = [NSMutableArray array];
    self.BLEDataTipList = [NSMutableArray array];
    self.curChipInfo = [[NRChipInfoModel alloc]init];
    self.serialnumber = [NSString stringWithFormat:@"%ld",(long)[NRCommand getRandomNumber:100000 to:1000000]];
    self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
    self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    self.winOrLose = YES;
    self.hasChipRead = NO;
    self.hasPayMoneyShow = NO;
    self.customerInfo = [[NRCustomerInfo alloc]init];
    self.customerInfo.tipsTitle = [NSString stringWithFormat:@"提示信息\n%@",[EPStr getStr:kEPTipsInfo note:@"提示信息"]];
    self.customerInfo.tipsInfo = [NSString stringWithFormat:@"请认真核对以上信息，确认是否进行下一步操作\n%@",[EPStr getStr:kEPNextTips note:@"请认真核对以上信息，确认是否进行下一步操作"]];
    self.customerInfo.isWinOrLose = NO;
    self.resultInfo = [[NRChipResultInfo alloc]init];
    
    //默认显示自动版本视图
    [self.view addSubview:self.automaticShowView];
    [self.view addSubview:self.manuaManagerView];
    //传输参数
    [self.manuaManagerView transLoginInfoWithLoginID:self.viewModel.loginInfo.access_token
                                             TableID:self.viewModel.curTableInfo.fid
                                        Serialnumber:self.serialnumber
                                               Peilv:self.viewModel.gameInfo.xz_setting
                                           TableName:self.viewModel.curTableInfo.ftbname];
    
    [self changeLanguageWithType:NO];
    self.manuaManagerView.hidden = YES;
    self.automaticShowView.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.clientSocket disconnect];
    [IQKeyboardManager sharedManager].enable = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self connectToServer];
    [IQKeyboardManager sharedManager].enable = NO;
    [self lookLuzhuAction];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)restartChangeStatus{
    [self lookLuzhuAction];
    self.viewModel.dragonCount=0;//龙赢次数
    self.viewModel.tigerCount=0;//虎赢次数
    self.viewModel.heCount=0;//和赢次数
    self.dragonInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.dragonCount];
    self.tigerInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.tigerCount];
    self.heInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.heCount];
}

#pragma mark -顶部top事件
- (void)moreOptionAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.optionArrowImg.image = [UIImage imageNamed:@"moreOptionsArrow_p"];
        [UIView animateWithDuration:0.2 animations:^{
            [self hideOrShowMenuButton:NO];
            self.coverBtn.hidden = NO;
            self.menuView.height = 320;
        } completion:^(BOOL finished) {

        }];
    }else{
        self.optionArrowImg.image = [UIImage imageNamed:@"moreOptionsArrow"];
        [UIView animateWithDuration:0.2 animations:^{
            self.coverBtn.hidden = YES;
            self.menuView.height = 0;
        } completion:^(BOOL finished) {
            [self hideOrShowMenuButton:YES];
        }];
    }
    [self.changexueci_button setSelected:NO];
    [self.updateLuzhu_button setSelected:NO];
    [self.daily_button setSelected:NO];
    [self.nextGame_button setSelected:NO];
}

- (void)topBarAction:(UIButton *)btn{
    if (btn.tag==1) {//换靴
        [self.moreOptionButton setSelected:NO];
        [self.changexueci_button setSelected:YES];
        [self.updateLuzhu_button setSelected:NO];
        [self.daily_button setSelected:NO];
        [self.nextGame_button setSelected:NO];
        [self changexueciAction];
    }else if (btn.tag==2){//修改露珠
        [self.moreOptionButton setSelected:NO];
        [self.changexueci_button setSelected:NO];
        [self.updateLuzhu_button setSelected:YES];
        [self.daily_button setSelected:NO];
        [self.nextGame_button setSelected:NO];
        [self updateLuzhu];
    }else if (btn.tag==3){//日结
        [self.moreOptionButton setSelected:NO];
        [self.changexueci_button setSelected:NO];
        [self.updateLuzhu_button setSelected:NO];
        [self.daily_button setSelected:YES];
        [self.nextGame_button setSelected:NO];
        [self daliyAction];
    }else if (btn.tag==4){//新一局
        [self.moreOptionButton setSelected:NO];
        [self.changexueci_button setSelected:NO];
        [self.updateLuzhu_button setSelected:NO];
        [self.daily_button setSelected:NO];
        [self.nextGame_button setSelected:YES];
        [self newGameAction];
    }
}

#pragma mark - 左侧弹出视图事件
- (void)menuAction:(UIButton *)btn{
    [self coverAction];
    switch (btn.tag) {
        case 1:{
            if ([self.changeChipBtn.titleLabel.text isEqualToString:@"切换手动版"]) {
                [self.changeChipBtn setTitle:@"切换自动版" forState:UIControlStateNormal];
                self.manuaManagerView.hidden = NO;
                self.automaticShowView.hidden = YES;
                self.isAutomicGame = YES;
                [[MJPopTool sharedInstance]popView:self.manuaManagerView WithFatherView:self.view animated:YES];
            }else{
                self.isAutomicGame = NO;
                self.resultNameString = @"";
                [self.changeChipBtn setTitle:@"切换手动版" forState:UIControlStateNormal];
                self.manuaManagerView.hidden = YES;
                self.automaticShowView.hidden = NO;
                [[MJPopTool sharedInstance]popView:self.automaticShowView WithFatherView:self.view animated:YES];
            }
        }
            break;
        case 2:{
            if ([self.changeLanguageBtn.titleLabel.text isEqualToString:@"切换柬文界面"]) {
                [self.changeLanguageBtn setTitle:@"切换英文界面" forState:UIControlStateNormal];
                [self changeLanguageWithType:YES];
            }else{
                [self.changeLanguageBtn setTitle:@"切换柬文界面" forState:UIControlStateNormal];
                [self changeLanguageWithType:NO];
            }
        }
            break;
        case 3:{//换班
            [self changeIDAction];
        }
            break;
        case 4:{//换桌
            [self changeTableAction];
        }
            break;
        case 5://查看注单
        {
            EPWebViewController *webVC = [[EPWebViewController alloc]init];
            webVC.webTitle = @"查看注单";
            webVC.link = [NSString stringWithFormat:@"http://%@/admin/customerrec/all.html?access_token=%@&ftable_id=%@",kHTTPCookieDomain,self.viewModel.loginInfo.access_token,self.viewModel.curTableInfo.fid];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 6://查看台面数据
        {
            [self showWaitingView];
            [self.viewModel queryTableDataWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                [self hideWaitingView];
                if (success) {
                    [[MJPopTool sharedInstance] popView:self.tableDataInfoV animated:YES];
                    [self.tableDataInfoV fellTableInfoDataWithTableList:self.viewModel.tableDataDict];
                }else{
                    //响警告声音
                    NSString *messgae = [msg NullToBlankString];
                    if (messgae.length == 0) {
                        messgae = @"网络异常";
                    }
                    [self showMessage:messgae];
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                }
            }];
        }
            break;
        case 7://点码
            [self.addOrMinusView fellListWithType:1];
            [[MJPopTool sharedInstance] popView:self.addOrMinusView animated:YES];
            break;
        case 8://台面加减彩
        {
            [self showWaitingView];
            [self.viewModel queryOperate_listWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                [self hideWaitingView];
                if (success) {
                    [self.addOrMinusView fellViewDataWithLoginID:self.viewModel.loginInfo.access_token TableID:self.viewModel.curTableInfo.fid];
                    [self.addOrMinusView fellListWithType:0];
                    [[MJPopTool sharedInstance] popView:self.addOrMinusView animated:YES];
                }else{
                    //响警告声音
                    NSString *messgae = [msg NullToBlankString];
                    if (messgae.length == 0) {
                        messgae = @"网络异常";
                    }
                    [self showMessage:messgae];
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                }
            }];
        }
            break;
        case 9://开台和收台
            [self.addOrMinusView fellListWithType:2];
            [[MJPopTool sharedInstance] popView:self.addOrMinusView animated:YES];
            break;
        default:
            break;
    }
}

- (void)hideOrShowMenuButton:(BOOL)hide{
    self.changeChipBtn.hidden = hide;
    self.changeLanguageBtn.hidden = hide;
    self.huanbanBtn.hidden = hide;
    self.changeTableBtn.hidden = hide;
    self.queryNoteBtn.hidden = hide;
    self.queryTableInfoBtn.hidden = hide;
    self.jiaCaiBtn.hidden = hide;
    self.dianmaBtn.hidden = hide;
    self.openTableBtn.hidden = hide;
}

- (void)coverAction{
    self.optionArrowImg.image = [UIImage imageNamed:@"moreOptionsArrow"];
    [self.moreOptionButton setSelected:NO];
    [UIView animateWithDuration:0.2 animations:^{
        self.coverBtn.hidden = YES;
        self.menuView.height = 0;
    } completion:^(BOOL finished) {
        [self hideOrShowMenuButton:YES];
    }];
}

#pragma mark - 自动版事件
- (void)connectToServer{
    // 准备创建客户端socket
    NSError *error = nil;
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 开始连接服务器
   [self.clientSocket connectToHost:@"192.168.1.192" onPort:6000 viaInterface:nil withTimeout:-1 error:&error];
}

- (void)resultAction:(UIButton *)btn{
    if (self.puciCount != self.prePuciCount) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    if (self.result_string.length==0) {
        [[EPToast makeText:@"请选择开牌结果"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    if (btn.tag==1) {//龙
        [self.dragonBtn setSelected:YES];
        [self.tigerBtn setSelected:NO];
        [self.heBtn setSelected:NO];
        self.result_string = @"龙赢";
    }else if (btn.tag==2){//虎
        [self.dragonBtn setSelected:NO];
        [self.tigerBtn setSelected:YES];
        [self.heBtn setSelected:NO];
        self.result_string = @"虎赢";
    }else if (btn.tag==3){//和
        [self.dragonBtn setSelected:NO];
        [self.tigerBtn setSelected:NO];
        [self.heBtn setSelected:YES];
        self.result_string = @"和局";
    }
}

- (void)resultEntryAction:(UIButton *)btn{
    if (self.puciCount != self.prePuciCount) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    if (self.result_string.length==0) {
        [[EPToast makeText:@"请选择开牌结果"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    [self showWaitingView];
    [self entryResult];
}

#pragma mark - 设置硬盘工作模式
- (void)sendDeviceWorkModel{
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand setDeviceWorkModel] withTimeout:- 1 tag:0];
}

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    self.titleBar.hidden = YES;
    [self.titleBar setTitle:@"VM娱乐桌面跟踪系统"];
    [self setLeftItemForGoBack];
    self.titleBar.rightItem = nil;
    self.titleBar.leftItem = nil;
    self.titleBar.showBottomLine = NO;
}

//换班
- (void)changeIDAction{
    [EPSound playWithSoundName:@"click_sound"];
    [self showWaitingView];
    [self.viewModel otherTableWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self hideWaitingView];
        if (success) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSString *messgae = [msg NullToBlankString];
            if (messgae.length == 0) {
                messgae = @"网络异常";
            }
            [self showMessage:messgae];
        }
    }];
}

//换桌
- (void)changeTableAction{
    [EPSound playWithSoundName:@"click_sound"];
    [self showWaitingView];
    [self.viewModel otherTableWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self hideWaitingView];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *messgae = [msg NullToBlankString];
            if (messgae.length == 0) {
                messgae = @"网络异常";
            }
            [self showMessage:messgae];
        }
    }];
}

- (void)showInfoStatusWith:(BOOL)isWin{
    self.customerInfo.isWinOrLose = isWin;
}

#pragma mark - 还原选择结果按钮状态
- (void)researtResultButtonStatus{
    [self.dragon_button setSelected:NO];
    [self.he_button setSelected:NO];
    [self.tiger_button setSelected:NO];
}

- (void)lookLuzhuAction{
    [self.viewModel getLuzhuWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            self.puciCount = self.viewModel.lastPuciCount;
            self.prePuciCount = self.puciCount+1;
            self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
            //UIcollectionview 默认样式
            [self.solidItemView fellLuzhuListWithDataList:self.viewModel.luzhuUpList];
        }else{
            //响警告声音
            NSString *messgae = [msg NullToBlankString];
            if (messgae.length == 0) {
                messgae = @"网络异常";
            }
            [self showMessage:messgae];
        }
    }];
}

-(JhPageItemView *)solidItemView{
    if (!_solidItemView) {
        CGRect femwe =  CGRectMake(0, 0, kScreenWidth-30-156-249, 231);
        JhPageItemView *view =  [[JhPageItemView alloc]initWithFrame:femwe];
        view.backgroundColor = [UIColor whiteColor];
        self.solidItemView = view;
    }
    return _solidItemView;
}

#pragma mark - 龙
- (void)dragonAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.hasChipRead) {
        [self showMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
        return;
    }
    if (self.puciCount==0) {
        [self showMessage:@"请先录入结果"];
        return;
    }
    NSString *realCashMoney = self.curChipInfo.chipDenomination;
    if (self.resultInt==1) {
        self.winOrLose = YES;
    }else{
        self.winOrLose = NO;
    }
    [self showInfoStatusWith:self.winOrLose];
    [self.dragon_button setSelected:YES];
    [self.he_button setSelected:NO];
    [self.tiger_button setSelected:NO];
    if (self.winOrLose) {
        self.odds = 1;
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n龙赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.compensateMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPRealpay note:@"实赔"],self.odds*[realCashMoney floatValue]];
        self.customerInfo.compensateCode = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPCompensate note:@"应赔"],self.odds*[realCashMoney floatValue]];
        self.customerInfo.totalMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPAllChip note:@"总码"],(self.odds+1)*[realCashMoney floatValue]];
        self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%@:0",[EPStr getStr:kEPDashui note:@"打水"]];
        self.viewModel.curupdateInfo.cp_name = @"龙";
        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
        self.viewModel.curupdateInfo.cp_result = @"1";
        self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",(self.odds+1)*[realCashMoney floatValue]];
    }else{
        if (self.resultInt==3) {
            self.odds = 0.5;
            self.customerInfo.isTiger = YES;
        }else{
            self.odds = 1;
        }
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n龙输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.xiazhu = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPBetch note:@"下注"],realCashMoney];
        self.customerInfo.shazhu = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPshouldShazhu note:@"应杀注"],self.odds*[realCashMoney floatValue]];
        self.viewModel.curupdateInfo.cp_name = @"龙";
        self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"%@:0",[EPStr getStr:kEPAddChip note:@"应加赔"]];
        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
        self.viewModel.curupdateInfo.cp_result = @"-1";
        self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",self.odds*[realCashMoney floatValue]];
    }
}

#pragma mark - 虎
- (void)tigerAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.hasChipRead) {
        [self showMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
        return;
    }
    if (self.puciCount==0) {
        [self showMessage:@"请先录入结果"];
        return;
    }
    NSString *realCashMoney = self.curChipInfo.chipDenomination;
    if (self.resultInt==2) {
        self.winOrLose = YES;
    }else{
       self.winOrLose = NO;
    }
    [self showInfoStatusWith:self.winOrLose];
    [self.dragon_button setSelected:NO];
    [self.he_button setSelected:NO];
    [self.tiger_button setSelected:YES];
    if (self.winOrLose) {
        self.odds = 1;
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n虎赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%@:0",[EPStr getStr:kEPDashui note:@"打水"]];
        self.viewModel.curupdateInfo.cp_name = @"虎";
        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
        self.viewModel.curupdateInfo.cp_result = @"1";
    }else{
        if (self.resultInt==3) {
            self.customerInfo.isTiger = YES;
            self.odds = 0.5;
        }else{
            self.odds = 1;
        }
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n虎输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.viewModel.curupdateInfo.cp_name = @"虎";
        self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"%@:0",[EPStr getStr:kEPAddChip note:@"应加赔"]];
        self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",self.odds*[realCashMoney floatValue]];
        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
        self.viewModel.curupdateInfo.cp_result = @"-1";
    }
}

#pragma mark - 和
- (void)heAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.hasChipRead) {
        [self showMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
        return;
    }
    if (self.puciCount==0) {
        [self showMessage:@"请先录入结果"];
        return;
    }
    if (self.resultInt==3) {
        self.winOrLose = YES;
    }else{
        self.winOrLose = NO;
    }
    self.customerInfo.isTiger = NO;
    [self showInfoStatusWith:self.winOrLose];
    //赔率
    NSArray *xz_array = self.viewModel.gameInfo.xz_setting;
    if (xz_array.count>2) {
        self.odds = [xz_array[2][@"fpl"] floatValue];
        self.yj = [xz_array[2][@"fyj"] floatValue];
    }
    NSString *realCashMoney = self.curChipInfo.chipDenomination;
    [self.dragon_button setSelected:NO];
    [self.he_button setSelected:YES];
    [self.tiger_button setSelected:NO];
    if (self.winOrLose) {
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n和赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.compensateMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPRealpay note:@"实赔"],self.odds*[realCashMoney floatValue]];
        self.customerInfo.compensateCode = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPCompensate note:@"应赔"],self.odds*[realCashMoney floatValue]];
        self.customerInfo.totalMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPAllChip note:@"总码"],(self.odds+1)*[realCashMoney floatValue]];
        self.viewModel.curupdateInfo.cp_name = @"和";
        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
        self.viewModel.curupdateInfo.cp_result = @"1";
        self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",(self.odds-self.yj+1)*[realCashMoney floatValue]];
    }else{
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n和输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.xiazhu = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPBetch note:@"下注"],realCashMoney];
        self.customerInfo.shazhu = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPshouldShazhu note:@"应杀注"],realCashMoney];
        self.viewModel.curupdateInfo.cp_name = @"和";
        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
        self.viewModel.curupdateInfo.cp_result = @"-1";
        self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"%@:0",[EPStr getStr:kEPAddChip note:@"应加赔"]];
        self.viewModel.curupdateInfo.cp_money = realCashMoney;
        
    }
}

- (void)changeLanguageWithType:(BOOL)isEnglish{
    [EPSound playWithSoundName:@"click_sound"];
    if (isEnglish) {
        [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:0];
    }else{
        [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:1];
    }
    [self.moreOptionButton setTitle:@"更多选项\nMoreOptions" forState:UIControlStateNormal];
    [self.changexueci_button setTitle:[NSString stringWithFormat:@"新靴\n%@",[EPStr getStr:kEPChangeXueci note:@"新靴"]] forState:UIControlStateNormal];
    [self.updateLuzhu_button setTitle:[NSString stringWithFormat:@"修改露珠\n%@",@"Update Results"] forState:UIControlStateNormal];
    [self.daily_button setTitle:[NSString stringWithFormat:@"日结\n%@",[EPStr getStr:kEPDaily note:@"日结"]] forState:UIControlStateNormal];
    [self.nextGame_button setTitle:[NSString stringWithFormat:@"新一局\n%@",[EPStr getStr:kEPNewGame note:@"新一局"]] forState:UIControlStateNormal];
    [self.zhuxiaochouma_button setTitle:@"打散" forState:UIControlStateNormal];
    
    [self.dragonBtn setTitle:[NSString stringWithFormat:@"  龙 %@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
    [self.dragonInfoBtn setTitle:[NSString stringWithFormat:@"龙\n%@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
    [self.dragon_button setTitle:[NSString stringWithFormat:@"龙  %@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
    
    [self.tigerBtn setTitle:[NSString stringWithFormat:@"  虎 %@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
    [self.tigerInfoBtn setTitle:[NSString stringWithFormat:@"虎\n%@",[EPStr getStr:kEPTiger note:@"虎"]] forState:UIControlStateNormal];
    [self.tiger_button setTitle:[NSString stringWithFormat:@"虎  %@",[EPStr getStr:kEPTiger note:@"虎"]] forState:UIControlStateNormal];
    
    [self.heBtn setTitle:[NSString stringWithFormat:@"和 %@",[EPStr getStr:kEPTigerHe note:@"和"]] forState:UIControlStateNormal];
    [self.heInfoBtn setTitle:[NSString stringWithFormat:@"和\n%@",[EPStr getStr:kEPTigerHe note:@"和"]] forState:UIControlStateNormal];
    [self.he_button setTitle:[NSString stringWithFormat:@"和  %@",[EPStr getStr:kEPTigerHe note:@"和"]] forState:UIControlStateNormal];
    [self.aTipRecordButton setTitle:[NSString stringWithFormat:@"记录小费"] forState:UIControlStateNormal];
}

#pragma mark - 更换靴次
- (void)changexueciAction{
    [EPSound playWithSoundName:@"click_sound"];
   [[MJPopTool sharedInstance] popView:self.empowerView animated:YES];
    @weakify(self);
    self.empowerView.sureActionBlock = ^(NSString * _Nonnull adminName, NSString * _Nonnull password) {
        @strongify(self);
        [self showWaitingView];
        [self.viewModel authorizationAccountWitAccountName:adminName Password:password Block:^(BOOL success, NSString *msg, EPSreviceError error) {
            if (success) {
                if (self.isAutomicGame) {
                    [self.viewModel clearLuzhuWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                        [self hideWaitingView];
                        if (success) {
                            self.manuaManagerView.xueciCount +=1;
                            self.manuaManagerView.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.manuaManagerView.xueciCount];
                            self.viewModel.curXueci = self.manuaManagerView.xueciCount;
                            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:self.manuaManagerView.xueciCount] forKey:[NSString stringWithFormat:@"%@_Xueci",self.viewModel.curTableInfo.fid]];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            self.manuaManagerView.puciCount =0;
                            self.manuaManagerView.prePuciCount = self.manuaManagerView.puciCount+1;
                            self.manuaManagerView.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.manuaManagerView.puciCount];
                            [self.manuaManagerView restartChangeStatus];
                            [self showMessage:[EPStr getStr:kEPChangeXueciSucceed note:@"更换靴次成功"] withSuccess:YES];
                            //响警告声音
                            [EPSound playWithSoundName:@"succeed_sound"];
                        }else{
                            NSString *messgae = [msg NullToBlankString];
                            if (messgae.length == 0) {
                                messgae = @"网络异常";
                            }
                            [self showMessage:messgae];
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
                        }
                    }];
                }else{
                    [self hideWaitingView];
                    self.xueciCount +=1;
                    self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
                    self.puciCount =0;
                    self.prePuciCount = self.puciCount+1;
                    self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
                    [self restartChangeStatus];
                    [self showMessage:[EPStr getStr:kEPChangeXueciSucceed note:@"更换靴次成功"] withSuccess:YES];
                    //响警告声音
                    [EPSound playWithSoundName:@"succeed_sound"];
                }
            }else{
                [self hideWaitingView];
                NSString *messgae = [msg NullToBlankString];
                if (messgae.length == 0) {
                    messgae = @"网络异常";
                }
                [self showMessage:messgae];
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
            }
        }];
    };
}

#pragma mark - 修改露珠
- (void)updateLuzhu{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.isAutomicGame) {
        if (self.manuaManagerView.realLuzhuList.count<=0) {
            [self showMessage:@"暂无露珠可修改" withSuccess:NO];
            return;
        }
        [[MJPopTool sharedInstance] popView:self.modifyResultsView animated:YES];
            //传输参数
            [self.modifyResultsView fellViewDataWithLoginID:self.viewModel.loginInfo.access_token
                                                    TableID:self.viewModel.curTableInfo.fid
                                                      Xueci:self.manuaManagerView.xueciCount
                                                       List:self.manuaManagerView.realLuzhuList
                                                 Xz_setting:self.viewModel.gameInfo.xz_setting];
            @weakify(self);
            self.modifyResultsView.sureActionBlock = ^(BOOL isUpdateStatus) {
                @strongify(self);
                if (isUpdateStatus) {
                    [self.manuaManagerView getLUzhuINfo];
                }
//        [[UIApplication sharedApplication].keyWindow addSubview:self.empowerView];
//        self.empowerView.sureActionBlock = ^(NSString * _Nonnull adminName, NSString * _Nonnull password) {
//            @strongify(self);
//            [self showWaitingView];
//            [self.viewModel authorizationAccountWitAccountName:adminName Password:password Block:^(BOOL success, NSString *msg, EPSreviceError error) {
//                [self hideWaitingView];
//                if (success) {
//                    //响警告声音
//                    [EPSound playWithSoundName:@"succeed_sound"];
//                }else{
//                    NSString *messgae = [msg NullToBlankString];
//                    if (messgae.length == 0) {
//                        messgae = @"网络异常";
//                    }
//                    [self showMessage:messgae];
//                    //响警告声音
//                    [EPSound playWithSoundName:@"wram_sound"];
//                }
//            }];
//        };
            };
    }else{
        return;
    }
}

#pragma mark - 日结
- (void)daliyAction{
    [EPSound playWithSoundName:@"click_sound"];
    [[MJPopTool sharedInstance] popView:self.empowerView animated:YES];
    @weakify(self);
    self.empowerView.sureActionBlock = ^(NSString * _Nonnull adminName, NSString * _Nonnull password) {
        @strongify(self);
        [self showWaitingView];
        [self.viewModel authorizationAccountWitAccountName:adminName Password:password Block:^(BOOL success, NSString *msg, EPSreviceError error) {
            if (success) {
                self.viewModel.curupdateInfo.femp_num = adminName;
                self.viewModel.curupdateInfo.femp_pwd = password;
                self.viewModel.curupdateInfo.fhg_id = self.viewModel.loginInfo.fid;
                [self.viewModel commitDailyWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                    [self hideWaitingView];
                    if (success) {
                        self.viewModel.curXueci = 1;
                        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:[NSString stringWithFormat:@"%@_Xueci",self.viewModel.curTableInfo.fid]];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        [self showMessage:@"日结成功" withSuccess:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        NSString *messgae = [msg NullToBlankString];
                        if (messgae.length == 0) {
                            messgae = @"网络异常";
                        }
                        [self showMessage:messgae];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                    }
                }];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
            }else{
                [self hideWaitingView];
                NSString *messgae = [msg NullToBlankString];
                if (messgae.length == 0) {
                    messgae = @"网络异常";
                }
                [self showMessage:messgae];
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
            }
        }];
    };
}

#pragma mark - 新一局
- (void)newGameAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.isAutomicGame) {
        if (self.manuaManagerView.prePuciCount==self.manuaManagerView.puciCount) {
            [self showMessage:@"请先提交开牌结果" withSuccess:NO];
            return;
        }
    }else{
       if (self.prePuciCount==self.puciCount) {
            [self showMessage:@"请先提交开牌结果" withSuccess:NO];
            return;
        }
    }
    @weakify(self);
    [EPPopView showInWindowWithMessage:[NSString stringWithFormat:@"是否确定开启新一局？\n%@",[EPStr getStr:kEPSureNextGame note:@"确定开启新一局？"]] handler:^(int buttonType) {
        @strongify(self);
        if (buttonType==0) {
            if (self.isAutomicGame) {
                self.manuaManagerView.puciCount +=1;
                self.manuaManagerView.prePuciCount = self.manuaManagerView.puciCount;
                self.manuaManagerView.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.manuaManagerView.puciCount];
            }else{
                self.puciCount +=1;
                self.prePuciCount = self.puciCount;
                self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
            }
            [self showMessage:@"开启新一局成功" withSuccess:YES];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
        }
    }];
}

#pragma mark - 录入开牌结果
- (void)entryResult{
    self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
    self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
    self.viewModel.curupdateInfo.cp_name = self.resultNameString;
    @weakify(self);
    self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
    [self.viewModel commitkpResultWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        [self hideWaitingView];
        if (success) {
            [self showMessage:[EPStr getStr:kEPResultCacheSucceed note:@"结果录入成功"] withSuccess:YES];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
        }else{
            NSString *messgae = [msg NullToBlankString];
            if (messgae.length == 0) {
                messgae = @"网络异常";
            }
            [self showMessage:messgae];
        }
    }];
}

#pragma mark - 提交客人输赢记录
- (void)commitCustomerInfo{
//    @weakify(self);
//    [self.viewModel commitCustomerRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
//        @strongify(self);
//        [self hideWaitingView];
//        self.zhaohuiMoney = 0;
//        if (success) {
//            self.hasChipRead = NO;
//            self.serialnumber = [NSString stringWithFormat:@"%ld",(long)[NRCommand getRandomNumber:100000 to:1000000]];
//            self.isShowingResult = NO;
//            [self.resultShowView _hide];
//            if (self.winOrLose) {
//                dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
//                dispatch_async(serialQueue, ^{
//                    for (int i = 0; i < realChipUIDList.count; i++) {
//                        self.curChipInfo.chipUID = realChipUIDList[i];
//                        //向指定标签中写入数据（块1）
//                        [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
//                        usleep(20 * 2000);
//                    }
//                });
//                [self showMessage:@"赔付成功"];
//                //响警告声音
//                [EPSound playWithSoundName:@"succeed_sound"];
//            }else{
//                if (self.customerInfo.isTiger) {
//                    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
//                    dispatch_async(serialQueue, ^{
//                        for (int i = 0; i < self.payChipUIDList.count; i++) {
//                            self.curChipInfo.chipUID = self.payChipUIDList[i];
//                            //向指定标签中写入数据（块1）
//                            [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
//                            usleep(20 * 2000);
//                        }
//                        for (int i = 0; i < self.chipUIDList.count; i++) {
//                            NSString *chipUID = realChipUIDList[i];
//                            //向指定标签中写入数据（块1）
//                            [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
//                            usleep(20 * 2000);
//
//                        }
//                    });
//                }else{
//                    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
//                    dispatch_async(serialQueue, ^{
//                        for (int i = 0; i < realChipUIDList.count; i++) {
//                            NSString *chipUID = realChipUIDList[i];
//                            //向指定标签中写入数据（块1）
//                            [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
//                            usleep(20 * 2000);
//                        }
//                    });
//                }
//                [self showMessage:[EPStr getStr:kEPShazhuSucceed note:@"杀注成功"]];
//                //响警告声音
//                [EPSound playWithSoundName:@"succeed_sound"];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self researtResultButtonStatus];
//            });
//        }else{
//            //响警告声音
//            [EPSound playWithSoundName:@"wram_sound"];
//            NSString *messgae = [msg NullToBlankString];
//            if (messgae.length == 0) {
//                messgae = @"网络异常";
//            }
//            [self showMessage:messgae];
//        }
//    }];
}

#pragma mark - 绑定筹码
- (void)bindChipAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.hasChipRead) {
        [self showMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
        return;
    }
    @weakify(self);
    [EPPopView showEntryInView:self.view WithTitle:[NSString stringWithFormat:@"提示信息\n%@",[EPStr getStr:kEPTipsInfo note:@"提示信息"]] handler:^(NSString *entryText) {
        @strongify(self);
        if ([[entryText NullToBlankString]length]!=0) {
            [EPPopView showInWindowWithMessage:@"确定绑定筹码？" handler:^(int buttonType) {
                if (buttonType==0) {
                    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
                    dispatch_async(serialQueue, ^{
                        for (int i = 0; i < self.chipUIDList.count; i++) {
                            self.curChipInfo.guestWashesNumber = entryText;
                            self.curChipInfo.chipUID = self.chipUIDList[i];
                            //向指定标签中写入数据（块1）
                            [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                            usleep(20 * 2000);
                        }
                    });
                    [self showLognMessage:@"绑定成功"];
                    //响警告声音
                    [EPSound playWithSoundName:@"succeed_sound"];
                }
            }];
        }else{
            [self showLognMessage:[EPStr getStr:kEPEntryWashNumber note:@"请输入洗码号"]];
        }
    }];
}

#pragma mark - 注销筹码
- (void)zhuxiaoAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.hasChipRead) {
        [self showMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
        return;
    }
    [EPPopView showInWindowWithMessage:[NSString stringWithFormat:@"是否确定清除客人洗码号？\n%@",[EPStr getStr:kEPClearWashNumberConfirm note:@"是否确定清除客人洗码号？"]] handler:^(int buttonType) {
        if (buttonType==0) {
            for (int i = 0; i < self.chipUIDList.count; i++) {
                NSString *chipUID = self.chipUIDList[i];
                //向指定标签中写入数据（块1）
                [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                usleep(20 * 2000);
            }
            [self showLognMessage:[EPStr getStr:kEPclearSucceed note:@"清除成功"]];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
        }
    }];
    
}

#pragma mark - 记录小费
- (void)recordTipMoneyAction:(UIButton *)btn{
    [EPSound playWithSoundName:@"click_sound"];
    if ([[self.viewModel.cp_fidString NullToBlankString]length]==0) {
        [self showMessage:@"请先提交输赢记录"];
        return;
    }
    self.isRecordTipMoney = YES;
    self.recordTipShowView = [EPPopAtipInfoView showInWindowWithNRCustomerInfo:self.customerInfo handler:^(int buttonType) {
        DLOG(@"buttonType===%d",buttonType);
        if (buttonType==1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showWaitingView];
            });
            [self.recordTipShowView _hide];
            self.viewModel.curupdateInfo.cp_xiaofeiList = self.tipChipUIDList;
            [self.viewModel commitTipResultWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                [self hideWaitingView];
                if (success) {
                    self.isRecordTipMoney = NO;
                    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
                    dispatch_async(serialQueue, ^{
                        for (int i = 0; i < self.tipChipUIDList.count; i++) {
                            NSString *chipUID = self.tipChipUIDList[i];
                            //向指定标签中写入数据（块1）
                            [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                            usleep(20 * 2000);
                        }
                    });
                    [self showMessage:@"提交成功"];
                    //响警告声音
                    [EPSound playWithSoundName:@"succeed_sound"];
                }else{
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                    NSString *messgae = [msg NullToBlankString];
                    if (messgae.length == 0) {
                        messgae = @"网络异常";
                    }
                    [self showMessage:messgae];
                }
            }];
            
        }else if (buttonType==2){
            self.isRecordTipMoney = YES;
            [self getTipChipsUIDList];
        }else if (buttonType==0){
            self.isRecordTipMoney = NO;
        }
    }];
}

- (void)showStatusInfo{
    self.viewModel.curupdateInfo.cp_washNumber = self.curChipInfo.guestWashesNumber;
    self.viewModel.curupdateInfo.cp_benjin = self.curChipInfo.chipDenomination;
    self.isShowingResult = YES;
    self.resultShowView =[EPPopAlertShowView showInWindowWithNRCustomerInfo:self.customerInfo handler:^(int buttonType) {
        DLOG(@"buttonType===%d",buttonType);
        if (buttonType==1) {
            [EPSound playWithSoundName:@"click_sound"];
            self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
            self.viewModel.curupdateInfo.cp_dianshu = @"0";
            NSMutableArray *realChipUIDList = [NSMutableArray array];
            self.viewModel.curupdateInfo.cp_chipType = self.curChipInfo.chipType;
            if (self.winOrLose) {
                [realChipUIDList addObjectsFromArray:self.chipUIDList];
                [realChipUIDList addObjectsFromArray:self.payChipUIDList];
            }else{
                if (self.customerInfo.isTiger) {
                    [realChipUIDList addObjectsFromArray:self.chipUIDList];
                    self.viewModel.curupdateInfo.cp_zhaohuiList = self.payChipUIDList;
                }else{
                    [realChipUIDList addObjectsFromArray:self.chipUIDList];
                    [realChipUIDList addObjectsFromArray:self.payChipUIDList];
                }
            }
            self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
            self.viewModel.curupdateInfo.cp_ChipUidList = realChipUIDList;
            
            if (self.customerInfo.isTiger&&(self.zhaohuiMoney != self.benjinMoney/2)) {
                [self showMessage:@"找回金额不正确"];
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
            }else{
                @weakify(self);
                [self.viewModel commitCustomerRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                    @strongify(self);
                    [self hideWaitingView];
                    self.zhaohuiMoney = 0;
                    if (success) {
                         self.hasChipRead = NO;
                        self.serialnumber = [NSString stringWithFormat:@"%ld",(long)[NRCommand getRandomNumber:100000 to:1000000]];
                        self.isShowingResult = NO;
                        [self.resultShowView _hide];
                        if (self.winOrLose) {
                            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
                            dispatch_async(serialQueue, ^{
                                for (int i = 0; i < realChipUIDList.count; i++) {
                                    self.curChipInfo.chipUID = realChipUIDList[i];
                                    //向指定标签中写入数据（块1）
                                    [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                                    usleep(20 * 2000);
                                }
                            });
                            [self showMessage:@"赔付成功"];
                            //响警告声音
                            [EPSound playWithSoundName:@"succeed_sound"];
                        }else{
                            if (self.customerInfo.isTiger) {
                                dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
                                dispatch_async(serialQueue, ^{
                                    for (int i = 0; i < self.payChipUIDList.count; i++) {
                                        self.curChipInfo.chipUID = self.payChipUIDList[i];
                                        //向指定标签中写入数据（块1）
                                        [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                                        usleep(20 * 2000);
                                    }
                                    for (int i = 0; i < self.chipUIDList.count; i++) {
                                        NSString *chipUID = realChipUIDList[i];
                                        //向指定标签中写入数据（块1）
                                        [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                                        usleep(20 * 2000);
                                        
                                    }
                                });
                            }else{
                                dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
                                dispatch_async(serialQueue, ^{
                                    for (int i = 0; i < realChipUIDList.count; i++) {
                                        NSString *chipUID = realChipUIDList[i];
                                        //向指定标签中写入数据（块1）
                                        [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                                        usleep(20 * 2000);
                                    }
                                });
                            }
                            [self showMessage:[EPStr getStr:kEPShazhuSucceed note:@"杀注成功"]];
                            //响警告声音
                            [EPSound playWithSoundName:@"succeed_sound"];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self researtResultButtonStatus];
                        });
                    }else{
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        NSString *messgae = [msg NullToBlankString];
                        if (messgae.length == 0) {
                            messgae = @"网络异常";
                        }
                        [self showMessage:messgae];
                    }
                }];
            }
        }else if (buttonType==2){
            [self getPayChipsUIDList];
        }else if (buttonType==0){
            self.isShowingResult = NO;
            [self clearChipCacheData];
        }
    }];
}
#pragma mark - 清除筹码数据
- (void)clearChipCacheData{
    self.payChipUIDList = nil;
    self.tipChipUIDList = nil;
    [self.BLEDataHasPayList removeAllObjects];
    [self.BLEUIDDataHasPayList removeAllObjects];
}

#pragma mark - 查询设备上的筹码UID
- (void)queryDeviceChips{
    [EPSound playWithSoundName:@"click_sound"];
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 识别筹码金额
- (void)readCurChipsMoney{
    [self researtResultButtonStatus];
    //执行读取命令
    [self.BLEDataList removeAllObjects];
    [self.BLEUIDDataList removeAllObjects];
    //向指定标签中写入数据（所有块）
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showWaitingView];
    });
    [self.viewModel checkChipIsTrueWithChipList:self.chipUIDList Block:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self hideWaitingView];
        if (success) {
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    NSString *chipID = self.chipUIDList[i];
                    [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
                    usleep(20 * 1000);
                }
            });
        }else{
            NSString *messgae = [msg NullToBlankString];
            if (messgae.length == 0) {
                messgae = @"网络异常";
            }
            [self showMessage:messgae];
            //响警告声音
            [EPSound playWithSoundName:@"wram_sound"];
        }
    }];
}

#pragma mark - 读取赔付筹码信息
- (void)getPayChipsUIDList{
    self.isShowingResult = YES;
    [self.BLEUIDDataHasPayList removeAllObjects];
    [self.BLEDataHasPayList removeAllObjects];
    [EPSound playWithSoundName:@"click_sound"];
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 读取赔付筹码信息
- (void)readAllPayChipsInfo{
    //向指定标签中写入数据（所有块）
    if (self.payChipUIDList.count != 0) {
        for (int i = 0; i < self.payChipUIDList.count; i++) {
            NSString *chipID = self.payChipUIDList[i];
            [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
            usleep(20 * 2000);
        }
    }else{
        [EPSound playWithSoundName:@"wram_sound"];
        [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
    }
}

#pragma mark - 读取小费筹码信息
- (void)getTipChipsUIDList{
    [EPSound playWithSoundName:@"click_sound"];
    //执行读取命令
    [self.BLEDataTipList removeAllObjects];
    [self.BLEUIDDataTipList removeAllObjects];
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 读取小费筹码信息
- (void)readAllTipChipsInfo{
    //向指定标签中写入数据（所有块）
    if (self.tipChipUIDList.count != 0) {
        for (int i = 0; i < self.tipChipUIDList.count; i++) {
            NSString *chipID = self.tipChipUIDList[i];
            [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
            usleep(20 * 1000);
        }
    }else{
        [EPSound playWithSoundName:@"wram_sound"];
        [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
    }
}

#pragma mark - GCDAsyncSocketDelegate
//连接主机对应端口
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self sendDeviceWorkModel];
    //    连接后,可读取服务器端的数据
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
}

// 收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 读取到服务器数据值后也能再读取
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    NSString *dataHexStr = [NRCommand hexStringFromData:data];
    if (!self.chipUIDData) {
        self.chipUIDData = [NSMutableData data];
    }
    DLOG(@"data = %@",data);
    if (![dataHexStr containsString:@"040000525a"]) {
        [self.chipUIDData appendData:data];
    }
    NSMutableArray *array = [NRCommand convertDataToHexStr:self.chipUIDData];
    DLOG(@"array===%@",array);
    if (array.count>1) {
        if ([array[0] isEqualToString:@"0e"]) {
            if (self.isShowingResult) {
                [self.BLEUIDDataHasPayList addObjectsFromArray:array];
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSString *BLEString = [itool dataStringFromArray:self.BLEUIDDataHasPayList];
                //存贮筹码UID
                self.payChipUIDList = [itool cacheChipUIDWithBLEString:BLEString WithOldUidList:self.payChipUIDList];
                self.payChipCount = self.payChipUIDList.count;
                if (self.payChipCount==0) {
                    self.payChipUIDList = nil;
                    [self.BLEUIDDataHasPayList removeAllObjects];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.hasPayMoneyShow = NO;
                        [self.BLEUIDDataHasPayList removeAllObjects];
                        [self.BLEDataHasPayList removeAllObjects];
                        if (self.customerInfo.isTiger) {
                            self.zhaohuiMoney = 0;
                            self.resultShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",@"已识别找回筹码",0];
                        }else{
                            self.resultShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",[EPStr getStr:kEPPeifuChip note:@"已赔付筹码:"],0];
                        }
                        
                    });
                }else{
                    [self readAllPayChipsInfo];
                }
            }else if (self.isRecordTipMoney){//记录小费
                [self.BLEUIDDataTipList addObjectsFromArray:array];
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSString *BLEString = [itool dataStringFromArray:self.BLEUIDDataTipList];
                //存贮筹码UID
                self.tipChipUIDList = [itool cacheChipUIDWithBLEString:BLEString WithOldUidList:self.tipChipUIDList];
                self.tipChipCount = self.tipChipUIDList.count;
                if (self.tipChipCount==0) {
                    self.tipChipUIDList = nil;
                    [self.BLEUIDDataTipList removeAllObjects];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.BLEUIDDataTipList removeAllObjects];
                        [self.BLEDataTipList removeAllObjects];
                        self.recordTipShowView.compensateMoneyLab.text = [NSString stringWithFormat:@"小费金额:%d",0];
                        self.recordTipShowView.guestNumberLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPWashNumber note:@"客人洗码号"],@"#"];
                    });
                }else{
                    [self readAllTipChipsInfo];
                }
            }else{
                [self.BLEUIDDataList addObjectsFromArray:array];
                if (self.BLEUIDDataList.count >= 0){
                    BLEIToll *itool = [[BLEIToll alloc]init];
                    NSString *BLEString = [itool dataStringFromArray:self.BLEUIDDataList];
                    //存贮筹码UID
                    self.chipUIDList = [itool cacheChipUIDWithBLEString:BLEString WithOldUidList:self.chipUIDList];
                    self.chipCount = self.chipUIDList.count;
                    DLOG(@"self.chipCount = %ld",(long)self.chipCount);
                    if (self.chipCount==0) {
                        [self.BLEUIDDataList removeAllObjects];
                        [self.BLEDataList removeAllObjects];
                        self.hasChipRead = NO;
                        self.chipUIDList = nil;
                        [self researtResultButtonStatus];
                    }else{
                        self.viewModel.curupdateInfo.cp_DashuiUidList = self.chipUIDList;
                        [self readCurChipsMoney];
                    }
                }
            }
        }else if([array[0] isEqualToString:@"09"]){
            if (self.isShowingResult) {
                [self.BLEDataHasPayList addObjectsFromArray:array];
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSString *realChipsInfoString = [itool dataStringFromArray:self.BLEDataHasPayList];
                DLOG(@"read111ChipsInfoString = %@",realChipsInfoString);
                if ([itool chipNumbersWithBLEString:realChipsInfoString]==3*self.payChipCount) {
                    NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:realChipsInfoString WithSplitSize:3];
                    //筹码额
                    __block int chipAllMoney = 0;
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                        chipAllMoney += [realmoney intValue];
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                        self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",benjinMoney+chipAllMoney];
                        if (self.customerInfo.isTiger) {
                            self.zhaohuiMoney = chipAllMoney;
                            self.resultShowView.havepayChipLab.text = [NSString stringWithFormat:@"已识别找回筹码:%d",chipAllMoney];
                            [self showMessage:@"识别找回筹码成功"];
                        }else{
                            self.resultShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",[EPStr getStr:kEPPeifuChip note:@"已赔付筹码:"],chipAllMoney];
                            [self showMessage:@"识别赔付筹码成功"];
                        }
                    });
                    //响警告声音
                    [EPSound playWithSoundName:@"succeed_sound"];
                }
            }else if (self.isRecordTipMoney){//记录小费
                [self.BLEDataTipList addObjectsFromArray:array];
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSString *realChipsInfoString = [itool dataStringFromArray:self.BLEDataTipList];
                DLOG(@"read222ChipsInfoString = %@",realChipsInfoString);
                if ([itool chipNumbersWithBLEString:realChipsInfoString]==3*self.tipChipCount) {
                    NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:realChipsInfoString WithSplitSize:3];
                    DLOG(@"readchipInfo = %@",chipInfo);
                    //客人洗码号
                    NSString *tipWashNumberChip = chipInfo[0][4];
                    if ([[tipWashNumberChip NullToBlankString]length]==0||[tipWashNumberChip isEqualToString:@"0"]) {
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self showMessage:@"筹码错误"];
                    }else{
                        self.curChipInfo.tipWashesNumber = chipInfo[0][4];
                        if (![self.curChipInfo.tipWashesNumber isEqualToString:self.curChipInfo.guestWashesNumber]) {
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
                            [self showMessage:@"筹码洗码号不一致"];
                        }else{
                            //筹码额
                            __block int chipAllMoney = 0;
                            [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                                chipAllMoney += [realmoney intValue];
                            }];
                            self.curChipInfo.tipMoney = [NSString stringWithFormat:@"%d",chipAllMoney];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.recordTipShowView.compensateMoneyLab.text = [NSString stringWithFormat:@"小费金额:%d",chipAllMoney];
                                self.recordTipShowView.guestNumberLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPWashNumber note:@"客人洗码号"],chipInfo[0][4]];
                            });
                            [self showMessage:@"识别小费筹码成功"];
                            //响警告声音
                            [EPSound playWithSoundName:@"succeed_sound"];
                        }
                    }
                }
            }else{
                [self.BLEDataList addObjectsFromArray:array];
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSString *realChipsInfoString = [itool dataStringFromArray:self.BLEDataList];
                DLOG(@"realChipsInfoString = %@",realChipsInfoString);
                if ([itool chipNumbersWithBLEString:realChipsInfoString]==3*self.chipCount) {
                    NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:realChipsInfoString WithSplitSize:3];
                    DLOG(@"chipInfo = %@",chipInfo);
                    if (chipInfo.count != 0) {
                        NSMutableArray *washNumberList = [NSMutableArray array];
                        [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (![washNumberList containsObject:infoList[4]]) {
                                [washNumberList addObject:infoList[4]];
                            }
                        }];
                        if (washNumberList.count>1) {
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
                            [self showMessage:@"不能出现两种洗码号"];
                        }else{
                            NSString *washNumber = washNumberList.firstObject;
                            if ([washNumber isEqualToString:@"0"]||[[washNumber NullToBlankString]length]==0) {
                                self.hasChipRead = NO;
                                //响警告声音
                                [EPSound playWithSoundName:@"wram_sound"];
                                [self showMessage:@"检测到有异常洗码号的筹码"];
                            }else{
                                self.hasChipRead = YES;
                                //响警告声音
                                [EPSound playWithSoundName:@"wram_sound"];
                            }
                            //客人洗码号
                            self.curChipInfo.guestWashesNumber = chipInfo[0][4];
                            //筹码类型
                            NSString *chipType = [chipInfo[0][1] NullToBlankString];
                            self.curChipInfo.chipType = chipType;
                            
                            //筹码额
                            __block int chipAllMoney = 0;
                            [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                                chipAllMoney += [realmoney intValue];
                            }];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",chipAllMoney];
                                self.customerInfo.guestNumber = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPWashNumber note:@"客人洗码号"],self.curChipInfo.guestWashesNumber];
                                self.customerInfo.principalMoney = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPBenjin note:@"本金"],self.curChipInfo.chipDenomination];
                                self.benjinMoney = chipAllMoney;
                            });
                            
                            [self showMessage:[EPStr getStr:kEPReadSucceed note:@"识别成功"]];
                            //响警告声音
                            [EPSound playWithSoundName:@"succeed_sound"];
                            [self hideWaitingView];
                        }
                    }
                }
            }
        }
    }
}

@end
