//
//  NRBaccaratViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRBaccaratViewController.h"
#import "EPPopAlertShowView.h"
#import "NRCustomerInfo.h"
#import "EPPopView.h"
#import "JXButton.h"
#import "EPService.h"
#import "NRLoginInfo.h"
#import "NRBaccaratViewModel.h"
#import "EPResultShowView.h"
#import "NRChipResultInfo.h"
#import "NRTableInfo.h"
#import "NRUpdateInfo.h"
#import "NRGameInfo.h"
#import "EPAppData.h"
#import "EPPopAtipInfoView.h"

#import "JhPageItemView.h"
#import "JhPageItemModel.h"
#import "NFPopupContainView.h"

#import "EPTigerShowView.h"
#import "NFPopupTextContainView.h"

#import "GCDAsyncSocket.h"
#import "BLEIToll.h"
#import "SFLabel.h"
#import "NRManualMangerView.h"
#import "IQKeyboardManager.h"

#import "TableDataInfoView.h"

@interface NRBaccaratViewController ()<GCDAsyncSocketDelegate>

//台桌数据
@property (nonatomic, strong) TableDataInfoView *tableDataInfoV;

//顶部选项卡
@property (nonatomic, strong) UIImageView *topBarImageV;
@property (nonatomic, strong) UIButton *moreOptionButton;
@property (nonatomic, strong) UIImageView *optionArrowImg;
@property (nonatomic, strong) UIButton *changexueci_button;
@property (nonatomic, strong) UIButton *updateLuzhu_button;
@property (nonatomic, strong) UIButton *daily_button;
@property (nonatomic, strong) UIButton *nextGame_button;
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIButton *changeChipBtn;
@property (nonatomic, strong) UIButton *changeLanguageBtn;
@property (nonatomic, strong) UIButton *huanbanBtn;
@property (nonatomic, strong) UIButton *changeTableBtn;
@property (nonatomic, strong) UIButton *queryNoteBtn;
@property (nonatomic, strong) UIButton *queryTableInfoBtn;
@property (nonatomic, strong) UIButton *jiaCaiBtn;

//自动版视图
@property (nonatomic, strong) UIView *automaticShowView;
@property (nonatomic, strong) UIButton *readChipMoney_button;//识别筹码金额
//露珠信息
@property (nonatomic, strong) UIImageView *luzhuImgV;
@property (nonatomic, strong) UILabel *luzhuInfoLab;
@property (nonatomic, strong) UIView *luzhuCollectionView;
@property (nonatomic, strong) JhPageItemView *solidView;
@property (nonatomic, strong) NSMutableArray *luzhuInfoList;

//台桌信息
@property (nonatomic, strong) UIImageView *tableInfoImgV;
@property (nonatomic, strong) UILabel *tableInfoLab;
@property (nonatomic, strong) UIView *tableInfoV;
@property (nonatomic, strong) SFLabel *stableIDLab;
@property (nonatomic, strong) UILabel *xueciLab;
@property (nonatomic, strong) UILabel *puciLab;
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
@property (nonatomic, strong) UIView *heBorderV;
@property (nonatomic, strong) UIButton *heInfoBtn;
@property (nonatomic, strong) UILabel *heInfoLab;
@property (nonatomic, assign) int xueciCount;//靴次
@property (nonatomic, assign) int puciCount;//铺次

//手动版视图
@property (nonatomic, strong) NRManualMangerView *manuaManagerView;
@property (nonatomic, strong) UIButton *aTipRecordButton;//小费按钮

//赢
@property (nonatomic, assign) BOOL winOrLose;
@property (nonatomic, strong) NSString *winColor;
@property (nonatomic, strong) NSString *normalColor;
@property (nonatomic, strong) NSString *buttonNormalColor;
@property (nonatomic, strong) NSString *loseColor;

@property (nonatomic, strong) UIButton *zhuang_button;
@property (nonatomic, strong) UIButton *xian_button;
@property (nonatomic, strong) UIButton *zhuangduizi_button;
@property (nonatomic, strong) UIButton *xianduizi_button;
@property (nonatomic, strong) UIButton *he_button;
@property (nonatomic, strong) UIButton *baoxian_button;
@property (nonatomic, strong) UIButton *luckysix_button;
@property (nonatomic, strong) UIButton *zhuangsix_button;
@property (nonatomic, strong) UIButton *zhuxiaochouma_button;;

@property (nonatomic, strong) NRCustomerInfo *customerInfo;
@property (nonatomic, assign) BOOL isBaoxian;
@property (nonatomic, assign) BOOL isLucky;//是否幸运6点

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

@property (nonatomic, strong) NSMutableArray *BLEUIDDataShuiqianList;//
@property (nonatomic, strong) NSMutableArray *BLEDataShuiqianList;//
@property (nonatomic, assign) NSInteger shuiqianChipCount;
@property (nonatomic, strong) NSArray *shuiqianChipUIDList;
@property (nonatomic, assign) BOOL isDashui;//是否打水

@property (nonatomic, strong) NRChipResultInfo *resultInfo;

@property (nonatomic, assign) BOOL hasChipRead;//是否有可用筹码被识别
@property (nonatomic, strong) NSString *serialnumber;//流水号
@property (nonatomic, assign) CGFloat odds;//倍数
@property (nonatomic, assign) CGFloat yj;//佣金
@property (nonatomic, strong) EPPopAlertShowView *resultShowView;
@property (nonatomic, strong) EPPopAtipInfoView *recordTipShowView;//识别小费
@property (nonatomic, strong) NSMutableArray *retultList;//

/** item数组 */
@property (nonatomic, strong) JhPageItemView *solidItemView;

// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSMutableData *chipUIDData;
@property (nonatomic, assign) CGFloat result_odds;
@property (nonatomic, assign) CGFloat result_yj;
@property (nonatomic, assign) CGFloat identifyValue;//水钱

@end

@implementation NRBaccaratViewController

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
        _menuView.backgroundColor = [UIColor colorWithHexString:@"#666f79"];
        _menuView.opaque = 0.6;
        
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
        lineV1.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
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
        lineV2.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
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
        lineV3.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
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
        lineV4.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
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
        lineV5.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
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
        lineV6.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        lineV6.alpha = 0.8;
        [self.queryTableInfoBtn addSubview:lineV6];
        [lineV6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.queryTableInfoBtn).offset(0);
            make.left.equalTo(self.queryTableInfoBtn).offset(5);
            make.centerX.equalTo(self.queryTableInfoBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.jiaCaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.jiaCaiBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.jiaCaiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.jiaCaiBtn setTitle:@"台面加减彩" forState:UIControlStateNormal];
        self.jiaCaiBtn.tag = 7;
        [self.jiaCaiBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.jiaCaiBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.jiaCaiBtn];
        [self.jiaCaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.queryTableInfoBtn.mas_bottom).offset(5);
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
        
        CGFloat tapItem_width = (kScreenWidth-240)/2;
        CGFloat tapItem_height = 70;
        CGFloat item_fontsize = 20;
        self.readChipMoney_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.readChipMoney_button.titleLabel.numberOfLines = 0;
        self.readChipMoney_button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.readChipMoney_button setBackgroundImage:[UIImage imageNamed:@"login_text_bg"] forState:UIControlStateNormal];
        self.readChipMoney_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        [self.readChipMoney_button addTarget:self action:@selector(queryDeviceChips) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.readChipMoney_button];
        [self.readChipMoney_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.luzhuCollectionView.mas_bottom).offset(20);
            make.left.equalTo(self.automaticShowView).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(200);
        }];
        
        self.aTipRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.aTipRecordButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.aTipRecordButton.titleLabel.numberOfLines = 0;
        [self.aTipRecordButton setBackgroundImage:[UIImage imageNamed:@"login_text_bg"] forState:UIControlStateNormal];
        self.aTipRecordButton.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        [self.aTipRecordButton addTarget:self action:@selector(recordTipMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.aTipRecordButton];
        [self.aTipRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.readChipMoney_button.mas_bottom).offset(20);
            make.left.equalTo(self.automaticShowView).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(200);
        }];
        
        self.zhuxiaochouma_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zhuxiaochouma_button.layer.cornerRadius = 2;
        self.zhuxiaochouma_button.titleLabel.numberOfLines = 2;
        self.zhuxiaochouma_button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.zhuxiaochouma_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
        self.zhuxiaochouma_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.zhuxiaochouma_button.backgroundColor = [UIColor colorWithHexString:@"#274560"];
        [self.zhuxiaochouma_button addTarget:self action:@selector(zhuxiaoAction) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.zhuxiaochouma_button];
        [self.zhuxiaochouma_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.aTipRecordButton.mas_bottom).offset(20);
            make.left.equalTo(self.automaticShowView).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(200);
        }];
        
        self.zhuang_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zhuang_button.layer.cornerRadius = 2;
        self.zhuang_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
        self.zhuang_button.layer.borderWidth = 1;
        self.zhuang_button.tag = 0;
        [self.zhuang_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
        self.zhuang_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.zhuang_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
        [self.zhuang_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.zhuang_button];
        [self.zhuang_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.luzhuCollectionView.mas_bottom).offset(20);
            make.left.equalTo(self.readChipMoney_button.mas_right).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(tapItem_width);
        }];
        
        self.xian_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.xian_button.layer.cornerRadius = 2;
        self.xian_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
        self.xian_button.layer.borderWidth = 1;
        self.xian_button.tag = 1;
        [self.xian_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
        self.xian_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.xian_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
        [self.xian_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.xian_button];
        [self.xian_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.luzhuCollectionView.mas_bottom).offset(20);
            make.left.equalTo(self.zhuang_button.mas_right).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(tapItem_width);
        }];
        
        self.zhuangduizi_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zhuangduizi_button.layer.cornerRadius = 2;
        self.zhuangduizi_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
        self.zhuangduizi_button.layer.borderWidth = 1;
        self.zhuangduizi_button.tag = 2;
        [self.zhuangduizi_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
        self.zhuangduizi_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.zhuangduizi_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
        [self.zhuangduizi_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.zhuangduizi_button];
        [self.zhuangduizi_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.zhuang_button.mas_bottom).offset(10);
            make.left.equalTo(self.readChipMoney_button.mas_right).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(tapItem_width);
        }];
        
        self.xianduizi_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.xianduizi_button.layer.cornerRadius = 2;
        self.xianduizi_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
        self.xianduizi_button.layer.borderWidth = 1;
        self.xianduizi_button.tag = 3;
        [self.xianduizi_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
        self.xianduizi_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.xianduizi_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
        [self.xianduizi_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.xianduizi_button];
        [self.xianduizi_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.zhuang_button.mas_bottom).offset(10);
            make.left.equalTo(self.zhuangduizi_button.mas_right).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(tapItem_width);
        }];
        
        self.he_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.he_button.layer.cornerRadius = 2;
        self.he_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
        self.he_button.layer.borderWidth = 1;
        self.he_button.tag = 4;
        [self.he_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
        self.he_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.he_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
        [self.he_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.he_button];
        [self.he_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.zhuangduizi_button.mas_bottom).offset(10);
            make.left.equalTo(self.readChipMoney_button.mas_right).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(tapItem_width);
        }];
        
        self.baoxian_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.baoxian_button.layer.cornerRadius = 2;
        self.baoxian_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
        self.baoxian_button.layer.borderWidth = 1;
        self.baoxian_button.tag = 5;
        [self.baoxian_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
        self.baoxian_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.baoxian_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
        [self.baoxian_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.baoxian_button];
        [self.baoxian_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.zhuangduizi_button.mas_bottom).offset(10);
            make.left.equalTo(self.he_button.mas_right).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(tapItem_width);
        }];
        
        self.luckysix_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.luckysix_button.layer.cornerRadius = 2;
        self.luckysix_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
        self.luckysix_button.layer.borderWidth = 1;
        self.luckysix_button.tag = 7;
        [self.luckysix_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
        self.luckysix_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.luckysix_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
        [self.luckysix_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.luckysix_button];
        [self.luckysix_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baoxian_button.mas_bottom).offset(10);
            make.left.equalTo(self.readChipMoney_button.mas_right).offset(10);
            make.height.mas_equalTo(tapItem_height);
            if (self.isYouyong.boolValue) {
                make.width.mas_offset(kScreenWidth-32-200-20);
            }else{
                make.width.mas_offset(tapItem_width);
            }
        }];
        
        if (!self.isYouyong.boolValue) {
            self.zhuangsix_button = [UIButton buttonWithType:UIButtonTypeCustom];
            self.zhuangsix_button.layer.cornerRadius = 2;
            self.zhuangsix_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
            self.zhuangsix_button.layer.borderWidth = 1;
            self.zhuangsix_button.tag = 6;
            [self.zhuangsix_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
            self.zhuangsix_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
            self.zhuangsix_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
            [self.zhuangsix_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.automaticShowView addSubview:self.zhuangsix_button];
            [self.zhuangsix_button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.baoxian_button.mas_bottom).offset(10);
                make.left.equalTo(self.luckysix_button.mas_right).offset(10);
                make.height.mas_equalTo(tapItem_height);
                make.width.mas_offset(tapItem_width);
            }];
        }
    }
    return _automaticShowView;
}

- (NRManualMangerView *)manuaManagerView{
    if (!_manuaManagerView) {
        _manuaManagerView = [[NRManualMangerView alloc]initWithFrame:CGRectMake(0,94, kScreenWidth, kScreenHeight-94)];
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

- (void)_setup{
    //台桌信息
    self.tableInfoImgV = [UIImageView new];
    self.tableInfoImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self.automaticShowView addSubview:self.self.tableInfoImgV];
    [self.tableInfoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.automaticShowView).offset(20);
        make.right.equalTo(self.automaticShowView).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_offset(200);
    }];
    
    self.tableInfoLab = [UILabel new];
    self.tableInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tableInfoLab.font = [UIFont systemFontOfSize:14];
    self.tableInfoLab.text = @"台桌信息Table information";
    [self.automaticShowView addSubview:self.tableInfoLab];
    [self.tableInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoImgV.mas_top).offset(8);
        make.left.equalTo(self.tableInfoImgV.mas_left).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.tableInfoV = [UIView new];
    self.tableInfoV.layer.cornerRadius = 2;
    self.tableInfoV.backgroundColor = [UIColor colorWithHexString:@"#3e565d"];
    [self.automaticShowView addSubview:self.tableInfoV];
    [self.tableInfoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoImgV.mas_bottom).offset(0);
        make.left.equalTo(self.tableInfoImgV.mas_left).offset(0);
        make.height.mas_equalTo(270);
        make.width.mas_offset(200);
    }];
    
    self.stableIDLab = [SFLabel new];
    self.stableIDLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.stableIDLab.font = [UIFont systemFontOfSize:12];
    self.stableIDLab.text = @"台桌ID:VIP0018";
    self.stableIDLab.layer.cornerRadius = 5;
    self.stableIDLab.backgroundColor = [UIColor colorWithHexString:@"#201f24"];
    [self.tableInfoV addSubview:self.stableIDLab];
    [self.stableIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoV).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.xueciLab = [UILabel new];
    self.xueciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xueciLab.font = [UIFont systemFontOfSize:12];
    self.xueciLab.text = @"靴次:1";
    [self.tableInfoV addSubview:self.xueciLab];
    [self.xueciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stableIDLab.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.puciLab = [UILabel new];
    self.puciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.puciLab.font = [UIFont systemFontOfSize:12];
    self.puciLab.text = @"铺次:10";
    [self.tableInfoV addSubview:self.puciLab];
    [self.puciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.zhuangBorderV = [UIView new];
    self.zhuangBorderV.layer.cornerRadius = 2;
    self.zhuangBorderV.backgroundColor = [UIColor clearColor];
    self.zhuangBorderV.layer.borderWidth = 0.5;
    self.zhuangBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.zhuangBorderV];
    [self.zhuangBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.puciLab.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(28);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.zhuangInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.zhuangInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.zhuangInfoBtn setTitle:@"B.庄" forState:UIControlStateNormal];
    [self.zhuangInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateNormal];
    [self.zhuangInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateHighlighted];
    [self.zhuangBorderV addSubview:self.zhuangInfoBtn];
    [self.zhuangInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.zhuangBorderV).offset(0);
        make.width.mas_equalTo((200-40)/2+20);
    }];
    
    self.zhuangInfoLab = [UILabel new];
    self.zhuangInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.zhuangInfoLab.font = [UIFont systemFontOfSize:12];
    self.zhuangInfoLab.text = @"6";
    self.zhuangInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.zhuangBorderV addSubview:self.zhuangInfoLab];
    [self.zhuangInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zhuangInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.zhuangBorderV);
        make.width.mas_equalTo((200-40)/2-20);
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
        make.height.mas_equalTo(28);
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
        make.width.mas_equalTo((200-40)/2+20);
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
        make.width.mas_equalTo((200-40)/2-20);
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
        make.height.mas_equalTo(28);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.sixWinInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sixWinInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.sixWinInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.sixWinInfoBtn setTitle:@"B.6点赢" forState:UIControlStateNormal];
    [self.sixWinInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateNormal];
    [self.sixWinInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateHighlighted];
    [self.sixWinBorderV addSubview:self.sixWinInfoBtn];
    [self.sixWinInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.sixWinBorderV).offset(0);
        make.width.mas_equalTo((200-40)/2+20);
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
        make.width.mas_equalTo((200-40)/2-20);
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
        make.height.mas_equalTo(28);
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
        make.width.mas_equalTo((200-40)/2+20);
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
        make.width.mas_equalTo((200-40)/2-20);
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
        make.height.mas_equalTo(28);
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
        make.width.mas_equalTo((200-40)/2+20);
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
        make.width.mas_equalTo((200-40)/2-20);
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
        make.height.mas_equalTo(28);
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
        make.width.mas_equalTo((200-40)/2+20);
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
        make.width.mas_equalTo((200-40)/2-20);
    }];
    
    //露珠信息
    self.luzhuImgV = [UIImageView new];
    self.luzhuImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self.automaticShowView addSubview:self.self.luzhuImgV];
    [self.luzhuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.automaticShowView).offset(20);
        make.right.equalTo(self.tableInfoImgV.mas_left).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_offset(kScreenWidth-15-200);
    }];
    
    self.luzhuInfoLab = [UILabel new];
    self.luzhuInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.luzhuInfoLab.font = [UIFont systemFontOfSize:14];
    self.luzhuInfoLab.text = @"露珠信息Dew information";
    [self.automaticShowView addSubview:self.luzhuInfoLab];
    [self.luzhuInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luzhuImgV.mas_top).offset(8);
        make.left.equalTo(self.luzhuImgV.mas_left).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.luzhuCollectionView = [UIView new];
    self.luzhuCollectionView.backgroundColor = [UIColor whiteColor];
    [self.automaticShowView addSubview:self.luzhuCollectionView];
    [self.luzhuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luzhuImgV.mas_bottom).offset(0);
        make.left.right.equalTo(self.luzhuImgV).offset(0);
        make.height.mas_equalTo(270);
    }];
    
    [self.luzhuCollectionView addSubview:self.solidView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self topBarSetUp];
    
    self.xueciCount = 1;
    self.puciCount = 0;
    self.chipUIDData = [NSMutableData data];
    self.BLEDataList = [NSMutableArray arrayWithCapacity:0];
    self.BLEUIDDataList = [NSMutableArray arrayWithCapacity:0];
    self.BLEUIDDataHasPayList = [NSMutableArray array];
    self.BLEDataHasPayList = [NSMutableArray array];
    self.BLEUIDDataShuiqianList = [NSMutableArray array];
    self.BLEDataShuiqianList = [NSMutableArray array];
    self.BLEUIDDataTipList = [NSMutableArray array];
    self.BLEDataTipList = [NSMutableArray array];
    
    self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
    self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
    self.curChipInfo = [[NRChipInfoModel alloc]init];
    self.serialnumber = [NSString stringWithFormat:@"%ld",(long)[NRCommand getRandomNumber:100000 to:1000000]];
    self.viewModel.curupdateInfo.cp_result = @"-1";
    self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
    
    self.hasChipRead = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    self.winOrLose = NO;
    self.winColor = @"#357522";
    self.loseColor = @"#b0251d";
    self.normalColor = @"#ffffff";
    self.buttonNormalColor = @"#1c1c1c";
    self.customerInfo = [[NRCustomerInfo alloc]init];
    self.customerInfo.tipsTitle = [NSString stringWithFormat:@"提示信息\n%@",[EPStr getStr:kEPTipsInfo note:@"提示信息"]];
    self.customerInfo.tipsInfo = [NSString stringWithFormat:@"请认真核对以上信息，确认是否进行下一步操作\n%@",[EPStr getStr:kEPNextTips note:@"请认真核对以上信息，确认是否进行下一步操作"]];
    self.customerInfo.isWinOrLose = NO;
    
    self.resultInfo = [[NRChipResultInfo alloc]init];
    
    //默认显示自动版本视图
    [self.view addSubview:self.automaticShowView];
    [self.view addSubview:self.manuaManagerView];
    
    [self changeLanguageWithType:NO];
}

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    [self.titleBar setTitle:@"VM娱乐桌面跟踪系统"];
    self.titleBar.hidden = YES;
    [self setLeftItemForGoBack];
    self.titleBar.rightItem = nil;
    self.titleBar.showBottomLine = NO;
    self.titleBar.leftItem = nil;
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark -顶部top事件
- (void)moreOptionAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.optionArrowImg.image = [UIImage imageNamed:@"moreOptionsArrow_p"];
        [UIView animateWithDuration:0.2 animations:^{
            [self hideOrShowMenuButton:NO];
            self.coverBtn.hidden = NO;
            self.menuView.height = 250;
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

- (void)menuAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1:{
            if ([self.changeChipBtn.titleLabel.text isEqualToString:@"切换手动版"]) {
                [self.changeChipBtn setTitle:@"切换自动版" forState:UIControlStateNormal];
                self.manuaManagerView.hidden = NO;
                self.automaticShowView.hidden = YES;
            }else{
                [self.changeChipBtn setTitle:@"切换手动版" forState:UIControlStateNormal];
                self.manuaManagerView.hidden = YES;
                self.automaticShowView.hidden = NO;
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
            break;
        case 6://查看台面数据
            [[UIApplication sharedApplication].keyWindow addSubview:self.tableDataInfoV];
            break;
        case 7://台面加减彩
            break;
        default:
            break;
    }
    [self coverAction];
}

- (void)hideOrShowMenuButton:(BOOL)hide{
    self.changeChipBtn.hidden = hide;
    self.changeLanguageBtn.hidden = hide;
    self.huanbanBtn.hidden = hide;
    self.changeTableBtn.hidden = hide;
    self.queryNoteBtn.hidden = hide;
    self.queryTableInfoBtn.hidden = hide;
    self.jiaCaiBtn.hidden = hide;
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

//识别水钱
- (void)identifyWaterMoney{
    self.isDashui = NO;
    [self winInfoShow];
}

- (void)showInfoStatusWith:(BOOL)isWin{
    self.customerInfo.isWinOrLose = isWin;
}

#pragma mark - 还原选择结果按钮状态
- (void)researtResultButtonStatus{
    self.hasChipRead = NO;
    [self.zhuang_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.xian_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.zhuangduizi_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.xianduizi_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.he_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.baoxian_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.zhuangsix_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.luckysix_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
}

- (void)lookLuzhuAction{
    [EPSound playWithSoundName:@"click_sound"];
    [self showWaitingView];
    [self.viewModel getLuzhuWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self hideWaitingView];
        if (success) {
            //UIcollectionview 默认样式
            [self solidItemView];
            self.solidItemView.dataArray = self.viewModel.luzhuUpList;
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

-(JhPageItemView *)solidItemView{
    if (!_solidItemView) {
        
        CGRect femwe =  CGRectMake(0, 60, kScreenWidth-40, 300);
        JhPageItemView *view =  [[JhPageItemView alloc]initWithFrame:femwe];
        view.backgroundColor = [UIColor whiteColor];
        self.solidItemView = view;
    }
    return _solidItemView;
}

#pragma mark - 日结
- (void)daliyAction{
    [EPSound playWithSoundName:@"click_sound"];
    NFPopupTextContainView *customView = [[NFPopupTextContainView alloc] init];
    DSHPopupContainer *container = [[DSHPopupContainer alloc] initWithCustomPopupView:customView];
    container.maskColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    [container show];
    @weakify(self);
    customView.sureButtonClickedCompleted = ^(NSString * _Nonnull adminName, NSString * _Nonnull adminPassword) {
        @strongify(self);
        [self showWaitingView];
        DLOG(@"adminName====%@",adminName);
        self.viewModel.curupdateInfo.femp_num = adminName;
        self.viewModel.curupdateInfo.femp_pwd = adminPassword;
        self.viewModel.curupdateInfo.fhg_id = self.viewModel.loginInfo.fid;
        [self.viewModel commitDailyWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
            [self hideWaitingView];
            if (success) {
                [EPSound playWithSoundName:@"succeed_sound"];
                [self showMessage:@"日结成功"];
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
    };
}

- (void)winInfoShow{
    NSString *realCashMoney = self.curChipInfo.chipDenomination;
    self.viewModel.curupdateInfo.cp_commission = [NSString stringWithFormat:@"%.f",self.result_yj*[realCashMoney floatValue]];
    CGFloat real_beishu = self.result_odds-self.result_yj;
    self.customerInfo.compensateMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPRealpay note:@"实赔"],real_beishu*[realCashMoney floatValue]+self.identifyValue];
    self.customerInfo.compensateCode = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPCompensate note:@"应赔"],real_beishu*[realCashMoney floatValue]];
    self.customerInfo.totalMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPAllChip note:@"总码"],real_beishu*[realCashMoney floatValue]+self.identifyValue];
    self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPDashui note:@"打水"],self.identifyValue];
    self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",(real_beishu+1)*[realCashMoney floatValue]];
    self.resultShowView.drawWaterMoneyLab.text = self.customerInfo.drawWaterMoney;
    self.resultShowView.compensateMoneyLab.text = self.customerInfo.compensateMoney;
    self.resultShowView.totalMoneyLab.text = self.customerInfo.totalMoney;
    self.resultShowView.totalMoneyLab.text = self.customerInfo.compensateMoney;
}

#pragma mark - 计算赔率或者杀注金额
- (void)caclulateMoney{
    if (self.winOrLose) {
        [self winInfoShow];
    }else{
        self.viewModel.curupdateInfo.cp_commission = @"0";
        NSString *realCashMoney = self.curChipInfo.chipDenomination;
        self.customerInfo.xiazhu = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPBetch note:@"下注"],realCashMoney];
        self.customerInfo.shazhu = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPshouldShazhu note:@"应杀注"],realCashMoney];
        self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"应加赔:0"];
        self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",[realCashMoney floatValue]];
    }
}

#pragma mark - 结果按钮触发事件
- (void)resultBtnAction:(UIButton *)btn{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.puciCount==0) {
        [self showMessage:@"请先录入结果"];
        return;
    }
    if (btn.tag==5) {//保险
        [self btnBackGroundColorWithBtntag:btn.tag];
    }else if (btn.tag==7){//幸运6点
        if ([self.retultList containsObject:@"庄赢"]) {
            self.winOrLose = YES;
        }else{
            self.winOrLose = NO;
        }
        [self btnBackGroundColorWithBtntag:btn.tag];
    }else{
        //赔率
        NSArray *xz_array = self.viewModel.gameInfo.xz_setting;
        if (xz_array.count!=0&&xz_array.count>btn.tag) {
            self.result_odds = [xz_array[btn.tag][@"fpl"] floatValue];
            self.result_yj = [xz_array[btn.tag][@"fyj"] floatValue]/100;
        }
        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.result_odds];
        //庄
        if (btn.tag==0) {
            if ([self.retultList containsObject:@"庄赢"]) {
                self.winOrLose = YES;
            }else{
                if (self.retultList.count==2&&[self.retultList containsObject:@"庄对"]&&[self.retultList containsObject:@"闲对"]) {
                    self.winOrLose = YES;
                }else{
                    self.winOrLose = NO;
                }
            }
        }else if (btn.tag==1){//闲
            if ([self.retultList containsObject:@"闲赢"]) {
                self.winOrLose = YES;
            }else{
                self.winOrLose = NO;
            }
        }else if (btn.tag==2){//庄对子
            if ([self.retultList containsObject:@"庄对"]) {
                self.winOrLose = YES;
            }else{
                self.winOrLose = NO;
            }
        }else if (btn.tag==3){//闲对子
            if ([self.retultList containsObject:@"闲对"]) {
                self.winOrLose = YES;
            }else{
                self.winOrLose = NO;
            }
        }else if (btn.tag==4){//和
            if ([self.retultList containsObject:@"和局"]) {
                self.winOrLose = YES;
            }else{
                self.winOrLose = NO;
            }
        }else if (btn.tag==6){//庄6点
            if ([self.retultList containsObject:@"庄赢"]) {
                self.winOrLose = YES;
            }else{
                self.winOrLose = NO;
            }
        }
        [self showInfoStatusWith:self.winOrLose];
        [self btnBackGroundColorWithBtntag:btn.tag];
        [self queryDeviceChips];
    }
}

#pragma mark - 根据结果设置按钮背景颜色
- (void)btnBackGroundColorWithBtntag:(int)btnTag{
    if (btnTag==0) {//庄
        self.isBaoxian = NO;
        self.isLucky = NO;
        if (self.winOrLose) {
            [self.zhuang_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n庄赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"庄赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.zhuang_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n庄输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"庄输";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.zhuang_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    }
    if (btnTag==1){//闲
        self.isBaoxian = NO;
        self.isLucky = NO;
        if (self.winOrLose) {
            [self.xian_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n闲赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"闲赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.xian_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n闲输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"闲输";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.xian_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    }
    
    if (btnTag==2){//庄对
        self.isBaoxian = NO;
        self.isLucky = NO;
        if (self.winOrLose) {
            [self.zhuangduizi_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
            self.customerInfo.winStatus =[NSString stringWithFormat:@"%@:\n庄对子赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"庄对子";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.zhuangduizi_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n庄对子输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"庄对子";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.zhuangduizi_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    }
    
    if (btnTag==3){//闲对
        self.isBaoxian = NO;
        self.isLucky = NO;
        if (self.winOrLose) {
            [self.xianduizi_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n闲对子赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"闲对子";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.xianduizi_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n闲对子输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"闲对子";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.xianduizi_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    }
    
    if (btnTag==4){//和
        self.isBaoxian = NO;
        self.isLucky = NO;
        if (self.winOrLose) {
            [self.he_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n和赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"和";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.he_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n和输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"和";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.he_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    }
    
    if (btnTag==5){//保险
        self.isBaoxian = YES;
        self.isLucky = NO;
        self.resultInfo.firstName = [EPStr getStr:kEPWin note:@"赢"];
        self.resultInfo.firstColor = @"#b0251d";
        self.resultInfo.secondName = [EPStr getStr:kEPLose note:@"输"];
        self.resultInfo.secondColor = @"#7f8cc8";
        self.resultInfo.tips = [EPStr getStr:kEPChooseResult note:@"选择当前局开牌结果"];
        self.resultInfo.hasMore = 1;
        @weakify(self);
        [EPTigerShowView showInWindowWithNRChipResultInfo:self.resultInfo handler:^(int buttonTag) {
            @strongify(self);
            if (buttonTag==1) {
                self.winOrLose = YES;
            }else if (buttonTag==2){
                self.winOrLose = NO;
            }
            [self showInfoStatusWith:self.winOrLose];
            self.isBaoxian = YES;
            self.isLucky = NO;
            if (self.winOrLose) {
                [self.baoxian_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
                self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n保险赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
                self.viewModel.curupdateInfo.cp_name = @"保险";
                self.viewModel.curupdateInfo.cp_result = @"1";
                [EPPopView showEntryInView:self.view WithTitle:@"请输入赔率" handler:^(NSString *entryText) {
                    @strongify(self);
                    if ([[entryText NullToBlankString]length]!=0) {
                        self.result_odds = [entryText floatValue];
                        self.result_yj = 0;
                        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",[entryText floatValue]];
                        [self queryDeviceChips];
                    }else{
                        [self showMessage:@"请输入赔率"];
                    }
                }];
            }else{
                self.result_odds = 1;
                [self.baoxian_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];;
                self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n保险输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
                self.viewModel.curupdateInfo.cp_name = @"保险";
                self.viewModel.curupdateInfo.cp_result = @"-1";
                [self queryDeviceChips];
            }
        }];
    }else{
        [self.baoxian_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    }
    if (btnTag==7){//幸运6点
        self.isBaoxian = NO;
        self.isLucky = YES;
        [self showInfoStatusWith:self.winOrLose];
        if (self.winOrLose) {
            [self.luckysix_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n幸运6点赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"幸运6点";
            self.viewModel.curupdateInfo.cp_result = @"1";
            @weakify(self);
            [EPPopView showEntryInView:self.view WithTitle:@"请输入赔率" handler:^(NSString *entryText) {
                @strongify(self);
                if ([[entryText NullToBlankString]length]!=0) {
                    self.result_odds = [entryText floatValue];
                    self.result_yj = 0;
                    self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",[entryText floatValue]];
                    [self queryDeviceChips];
                }else{
                    [self showMessage:@"请输入赔率"];
                }
            }];
        }else{
            self.result_odds = 1;
            [self.luckysix_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n幸运6点输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"幸运6点";
            self.viewModel.curupdateInfo.cp_result = @"-1";
            [self queryDeviceChips];
        }
    }else{
        [self.luckysix_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    }
    
    if (btnTag==6){//庄6点
        self.isBaoxian = NO;
        self.isLucky = NO;
        if (self.winOrLose) {
            [self.zhuangsix_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n庄6点赢赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"庄6点赢赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.zhuangsix_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n庄6点赢输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"庄6点赢输";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.zhuangsix_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    }
    
}

#pragma mark - 更换靴次
- (void)changexueciAction{
    [EPSound playWithSoundName:@"click_sound"];
    [EPPopView showInWindowWithMessage:[NSString stringWithFormat:@"确定更换靴次？\n%@",[EPStr getStr:kEPComfirmChangeXueci note:@"确定更换靴次？"]] handler:^(int buttonType) {
        if (buttonType==0) {
            self.xueciCount +=1;
//            self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
//            if (self.xueciCount<10) {
//                self.xueciLab.text = [NSString stringWithFormat:@"靴次:0%d",self.xueciCount];
//            }
            [self showLognMessage:[EPStr getStr:kEPChangeXueciSucceed note:@"更换靴次成功"]];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
        }
    }];
}

- (void)changeLanguageWithType:(BOOL)isEnglish{
    [EPSound playWithSoundName:@"click_sound"];
    if (isEnglish) {
        [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:0];
    }else{
        [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:1];
    }
    [self.moreOptionButton setTitle:@"更多选项\nMoreOptions" forState:UIControlStateNormal];
    [self.changexueci_button setTitle:[NSString stringWithFormat:@"换靴\n%@",[EPStr getStr:kEPChangeXueci note:@"换靴"]] forState:UIControlStateNormal];
    [self.updateLuzhu_button setTitle:[NSString stringWithFormat:@"查看露珠\n%@",[EPStr getStr:kEPLookluzhu note:@"查看露珠"]] forState:UIControlStateNormal];
    [self.daily_button setTitle:[NSString stringWithFormat:@"日结\n%@",[EPStr getStr:kEPDaily note:@"日结"]] forState:UIControlStateNormal];
    [self.nextGame_button setTitle:[NSString stringWithFormat:@"新一局\n%@",[EPStr getStr:kEPNewGame note:@"新一局"]] forState:UIControlStateNormal];
    [self.zhuxiaochouma_button setTitle:[NSString stringWithFormat:@"注销筹码\n%@",[EPStr getStr:kEPCancellationChip note:@"注销筹码"]] forState:UIControlStateNormal];
    [self.readChipMoney_button setTitle:[NSString stringWithFormat:@"识别筹码金额\n%@",[EPStr getStr:kEPReadChipMoney note:@"识别筹码金额"]] forState:UIControlStateNormal];
    [self.zhuang_button setTitle:[EPStr getStr:kEPZhuang note:@"庄"] forState:UIControlStateNormal];
    [self.xian_button setTitle:[EPStr getStr:kEPXian note:@"闲"] forState:UIControlStateNormal];
    [self.zhuangduizi_button setTitle:[EPStr getStr:kEPZhuangDuizi note:@"庄对子"] forState:UIControlStateNormal];
    [self.aTipRecordButton setTitle:[NSString stringWithFormat:@"记录小费\n%@",[EPStr getStr:kEPRecordTipsFee note:@"记录小费"]] forState:UIControlStateNormal];
    [self.xianduizi_button setTitle:[EPStr getStr:kEPXianDuizi note:@"闲对子"] forState:UIControlStateNormal];
    [self.baoxian_button setTitle:[EPStr getStr:kEPBaoxian note:@"保险"] forState:UIControlStateNormal];
    [self.zhuangsix_button setTitle:[EPStr getStr:kEPZhuangSixWin note:@"庄6点赢"] forState:UIControlStateNormal];
    [self.luckysix_button setTitle:[EPStr getStr:kEPSixWin note:@"幸运6点"] forState:UIControlStateNormal];
    [self.he_button setTitle:[EPStr getStr:kEPHe note:@"和"] forState:UIControlStateNormal];
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
            [EPPopView showInWindowWithMessage:[NSString stringWithFormat:@"确定输入正确的洗码号?\n%@",[EPStr getStr:kEPBindChipConfirm note:@"确定输入正确的洗码号?"]] handler:^(int buttonType) {
                if (buttonType==0) {
                    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
                    dispatch_async(serialQueue, ^{
                        for (int i = 0; i < self.chipUIDList.count; i++) {
                        self.curChipInfo.guestWashesNumber = entryText;
                        self.curChipInfo.chipUID = self.chipUIDList[i];
                        //向指定标签中写入数据（块1）
                        [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                        usleep(20 * 1000);
                        }
                    });
                    [self showLognMessage:[EPStr getStr:kEPBindChipSucceed note:@"绑定成功"]];
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
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    NSString *chipUID = self.chipUIDList[i];
                    //向指定标签中写入数据（块1）
                    [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                    usleep(20 * 2000);
                    
                }
            });
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

#pragma mark - 展示结果信息
- (void)showStatusInfo{
    
    self.viewModel.curupdateInfo.cp_washNumber = self.curChipInfo.guestWashesNumber;
    self.viewModel.curupdateInfo.cp_benjin = self.curChipInfo.chipDenomination;
    self.isShowingResult = YES;
    [self caclulateMoney];
    @weakify(self);
    self.resultShowView = [EPPopAlertShowView showInWindowWithNRCustomerInfo:self.customerInfo handler:^(int buttonType) {
        DLOG(@"buttonType===%d",buttonType);
        @strongify(self);
        [EPSound playWithSoundName:@"click_sound"];
        if (buttonType==1) {
            if ([self.curChipInfo.guestWashesNumber isEqualToString:@"0"]) {
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
                [self showMessage:@"筹码未绑定洗码号"];
            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self showWaitingView];
//                });
                if (self.winOrLose) {
                    [self getPayChipsUIDList];
                }else{
                    [self payChipMoney];
                }
            }
        }else if (buttonType==2){//水钱识别
            self.isDashui = YES;
            [self getShuiqianChipsUIDList];
        }else if (buttonType==0){
            self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
            self.identifyValue = 0;
            self.isShowingResult = NO;
            [self clearChipCacheData];
            self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
            [self researtResultButtonStatus];
        }
    }];
}

- (void)payChipMoney{
    NSMutableArray *realChipUIDList = [NSMutableArray array];
    [realChipUIDList addObjectsFromArray:self.chipUIDList];
    [realChipUIDList addObjectsFromArray:self.payChipUIDList];
    self.viewModel.curupdateInfo.cp_chipType = self.curChipInfo.chipType;
    self.viewModel.curupdateInfo.cp_ChipUidList = realChipUIDList;
    @weakify(self);
    [self.viewModel commitCustomerRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        [self hideWaitingView];
        if (success) {
            self.hasChipRead = NO;
            //重新生成台桌流水号
            self.serialnumber = [NSString stringWithFormat:@"%ld",(long)[NRCommand getRandomNumber:100000 to:1000000]];
            self.isShowingResult = NO;
            [self.resultShowView _hide];
            if (self.winOrLose) {
                self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
                self.identifyValue = 0;
                dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
                dispatch_async(serialQueue, ^{
                    for (int i = 0; i < realChipUIDList.count; i++) {
                        self.curChipInfo.chipUID = realChipUIDList[i];
                        //向指定标签中写入数据（块1）
                        [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                        usleep(20 * 2000);
                    }
                    //清除水钱
                    for (int i=0; i<self.shuiqianChipUIDList.count; i++) {
                        for (int i = 0; i < self.shuiqianChipUIDList.count; i++) {
                            NSString *chipUID = self.shuiqianChipUIDList[i];
                            //向指定标签中写入数据（块1）
                            [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                            usleep(20 * 1000);
                        }
                    }
                    self.chipUIDList = nil;
                    self.payChipUIDList = nil;
                    self.shuiqianChipUIDList = nil;
                });
                [self showMessage:@"赔付成功"];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
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
                [self showMessage:[EPStr getStr:kEPShazhuSucceed note:@"杀注成功"]];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isShowingResult = NO;
                self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
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

#pragma mark - 清除筹码数据
- (void)clearChipCacheData{
    self.payChipUIDList = nil;
    self.tipChipUIDList = nil;
    [self.BLEDataHasPayList removeAllObjects];
    [self.BLEUIDDataHasPayList removeAllObjects];
}

#pragma mark - 新一局
- (void)newGameAction{
    self.resultInfo.firstName = [EPStr getStr:kEPZhuangWin note:@"庄赢"];
    self.resultInfo.firstColor = @"#b0251d";
    self.resultInfo.secondName = [EPStr getStr:kEPXianWin note:@"闲赢"];
    self.resultInfo.secondColor = @"#7f8cc8";
    self.resultInfo.thirdName = [EPStr getStr:kEPHeju note:@"和局"];
    self.resultInfo.thirdColor = @"#4d9738";
    self.resultInfo.forthName = [EPStr getStr:kEPZhuangDui note:@"庄对"];
    self.resultInfo.forthColor = @"#b0251d";
    self.resultInfo.fiveName = [EPStr getStr:kEPXianDui note:@"闲对"];
    self.resultInfo.fiveColor = @"#7f8cc8";
    self.resultInfo.tips = [NSString stringWithFormat:@"选择当前局开牌结果\n%@",[EPStr getStr:kEPChooseResult note:@"选择当前局开牌结果"]];
    self.resultInfo.hasMore = 3;
    
    @weakify(self);
    [EPPopView showInWindowWithMessage:[NSString stringWithFormat:@"是否确定开启新一局？\n%@",[EPStr getStr:kEPSureNextGame note:@"确定开启新一局？"]] handler:^(int buttonType) {
        @strongify(self);
        if (buttonType==0) {
            [EPResultShowView showInWindowWithNRChipResultInfo:self.resultInfo handler:^(NSArray * resultArray) {
                DLOG(@"resultArray = %@",resultArray);
                self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
                self.retultList = [NSMutableArray arrayWithCapacity:0];
                for (int i=0; i<resultArray.count; i++) {
                    NSInteger tagResult = [resultArray[i]integerValue];
                    if (tagResult==1) {
                        [self.retultList addObject:@"庄赢"];
                    }else if (tagResult==2){
                        [self.retultList addObject:@"闲赢"];
                    }else if (tagResult==3){
                        [self.retultList addObject:@"和局"];
                    }else if (tagResult==4){
                        [self.retultList addObject:@"庄对"];
                    }else if (tagResult==5){
                        [self.retultList addObject:@"闲对"];
                    }
                }
                NSString *resultname = [self.retultList componentsJoinedByString:@","];
                self.viewModel.curupdateInfo.cp_name = resultname;
                self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
                self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
                self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
                self.puciCount +=1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showWaitingView];
                });
                @weakify(self);
                [self.viewModel commitkpResultWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                    @strongify(self);
                    [self hideWaitingView];
                    if (success) {
//                        self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
//                        if (self.puciCount<10) {
//                            self.puciLab.text = [NSString stringWithFormat:@"铺次:0%d",self.puciCount];
//                        }
                        [self showMessage:[EPStr getStr:kEPResultCacheSucceed note:@"结果录入成功"]];
                        //响警告声音
                        [EPSound playWithSoundName:@"succeed_sound"];
                    }else{
                        self.puciCount -=1;
                        NSString *messgae = [msg NullToBlankString];
                        if (messgae.length == 0) {
                            messgae = @"网络异常";
                        }
                        [self showMessage:messgae];
                    }
                }];
            }];
        }
    }];
}
#pragma mark - 查询设备上的筹码UID
- (void)queryDeviceChips{
    [EPSound playWithSoundName:@"click_sound"];
    //执行读取命令
    [self.BLEDataList removeAllObjects];
    [self.BLEUIDDataList removeAllObjects];
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 识别筹码金额
- (void)readCurChipsMoney{
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
                    usleep(20 * 2000);
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
            usleep(20 * 2000);
        }
    }else{
        [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
    }
}

#pragma mark - 读取水钱筹码信息
- (void)getShuiqianChipsUIDList{
    [EPSound playWithSoundName:@"click_sound"];
    //执行读取命令
    [self.BLEDataShuiqianList removeAllObjects];
    [self.BLEUIDDataShuiqianList removeAllObjects];
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 读取小费筹码信息
- (void)readAllShuiqianChipsInfo{
    //向指定标签中写入数据（所有块）
    if (self.shuiqianChipUIDList.count != 0) {
        for (int i = 0; i < self.shuiqianChipUIDList.count; i++) {
            NSString *chipID = self.shuiqianChipUIDList[i];
            [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
            usleep(20 * 2000);
        }
    }else{
        [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
    }
}

#pragma mark - GCDAsyncSocketDelegate
//连接主机对应端口
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
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
    if ([dataHexStr containsString:@"040000525a"]) {
        self.chipUIDData = nil;
    }
    [self.chipUIDData appendData:data];
    if (([dataHexStr containsString:@"04000e2cb3"]&&dataHexStr.length>10)||[dataHexStr isEqualToString:@"04000e2cb3"]) {
        NSMutableArray *array = [NRCommand convertDataToHexStr:self.chipUIDData];
        self.chipUIDData = nil;
        if (array.count>1) {
            if ([array[0] isEqualToString:@"0d"]) {
                if (self.isShowingResult) {
                    if (self.isDashui){//识别水钱
                        [self.BLEUIDDataShuiqianList addObjectsFromArray:array];
                        BLEIToll *itool = [[BLEIToll alloc]init];
                        NSString *BLEString = [itool dataStringFromArray:self.BLEUIDDataShuiqianList];
                        //存贮筹码UID
                        self.shuiqianChipUIDList =[itool getDeviceALlShuiqianChipUIDWithBLEString:BLEString WithUidList:self.chipUIDList];
                        self.shuiqianChipCount = self.shuiqianChipUIDList.count;
                        if (self.shuiqianChipCount==0) {
                            self.shuiqianChipUIDList = nil;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showLognMessage:@"未检测到赔付筹码"];
                                //响警告声音
                                [EPSound playWithSoundName:@"wram_sound"];
                            });
                        }else{
                            self.viewModel.curupdateInfo.cp_DashuiUidList = self.shuiqianChipUIDList;
                            [self readAllShuiqianChipsInfo];
                        }
                    }else{
                        [self.BLEUIDDataHasPayList addObjectsFromArray:array];
                        BLEIToll *itool = [[BLEIToll alloc]init];
                        NSString *BLEString = [itool dataStringFromArray:self.BLEUIDDataHasPayList];
                        //存贮筹码UID
                        self.payChipUIDList = [itool getDeviceALlPayChipUIDWithBLEString:BLEString WithUidList:self.chipUIDList WithShuiqianUidList:self.shuiqianChipUIDList];
                        self.payChipCount = self.payChipUIDList.count;
                        if (self.payChipCount==0) {
                            self.payChipUIDList = nil;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showLognMessage:@"未检测到赔付筹码"];
                                //响警告声音
                                [EPSound playWithSoundName:@"wram_sound"];
                            });
                        }else{
                            [self readAllPayChipsInfo];
                        }
                    }
                }else if (self.isRecordTipMoney){//记录小费
                    [self.BLEUIDDataTipList addObjectsFromArray:array];
                    BLEIToll *itool = [[BLEIToll alloc]init];
                    NSString *BLEString = [itool dataStringFromArray:self.BLEUIDDataTipList];
                    //存贮筹码UID
                    self.tipChipUIDList = [itool getDeviceALlTipsChipUIDWithBLEString:BLEString];
                    self.tipChipCount = self.tipChipUIDList.count;
                    if (self.tipChipCount==0) {
                        self.tipChipUIDList = nil;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.recordTipShowView.compensateMoneyLab.text = [NSString stringWithFormat:@"小费金额:%d",0];
                            self.recordTipShowView.guestNumberLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPWashNumber note:@"客人洗码号"],@"#"];
                            [self showLognMessage:@"未检测到赔付筹码"];
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
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
                        self.chipUIDList = [itool getDeviceAllChipUIDWithBLEString:BLEString];
                        self.chipCount = self.chipUIDList.count;
                        DLOG(@"self.chipCount = %ld",(long)self.chipCount);
                        if (self.chipCount==0) {
                            [self.BLEUIDDataList removeAllObjects];
                            [self.BLEDataList removeAllObjects];
                            self.hasChipRead = NO;
                            self.chipUIDList = nil;
                            [self researtResultButtonStatus];
                        }else{
                            [self readCurChipsMoney];
                        }
                    }
                }
            }else{
                self.isShowingResult = NO;
                self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
                [self researtResultButtonStatus];
                [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
                
            }
        }
    }else if ([dataHexStr hasPrefix:@"13000000"]){
        //展示结果之后
        if (self.isShowingResult) {
            if (!self.isDashui) {//识别赔付筹码
                NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
                NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"13000000" // 要查询的字符串中的某个字符
                                                                                      withString:@"13000000"
                                                                                         options:NSLiteralSearch
                                                                                           range:NSMakeRange(0, [chipNumberdataHexStr length])];
                if (count==self.payChipCount) {
                    NSMutableArray *array = [NRCommand convertDataToHexStr:self.chipUIDData];
                    self.chipUIDData = nil;
                    [self.BLEDataHasPayList addObjectsFromArray:array];
                    BLEIToll *itool = [[BLEIToll alloc]init];
                    NSString *realChipsInfoString = [itool dataStringFromArray:self.BLEDataHasPayList];
                    DLOG(@"read111ChipsInfoString = %@",realChipsInfoString);
                    NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:realChipsInfoString WithSplitSize:3];
                    DLOG(@"readchipInfo = %@",chipInfo);
                    //筹码额
                    __block int chipAllMoney = 0;
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                        chipAllMoney += [realmoney intValue];
                    }];
                    
                    NSMutableArray *washNumberList = [NSMutableArray array];
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![washNumberList containsObject:infoList[4]]) {
                            [washNumberList addObject:infoList[4]];
                        }
                    }];
                    if (washNumberList.count>1) {
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self showMessage:@"赔付筹码有误"];
                        int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                        self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",benjinMoney];
                        self.resultShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",[EPStr getStr:kEPPeifuChip note:@"已赔付筹码:"],0];
                    }else{
                        if ([washNumberList[0]isEqualToString:@"0"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                                self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",benjinMoney+chipAllMoney];
                            });
                            [self payChipMoney];
                        }else{
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
                            [self showMessage:@"赔付筹码有误"];
                            //                        int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                            self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",0];
                            self.resultShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",[EPStr getStr:kEPPeifuChip note:@"已赔付筹码:"],0];
                        }
                    }
                }
            }else{//识别水钱
                NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
                NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"13000000" // 要查询的字符串中的某个字符
                                                                                      withString:@"13000000"
                                                                                         options:NSLiteralSearch
                                                                                           range:NSMakeRange(0, [chipNumberdataHexStr length])];
                if (count==self.shuiqianChipCount) {
                    NSMutableArray *array = [NRCommand convertDataToHexStr:self.chipUIDData];
                    self.chipUIDData = nil;
                    [self.BLEDataShuiqianList addObjectsFromArray:array];
                    BLEIToll *itool = [[BLEIToll alloc]init];
                    NSString *realChipsInfoString = [itool dataStringFromArray:self.BLEDataShuiqianList];
                    DLOG(@"read222ChipsInfoString = %@",realChipsInfoString);
                    NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:realChipsInfoString WithSplitSize:3];
                    DLOG(@"readchipInfo = %@",chipInfo);
                    //客人洗码号
                    NSString *tipWashNumberChip = chipInfo[0][4];
                    if ([[tipWashNumberChip NullToBlankString]length]==0||[tipWashNumberChip isEqualToString:@"0"]) {
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self showMessage:@"筹码错误"];
                    }else{
                        //筹码额
                        __block int chipAllMoney = 0;
                        [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                            chipAllMoney += [realmoney intValue];
                        }];
                        //响警告声音
                        [EPSound playWithSoundName:@"succeed_sound"];
                        self.identifyValue = chipAllMoney;
                        [self identifyWaterMoney];
                    }
                }
            }
            
        }else if (self.isRecordTipMoney){//记录小费
            NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
            NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"13000000" // 要查询的字符串中的某个字符
                                                                                  withString:@"13000000"
                                                                                     options:NSLiteralSearch
                                                                                       range:NSMakeRange(0, [chipNumberdataHexStr length])];
            if (count==self.tipChipCount) {
                NSMutableArray *array = [NRCommand convertDataToHexStr:self.chipUIDData];
                self.chipUIDData = nil;
                [self.BLEDataTipList addObjectsFromArray:array];
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSString *realChipsInfoString = [itool dataStringFromArray:self.BLEDataTipList];
                DLOG(@"read222ChipsInfoString = %@",realChipsInfoString);
                NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:realChipsInfoString WithSplitSize:3];
                DLOG(@"readchipInfo = %@",chipInfo);
                //客人洗码号
                NSString *tipWashNumberChip = chipInfo[0][4];
                if ([[tipWashNumberChip NullToBlankString]length]==0||[tipWashNumberChip isEqualToString:@"0"]) {
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                    [self showMessage:@"筹码错误"];
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
                    [self showMessage:@"识别小费成功"];
                    //响警告声音
                    [EPSound playWithSoundName:@"succeed_sound"];
                    
                }
            }
        }else{
            //1.识别桌面筹码金额
            NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
            NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"13000000" // 要查询的字符串中的某个字符
                                                                                  withString:@"13000000"
                                                                                     options:NSLiteralSearch
                                                                                       range:NSMakeRange(0, [chipNumberdataHexStr length])];
            if (count==self.chipCount) {
                NSMutableArray *array = [NRCommand convertDataToHexStr:self.chipUIDData];
                [self.BLEDataList addObjectsFromArray:array];
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSString *realChipsInfoString = [itool dataStringFromArray:self.BLEDataList];
                DLOG(@"realChipsInfoString = %@",realChipsInfoString);
                self.chipUIDData = nil;
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
                        if ([[washNumber NullToBlankString]length]==0) {
                            self.hasChipRead = NO;
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
                            [self showMessage:@"检测到有异常洗码号的筹码"];
                        }else{
                            self.hasChipRead = YES;
                            //响警告声音
                            [EPSound playWithSoundName:@"succeed_sound"];
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
                            [self showStatusInfo];
                            [self hideWaitingView];
                        });
                    }
                }
            }
        }
    }
}

@end
