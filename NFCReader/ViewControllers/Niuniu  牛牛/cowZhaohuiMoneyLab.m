//
//  NRBaccaratViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRCowViewController.h"
#import "NRCustomerInfo.h"
#import "EPPopView.h"
#import "JXButton.h"
#import "EPService.h"
#import "NRLoginInfo.h"
#import "NRCowViewModel.h"
#import "NRTableInfo.h"
#import "NRGameInfo.h"
#import "NRUpdateInfo.h"
#import "NRGameInfo.h"
#import "EPAppData.h"

#import "EPPopAtipInfoView.h"
#import "GCDAsyncSocket.h"
#import "BLEIToll.h"
#import "IQKeyboardManager.h"
#import "JhPageItemView.h"
#import "SFLabel.h"
#import "ManualManagerCow.h"

#import "NFPopupContainView.h"
#import "NFPopupTextContainView.h"

#import "TableDataInfoView.h"
#import "EmpowerView.h"
#import "ModificationResultsView.h"
#import "TableJiaJiancaiView.h"
#import "JhPageItemModel.h"
#import "EPCowPointChooseShowView.h"

#import "EPWebViewController.h"
#import "EPKillShowView.h"
#import "EPPayShowView.h"
#import "ChipInfoView.h"
#import "EPDaSanInfoView.h"

@interface NRCowViewController ()<GCDAsyncSocketDelegate>

//台桌数据
@property (nonatomic, strong) TableDataInfoView *tableDataInfoV;

//授权验证
@property (nonatomic, strong) EmpowerView *empowerView;

//修改露珠
@property (nonatomic, strong) ModificationResultsView *modifyResultsView;

//加减彩
@property (nonatomic, strong) TableJiaJiancaiView *addOrMinusView;

//杀注界面
@property (nonatomic, strong) EPKillShowView *killShowView;
//赔付界面
@property (nonatomic, strong) EPPayShowView *payShowView;

//是否识别筹码
@property (nonatomic, strong) ChipInfoView *chipInfoView;
@property (nonatomic, strong) NSMutableArray *chipInfoList;
@property (nonatomic, assign) BOOL isShowChipInfo;//是否在识别筹码
@property (nonatomic, assign) BOOL isUpdateWashNumber;//是否更改洗码号

//顶部选项卡
@property (nonatomic, strong) UIImageView *topBarImageV;
@property (nonatomic, strong) UIButton *moreOptionButton;
@property (nonatomic, strong) UIImageView *optionArrowImg;
@property (nonatomic, strong) UIButton *changexueci_button;
@property (nonatomic, strong) UIButton *updateLuzhu_button;
@property (nonatomic, strong) UIButton *daily_button;
@property (nonatomic, strong) UIButton *nextGame_button;
@property (nonatomic, strong) UIButton *coverBtn;
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

//操作中心
@property (nonatomic, strong) UIImageView *operateCenterImgV;
@property (nonatomic, strong) UILabel *operateCenterLabel;
@property (nonatomic, strong) UIView *operateCenterView;

//露珠信息
@property (nonatomic, strong) UIImageView *luzhuImgV;
@property (nonatomic, strong) UILabel *luzhuInfoLab;
@property (nonatomic, strong) UILabel *noDataInfoLab;
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
@property (nonatomic, assign) int xueciCount;//靴次
@property (nonatomic, assign) int puciCount;//铺次

//赢
@property (nonatomic, strong) UIButton *win_button;
@property (nonatomic, assign) BOOL winOrLose;
@property (nonatomic, assign) BOOL isShaZhuAction;//是否杀注操作

@property (nonatomic, assign) NSInteger bindChipCount;
@property (nonatomic, strong) NSArray *bindChipUIDList;
@property (nonatomic, assign) BOOL isBindChipWashNumber;//是否绑定洗码号
@property (nonatomic, assign) BOOL isBreakUpChip;//是否打散筹码

@property (nonatomic, strong) NSMutableArray *washNumberList;
@property (nonatomic, strong) NSMutableArray *shazhuInfoList;//杀注信息
@property (nonatomic, strong) NSMutableArray *chipTypeList;//筹码类型数据
@property (nonatomic, strong) NSString *curBindChipWashNumber;//需要绑定筹码的洗码号
//输
@property (nonatomic, strong) UIButton *lose_button;

@property (nonatomic, strong) UIButton *superDouble_button;
@property (nonatomic, strong) UIButton *double_button;
@property (nonatomic, strong) UIButton *flat_button;

@property (nonatomic, strong) NRCustomerInfo *customerInfo;
@property (nonatomic, assign) NSInteger chipCount;
@property (nonatomic, strong) NSArray *chipUIDList;
@property (nonatomic, strong) NRChipInfoModel *curChipInfo;

@property (nonatomic, assign) NSInteger payChipCount;
@property (nonatomic, strong) NSArray *payChipUIDList;
@property (nonatomic, assign) BOOL isShowingResult;//是否展示结果

@property (nonatomic, assign) NSInteger tipChipCount;
@property (nonatomic, strong) NSArray *tipChipUIDList;
@property (nonatomic, assign) BOOL isRecordTipMoney;//是否记录小费

@property (nonatomic, assign) NSInteger shuiqianChipCount;
@property (nonatomic, strong) NSArray *shuiqianChipUIDList;
@property (nonatomic, assign) BOOL isDashui;//是否打水
@property (nonatomic, assign) int beishuType;

@property (nonatomic, strong) NSString *serialnumber;//流水号
@property (nonatomic, assign) CGFloat odds;//倍数
@property (nonatomic, assign) CGFloat yj;//佣金
@property (nonatomic, assign) int chipBLECount;//

@property (nonatomic, strong) EPCowPointChooseShowView *cowPointShowView;
@property (nonatomic, strong) EPPopAtipInfoView *recordTipShowView;//识别小费

// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSMutableData *chipUIDData;
@property (nonatomic, assign) BOOL isResultAction;//是否
@property (nonatomic, assign) CGFloat identifyValue;//水钱

@property (nonatomic,strong) ManualManagerCow *cowManager;
@property (nonatomic, assign) BOOL isAutomicGame;//是否手动版

@property (nonatomic, assign) BOOL isReadChipUID;//是否正在识别筹码UID
@property (nonatomic, assign) BOOL isReadChipInfo;//是否正在识别筹码信息
@property (nonatomic, assign) BOOL isOperateChip;//是否操作筹码
@property (nonatomic, assign) BOOL isDasanChip;//是否打散筹码
@property (nonatomic, assign) BOOL isUpdateChip;//是否修改筹码
@property (nonatomic, assign) int operateChipCount;//正在操作筹码的数量
@property (nonatomic, assign) BOOL isSetUpDeviceModel;//设置读写器模式
@property (nonatomic, assign) int writeCount;//写入次数
@property (nonatomic, assign) int clearCount;//清除次数

@property (nonatomic, strong) EPDaSanInfoView *daSanInfoView;
@property (nonatomic, assign) NSInteger zhaoHuiChipCount;
@property (nonatomic, strong) NSArray *zhaoHuiChipUIDList;
@property (nonatomic, assign) BOOL isZhaoHui;//是否找回筹码

@end

@implementation NRCowViewController

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
        
        CGFloat result_w = (kScreenWidth -200-105)/2;
        CGFloat result_h = 104;
        self.win_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.win_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.win_button.titleLabel.font = [UIFont systemFontOfSize:21];
        [self.win_button setBackgroundImage:[UIImage imageNamed:@"cow_win_selectedIcon"] forState:UIControlStateSelected];
        [self.win_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.win_button addTarget:self action:@selector(winAction) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.win_button];
        [self.win_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.operateCenterView).offset(15);
            make.left.equalTo(self.aTipRecordButton.mas_right).offset(31);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_w);
        }];
        
        self.lose_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.lose_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.lose_button.titleLabel.font = [UIFont systemFontOfSize:21];
        [self.lose_button setBackgroundImage:[UIImage imageNamed:@"cow_lose_selectedIcon"] forState:UIControlStateSelected];
        [self.lose_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.lose_button addTarget:self action:@selector(loseAction) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.lose_button];
        [self.lose_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.operateCenterView).offset(15);
            make.left.equalTo(self.win_button.mas_right).offset(24);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_w);
        }];
        
        CGFloat result_double_w = kScreenWidth-200-81;
        self.superDouble_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.superDouble_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.superDouble_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        [self.superDouble_button setBackgroundImage:[UIImage imageNamed:@"cow_superDouble_selectedIcon"] forState:UIControlStateSelected];
        [self.superDouble_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.superDouble_button addTarget:self action:@selector(superDoubleAction) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.superDouble_button];
        [self.superDouble_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.win_button.mas_bottom).offset(38);
            make.left.equalTo(self.aTipRecordButton.mas_right).offset(31);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_double_w);
        }];

        self.double_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.double_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.double_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        [self.double_button setBackgroundImage:[UIImage imageNamed:@"cow_win_selectedIcon"] forState:UIControlStateSelected];
        [self.double_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.double_button addTarget:self action:@selector(doubleAction) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.double_button];
        [self.double_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.superDouble_button.mas_bottom).offset(31);
            make.left.equalTo(self.aTipRecordButton.mas_right).offset(31);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_double_w);
        }];

        self.flat_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.flat_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.flat_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        [self.flat_button setBackgroundImage:[UIImage imageNamed:@"tiger_selectedIcon"] forState:UIControlStateSelected];
        [self.flat_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.flat_button addTarget:self action:@selector(flatAction) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.flat_button];
        [self.flat_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.double_button.mas_bottom).offset(31);
            make.left.equalTo(self.aTipRecordButton.mas_right).offset(31);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_double_w);
        }];
        
    }
    return _automaticShowView;
}

- (ManualManagerCow *)cowManager{
    if (!_cowManager) {
        _cowManager = [[ManualManagerCow alloc]initWithFrame:CGRectMake(0,94, kScreenWidth, kScreenHeight-94)];
        _cowManager.hidden = YES;
    }
    return _cowManager;
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

- (ModificationResultsView *)modifyResultsView{
    if (!_modifyResultsView) {
        _modifyResultsView = [[[NSBundle mainBundle]loadNibNamed:@"ModificationResultsView" owner:nil options:nil]lastObject];
        _modifyResultsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _modifyResultsView;
}

- (EPCowPointChooseShowView *)cowPointShowView{
    if (!_cowPointShowView) {
        _cowPointShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPCowPointChooseShowView" owner:nil options:nil]lastObject];
        _cowPointShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _cowPointShowView;
}

- (TableJiaJiancaiView *)addOrMinusView{
    if (!_addOrMinusView) {
        _addOrMinusView = [[TableJiaJiancaiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _addOrMinusView;
}

-(JhPageItemView *)solidView{
    if (!_solidView) {
        CGRect femwe =  CGRectMake(0, 0, kScreenWidth-25-156, 232);
        JhPageItemView *view =  [[JhPageItemView alloc]initWithFrame:femwe];
        view.backgroundColor = [UIColor whiteColor];
        self.solidView = view;
    }
    return _solidView;
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

- (void)_setup{
    //台桌信息
    self.tableInfoImgV = [UIImageView new];
    self.tableInfoImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self.automaticShowView addSubview:self.self.tableInfoImgV];
    [self.tableInfoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.automaticShowView).offset(20);
        make.right.equalTo(self.automaticShowView).offset(-10);
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
    [self.tableInfoV addSubview:self.xueciLab];
    [self.xueciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stableIDLab.mas_bottom).offset(3);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.puciLab = [UILabel new];
    self.puciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.puciLab.font = [UIFont systemFontOfSize:10];
    [self.tableInfoV addSubview:self.puciLab];
    [self.puciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(3);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    //露珠信息
    self.luzhuImgV = [UIImageView new];
    self.luzhuImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self.automaticShowView addSubview:self.self.luzhuImgV];
    [self.luzhuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.automaticShowView).offset(20);
        make.right.equalTo(self.tableInfoImgV.mas_left).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_offset(kScreenWidth-25-156);
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
        make.width.mas_offset(kScreenWidth-25-156);
    }];
    
    self.luzhuCollectionView = [UIView new];
    self.luzhuCollectionView.backgroundColor = [UIColor whiteColor];
    [self.automaticShowView addSubview:self.luzhuCollectionView];
    [self.luzhuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luzhuImgV.mas_bottom).offset(0);
        make.left.right.equalTo(self.luzhuImgV).offset(0);
        make.height.mas_equalTo(232);
    }];
    
    [self.luzhuCollectionView addSubview:self.solidView];
    [self.solidView fellLuzhuListWithDataList:self.luzhuInfoList];
    self.solidView.collectionView.scrollEnabled = NO;
    
    self.noDataInfoLab = [UILabel new];
    self.noDataInfoLab.textColor = [UIColor colorWithHexString:@"#7b7b7b"];
    self.noDataInfoLab.font = [UIFont systemFontOfSize:23];
    self.noDataInfoLab.text = @"此对局无露珠信息";
    [self.luzhuCollectionView addSubview:self.noDataInfoLab];
    [self.noDataInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.center.equalTo(self.luzhuCollectionView);
    }];
}

- (void)luzhuList{
    self.luzhuInfoList = [NSMutableArray array];
    for (int i=0; i<luzhuMaxCount; i++) {
        JhPageItemModel *model = [[JhPageItemModel alloc]init];
        model.img = @"";
        model.text = @"";
        model.luzhuType = 0;
        model.colorString = @"#ffffff";
        [self.luzhuInfoList addObject:model];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self topBarSetUp];
    
    [self luzhuList];
    self.xueciCount = 1;
    self.puciCount = 0;
    
    self.chipUIDData = [NSMutableData data];
    self.curChipInfo = [[NRChipInfoModel alloc]init];
    self.shazhuInfoList = [NSMutableArray arrayWithCapacity:0];
    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    self.chipTypeList = [NSMutableArray arrayWithCapacity:0];
    self.washNumberList = [NSMutableArray arrayWithCapacity:0];
    self.serialnumber = [NRCommand randomStringWithLength:30];
    self.viewModel.curupdateInfo.cp_result = @"-1";
    self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
    self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
    self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
    //日结日期
    NSString * curRijieDate = [LYKeychainTool readKeychainValue:[NSString stringWithFormat:@"%@_RijieDate",self.viewModel.curTableInfo.fid]];
    if ([[curRijieDate NullToBlankString]length]!=0) {
        self.viewModel.cp_tableRijieDate = curRijieDate;
    }else{
        self.viewModel.cp_tableRijieDate = [NRCommand getCurrentDate];
        [LYKeychainTool saveKeychainValue:self.viewModel.cp_tableRijieDate key:[NSString stringWithFormat:@"%@_RijieDate",self.viewModel.curTableInfo.fid]];
    }
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    self.winOrLose = NO;
    self.customerInfo = [[NRCustomerInfo alloc]init];
    self.customerInfo.tipsTitle = [NSString stringWithFormat:@"提示信息\n%@",[EPStr getStr:kEPTipsInfo note:@"提示信息"]];
    self.customerInfo.tipsInfo = [NSString stringWithFormat:@"请认真核对以上信息，确认是否进行下一步操作\n%@",[EPStr getStr:kEPNextTips note:@"请认真核对以上信息，确认是否进行下一步操作"]];
    self.customerInfo.isWinOrLose = NO;
    
    //默认显示自动版本视图
    [self.view addSubview:self.automaticShowView];
    [self.view addSubview:self.cowManager];
    [self winAction];
    [self changeLanguageWithType:NO];
    
    self.cowManager.hidden = YES;
    self.automaticShowView.hidden = NO;
    self.isAutomicGame = YES;
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
    @weakify(self);
    [self.viewModel getLastXueCiInfoWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        NSDictionary *tableInfo = self.viewModel.lastTableInfoDict;
        if (tableInfo&&tableInfo.count!=0) {
            NSString *fnew_xueci = tableInfo[@"fnew_xueci"];
            if(![fnew_xueci isEqual:[NSNull null]]) {
                //result是从服务器返回的数据
                //在这里进行操作
                int curNewXueci = [fnew_xueci intValue];
                self.xueciCount = curNewXueci;
            }else{
                int fXueci = [tableInfo[@"fxueci"]intValue];
                self.xueciCount = fXueci;
            }
        }
        self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
        self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
        self.puciCount = [tableInfo[@"fpuci"]intValue];
        self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
        //传输参数
        [self.cowManager transLoginInfoWithLoginID:self.viewModel.loginInfo.access_token
                                                 TableID:self.viewModel.curTableInfo.fid
                                            Serialnumber:self.serialnumber
                                                   Peilv:self.viewModel.gameInfo.xz_setting
                                               TableName:self.viewModel.curTableInfo.ftbname
                                                RijieData:self.viewModel.cp_tableRijieDate
                                              ResultDict:self.viewModel.lastTableInfoDict];
    }];
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
        self.cowManager.hidden = NO;
        self.automaticShowView.hidden = YES;
        self.isAutomicGame = NO;
        [[MJPopTool sharedInstance]popView:self.cowManager WithFatherView:self.view animated:YES];
        [self.cowManager fellXueCiWithXueCi:self.xueciCount PuCi:self.puciCount];
    }else{
        self.isAutomicGame = YES;
        [self.daily_button setTitle:[NSString stringWithFormat:@"现金版\nCash model"] forState:UIControlStateNormal];
        self.cowManager.hidden = YES;
        self.automaticShowView.hidden = NO;
        [[MJPopTool sharedInstance]popView:self.automaticShowView WithFatherView:self.view animated:YES];
    }
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

- (void)menuAction:(UIButton *)btn{
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
            [self queryDeviceChips];
        }
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
    self.dianmaBtn.hidden = hide;
    self.openTableBtn.hidden = hide;
    self.updateWashNumberBtn.hidden = hide;
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
    if (!self.clientSocket) {
        self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    // 开始连接服务器
    [self.clientSocket connectToHost:self.viewModel.curTableInfo.bindip onPort:6000 viaInterface:nil withTimeout:60 error:&error];
     [self.clientSocket readDataWithTimeout:-1 tag:0];
}

#pragma mark --重连服务器
- (void)reConnectServer{
    if (self.clientSocket.isConnected) {
        return;
    }
    [self connectToServer];
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

#pragma mark - 还原选择结果按钮状态
- (void)researtResultButtonStatus{
    [self.superDouble_button setSelected:NO];
    [self.double_button setSelected:NO];
    [self.flat_button setSelected:NO];
    [self.shazhuInfoList removeAllObjects];
    self.chipUIDList = nil;
    self.payChipUIDList = nil;
    self.shuiqianChipUIDList = nil;
    self.zhaoHuiChipUIDList = nil;
}

- (void)winAction{
    self.winOrLose = YES;
    self.customerInfo.isWinOrLose = YES;
    self.viewModel.curupdateInfo.cp_result = @"1";
    [self.win_button setSelected:YES];
    [self.lose_button setSelected:NO];
    [self _resetResultBtnStatus];
}

- (void)loseAction{
    self.winOrLose = NO;
    self.customerInfo.isWinOrLose = NO;
    self.viewModel.curupdateInfo.cp_result = @"-1";
    [self.lose_button setSelected:YES];
    [self.win_button setSelected:NO];
    [self _resetResultBtnStatus];
}

- (void)_resetResultBtnStatus{
    self.payChipUIDList = [NSArray array];
    [self.superDouble_button setSelected:NO];
    [self.double_button setSelected:NO];
    [self.flat_button setSelected:NO];
}

#pragma mark - 根据点数计算赔率
- (void)CalcuteChipMoneyWithPoint{
    [[MJPopTool sharedInstance] popView:self.cowPointShowView animated:YES];
    @weakify(self);
    self.cowPointShowView.pointsResultBlock = ^(int curPoint) {
        @strongify(self);
        //提交开牌结果
        [self showWaitingView];
        self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
        self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
        self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
        self.viewModel.curupdateInfo.cp_washNumber = self.curChipInfo.guestWashesNumber;
        [self.viewModel commitkpResultWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
            @strongify(self);
            [self hideWaitingView];
            if (success) {
                //赔率
                NSArray *xz_array = self.viewModel.gameInfo.xz_setting;
                NSDictionary *fplDict = nil;
                NSDictionary *fyjDict = nil;
                if (self.beishuType==1) {//超级翻倍
                    self.viewModel.curupdateInfo.cp_name = @"超级翻倍";
                    fplDict = xz_array[2][@"fpl"];
                    fyjDict = xz_array[2][@"fyj"];
                }else if (self.beishuType==2){//翻倍
                    self.viewModel.curupdateInfo.cp_name = @"翻倍";
                    fplDict = xz_array[1][@"fpl"];
                    fyjDict = xz_array[1][@"fyj"];
                }else{
                    self.viewModel.curupdateInfo.cp_name = @"平倍";
                    fplDict = xz_array[0][@"fpl"];
                    fyjDict = xz_array[0][@"fyj"];
                }
                if (curPoint==99) {
                    self.odds = 1;
                    self.yj = 0;
                }else{
                    self.odds = [[fplDict valueForKey:[NSString stringWithFormat:@"%d",curPoint]]floatValue];
                    self.yj = [[fyjDict valueForKey:[NSString stringWithFormat:@"%d",curPoint]]floatValue]/100;
                }
                if (self.winOrLose) {
                    if (self.beishuType==1) {
                        self.customerInfo.winStatus = @"超级翻倍赢";
                    }else if (self.beishuType==2){
                        self.customerInfo.winStatus = @"翻倍赢";
                    }else if (self.beishuType==3){
                        self.customerInfo.winStatus = @"平倍赢";
                    }
                }else{
                    if (self.beishuType==1) {
                        self.customerInfo.winStatus = @"超级翻倍输";
                    }else if (self.beishuType==2){
                        self.customerInfo.winStatus = @"翻倍输";
                    }else if (self.beishuType==3){
                        self.customerInfo.winStatus = @"平倍输";
                    }
                    self.customerInfo.drawWaterMoney = @"0";
                }
                if (curPoint==99) {
                    self.viewModel.curupdateInfo.cp_dianshu = [NSString stringWithFormat:@"%d",0];
                }else{
                    self.viewModel.curupdateInfo.cp_dianshu = [NSString stringWithFormat:@"%d",curPoint];
                }
                [self queryDeviceChips];
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

#pragma mark -- 是否可以进行下一步
- (BOOL)canResultNext{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.clientSocket.isConnected) {
        [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
        return NO;
    }
    if (self.puciCount==0) {
        [self showMessage:@"请先开启新一局" withSuccess:NO];
        return NO;
    }
    return YES;
}

#pragma mark - 超级翻倍
- (void)superDoubleAction{
    if (![self canResultNext]) {
        return;
    }
    self.beishuType = 1;
    [self.superDouble_button setSelected:YES];
    [self.double_button setSelected:NO];
    [self.flat_button setSelected:NO];
    [self CalcuteChipMoneyWithPoint];
}

#pragma mark - 翻倍
- (void)doubleAction{
    if (![self canResultNext]) {
        return;
    }
    self.beishuType = 2;
    [self.superDouble_button setSelected:NO];
    [self.double_button setSelected:YES];
    [self.flat_button setSelected:NO];
    [self CalcuteChipMoneyWithPoint];
}

#pragma mark - 平倍
- (void)flatAction{
    if (![self canResultNext]) {
        return;
    }
    self.beishuType = 3;
    [self.superDouble_button setSelected:NO];
    [self.double_button setSelected:NO];
    [self.flat_button setSelected:YES];
    [self CalcuteChipMoneyWithPoint];
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
    [self.daily_button setTitle:[NSString stringWithFormat:@"现金版\nCash model"] forState:UIControlStateNormal];
    [self.nextGame_button setTitle:[NSString stringWithFormat:@"新一局\n%@",[EPStr getStr:kEPNewGame note:@"新一局"]] forState:UIControlStateNormal];
    [self.superDouble_button setTitle:[EPStr getStr:kEPSuperDouble note:@"超级翻倍"] forState:UIControlStateNormal];
    [self.double_button setTitle:[EPStr getStr:kEPDouble note:@"翻倍"] forState:UIControlStateNormal];
    [self.lose_button setTitle:[EPStr getStr:kEPLose note:@"输"] forState:UIControlStateNormal];
    [self.flat_button setTitle:[EPStr getStr:kEPPingTimes note:@"平倍 Equal"] forState:UIControlStateNormal];
    [self.win_button setTitle:[EPStr getStr:kEPWin note:@"赢"] forState:UIControlStateNormal];
    [self.aTipRecordButton setTitle:[NSString stringWithFormat:@"记录小费\nTip"] forState:UIControlStateNormal];
    [self.zhuxiaochouma_button setTitle:@"换钱\nChange money" forState:UIControlStateNormal];
    [self.readChip_button setTitle:@"筹码识别\nDetection chip" forState:UIControlStateNormal];
}

#pragma mark - 更改客人洗码号
- (void)showUpdateWashNumberView{
    self.isUpdateWashNumber = NO;
    [[MJPopTool sharedInstance] popView:self.empowerView animated:YES];
    @weakify(self);
    self.empowerView.sureActionBlock = ^(NSString * _Nonnull adminName, NSString * _Nonnull password) {
        @strongify(self);
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.viewModel authorizationAccountWitAccountName:adminName Password:password Block:^(BOOL success, NSString *msg, EPSreviceError error) {
                [self hideWaitingView];
                if (success) {
                    [EPPopView showEntryInView:self.view WithTitle:@"请输入洗码号" handler:^(NSString *entryText) {
                        @strongify(self);
                        if ([[entryText NullToBlankString]length]==0) {
                            [self showMessage:@"请输入洗码号"];
                        }else{
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                // 处理耗时操作的代码块...
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self showWaitingView];
                                });
                            });
                            [self.viewModel updateCustomerWashNumberWithChipList:self.chipUIDList CurWashNumber:entryText AdminName:adminName Block:^(BOOL success, NSString *msg, EPSreviceError error) {
                                @strongify(self);
                                if (success) {
                                    self.isUpdateChip = YES;
                                    self.operateChipCount = (int)self.chipUIDList.count;
                                    for (int i = 0; i < self.chipUIDList.count; i++) {
                                        self.curChipInfo.chipUID = self.chipUIDList[i];
                                        self.curChipInfo.guestWashesNumber = entryText;
                                        //向指定标签中写入数据（块1）
                                        [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                                        usleep(self.operateChipCount * 10000);
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
            }];
        });
    };
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
            [self hideWaitingView];
            if (success) {
                self.puciCount =0;
                self.xueciCount +=1;
                if (!self.isAutomicGame) {
                    [self.cowManager fellXueCiWithXueCi:self.xueciCount PuCi:self.puciCount];
                }else{
                    self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
                    self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
                }
                [self.viewModel postNewxueciWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                }];
                self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
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
    };
}

#pragma mark - 修改露珠
- (void)updateLuzhu{
    [self showMessage:@"暂无露珠可修改" withSuccess:NO];
    //响警告声音
    [EPSound playWithSoundName:@"wram_sound"];
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
      if (self.cowManager.puciCount==0) {
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
                        [LYKeychainTool deleteKeychainValue:[NSString stringWithFormat:@"%@_RijieDate",self.viewModel.curTableInfo.fid]];
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
        if (!self.clientSocket.isConnected) {
            [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
            return;
        }
    }
    @weakify(self);
    [EPPopView showInWindowWithMessage:[NSString stringWithFormat:@"是否确定开启新一局？\n%@",[EPStr getStr:kEPSureNextGame note:@"确定开启新一局？"]] handler:^(int buttonType) {
        @strongify(self);
        if (buttonType==0) {
            self.puciCount +=1;
            if (!self.isAutomicGame) {
                [self.cowManager fellXueCiWithXueCi:self.xueciCount PuCi:self.puciCount];
            }else{
                self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
            }
            [self.cowManager clearMoney];
            [self showMessage:@"开启新一局成功" withSuccess:YES];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
        }
    }];
}

#pragma mark - 打散筹码
- (void)zhuxiaoAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.clientSocket.isConnected) {
        [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
        return;
    }
    self.isBreakUpChip = YES;
    [self queryDeviceChips];
}

- (void)breakUpChip{
    self.isBreakUpChip = NO;
    [self hideWaitingView];
    [self bindChipsWithWashNumber];
}

#pragma mark - 绑定筹码
- (void)bindChipsWithWashNumber{
    @weakify(self);
    self.daSanInfoView = [EPDaSanInfoView showInWindowWithNRCustomerInfo:self.curChipInfo handler:^(int buttonType) {
        @strongify(self);
        if (buttonType==1) {
            self.isBindChipWashNumber = YES;
            [self queryDeviceChips];
        }else{
            [self hideWaitingView];
        }
    }];
}

#pragma mark - 读取赔绑定筹码信息
- (void)readAllBindChipsInfo{
    //向指定标签中写入数据（所有块）
    for (int i = 0; i < self.bindChipUIDList.count; i++) {
        NSString *chipID = self.bindChipUIDList[i];
        [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
        usleep((int)self.bindChipUIDList.count * 10000);
    }
}

#pragma mark--打散或者绑定筹码
- (void)distoryOrbindChipInfo{
    [self.viewModel changeChipWashNumberWithChipList:self.chipUIDList WashNumber:self.curBindChipWashNumber ChangChipList:self.bindChipUIDList Block:^(BOOL success, NSString *msg, EPSreviceError error) {
        self.isBindChipWashNumber = NO;
        if (success) {
            self.isDasanChip = YES;
            self.operateChipCount = (int)self.chipUIDList.count+(int)self.bindChipUIDList.count;
            for (int i = 0; i < self.chipUIDList.count; i++) {
                NSString *chipUID = self.chipUIDList[i];
                //向指定标签中写入数据（块1）
                [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                usleep(self.operateChipCount * 10000);
            }
            for (int i = 0; i < self.bindChipUIDList.count; i++) {
                self.curChipInfo.guestWashesNumber = self.curBindChipWashNumber;
                self.curChipInfo.chipUID = self.bindChipUIDList[i];
                //向指定标签中写入数据（块1）
                [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                usleep(self.operateChipCount * 10000);
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

#pragma mark - 记录小费
- (void)recordTipMoneyAction:(UIButton *)btn{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.clientSocket.isConnected) {
        [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
        return;
    }
    self.isRecordTipMoney = YES;
    [self queryDeviceChips];
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

#pragma mark - 识别筹码
- (void)readChipsAction{
    self.isShowChipInfo = YES;
    self.chipUIDList = nil;
    self.payChipUIDList = nil;
    self.shuiqianChipUIDList = nil;
    self.zhaoHuiChipUIDList = nil;
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
            [self queryDeviceChips];
        }else{
            self.chipUIDList = nil;
            self.isShowChipInfo = NO;
        }
    };
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

#pragma mark - 弹出结果
- (void)showStatusInfo{
    self.viewModel.curupdateInfo.cp_washNumber = self.curChipInfo.guestWashesNumber;
    self.viewModel.curupdateInfo.cp_benjin = self.curChipInfo.chipDenomination;
    self.customerInfo.chipType = self.curChipInfo.chipType;
    self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
    self.customerInfo.hasDashui = YES;
    self.isShowingResult = YES;
    self.customerInfo.odds = self.odds;
    self.viewModel.curupdateInfo.cp_zhaohuiList = [NSArray array];
    self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
    self.viewModel.curupdateInfo.cp_ChipUidList = self.chipUIDList;
    self.customerInfo.drawWaterMoney = @"0";
    if (self.odds>1&&!self.winOrLose) {
        self.customerInfo.isCow = YES;
    }else{
        self.customerInfo.isCow = NO;
    }
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
                [self queryDeviceChips];
            }else if (payConfirmType==2){//关闭并清除所有信息
                [EPSound playWithSoundName:@"click_sound"];
                [self clearChipCacheData];
                self.isShowingResult = NO;
                [self _resetResultBtnStatus];
            }else if (payConfirmType==3){//识别水钱
                self.isDashui = YES;
                [self queryDeviceChips];
            }
        };
    }else{
        [[MJPopTool sharedInstance] popView:self.killShowView animated:YES];
        self.killShowView.cowHadMoneyLab.text = [NSString stringWithFormat:@"%@:0",@"已加赔"];
        self.killShowView.cowZhaohuiMoneyLab.text = [NSString stringWithFormat:@"%@:0",@"已找回"];
        [self.killShowView fellViewDataNRCustomerInfo:self.customerInfo];
        @weakify(self);
        self.killShowView.sureActionBlock = ^(NSInteger killConfirmType) {
            @strongify(self);
            if (killConfirmType==1) {//确认
                if (self.customerInfo.isCow) {//有加赔
                }else{
                    self.isShaZhuAction = YES;
                }
                [self queryDeviceChips];
            }else if (killConfirmType==2){//关闭
                [EPSound playWithSoundName:@"click_sound"];
                [self clearChipCacheData];
                self.isShowingResult = NO;
                [self _resetResultBtnStatus];
            }else if (killConfirmType==3){//识别找回筹码
                [EPSound playWithSoundName:@"click_sound"];
                self.isZhaoHui = YES;
                [self queryDeviceChips];
            }
        };
    }
}

#pragma mark--写入赔付筹码洗码号
- (void)writePayChipsWashNumberCommand{
    self.isOperateChip = YES;
    self.operateChipCount = (int)self.payChipUIDList.count+(int)self.shuiqianChipUIDList.count;
    for (int i = 0; i < self.payChipUIDList.count; i++) {
        self.curChipInfo.chipUID = self.payChipUIDList[i];
        //向指定标签中写入数据（块1）
        [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
        usleep(self.operateChipCount * 10000);
    }
    //清除水钱洗码号
    for (int i=0; i<self.shuiqianChipUIDList.count; i++) {
        NSString *chipUID = self.shuiqianChipUIDList[i];
        //向指定标签中写入数据（块1）
        [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
        usleep(self.operateChipCount * 10000);
    }
}

#pragma mark - 提交客人输赢记录
- (void)commitCustomerInfoWithRealChipUIDList:(NSArray *)realChipUIDList{
    self.viewModel.curupdateInfo.cp_chipType = self.curChipInfo.chipType;
    self.isShaZhuAction = NO;
    @weakify(self);
    [self.viewModel commitCustomerRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        if (success) {
            self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
            self.serialnumber = [NRCommand randomStringWithLength:30];
            self.isShowingResult = NO;
            if (self.winOrLose) {
                [self writePayChipsWashNumberCommand];
            }else{
                [self clearChipListWashNumber];
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

#pragma mark -- 清除洗码号
- (void)clearChipListWashNumber{
    self.isOperateChip = YES;
    self.operateChipCount = (int)self.chipUIDList.count+(int)self.payChipUIDList.count+(int)self.zhaoHuiChipUIDList.count;
    for (int i = 0; i < self.chipUIDList.count; i++) {
        NSString *chipUID = self.chipUIDList[i];
        //向指定标签中写入数据（块1）
        [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
        usleep(self.operateChipCount * 10000);
    }
    for (int i = 0; i < self.payChipUIDList.count; i++) {
        NSString *chipUID = self.payChipUIDList[i];
        //向指定标签中写入数据（块1）
        [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
        usleep(self.operateChipCount * 10000);
    }
    
    for (int i = 0; i < self.zhaoHuiChipUIDList.count; i++) {
        self.curChipInfo.chipUID = self.zhaoHuiChipUIDList[i];
        //向指定标签中写入数据（块1）
        [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
        usleep(self.operateChipCount * 10000);
    }
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
            self.serialnumber = [NRCommand randomStringWithLength:30];
            self.isShowingResult = NO;
            [self clearChipListWashNumber];
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

#pragma mark - 清除筹码数据
- (void)clearChipCacheData{
    self.payChipUIDList = nil;
    self.tipChipUIDList = nil;
    self.shuiqianChipUIDList = nil;
    self.zhaoHuiChipUIDList = nil;
    self.identifyValue = 0;
    self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
}

#pragma mark --清除状态值
- (void)clearStatusValue{
    self.isBreakUpChip = NO;
    self.isReadChipUID = NO;
    self.isOperateChip = NO;
    self.isShowChipInfo = NO;
    self.isRecordTipMoney = NO;
    self.isZhaoHui = NO;
}

#pragma mark - 查询设备上的筹码UID
- (void)queryDeviceChips{
    [EPSound playWithSoundName:@"click_sound"];
    [self showWaitingView];
    //设置感应盘工作模式
    self.isReadChipUID = YES;
    self.chipUIDData = nil;
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 识别筹码金额
- (void)readCurChipsMoney{
    //向指定标签中写入数据（所有块）
    [self.viewModel checkChipIsTrueWithChipList:self.chipUIDList Block:^(BOOL success, NSString *msg, EPSreviceError error) {
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
            [self hideWaitingView];
            [self researtResultButtonStatus];
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
- (void)readAllPayChipsInfo{
    //向指定标签中写入数据（所有块）
    for (int i = 0; i < self.payChipUIDList.count; i++) {
        NSString *chipID = self.payChipUIDList[i];
        [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
        usleep((int)self.payChipUIDList.count * 10000);
    }
}

#pragma mark - 读取找回筹码信息
- (void)readAllZhaoHuiChipsInfo{
    //向指定标签中写入数据（所有块）
    for (int i = 0; i < self.zhaoHuiChipUIDList.count; i++) {
        NSString *chipID = self.zhaoHuiChipUIDList[i];
        [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
        usleep((int)self.zhaoHuiChipUIDList.count * 10000);
    }
}

#pragma mark - 读取小费筹码信息
- (void)readAllTipChipsInfo{
    //向指定标签中写入数据（所有块）
    for (int i = 0; i < self.tipChipUIDList.count; i++) {
        NSString *chipID = self.tipChipUIDList[i];
        [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
        usleep((int)self.tipChipUIDList.count * 10000);
    }
}

#pragma mark - 计算赔率或者杀注金额
- (void)caclulateMoney{
    if (self.winOrLose) {
        [self winInfoShow];
    }else{
        NSString *realCashMoney = self.curChipInfo.chipDenomination;
        self.customerInfo.xiazhu = [NSString stringWithFormat:@"%@",realCashMoney];
        self.customerInfo.shazhu = [NSString stringWithFormat:@"%.f",self.odds*[realCashMoney floatValue]];
        self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"应加赔:%.f",(self.odds-1)*[realCashMoney floatValue]];
        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
        self.viewModel.curupdateInfo.cp_result = @"-1";
        self.viewModel.curupdateInfo.cp_commission = @"0";
        self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",self.odds*[realCashMoney floatValue]];
    }
}

//识别水钱
- (void)identifyWaterMoney{
    self.isDashui = NO;
    [self winInfoShow];
}

- (void)winInfoShow{
    NSString *realCashMoney = self.curChipInfo.chipDenomination;
    CGFloat compensateMoney = self.odds*[realCashMoney floatValue];//应赔
    CGFloat yongjinMoney = self.yj*compensateMoney;//佣金
    self.customerInfo.compensateCode = [NSString stringWithFormat:@"%.f",compensateMoney];
    self.viewModel.curupdateInfo.cp_commission = [NSString stringWithFormat:@"%.f",yongjinMoney];//佣金
    self.customerInfo.compensateMoney = [NSString stringWithFormat:@"%.f",compensateMoney-yongjinMoney+self.identifyValue];
    self.customerInfo.totalMoney = [NSString stringWithFormat:@"%.f",[realCashMoney floatValue]+compensateMoney-yongjinMoney+self.identifyValue];
    self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",[realCashMoney floatValue]+compensateMoney-yongjinMoney];
    self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%.f",self.identifyValue];
    [self.payShowView fellViewDataNRCustomerInfo:self.customerInfo];
    self.identifyValue = 0;
}

#pragma mark - 读取水钱筹码信息
- (void)readAllShuiqianChipsInfo{
    //向指定标签中写入数据（所有块）
    for (int i = 0; i < self.shuiqianChipUIDList.count; i++) {
        NSString *chipID = self.shuiqianChipUIDList[i];
        [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
        usleep((int)self.shuiqianChipUIDList.count * 10000);
    }
}

#pragma mark - 关闭设备自动感应
- (void)closeDeviceWorkModel{
    //设置感应盘工作模式
    self.isSetUpDeviceModel = YES;
    [self.clientSocket writeData:[NRCommand setDeviceWorkModel] withTimeout:- 1 tag:0];
}

#pragma mark - 设置设备功率
- (void)setBigDevicePower{
    [self.clientSocket writeData:[NRCommand setDeviceWorkPower] withTimeout:- 1 tag:0];
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
//    [self setBigDevicePower];
    [self sendDeviceKeepAlive];
    //    连接后,可读取服务器端的数据
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err{
    DLOG(@"进入这里11");
    [self reConnectServer];
}

// 收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 读取到服务器数据值后也能再读取
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    DLOG(@"data = %@",data);
    if (!self.chipUIDData) {
        self.chipUIDData = [NSMutableData data];
    }
    NSString *dataHexStr = [NRCommand hexStringFromData:data];
    if ([dataHexStr isEqualToString:@"050020a04feb"]) {
        return;
    }
    //将数据存入缓存区
    [self.chipUIDData appendData:data];
    if (self.isSetUpDeviceModel) {
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"040000525a" withString:@"040000525a"
           options:NSLiteralSearch
             range:NSMakeRange(0, [chipNumberdataHexStr length])];
        if (count==2) {
            self.isSetUpDeviceModel= NO;
            self.chipUIDData = nil;
        }
        return;
    }
    DLOG(@"self.chipUIDData = %@",self.chipUIDData);
    NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
    if (self.isOperateChip||self.isDasanChip||self.isUpdateChip) {//正在操作筹码，赔付或者杀注
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        int statusCount = [NRCommand showBackStatusCountWithHexStatus:chipNumberdataHexStr AllChipCount:self.operateChipCount];
        if (statusCount==1||statusCount==2) {
            self.chipUIDData = nil;
            self.operateChipCount = 0;
            if (self.isOperateChip) {
                self.isOperateChip = NO;
                if (self.winOrLose) {
                    if (statusCount==1) {
                        self.writeCount = 0;
                        self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                        [self.payShowView clearPayShowInfo];
                        [self.payShowView removeFromSuperview];
                        [self showMessage:@"赔付成功" withSuccess:YES];
                    }else{
                        self.writeCount+=1;
                        if (self.writeCount>=3) {
                            self.writeCount = 0;
                            self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                            [self.payShowView clearPayShowInfo];
                            [self.payShowView removeFromSuperview];
                            [self showLongMessage:@"赔付成功,但是赔付筹码数据写入异常，请检查!!!" withSuccess:YES];
                        }else{
                           [self writePayChipsWashNumberCommand];
                        }
                    }
                }else{
                    if (statusCount==1) {
                        self.clearCount = 0;
                        [self.killShowView clearKillShowView];
                        [self.killShowView removeFromSuperview];
                        [self researtResultButtonStatus];
                        [self showMessage:[EPStr getStr:kEPShazhuSucceed note:@"杀注成功"] withSuccess:YES];
                    }else{
                       self.clearCount+=1;
                        if (self.clearCount>=3) {
                            self.clearCount = 0;
                            [self.killShowView clearKillShowView];
                            [self.killShowView removeFromSuperview];
                            [self researtResultButtonStatus];
                            [self showLongMessage:@"杀注成功,但是筹码数据清除异常，请检查!!!" withSuccess:YES];
                        }else{
                           [self clearChipListWashNumber];
                        }
                    }
                }
            }else if (self.isUpdateChip){
                self.isUpdateChip = NO;
                if (statusCount==1) {
                    [self showMessage:@"修改成功" withSuccess:YES];
                }else{
                    [self showMessage:@"修改成功,但是筹码数据修改异常，请检查!!!" withSuccess:YES];
                }
            }else{
                [self.daSanInfoView _hide];
                self.isDasanChip = NO;
                if (statusCount==1) {
                    [self showMessage:@"打散成功" withSuccess:YES];
                }else{
                    [self showMessage:@"打散成功,但是筹码数据写入异常，请检查!!!" withSuccess:YES];
                }
            }
            [self hideWaitingView];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
        }
    }else if (self.isReadChipUID) {//正在识别筹码
        //是否完整包含结束字符04000e2cb3
        if ([chipNumberdataHexStr hasSuffix:@"04000e2cb3"]) {//检测到结束字符,识别筹码UID完毕
            self.chipUIDData = nil;
            self.isReadChipUID = NO;
            chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"04000e2cb3" withString:@""];
            chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"040000525a" withString:@""];
            NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"0d000000" withString:@"0d000000"
               options:NSLiteralSearch
                 range:NSMakeRange(0, [chipNumberdataHexStr length])];
            if (count==0) {//设备上没有筹码
                [self clearStatusValue];
                if (self.isRecordTipMoney) {//记录小费
                    self.tipChipUIDList = nil;
                    self.isRecordTipMoney = NO;
                    [self showMessage:@"未检测到小费筹码"];
                }else{
                    self.isUpdateWashNumber = NO;
                    [self researtResultButtonStatus];
                    [self.chipInfoList removeAllObjects];
                    [self.chipInfoView fellChipViewWithChipList:self.chipInfoList];
                    self.isShaZhuAction = NO;
                    [self showMessage:@"未检测到筹码"];
                }
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
                [self hideWaitingView];
                return;
            }
            BLEIToll *itool = [[BLEIToll alloc]init];
            if (self.isShowingResult) {//已经弹出结果展示界面
                if (self.isDashui){//识别水钱
                    //存贮筹码UID
                    self.shuiqianChipUIDList = [itool getDeviceRealShuiqianChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithPayUidList:self.payChipUIDList];
                    self.shuiqianChipCount = self.shuiqianChipUIDList.count;
                    if (self.shuiqianChipCount==0) {//没有水钱筹码
                        self.isDashui = NO;
                        self.shuiqianChipUIDList = nil;
                        [self showLognMessage:@"未检测到水钱筹码"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self hideWaitingView];
                    }else{
                        //有水钱筹码，识别水钱信息
                        self.isReadChipInfo = YES;
                        self.viewModel.curupdateInfo.cp_DashuiUidList = self.shuiqianChipUIDList;
                        [self readAllShuiqianChipsInfo];
                    }
                }else if (self.isShaZhuAction){//杀注界面
                    if (count != self.chipUIDList.count) {
                        self.isShaZhuAction = NO;
                        [self showLognMessage:@"筹码金额不一致"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self hideWaitingView];
                        return;
                    }
                    //提交杀注结果
                    [self commitCustomerInfo_ShaZhuWithRealChipUIDList:self.chipUIDList];
                }else if (self.isZhaoHui){
                    //找回筹码UID
                    self.zhaoHuiChipUIDList = [itool getDeviceALlPayChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithShuiqianUidList:self.payChipUIDList];
                    self.zhaoHuiChipCount = self.zhaoHuiChipUIDList.count;
                    if (self.zhaoHuiChipCount==0) {
                        self.isZhaoHui = NO;
                        self.zhaoHuiChipUIDList = nil;
                        self.killShowView.cowZhaohuiMoneyLab.text = [NSString stringWithFormat:@"%@:%d",@"已找回",0];
                        [self hideWaitingView];
                        [self showMessage:@"未检测到找回筹码"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                    }else{
                        self.isReadChipInfo = YES;
                        [self readAllZhaoHuiChipsInfo];
                    }
                }else{
                    //赔付筹码UID
                    self.payChipUIDList = [itool getDeviceCow_ALlPayChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithShuiqianUidList:self.shuiqianChipUIDList WithZhaoHuiUidList:self.zhaoHuiChipUIDList];
                    self.payChipCount = self.payChipUIDList.count;
                    if (self.payChipCount==0) {
                        self.payChipUIDList = nil;
                        self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                        [self hideWaitingView];
                        [self showMessage:@"未检测到赔付筹码"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                    }else{
                        self.isReadChipInfo = YES;
                        [self readAllPayChipsInfo];
                    }
                }
            }else if (self.isBindChipWashNumber){//绑定筹码
                //存贮筹码UID
                self.bindChipUIDList = [itool getDeviceALlPayChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithShuiqianUidList:[NSArray array]];
                self.bindChipCount = self.bindChipUIDList.count;
                if (self.bindChipCount==0) {
                    self.bindChipUIDList = nil;
                    self.isBindChipWashNumber = NO;
                    [self showMessage:@"未检测到与打散筹码相同金额的筹码"];
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                    [self hideWaitingView];
                    return;
                }else{
                    self.isReadChipInfo = YES;
                    [self readAllBindChipsInfo];
                }
            }else if (self.isRecordTipMoney){//记录小费
                //存贮筹码UID
                self.tipChipUIDList = [itool getDeviceALlTipsChipUIDWithBLEString:chipNumberdataHexStr];
                self.tipChipCount = self.tipChipUIDList.count;
                self.isReadChipInfo = YES;
                [self readAllTipChipsInfo];
            }else{//本金
                //存贮筹码UID
                self.chipUIDList = [itool getDeviceAllChipUIDWithBLEString:chipNumberdataHexStr];
                self.chipCount = self.chipUIDList.count;
                DLOG(@"self.chipCount = %ld",(long)self.chipCount);
                if(self.isUpdateWashNumber){//更改洗码号
                    [self hideWaitingView];
                    [self showUpdateWashNumberView];
                }else{
                    self.isReadChipInfo = YES;
                    [self readCurChipsMoney];//识别下注本金
                }
            }
        }
    }else if (self.isReadChipInfo){//正在识别筹码信息
        //总数据长度130000001001000a002019120800789000006b73
        NSInteger infoByteLength = 40;
        if (self.isShowingResult) {//已经弹出结果展示界面
            if (self.isDashui){//识别水钱
                infoByteLength = self.shuiqianChipCount*infoByteLength;
            }else if (self.isZhaoHui){
                infoByteLength = self.zhaoHuiChipCount*infoByteLength;
            }else{
                infoByteLength = self.payChipCount*infoByteLength;
            }
        }else if (self.isBindChipWashNumber){//绑定筹码
            infoByteLength = self.bindChipCount*infoByteLength;
        }else if (self.isRecordTipMoney){//记录小费
            infoByteLength = self.tipChipCount*infoByteLength;
        }else{//本金
            infoByteLength = self.chipCount*infoByteLength;
        }
        if (chipNumberdataHexStr.length==infoByteLength) {//数据长度相同，筹码信息已经接受完毕
            self.chipUIDData = nil;
            BLEIToll *itool = [[BLEIToll alloc]init];
            NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr WithSplitSize:3];
            DLOG(@"ChipInfo = %@",chipInfo);
            if (self.isShowingResult) {
                if (self.isDashui) {
                    __block BOOL isWashNumberTrue = YES;
                    [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *chipWashNumber = infoList[4];
                        if ([[chipWashNumber NullToBlankString]length]==0||[chipWashNumber isEqualToString:@"0"]) {
                            isWashNumberTrue = NO;
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
                }else if (self.isZhaoHui){//杀注找回筹码
                    self.isZhaoHui = NO;
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
                    [self hideWaitingView];
                    if (!isWashNumberTrue) {
                        [self showMessage:@"找回筹码不正确"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        return;
                    }
                    if (washNumberList.count>1) {
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self showMessage:@"不能出现多种洗码号"];
                        return;
                    }
                    if (chipTypeList.count>1) {
                        [self showMessage:@"存在多个筹码类型"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        return;
                    }
                    if (![chipTypeList.firstObject isEqualToString:self.curChipInfo.chipType]) {
                        [self showMessage:@"找回筹码类型与本金筹码类型不一致"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.viewModel.curupdateInfo.cp_zhaohuiList = self.zhaoHuiChipUIDList;
                        self.curChipInfo.hasKillZhaohuiMoney = [NSString stringWithFormat:@"%d",chipAllMoney];
                        self.killShowView.cowZhaohuiMoneyLab.text = [NSString stringWithFormat:@"%@:%d",@"已找回",chipAllMoney];
                    });
                }else{//赔付筹码
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
                        if (self.customerInfo.isCow) {
                            if (![chipWashNumber isEqualToString:@"0"]){
                                if (![washNumberList containsObject:chipWashNumber]) {
                                    [washNumberList addObject:chipWashNumber];
                                }
                            }else{
                                isWashNumberTrue = NO;
                            }
                        }else{
                           if ([chipWashNumber isEqualToString:@"0"]){
                               if (![washNumberList containsObject:chipWashNumber]) {
                                   [washNumberList addObject:chipWashNumber];
                               }
                           }else{
                               isWashNumberTrue = NO;
                           }
                        }
                        if (![chipTypeList containsObject:chipType]) {
                            [chipTypeList addObject:chipType];
                        }
                    }];
                    if (!isWashNumberTrue) {
                        if (self.customerInfo.isCow) {
                            [self showMessage:@"加赔金额不正确"];
                        }else{
                            self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                            [self showMessage:@"赔付筹码有误"];
                        }
                        [self hideWaitingView];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        return;
                    }
                    if (self.customerInfo.isCow) {
                        if (washNumberList.count>1) {
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
                            [self showMessage:@"不能出现多种洗码号"];
                            self.isShowingResult = NO;
                            return;
                        }
                    }
                    if (chipTypeList.count>1) {
                        [self showMessage:@"存在多个筹码类型"];
                        [self hideWaitingView];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        return;
                    }
                    if (![chipTypeList.firstObject isEqualToString:self.curChipInfo.chipType]) {
                        if (self.customerInfo.isCow) {
                            [self showMessage:@"加赔筹码类型与本金筹码类型不一致"];
                        }else{
                            [self showMessage:@"赔付筹码类型与本金筹码类型不一致"];
                        }
                        [self hideWaitingView];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableArray *realChipUIDList = [NSMutableArray array];
                        [realChipUIDList addObjectsFromArray:self.chipUIDList];
                        [realChipUIDList addObjectsFromArray:self.payChipUIDList];
                        self.viewModel.curupdateInfo.cp_ChipUidList = realChipUIDList;
                        if (!self.customerInfo.isCow) {
                            int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                            self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",benjinMoney+chipAllMoney];
                            self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",chipAllMoney];
                        }else{
                            self.killShowView.cowHadMoneyLab.text = [NSString stringWithFormat:@"%@:%d",@"已加赔",chipAllMoney];
                        }
                        [self commitCustomerInfoWithRealChipUIDList:realChipUIDList];
                    });
                }
            }else if (self.isBindChipWashNumber){//打散筹码
                //筹码额
                __block int chipAllMoney = 0;
                [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                    chipAllMoney += [realmoney intValue];
                }];
                __block BOOL isWashNumberTrue = YES;
                [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *chipWashNumber = infoList[4];
                    if (![chipWashNumber isEqualToString:@"0"]){
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
                self.daSanInfoView.hasPayMoneyLab.text = [NSString stringWithFormat:@"已放入金额:%d",chipAllMoney];
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
            }else if (self.isBreakUpChip){//打散筹码
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
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                    self.isBreakUpChip = NO;
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
                [self breakUpChip];
            }else if (self.isRecordTipMoney){//记录小费
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
            }else{//本金
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
                if ((!isWashNumberTrue)||self.washNumberList.count==0) {
                   //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                    [self showLognMessage:@"检测到有异常洗码号的筹码"];
                    [self hideWaitingView];
                    [self researtResultButtonStatus];
                    return;
                }
                //筹码类型
                NSString *chipType = [self.chipTypeList.firstObject NullToBlankString];
                self.curChipInfo.chipType = chipType;
                //客人洗码号
                self.curChipInfo.guestWashesNumber = self.washNumberList.firstObject;
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
                    self.customerInfo.chipInfoList = self.shazhuInfoList;
                    [self caclulateMoney];
                    [self hideWaitingView];
                    [self showStatusInfo];
                });
            }
        }
    }
}

@end
