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

#import "ChipInfoView.h"

#import "EPWebViewController.h"

@interface NRTigerViewController ()<GCDAsyncSocketDelegate>

//台桌数据
@property (nonatomic, strong) TableDataInfoView *tableDataInfoV;

//授权验证
@property (nonatomic, strong) EmpowerView *empowerView;

//筹码信息
@property (nonatomic, strong) ChipInfoView *chipInfoView;

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
@property (nonatomic, strong) UIButton *updateWashNumberBtn;

//自动版视图
@property (nonatomic, strong) UIView *automaticShowView;
@property (nonatomic, strong) JXButton *zhuxiaochouma_button;
@property (nonatomic, strong) JXButton *readChip_button;
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


@property (nonatomic, assign) BOOL winOrLose;
@property (nonatomic, assign) BOOL isShaZhuAction;//是否杀注操作
@property (nonatomic, assign) BOOL isFirstEntryGame;//是否刚进入游戏

@property (nonatomic, assign) NSInteger bindChipCount;
@property (nonatomic, strong) NSArray *bindChipUIDList;
@property (nonatomic, assign) BOOL isBindChipWashNumber;//是否绑定洗码号
@property (nonatomic, assign) BOOL isBreakUpChip;//是否打散筹码

@property (nonatomic, assign) BOOL isUpdateChip;//是否操作筹码
@property (nonatomic, assign) BOOL isDasanChip;//是否打散筹码
@property (nonatomic, assign) int updateChipCount;//正在操作筹码的数量

@property (nonatomic, strong) NSMutableArray *washNumberList;//洗码号数据
@property (nonatomic, strong) NSMutableArray *chipTypeList;//筹码类型数据
@property (nonatomic, strong) NSMutableArray *shazhuInfoList;//杀注信息

@property (nonatomic, strong) UIButton *dragon_button;
@property (nonatomic, strong) UIButton *tiger_button;
@property (nonatomic, strong) UIButton *he_button;
@property (nonatomic, strong) NRCustomerInfo *customerInfo;

@property (nonatomic, assign) NSInteger chipCount;
@property (nonatomic, strong) NSArray *chipUIDList;
@property (nonatomic, assign) BOOL isUpdateWashNumber;//是否更改洗码号

@property (nonatomic, assign) NSInteger shuiqianChipCount;
@property (nonatomic, strong) NSArray *shuiqianChipUIDList;
@property (nonatomic, assign) BOOL isDashui;//是否打水
@property (nonatomic, assign) CGFloat identifyValue;//水钱

//是否识别筹码
@property (nonatomic, strong) NSMutableArray *chipInfoList;
@property (nonatomic, assign) BOOL isShowChipInfo;//是否在识别筹码
@property (nonatomic, strong) NRChipInfoModel *curChipInfo;

@property (nonatomic, assign) NSInteger payChipCount;
@property (nonatomic, strong) NSArray *payChipUIDList;
@property (nonatomic, assign) BOOL isShowingResult;//是否展示结果

@property (nonatomic, assign) NSInteger tipChipCount;
@property (nonatomic, strong) NSArray *tipChipUIDList;
@property (nonatomic, assign) BOOL isRecordTipMoney;//是否记录小费

@property (nonatomic, strong) NSString *serialnumber;//流水号
@property (nonatomic, strong) NSString *curBindChipWashNumber;//需要绑定筹码的洗码号
@property (nonatomic, assign) CGFloat odds;//倍数
@property (nonatomic, assign) CGFloat yj;//佣金
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
        [self.changeChipBtn setTitle:@"日结" forState:UIControlStateNormal];
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
        
        UIView *lineV9 = [UIView new];
        lineV9.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
        lineV9.alpha = 0.8;
        [self.openTableBtn addSubview:lineV9];
        [lineV9 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.openTableBtn).offset(0);
            make.left.equalTo(self.openTableBtn).offset(5);
            make.centerX.equalTo(self.openTableBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.updateWashNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.updateWashNumberBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.updateWashNumberBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.updateWashNumberBtn setTitle:@"修改洗码号" forState:UIControlStateNormal];
        self.updateWashNumberBtn.tag = 10;
        [self.updateWashNumberBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
        [self.updateWashNumberBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:self.updateWashNumberBtn];
        [self.updateWashNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.openTableBtn.mas_bottom).offset(5);
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
        [self.readChip_button addTarget:self action:@selector(readChipsAction) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.readChip_button];
        [self.readChip_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.zhuxiaochouma_button.mas_bottom).offset(22);
            make.left.equalTo(self.operateCenterView).offset(15);
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
    CGFloat setBtn_h = 45;
    self.dragonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dragonBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.dragonBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.dragonBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.dragonBtn.tag = 1;
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
    
    self.tigerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tigerBtn setTitleColor:[UIColor colorWithHexString:@"#1d3edd"] forState:UIControlStateNormal];
    [self.tigerBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.tigerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.tigerBtn.tag = 2;
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
    
    self.heBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#75e65c"] forState:UIControlStateNormal];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.heBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.heBtn.tag = 3;
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
    
    self.setmentOKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setmentOKBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.setmentOKBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.setmentOKBtn setTitle:@"OK.录入开牌结果" forState:UIControlStateNormal];
    [self.setmentOKBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateNormal];
    [self.setmentOKBtn addTarget:self action:@selector(resultEntryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.setmentOKBtn];
    [self.setmentOKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heBtn.mas_bottom).offset(10);
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
    self.stableIDLab.text = [NSString stringWithFormat:@"台桌ID:%@",self.viewModel.curTableInfo.ftbname];
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
    self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
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

- (ChipInfoView *)chipInfoView{
    if (!_chipInfoView) {
        _chipInfoView = [[[NSBundle mainBundle]loadNibNamed:@"ChipInfoView" owner:nil options:nil]lastObject];
        _chipInfoView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _chipInfoView;
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

-(JhPageItemView *)solidItemView{
    if (!_solidItemView) {
        CGRect femwe =  CGRectMake(0, 0, kScreenWidth-30-156-249, 231);
        JhPageItemView *view =  [[JhPageItemView alloc]initWithFrame:femwe];
        view.backgroundColor = [UIColor whiteColor];
        self.solidItemView = view;
    }
    return _solidItemView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    [self topBarSetUp];
    [self _initParams];
    
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
    [self.solidItemView fellLuzhuListWithDataList:self.viewModel.luzhuUpList];
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
    [self showWaitingViewWithText:@"露珠加载中..."];
    [self getBaseTableInfoAndLuzhuInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
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

#pragma mark --初始化一些参数信息
- (void)_initParams{
    self.resultInt=0;
    self.xueciCount = 1;
    self.puciCount = 0;
    self.prePuciCount = 1;
    self.isAutomicGame = YES;
    self.chipUIDData = [NSMutableData data];
    self.washNumberList = [NSMutableArray arrayWithCapacity:0];
    self.chipTypeList = [NSMutableArray arrayWithCapacity:0];
    self.shazhuInfoList = [NSMutableArray arrayWithCapacity:0];
    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    self.curChipInfo = [[NRChipInfoModel alloc]init];
    self.customerInfo = [[NRCustomerInfo alloc]init];
    self.serialnumber = [NRCommand randomStringWithLength:30];
    int  curXueciValue = [[LYKeychainTool readKeychainValue:[NSString stringWithFormat:@"%@_Xueci",self.viewModel.curTableInfo.fid]]intValue];
    if (curXueciValue!=0) {
        self.viewModel.curXueci = curXueciValue;
        self.xueciCount = curXueciValue;
    }
    self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
    [self fellCustomerInfo];
}

#pragma mark --获取露珠信息和当前台桌基础信息
- (void)getBaseTableInfoAndLuzhuInfo{
    self.isFirstEntryGame = YES;
    [self.viewModel getLastXueCiInfoWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self getLuzhuInfoList];
    }];
}

#pragma mark - 根据开出结果改变按钮状态
- (void)_setResultBtnStatusWithResult:(int)result{
    self.resultInt = result;
    if (result==1) {
        [self.dragonBtn setSelected:YES];
        [self.tigerBtn setSelected:NO];
        [self.heBtn setSelected:NO];
        self.resultNameString = @"龙";
    }else if(result==2){
        [self.tigerBtn setSelected:YES];
        [self.dragonBtn setSelected:NO];
        [self.heBtn setSelected:NO];
        self.resultNameString = @"虎";
    }else{
        [self.heBtn setSelected:YES];
        [self.tigerBtn setSelected:NO];
        [self.dragonBtn setSelected:NO];
        self.resultNameString = @"和";
    }
}

#pragma mark --把台桌信息归0
- (void)_resetTableInfoToZero{
    self.viewModel.dragonCount=0;//龙赢次数
    self.viewModel.tigerCount=0;//虎赢次数
    self.viewModel.heCount=0;//和赢次数
    self.dragonInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.dragonCount];
    self.tigerInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.tigerCount];
    self.heInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.heCount];
}

#pragma mark - 还原选择结果按钮状态
- (void)_resetSelectResultButtonStatus{
    [self.dragon_button setSelected:NO];
    [self.he_button setSelected:NO];
    [self.tiger_button setSelected:NO];
    [self.shazhuInfoList removeAllObjects];
    self.chipUIDList = nil;
    self.payChipUIDList = nil;
}

#pragma mark -顶部top事件
- (void)moreOptionAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.optionArrowImg.image = [UIImage imageNamed:@"moreOptionsArrow_p"];
        [UIView animateWithDuration:0.2 animations:^{
            [self hideOrShowMenuButton:NO];
            self.coverBtn.hidden = NO;
            self.menuView.height = 350;
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

#pragma mark --手自动版切换
- (void)automoticChangeAction{
    if ([self.daily_button.titleLabel.text isEqualToString:[NSString stringWithFormat:@"现金版\nCash model"]]) {
        [self.daily_button setTitle:[NSString stringWithFormat:@"自动版\nChip model"] forState:UIControlStateNormal];
        self.manuaManagerView.hidden = NO;
        self.automaticShowView.hidden = YES;
        self.isAutomicGame = NO;
        [[MJPopTool sharedInstance]popView:self.manuaManagerView WithFatherView:self.view animated:YES];
        [self.manuaManagerView getLUzhuINfo];
        self.manuaManagerView.xueciCount = self.xueciCount;
        self.manuaManagerView.puciCount = self.puciCount;
        [self.manuaManagerView fellXueCiWithXueCi:self.manuaManagerView.xueciCount PuCi:self.manuaManagerView.puciCount];
    }else{
        self.isAutomicGame = YES;
        [self.daily_button setTitle:[NSString stringWithFormat:@"现金版\nCash model"] forState:UIControlStateNormal];
        self.manuaManagerView.hidden = YES;
        self.automaticShowView.hidden = NO;
        [[MJPopTool sharedInstance]popView:self.automaticShowView WithFatherView:self.view animated:YES];
        [self getBaseTableInfoAndLuzhuInfo];
    }
}

#pragma mark --顶部按钮触发事件
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
        [self automoticChangeAction];
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
            [self daliyAction];
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
            [self.addOrMinusView fellViewDataWithLoginID:self.viewModel.loginInfo.access_token TableID:self.viewModel.curTableInfo.fid];
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
            [self.addOrMinusView fellViewDataWithLoginID:self.viewModel.loginInfo.access_token TableID:self.viewModel.curTableInfo.fid];
            [self.addOrMinusView fellListWithType:2];
            [[MJPopTool sharedInstance] popView:self.addOrMinusView animated:YES];
            break;
        case 10://修改洗码号
        {
            [EPSound playWithSoundName:@"click_sound"];
            if (!self.clientSocket.isConnected) {
                [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
                return;
            }
            self.isUpdateWashNumber = YES;
            [self showWaitingView];
            [self queryDeviceChips];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 更改客人洗码号
- (void)showUpdateWashNumberView{
    self.isUpdateWashNumber = NO;
    [[MJPopTool sharedInstance] popView:self.empowerView animated:YES];
    @weakify(self);
    self.empowerView.sureActionBlock = ^(NSString * _Nonnull adminName, NSString * _Nonnull password) {
        @strongify(self);
        [self showWaitingView];
        [self.viewModel authorizationAccountWitAccountName:adminName Password:password Block:^(BOOL success, NSString *msg, EPSreviceError error) {
            if (success) {
                [EPPopView showEntryInView:self.view WithTitle:@"请输入洗码号" handler:^(NSString *entryText) {
                    @strongify(self);
                    if ([[entryText NullToBlankString]length]==0) {
                        [self showMessage:@"请输入洗码号"];
                    }else{
                        [self showWaitingView];
                        [self.viewModel updateCustomerWashNumberWithChipList:self.chipUIDList CurWashNumber:entryText AdminName:adminName Block:^(BOOL success, NSString *msg, EPSreviceError error) {
                            @strongify(self);
                            [self hideWaitingView];
                            if (success) {
                                self.updateChipCount = (int)self.chipUIDList.count;
                                for (int i = 0; i < self.chipUIDList.count; i++) {
                                    self.curChipInfo.chipUID = self.chipUIDList[i];
                                    self.curChipInfo.guestWashesNumber = entryText;
                                    //向指定标签中写入数据（块1）
                                    [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                                    usleep(self.updateChipCount * 10000);
                                }
                                [self showMessage:@"修改成功" withSuccess:YES];
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
                    }
                }];
            }else{
                NSString *messgae = [msg NullToBlankString];
                if (messgae.length == 0) {
                    messgae = @"网络异常";
                }
                [self showMessage:messgae];
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
            }
            [self hideWaitingView];
        }];
    };
}

#pragma mark --展示或者隐藏菜单
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
    self.updateWashNumberBtn.hidden = hide;
}

#pragma mark --遮罩
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
    if (!self.clientSocket) {
        self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    // 开始连接服务器
    [self.clientSocket connectToHost:self.viewModel.curTableInfo.bindip onPort:6000 viaInterface:nil withTimeout:-1 error:&error];
}

#pragma mark --结果按钮触发事件
- (void)resultAction:(UIButton *)btn{
    if (self.puciCount != self.prePuciCount) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    [self _setResultBtnStatusWithResult:(int)btn.tag];
}

#pragma mark --录入开牌结果
- (void)resultEntryAction:(UIButton *)btn{
    if (self.puciCount != self.prePuciCount) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    if (self.resultNameString.length==0) {
        [[EPToast makeText:@"请选择开牌结果"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    [self showWaitingView];
    [self entryResult];
}

#pragma mark - 录入开牌结果
- (void)entryResult{
    self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
    self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
    self.viewModel.curupdateInfo.cp_name = self.resultNameString;
    self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
    @weakify(self);
    [self.viewModel commitkpResultWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        [self hideWaitingView];
        if (success) {
            self.prePuciCount = self.puciCount+1;
            [self showMessage:[EPStr getStr:kEPResultCacheSucceed note:@"结果录入成功"] withSuccess:YES];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
            [self getLuzhuInfoList];
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

#pragma mark --换班
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

#pragma mark --换桌
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

#pragma mark -- 获取露珠信息
- (void)getLuzhuInfoList{
    [self.viewModel getLuzhuWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            //UIcollectionview 默认样式
            [self.solidItemView fellLuzhuListWithDataList:self.viewModel.luzhuUpList];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dragonInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.dragonCount];
                self.tigerInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.tigerCount];
                self.heInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.heCount];
            });
            if (self.isFirstEntryGame) {
                self.isFirstEntryGame = NO;
                if (self.viewModel.realLuzhuList.count!=0) {
                    if (self.viewModel.lastTableInfoDict.count!=0) {
                        NSDictionary *tableInfo = self.viewModel.lastTableInfoDict;
                        //判断结果
                        NSString *cp_result = tableInfo[@"fkpresult"];
                        self.puciCount = [tableInfo[@"fpuci"]intValue];
                        self.manuaManagerView.puciCount = self.puciCount;
                        int resultStatus = 0;
                        if ([cp_result isEqualToString:@"龙"]) {
                            resultStatus=1;
                        }else if ([cp_result isEqualToString:@"虎"]){
                            resultStatus=2;
                        }else{
                            resultStatus=3;
                        }
                        self.prePuciCount = self.puciCount+1;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
                            [self _setResultBtnStatusWithResult:resultStatus];
                        });
                    }
                }
            }
        }
        [self hideWaitingView];
    }];
}

#pragma mark - 筹码信息检测
- (BOOL)chipInfoCheck{
    if (self.washNumberList.count>1) {
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        [self showMessage:@"不能出现多种洗码号"];
        return NO;
    }
    if (self.chipTypeList.count>1) {
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        [self showMessage:@"不能出现两种筹码类型"];
        return NO;
    }
    return YES;
}

#pragma mark --封装筹码基本信息
- (void)fellChipinfo{
    
}

#pragma mark -- 封装客人基本信息
- (void)fellCustomerInfo{
    self.customerInfo.tipsTitle = [NSString stringWithFormat:@"提示信息\n%@",[EPStr getStr:kEPTipsInfo note:@"提示信息"]];
    self.customerInfo.tipsInfo = [NSString stringWithFormat:@"请认真核对以上信息，确认是否进行下一步操作\n%@",[EPStr getStr:kEPNextTips note:@"请认真核对以上信息，确认是否进行下一步操作"]];
    self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"0"];
}

#pragma mark -- 封装参数
- (void)fellViewModelUpdateInfo{
    self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
    self.viewModel.curupdateInfo.cp_result = [NSString stringWithFormat:@"%@",self.winOrLose?@"1":@"-1"];
    self.viewModel.curupdateInfo.cp_washNumber = self.curChipInfo.guestWashesNumber;
    self.viewModel.curupdateInfo.cp_benjin = self.curChipInfo.chipDenomination;
    self.viewModel.curupdateInfo.cp_name = self.resultNameString;
    self.customerInfo.chipType = self.curChipInfo.chipType;
    self.viewModel.curupdateInfo.cp_dianshu = @"0";
    self.customerInfo.hasDashui = YES;
    self.isShowingResult = YES;
    self.customerInfo.odds = 0.5;
    self.viewModel.curupdateInfo.cp_zhaohuiList = [NSArray array];
    self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
    self.viewModel.curupdateInfo.cp_ChipUidList = self.chipUIDList;
    self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
    self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
}

#pragma mark -- 是否能进行结果选择按钮
- (BOOL)canResultBtnAciontNextStep{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.clientSocket.isConnected) {
        [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
        return NO;
    }
    if (self.puciCount==0) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return NO;
    }
    if (self.prePuciCount==self.puciCount) {
        [[EPToast makeText:@"请先提交开牌结果"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return NO;
    }
    return YES;
}

#pragma mark - 龙
- (void)dragonAction{
    if (![self canResultBtnAciontNextStep]) {
        return;
    }
    if (self.resultInt==1) {
        self.winOrLose = YES;
    }else{
        self.winOrLose = NO;
    }
    [self.dragon_button setSelected:YES];
    [self.he_button setSelected:NO];
    [self.tiger_button setSelected:NO];
    self.customerInfo.isTiger = NO;
    self.viewModel.curupdateInfo.cp_Result_name = @"龙";
    self.odds = 1;
    self.customerInfo.winStatus = [NSString stringWithFormat:@"%@",self.winOrLose?@"龙赢":@"龙输"];
    if (!self.winOrLose) {
        if (self.resultInt==3) {
            self.odds = 0.5;
            self.customerInfo.isTiger = YES;
        }
    }
    [self showWaitingView];
    [self queryDeviceChips];
}

#pragma mark - 虎
- (void)tigerAction{
    if (![self canResultBtnAciontNextStep]) {
        return;
    }
    if (self.resultInt==2) {
        self.winOrLose = YES;
    }else{
       self.winOrLose = NO;
    }
    [self.dragon_button setSelected:NO];
    [self.he_button setSelected:NO];
    [self.tiger_button setSelected:YES];
    self.customerInfo.isTiger = NO;
    self.viewModel.curupdateInfo.cp_Result_name = @"虎";
    self.customerInfo.winStatus = [NSString stringWithFormat:@"%@",self.winOrLose?@"虎赢":@"虎输"];
    self.odds = 1;
    if (!self.winOrLose) {
        if (self.resultInt==3) {
            self.odds = 0.5;
            self.customerInfo.isTiger = YES;
        }
    }
    [self showWaitingView];
    [self queryDeviceChips];
}

#pragma mark - 和
- (void)heAction{
    if (![self canResultBtnAciontNextStep]) {
        return;
    }
    if (self.resultInt==3) {
        self.winOrLose = YES;
    }else{
        self.winOrLose = NO;
    }
    //赔率
    NSArray *xz_array = self.viewModel.gameInfo.xz_setting;
    if (xz_array.count>2) {
        self.odds = [xz_array[2][@"fpl"] floatValue];
        self.yj = [xz_array[2][@"fyj"] floatValue];
    }
    if (!self.winOrLose) {
        self.odds = 1;
        self.yj = 0;
    }
    [self.dragon_button setSelected:NO];
    [self.he_button setSelected:YES];
    [self.tiger_button setSelected:NO];
    self.customerInfo.isTiger = NO;
    self.viewModel.curupdateInfo.cp_Result_name = @"和";
    self.customerInfo.winStatus = [NSString stringWithFormat:@"%@",self.winOrLose?@"和赢":@"和输"];
    [self showWaitingView];
    [self queryDeviceChips];
}

- (void)showStatusInfo{
    [self fellViewModelUpdateInfo];
    [self fellCustomerInfo];
    if (self.winOrLose) {
        if (![self chipInfoCheck]) {
            self.isShowingResult = NO;
            return;
        }
        [[MJPopTool sharedInstance] popView:self.payShowView animated:YES];
        [self.payShowView fellViewDataNRCustomerInfo:self.customerInfo];
        @weakify(self);
        self.payShowView.sureActionBlock = ^(NSInteger payConfirmType) {
            @strongify(self);
            if (payConfirmType==1) {//确认并识别赔付筹码
                [EPSound playWithSoundName:@"click_sound"];
                [self showWaitingView];
                [self getPayChipsUIDList];
            }else if (payConfirmType==2){//关闭并清除所有信息
                [self clearChipCacheData];
                [self _resetSelectResultButtonStatus];
            }else if (payConfirmType==3){//识别水钱
                self.isDashui = YES;
                [self showWaitingView];
                [self getShuiqianChipsUIDList];
            }
        };
    }else{
        [[MJPopTool sharedInstance] popView:self.killShowView animated:YES];
        [self.killShowView fellViewDataNRCustomerInfo:self.customerInfo];
        @weakify(self);
        self.killShowView.sureActionBlock = ^(NSInteger killConfirmType) {
            @strongify(self);
            if (killConfirmType==1) {//确认
                [EPSound playWithSoundName:@"click_sound"];
                [self showWaitingView];
                if (self.customerInfo.isTiger) {//杀一半
                    [self getPayChipsUIDList];
                }else{
                    self.isShaZhuAction = YES;
                    [self queryDeviceChips];
                }
            }else if (killConfirmType==2){//关闭
                [self clearChipCacheData];
                [self _resetSelectResultButtonStatus];
            }
        };
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
    [self.daily_button setTitle:[NSString stringWithFormat:@"现金版\nCash model"] forState:UIControlStateNormal];
    [self.nextGame_button setTitle:[NSString stringWithFormat:@"新一局\n%@",[EPStr getStr:kEPNewGame note:@"新一局"]] forState:UIControlStateNormal];
    [self.dragonBtn setTitle:[NSString stringWithFormat:@"  龙 %@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
    [self.dragonInfoBtn setTitle:[NSString stringWithFormat:@"龙\n%@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
    [self.dragon_button setTitle:[NSString stringWithFormat:@"龙  %@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
    
    [self.tigerBtn setTitle:[NSString stringWithFormat:@"  虎 %@",[EPStr getStr:kEPTiger note:@"虎"]] forState:UIControlStateNormal];
    [self.tigerInfoBtn setTitle:[NSString stringWithFormat:@"虎\n%@",[EPStr getStr:kEPTiger note:@"虎"]] forState:UIControlStateNormal];
    [self.tiger_button setTitle:[NSString stringWithFormat:@"虎  %@",[EPStr getStr:kEPTiger note:@"虎"]] forState:UIControlStateNormal];
    
    [self.heBtn setTitle:[NSString stringWithFormat:@"和 %@",[EPStr getStr:kEPTigerHe note:@"和"]] forState:UIControlStateNormal];
    [self.heInfoBtn setTitle:[NSString stringWithFormat:@"和\n%@",[EPStr getStr:kEPTigerHe note:@"和"]] forState:UIControlStateNormal];
    [self.he_button setTitle:[NSString stringWithFormat:@"和  %@",[EPStr getStr:kEPTigerHe note:@"和"]] forState:UIControlStateNormal];
    [self.aTipRecordButton setTitle:[NSString stringWithFormat:@"记录小费\nTip"] forState:UIControlStateNormal];
    [self.zhuxiaochouma_button setTitle:@"换钱\nChange money" forState:UIControlStateNormal];
    [self.readChip_button setTitle:@"筹码识别\nDetection chip" forState:UIControlStateNormal];
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
                [self.viewModel clearLuzhuWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                    [self hideWaitingView];
                    if (success) {
                        int cacheXueciCount = 0;
                        if (!self.isAutomicGame) {
                            self.manuaManagerView.xueciCount +=1;
                            self.manuaManagerView.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.manuaManagerView.xueciCount];
                            self.viewModel.curXueci = self.manuaManagerView.xueciCount;
                            self.manuaManagerView.puciCount =0;
                            self.manuaManagerView.prePuciCount = self.manuaManagerView.puciCount+1;
                            self.manuaManagerView.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.manuaManagerView.puciCount];
                            [self.manuaManagerView restartChangeStatus];
                            cacheXueciCount = self.manuaManagerView.xueciCount;
                        }else{
                            [self.dragonBtn setSelected:NO];
                            [self.tigerBtn setSelected:NO];
                            [self.heBtn setSelected:NO];
                            self.resultNameString = @"";
                            self.xueciCount +=1;
                            self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
                            self.puciCount =0;
                            self.prePuciCount = self.puciCount+1;
                            self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
                            self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
                            [self _resetTableInfoToZero];
                            cacheXueciCount = self.xueciCount;
                            [self getLuzhuInfoList];
                        }
                        [LYKeychainTool saveKeychainValue:[NSString stringWithFormat:@"%d",cacheXueciCount] key:[NSString stringWithFormat:@"%@_Xueci",self.viewModel.curTableInfo.fid]];
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
    if (!self.isAutomicGame) {
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
        };
    }else{
        if (self.viewModel.realLuzhuList.count<=0) {
            [self showMessage:@"暂无露珠可修改" withSuccess:NO];
            return;
        }
        [[MJPopTool sharedInstance] popView:self.modifyResultsView animated:YES];
        //传输参数
        [self.modifyResultsView fellViewDataWithLoginID:self.viewModel.loginInfo.access_token
                                                TableID:self.viewModel.curTableInfo.fid
                                                  Xueci:self.xueciCount
                                                   List:self.viewModel.realLuzhuList
                                             Xz_setting:self.viewModel.gameInfo.xz_setting];
        @weakify(self);
        self.modifyResultsView.sureActionBlock = ^(BOOL isUpdateStatus) {
            @strongify(self);
            if (isUpdateStatus) {
                self.isFirstEntryGame = YES;
                [self getBaseTableInfoAndLuzhuInfo];
            }
        };
    }
}

#pragma mark - 日结
- (void)daliyAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.isAutomicGame) {
        if (self.puciCount==0) {
            [self showMessage:@"铺次为0，不能日结" withSuccess:NO];
            //响警告声音
            [EPSound playWithSoundName:@"wram_sound"];
            return;
        }
    }else{
      if (self.manuaManagerView.puciCount==0) {
            [self showMessage:@"铺次为0，不能日结" withSuccess:NO];
            //响警告声音
            [EPSound playWithSoundName:@"wram_sound"];
            return;
        }
    }
    
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
                        [LYKeychainTool deleteKeychainValue:[NSString stringWithFormat:@"%@_Xueci",self.viewModel.curTableInfo.fid]];
                        self.viewModel.curXueci = 1;
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
    if (!self.isAutomicGame) {
        if (self.manuaManagerView.prePuciCount==self.manuaManagerView.puciCount) {
            [self showMessage:@"请先提交开牌结果" withSuccess:NO];
            return;
        }
    }else{
        if (!self.clientSocket.isConnected) {
            [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
            return;
        }
       if (self.prePuciCount==self.puciCount) {
            [self showMessage:@"请先提交开牌结果" withSuccess:NO];
            return;
        }
    }
    @weakify(self);
    [EPPopView showInWindowWithMessage:[NSString stringWithFormat:@"是否确定开启新一局？\n%@",[EPStr getStr:kEPSureNextGame note:@"确定开启新一局？"]] handler:^(int buttonType) {
        @strongify(self);
        if (buttonType==0) {
            [self.dragonBtn setSelected:NO];
            [self.tigerBtn setSelected:NO];
            [self.heBtn setSelected:NO];
            self.resultNameString = @"";
            if (!self.isAutomicGame) {
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

#pragma mark - 提交客人输赢记录
- (void)commitCustomerInfoWithRealChipUIDList:(NSArray *)realChipUIDList{
    self.viewModel.curupdateInfo.cp_chipType = self.curChipInfo.chipType;
    @weakify(self);
    [self.viewModel commitCustomerRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        if (success) {
            self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
            self.zhaohuiMoney = 0;
            self.serialnumber = [NRCommand randomStringWithLength:30];
            self.isShowingResult = NO;
            self.isUpdateChip = YES;
            if (self.winOrLose) {
                self.updateChipCount = (int)realChipUIDList.count+(int)self.shuiqianChipUIDList.count;
                for (int i = 0; i < realChipUIDList.count; i++) {
                    self.curChipInfo.chipUID = realChipUIDList[i];
                    //向指定标签中写入数据（块1）
                    [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                    usleep(self.updateChipCount * 10000);
                }
                //清除水钱洗码号
                for (int i=0; i<self.shuiqianChipUIDList.count; i++) {
                    NSString *chipUID = self.shuiqianChipUIDList[i];
                    //向指定标签中写入数据（块1）
                    [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                    usleep(self.updateChipCount * 10000);
                }
            }else{
                if (self.customerInfo.isTiger) {
                    self.updateChipCount = (int)self.payChipUIDList.count+(int)self.chipUIDList.count;
                    for (int i = 0; i < self.payChipUIDList.count; i++) {
                        self.curChipInfo.chipUID = self.payChipUIDList[i];
                        //向指定标签中写入数据（块1）
                        [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                        usleep(self.updateChipCount * 10000);
                    }
                    for (int i = 0; i < self.chipUIDList.count; i++) {
                        NSString *chipUID = realChipUIDList[i];
                        //向指定标签中写入数据（块1）
                        [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                        usleep(self.updateChipCount * 10000);
                    }
                }else{
                    self.updateChipCount = (int)realChipUIDList.count;
                    for (int i = 0; i < realChipUIDList.count; i++) {
                        NSString *chipUID = realChipUIDList[i];
                        //向指定标签中写入数据（块1）
                        [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                        usleep(self.updateChipCount * 10000);
                    }
                }
            }
        }else{
            [self hideWaitingView];
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

#pragma mark - 提交客人输赢记录（杀注）
- (void)commitCustomerInfo_ShaZhuWithRealChipUIDList:(NSArray *)realChipUIDList{
   self.viewModel.curupdateInfo.cp_chipType = self.curChipInfo.chipType;
    self.viewModel.curupdateInfo.cp_ChipUidList = realChipUIDList;
    self.isShaZhuAction = NO;
    @weakify(self);
    [self.viewModel commitCustomerRecord_ShaZhuWithWashNumberList:self.washNumberList Block:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        if (success) {
            self.updateChipCount = (int)realChipUIDList.count;
            self.zhaohuiMoney = 0;
            self.serialnumber = [NRCommand randomStringWithLength:30];
            self.isShowingResult = NO;
            self.isUpdateChip = YES;
            for (int i = 0; i < realChipUIDList.count; i++) {
                NSString *chipUID = realChipUIDList[i];
                //向指定标签中写入数据（块1）
                [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                usleep(self.updateChipCount * 10000);
            }
        }else{
            [self hideWaitingView];
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

//识别水钱
- (void)identifyWaterMoney{
    self.isDashui = NO;
    NSString *realCashMoney = self.curChipInfo.chipDenomination;
    self.viewModel.curupdateInfo.cp_commission = [NSString stringWithFormat:@"%.f",self.yj*[realCashMoney floatValue]];
    CGFloat real_beishu = self.odds-self.yj;
    self.customerInfo.compensateMoney = [NSString stringWithFormat:@"%.f",real_beishu*[realCashMoney floatValue]+self.identifyValue];
    self.customerInfo.compensateCode = [NSString stringWithFormat:@"%.f",real_beishu*[realCashMoney floatValue]];
    self.customerInfo.totalMoney = [NSString stringWithFormat:@"%.f",real_beishu*[realCashMoney floatValue]+self.identifyValue];
    self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%.f",self.identifyValue];
    self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",(real_beishu+1)*[realCashMoney floatValue]];
    [self.payShowView fellViewDataNRCustomerInfo:self.customerInfo];
}

#pragma mark - 打散筹码
- (void)zhuxiaoAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.clientSocket.isConnected) {
        [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
        return;
    }
    self.isBreakUpChip = YES;
    [self showWaitingView];
    [self queryDeviceChips];
}

- (void)breakUpChip{
    self.isBreakUpChip = NO;
    [self bindChipsWithWashNumber];
}

#pragma mark - 绑定筹码
- (void)bindChipsWithWashNumber{
    @weakify(self);
    [EPPopView showInWindowWithMessage:@"请放入相同金额散筹码" handler:^(int buttonType) {
        @strongify(self);
        if (buttonType==0) {
            [self showWaitingView];
            [self getBindChipsUIDList];
        }else{
            [self hideWaitingView];
        }
    }];
}

#pragma mark - 读取绑定筹码信息
- (void)getBindChipsUIDList{
    self.isBindChipWashNumber = YES;
    [EPSound playWithSoundName:@"click_sound"];
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 读取赔绑定筹码信息
- (void)readAllBindChipsInfo{
    //向指定标签中写入数据（所有块）
    [self hideWaitingView];
    if (self.bindChipUIDList.count != 0) {
        for (int i = 0; i < self.bindChipUIDList.count; i++) {
            NSString *chipID = self.bindChipUIDList[i];
            [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
            usleep((int)self.bindChipUIDList.count * 10000);
        }
    }else{
        [EPSound playWithSoundName:@"wram_sound"];
        [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
    }
}

- (void)distoryOrbindChipInfo{
    [self.viewModel changeChipWashNumberWithChipList:self.chipUIDList WashNumber:self.curBindChipWashNumber ChangChipList:self.bindChipUIDList Block:^(BOOL success, NSString *msg, EPSreviceError error) {
        self.isBindChipWashNumber = NO;
        if (success) {
            self.isDasanChip = YES;
            self.updateChipCount = (int)self.chipUIDList.count+(int)self.bindChipUIDList.count;
            for (int i = 0; i < self.chipUIDList.count; i++) {
                NSString *chipUID = self.chipUIDList[i];
                //向指定标签中写入数据（块1）
                [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                usleep(self.updateChipCount * 10000);
            }
            for (int i = 0; i < self.bindChipUIDList.count; i++) {
                self.curChipInfo.guestWashesNumber = self.curBindChipWashNumber;
                self.curChipInfo.chipUID = self.bindChipUIDList[i];
                //向指定标签中写入数据（块1）
                [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                usleep(self.updateChipCount * 10000);
            }
        }else{
            [self hideWaitingView];
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

#pragma mark - 读取水钱筹码信息
- (void)getShuiqianChipsUIDList{
    [EPSound playWithSoundName:@"click_sound"];
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 读取水钱筹码信息
- (void)readAllShuiqianChipsInfo{
    //向指定标签中写入数据（所有块）
    if (self.shuiqianChipUIDList.count != 0) {
        for (int i = 0; i < self.shuiqianChipUIDList.count; i++) {
            NSString *chipID = self.shuiqianChipUIDList[i];
            [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
            usleep((int)self.shuiqianChipUIDList.count * 10000);
        }
    }else{
        [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
    }
}

#pragma mark - 识别筹码
- (void)readChipsAction{
    self.chipUIDList = nil;
    self.isShowChipInfo = YES;
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.clientSocket.isConnected) {
        [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
        return;
    }
    [[MJPopTool sharedInstance] popView:self.chipInfoView animated:YES];
    [self.chipInfoView clearCurChipInfos];
    @weakify(self);
    self.chipInfoView.sureActionBlock = ^(NSInteger killConfirmType) {
        @strongify(self);
        if (killConfirmType==1) {//识别筹码
            [self showWaitingView];
            [self queryDeviceChips];
        }else{
            self.chipUIDList = nil;
            self.isShowChipInfo = NO;
        }
    };
}

#pragma mark - 记录小费
- (void)recordTipMoneyAction:(UIButton *)btn{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.clientSocket.isConnected) {
        [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
        return;
    }
    self.isRecordTipMoney = YES;
    [self showWaitingView];
    [self getTipChipsUIDList];
}

#pragma mark - 小费弹出框
- (void)showTipsInfoView{
    self.recordTipShowView = [EPPopAtipInfoView showInWindowWithNRCustomerInfo:self.customerInfo handler:^(int buttonType) {
        DLOG(@"buttonType===%d",buttonType);
        if (buttonType==1) {
            [self showWaitingView];
            [self.recordTipShowView _hide];
            self.viewModel.curupdateInfo.cp_xiaofeiList = self.tipChipUIDList;
            [self.viewModel commitTipResultWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                [self hideWaitingView];
                self.isRecordTipMoney = NO;
                if (success) {
                    [self showMessage:@"提交成功" withSuccess:YES];
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
        }else if (buttonType==0){
            self.isRecordTipMoney = NO;
        }
    }];
}

#pragma mark - 清除筹码数据
- (void)clearChipCacheData{
    [EPSound playWithSoundName:@"click_sound"];
    self.isShowingResult = NO;
    self.payChipUIDList = nil;
    self.shuiqianChipUIDList = nil;
    self.identifyValue = 0;
    self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.customerInfo.isTiger) {
            self.zhaohuiMoney = 0;
            self.killShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",@"已识别找回筹码",0];
        }else{
            self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
        }
    });
}

#pragma mark - 查询设备上的筹码UID
- (void)queryDeviceChips{
    [EPSound playWithSoundName:@"click_sound"];
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 识别筹码金额
- (void)readCurChipsMoney{
    //执行读取命令
    [self.viewModel checkChipIsTrueWithChipList:self.chipUIDList Block:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self hideWaitingView];
        if (success) {
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    NSString *chipID = self.chipUIDList[i];
                    [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
                    usleep((int)self.chipUIDList.count * 10000);
                }
            });
        }else{
            [self _resetSelectResultButtonStatus];
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
            usleep((int)self.payChipUIDList.count * 10000);
        }
    }else{
        [EPSound playWithSoundName:@"wram_sound"];
        [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
    }
}

#pragma mark - 读取小费筹码信息
- (void)getTipChipsUIDList{
    [EPSound playWithSoundName:@"click_sound"];
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
            usleep((int)self.tipChipUIDList.count * 10000);
        }
    }else{
        [EPSound playWithSoundName:@"wram_sound"];
        [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
    }
}

- (void)hasNoChipShow{
    [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
    //响警告声音
    [EPSound playWithSoundName:@"wram_sound"];
}

#pragma mark - 关闭设备自动感应
- (void)closeDeviceWorkModel{
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand setDeviceWorkModel] withTimeout:- 1 tag:0];
}

#pragma mark - 设置心跳指令
- (void)sendDeviceKeepAlive{
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand keepDeviceAlive] withTimeout:- 1 tag:0];
}

#pragma mark - GCDAsyncSocketDelegate
//连接主机对应端口
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self closeDeviceWorkModel];
    [self sendDeviceKeepAlive];
    //    连接后,可读取服务器端的数据
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err{
    DLOG(@"进入这里11");
    [self connectToServer];
}

// 收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 读取到服务器数据值后也能再读取
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    DLOG(@"data = %@",data);
    NSString *dataHexStr = [NRCommand hexStringFromData:data];
    if (!self.chipUIDData) {
        self.chipUIDData = [NSMutableData data];
    }
    if ([dataHexStr isEqualToString:@"050020a04feb"]) {
        return;
    }
    if ([dataHexStr containsString:@"040000525a"]) {
        if (self.isUpdateChip||self.isDasanChip) {
            [self.chipUIDData appendData:data];
            NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
            NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"040000525a"
            withString:@"040000525a"
               options:NSLiteralSearch
                 range:NSMakeRange(0, [chipNumberdataHexStr length])];
            if (count == self.updateChipCount) {
                self.updateChipCount = 0;
                [self hideWaitingView];
                if (self.isUpdateChip) {
                    self.isUpdateChip = NO;
                    if (self.winOrLose) {
                        self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                        [self.payShowView clearPayShowInfo];
                        [self.payShowView removeFromSuperview];
                        [self showMessage:@"赔付成功" withSuccess:YES];
                        //响警告声音
                        [EPSound playWithSoundName:@"succeed_sound"];
                    }else{
                        if (self.customerInfo.isTiger) {
                            self.zhaohuiMoney = 0;
                            self.killShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",@"已识别找回筹码",0];
                        }else{
                            self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                        }
                        [self.killShowView clearKillShowView];
                        [self.killShowView removeFromSuperview];
                        [self showMessage:[EPStr getStr:kEPShazhuSucceed note:@"杀注成功"] withSuccess:YES];
                        //响警告声音
                        [EPSound playWithSoundName:@"succeed_sound"];
                    }
                    [self _resetSelectResultButtonStatus];
                }else{
                    self.isDasanChip = NO;
                    [self showMessage:@"打散成功" withSuccess:YES];
                    //响警告声音
                    [EPSound playWithSoundName:@"succeed_sound"];
                }
            }
        }
        return;
    }
    //判断是否是结束指令
    [self.chipUIDData appendData:data];
    if ([dataHexStr containsString:@"0d000000"]||[dataHexStr containsString:@"04000e2cb3"]||[dataHexStr containsString:@"050020a04feb"]||[dataHexStr containsString:@"040000525a"]) {//筹码识别
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"040000525a" withString:@""];
        chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"050020a04feb" withString:@""];
        if ([chipNumberdataHexStr hasSuffix:@"04000e2cb3"]) {//筹码已经识别完成
            chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"04000e2cb3" withString:@""];
            NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"0d000000"
            withString:@"0d000000"
               options:NSLiteralSearch
                 range:NSMakeRange(0, [chipNumberdataHexStr length])];
            if (count==0) {
                [self showMessage:@"未检测到筹码"];
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
                [self hideWaitingView];
                self.chipUIDData = nil;
                return;
            }
             self.chipUIDData = nil;
            if (self.isShowingResult) {
                if (self.isDashui){//识别水钱
                    BLEIToll *itool = [[BLEIToll alloc]init];
                    //存贮筹码UID
                    self.shuiqianChipUIDList = [itool getDeviceRealShuiqianChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithPayUidList:self.payChipUIDList];
                    self.shuiqianChipCount = self.shuiqianChipUIDList.count;
                    if (self.shuiqianChipCount==0) {
                        self.isDashui = NO;
                        self.shuiqianChipUIDList = nil;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showLognMessage:@"未检测到水钱筹码"];
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
                            [self hideWaitingView];
                        });
                    }else{
                        self.viewModel.curupdateInfo.cp_DashuiUidList = self.shuiqianChipUIDList;
                        [self readAllShuiqianChipsInfo];
                    }
                }else if (self.isShaZhuAction){
                    BLEIToll *itool = [[BLEIToll alloc]init];
                    //存贮筹码UID
                    NSArray *realChipList = [itool getDeviceAllChipUIDWithBLEString:chipNumberdataHexStr];
                    if (realChipList.count != self.chipUIDList.count) {
                        self.isShaZhuAction = NO;
                        [self showLognMessage:@"筹码金额不一致"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self hideWaitingView];
                        return;
                    }
                    self.chipUIDList = realChipList;
                    self.chipCount = self.chipUIDList.count;
                    DLOG(@"self.chipCount = %ld",(long)self.chipCount);
                    if (self.chipCount==0) {
                        self.isShaZhuAction = NO;
                        [self showLognMessage:@"未检测到筹码"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self hideWaitingView];
                    }else{
                        [self commitCustomerInfo_ShaZhuWithRealChipUIDList:self.chipUIDList];
                    }
                }else{
                    BLEIToll *itool = [[BLEIToll alloc]init];
                    //存贮筹码UID
                    self.payChipUIDList = [itool getDeviceALlPayChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithShuiqianUidList:self.shuiqianChipUIDList];
                    self.payChipCount = self.payChipUIDList.count;
                    if (self.payChipCount==0) {
                        self.payChipUIDList = nil;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (self.customerInfo.isTiger) {
                                [self showMessage:@"未检测到找回筹码"];
                                self.zhaohuiMoney = 0;
                                self.killShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",@"已识别找回筹码",0];
                                //响警告声音
                                [EPSound playWithSoundName:@"wram_sound"];
                            }else{
                                self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                                [self showMessage:@"未检测到赔付筹码"];
                                //响警告声音
                                [EPSound playWithSoundName:@"wram_sound"];
                            }
                        });
                        [self hideWaitingView];
                    }else{
                        [self readAllPayChipsInfo];
                    }
                }
            }else if (self.isBindChipWashNumber){//绑定筹码
                BLEIToll *itool = [[BLEIToll alloc]init];
                //存贮筹码UID
                self.bindChipUIDList = [itool getDeviceALlPayChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithShuiqianUidList:[NSArray array]];
                self.bindChipCount = self.bindChipUIDList.count;
                if (self.bindChipCount==0) {
                    self.bindChipUIDList = nil;
                    self.isBindChipWashNumber = NO;
                    [self showMessage:@"未检测到筹码"];
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                    [self hideWaitingView];
                    self.chipUIDData = nil;
                    return;
                }else{
                    [self readAllBindChipsInfo];
                }
            }else if (self.isRecordTipMoney){//记录小费
                BLEIToll *itool = [[BLEIToll alloc]init];
                //存贮筹码UID
                self.tipChipUIDList = [itool getDeviceALlTipsChipUIDWithBLEString:chipNumberdataHexStr];
                self.tipChipCount = self.tipChipUIDList.count;
                if (self.tipChipCount==0) {
                    self.tipChipUIDList = nil;
                    self.isRecordTipMoney = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.recordTipShowView.compensateMoneyLab.text = [NSString stringWithFormat:@"小费金额:%d",0];
                        self.recordTipShowView.guestNumberLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPWashNumber note:@"客人洗码号"],@"#"];
                        [self hasNoChipShow];
                        [self hideWaitingView];
                    });
                }else{
                    [self readAllTipChipsInfo];
                }
            }else{
                BLEIToll *itool = [[BLEIToll alloc]init];
                //存贮筹码UID
                self.chipUIDList = [itool getDeviceAllChipUIDWithBLEString:chipNumberdataHexStr];
                self.chipCount = self.chipUIDList.count;
                DLOG(@"self.chipCount = %ld",(long)self.chipCount);
                if (self.chipCount==0) {
                    self.chipUIDList = nil;
                    self.isUpdateWashNumber = NO;
                    [self _resetSelectResultButtonStatus];
                    [self.chipInfoList removeAllObjects];
                    [self.chipInfoView fellChipViewWithChipList:self.chipInfoList];
                    [self hasNoChipShow];
                    [self hideWaitingView];
                }else{
                    if(self.isUpdateWashNumber){
                        [self hideWaitingView];
                        [self showUpdateWashNumberView];
                    }else{
                        [self readCurChipsMoney];//识别下注本金
                    }
                }
            }
        }
    }else if ([dataHexStr containsString:@"13000000"]){
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"040000525a" withString:@""];
        chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"04000e2cb3" withString:@""];
        chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"050020a04feb" withString:@""];
        NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"13000000"
                                                                              withString:@"13000000"
                                                                                 options:NSLiteralSearch
                                                                                   range:NSMakeRange(0, [chipNumberdataHexStr length])];
        if (self.isShowingResult) {
            if (self.isDashui) {
                if (count==self.shuiqianChipCount) {
                    self.chipUIDData = nil;
                    BLEIToll *itool = [[BLEIToll alloc]init];
                    NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr WithSplitSize:3];
                    DLOG(@"readShuiqianChipInfo = %@",chipInfo);
                    //客人洗码号
                    NSMutableArray *washNumberList = [NSMutableArray array];
                    __block BOOL isWashNumberTrue = YES;
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *chipWashNumber = infoList[4];
                        if ([[chipWashNumber NullToBlankString]length]==0||[chipWashNumber isEqualToString:@"0"]) {
                            isWashNumberTrue = NO;
                        }else{
                            if (![washNumberList containsObject:chipWashNumber]) {
                                [washNumberList addObject:chipWashNumber];
                            }
                        }
                    }];
                    if (!isWashNumberTrue) {
                        self.isDashui = NO;
                        self.shuiqianChipUIDList = nil;
                        self.identifyValue = 0;
                        self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self showMessage:@"水钱筹码错误"];
                        [self hideWaitingView];
                        return;
                    }
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
                    [self hideWaitingView];
                }
            }else{
                if (count==self.payChipCount) {
                    self.chipUIDData = nil;
                    BLEIToll *itool = [[BLEIToll alloc]init];
                    NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr WithSplitSize:3];
                    DLOG(@"readPaychipInfo = %@",chipInfo);
                    //筹码额
                    __block int chipAllMoney = 0;
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                        chipAllMoney += [realmoney intValue];
                    }];
                    
                    NSMutableArray *washNumberList = [NSMutableArray array];
                    NSMutableArray *chipTypeList = [NSMutableArray array];
                    __block BOOL isWashNumberTrue = YES;
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *chipWashNumber = infoList[4];
                        NSString *chipType = infoList[1];
                        if ([chipWashNumber isEqualToString:@"0"]){
                            if (![washNumberList containsObject:chipWashNumber]) {
                                [washNumberList addObject:chipWashNumber];
                            }
                        }else{
                            isWashNumberTrue = NO;
                        }
                        if (![chipTypeList containsObject:chipType]) {
                            [chipTypeList addObject:chipType];
                        }
                    }];
                    if (!isWashNumberTrue) {
                        if (self.customerInfo.isTiger) {
                            self.zhaohuiMoney = 0;
                            self.killShowView.havepayChipLab.text = [NSString stringWithFormat:@"已识别找回筹码:%d",0];
                            [self showMessage:@"找回金额不正确"];
                        }else{
                            int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                            self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",benjinMoney];
                            self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                            [self showMessage:@"赔付筹码有误"];
                        }
                        [self hideWaitingView];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        return;
                    }
                    if (![chipTypeList.firstObject isEqualToString:self.curChipInfo.chipType]) {
                        [self showMessage:@"赔付筹码类型与本金筹码类型不一致"];
                        [self hideWaitingView];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        return;
                    }
                    if (chipTypeList.count>1) {
                        [self showMessage:@"存在多个筹码类型"];
                        [self hideWaitingView];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                        self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",benjinMoney+chipAllMoney];
                        if (self.customerInfo.isTiger) {
                            self.zhaohuiMoney = chipAllMoney;
                            self.killShowView.havepayChipLab.text = [NSString stringWithFormat:@"已识别找回筹码:%d",chipAllMoney];
                            if (self.customerInfo.isTiger) {
                                self.viewModel.curupdateInfo.cp_zhaohuiList = self.payChipUIDList;
                            }
                            if (self.customerInfo.isTiger&&(self.zhaohuiMoney != self.benjinMoney/2)) {
                                [self showMessage:@"找回金额不正确"];
                                //响警告声音
                                [EPSound playWithSoundName:@"wram_sound"];
                                [self hideWaitingView];
                            }else{
                                [self commitCustomerInfoWithRealChipUIDList:self.chipUIDList];
                            }
                        }else{
                            self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",chipAllMoney];
                            NSMutableArray *realChipUIDList = [NSMutableArray array];
                            [realChipUIDList addObjectsFromArray:self.chipUIDList];
                            [realChipUIDList addObjectsFromArray:self.payChipUIDList];
                            self.viewModel.curupdateInfo.cp_ChipUidList = realChipUIDList;
                            [self commitCustomerInfoWithRealChipUIDList:realChipUIDList];
                        }
                    });
                }
            }
            
        }else if (self.isBindChipWashNumber){
            if (count==self.bindChipCount) {
                self.chipUIDData = nil;
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr WithSplitSize:3];
                DLOG(@"readBindchipInfo = %@",chipInfo);
                //筹码额
                __block int chipAllMoney = 0;
                [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                    chipAllMoney += [realmoney intValue];
                }];
                
                NSMutableArray *washNumberList = [NSMutableArray array];
                __block BOOL isWashNumberTrue = YES;
                [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *chipWashNumber = infoList[4];
                    if ([chipWashNumber isEqualToString:@"0"]){
                        if (![washNumberList containsObject:infoList[4]]) {
                            [washNumberList addObject:infoList[4]];
                        }
                    }else{
                        isWashNumberTrue = NO;
                    }
                }];
                if (!isWashNumberTrue) {
                    self.isBindChipWashNumber = NO;
                    [self showMessage:@"打散筹码有误"];
                    [self hideWaitingView];
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                    return;
                }
                int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                if (chipAllMoney != benjinMoney) {
                    self.isBindChipWashNumber = NO;
                    [self showMessage:@"打散金额不匹配,请检查筹码金额是否正确"];
                    [self hideWaitingView];
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                    return;
                }
                [self distoryOrbindChipInfo];
            }
        }else if (self.isRecordTipMoney){
            if (count==self.tipChipCount) {
                self.chipUIDData = nil;
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr WithSplitSize:3];
                DLOG(@"readchipInfo = %@",chipInfo);
                __block BOOL isWashNumberTrue = YES;
                [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *chipWashNumber = infoList[4];
                    if ([[chipWashNumber NullToBlankString]length]==0||[chipWashNumber isEqualToString:@"0"]){
                        isWashNumberTrue = NO;
                    }
                }];
                if (!isWashNumberTrue) {
                    self.isRecordTipMoney = NO;
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                    [self showMessage:@"小费筹码错误"];
                    [self hideWaitingView];
                    return;
                }
                self.curChipInfo.tipWashesNumber = chipInfo[0][4];
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
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
                [self hideWaitingView];
                [self showTipsInfoView];
            }
        }else if (self.isBreakUpChip){//打散筹码
            if (count==self.chipCount) {
                self.chipUIDData = nil;
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr WithSplitSize:3];
                DLOG(@"chipInfo = %@",chipInfo);
                if (chipInfo.count != 0) {
                    [self.washNumberList removeAllObjects];
                    __block BOOL isWashNumberTrue = YES;
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *chipWashNumber = infoList[4];
                        if ([chipWashNumber isEqualToString:@"0"]||[[chipWashNumber NullToBlankString]length]==0){
                            isWashNumberTrue = NO;
                        }else{
                            if (![self.washNumberList containsObject:infoList[4]]) {
                                [self.washNumberList addObject:infoList[4]];
                            }
                        }
                    }];
                    if (!isWashNumberTrue) {
                        self.isBreakUpChip = NO;
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self showLognMessage:@"检测到有异常洗码号的筹码"];
                        [self hideWaitingView];
                        return;
                    }
                    //客人洗码号
                    self.curChipInfo.guestWashesNumber = chipInfo[0][4];
                    self.curBindChipWashNumber = self.curChipInfo.guestWashesNumber;
                    //筹码额
                    __block int chipAllMoney = 0;
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                        chipAllMoney += [realmoney intValue];
                    }];
                    self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",chipAllMoney];
                    [self hideWaitingView];
                    [self breakUpChip];
                }
            }
        }else{
            if (count==self.chipCount) {
                self.chipUIDData = nil;
                BLEIToll *itool = [[BLEIToll alloc]init];
                NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr WithSplitSize:3];
                DLOG(@"chipInfo = %@",chipInfo);
                if (chipInfo.count != 0) {
                    if (self.isShowChipInfo) {
                        [self.chipInfoList removeAllObjects];
                        [self.chipInfoList addObjectsFromArray:chipInfo];
                        [self.chipInfoView fellChipViewWithChipList:self.chipInfoList];
                        [self hideWaitingView];
                        //响警告声音
                        [EPSound playWithSoundName:@"succeed_sound"];
                        return;
                    }
                    [self.shazhuInfoList removeAllObjects];
                    NSArray *chip_shazhuList = [BLEIToll shaiXuanShazhuListWithOriginalList:chipInfo];
                    [self.shazhuInfoList addObjectsFromArray:chip_shazhuList];
                    [self.washNumberList removeAllObjects];
                    [self.chipTypeList removeAllObjects];
                    __block BOOL isWashNumberTrue = YES;
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *chipWashNumber = infoList[4];
                        NSString *chipType = infoList[1];
                        if ([chipWashNumber isEqualToString:@"0"]||[[chipWashNumber NullToBlankString]length]==0){
                            isWashNumberTrue = NO;
                        }else{
                            if (![self.washNumberList containsObject:chipWashNumber]) {
                                [self.washNumberList addObject:chipWashNumber];
                            }
                           if (![self.chipTypeList containsObject:chipType]) {
                                [self.chipTypeList addObject:chipType];
                            }
                        }
                    }];
                    if (!isWashNumberTrue) {
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self showLognMessage:@"检测到有异常洗码号的筹码"];
                        [self hideWaitingView];
                        [self _resetSelectResultButtonStatus];
                        return;
                    }
                    //筹码类型
                    NSString *chipType = [self.chipTypeList.firstObject NullToBlankString];
                    self.curChipInfo.chipType = chipType;
                    //客人洗码号
                    self.curChipInfo.guestWashesNumber = self.washNumberList.firstObject;
                    self.curBindChipWashNumber = self.curChipInfo.guestWashesNumber;
                    //筹码额
                    __block int chipAllMoney = 0;
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                        chipAllMoney += [realmoney intValue];
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",chipAllMoney];
                        self.customerInfo.guestNumber = self.curChipInfo.guestWashesNumber;
                        self.customerInfo.principalMoney = self.curChipInfo.chipDenomination;
                        self.benjinMoney = chipAllMoney;
                        self.customerInfo.chipInfoList = self.shazhuInfoList;
                        NSString *realCashMoney = self.curChipInfo.chipDenomination;
                        if (self.winOrLose) {
                            self.customerInfo.compensateMoney = [NSString stringWithFormat:@"%.f",self.odds*[realCashMoney floatValue]];
                            self.customerInfo.compensateCode = [NSString stringWithFormat:@"%.f",self.odds*[realCashMoney floatValue]];
                            self.customerInfo.totalMoney = [NSString stringWithFormat:@"%.f",(self.odds+1)*[realCashMoney floatValue]];
                            self.customerInfo.drawWaterMoney = @"0";
                            self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
                            self.viewModel.curupdateInfo.cp_result = @"1";
                            self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",(self.odds+1)*[realCashMoney floatValue]];
                        }else{
                            self.viewModel.fxz_cmtype_list = self.chipTypeList;
                            self.customerInfo.xiazhu = realCashMoney;
                            self.customerInfo.shazhu = realCashMoney;
                            self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"0"];
                            self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
                            self.viewModel.curupdateInfo.cp_result = @"-1";
                            self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",self.odds*[realCashMoney floatValue]];
                        }
                        [self hideWaitingView];
                        [self showStatusInfo];
                    });
                }
            }
        }
    }
}

@end
