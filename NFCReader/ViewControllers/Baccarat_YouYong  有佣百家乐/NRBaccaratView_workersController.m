//
//  NRBaccaratViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRBaccaratView_workersController.h"
#import "EPPopAlertShowView.h"
#import "NRCustomerInfo.h"
#import "EPPopView.h"
#import "JXButton.h"
#import "EPService.h"
#import "NRLoginInfo.h"
#import "NRBaccarat_workersViewModel.h"
#import "EPResultShowView.h"
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
#import "NRManualManger_workers.h"
#import "IQKeyboardManager.h"

#import "TableDataInfoView.h"
#import "EmpowerView.h"
#import "ModificationResultsView.h"
#import "TableJiaJiancaiView.h"

#import "EPSixWinShowView.h"
#import "EPINSShowView.h"
#import "EPINSOddsShowView.h"

#import "EPKillShowView.h"
#import "EPPayShowView.h"
#import "ChipInfoView.h"

#import "EPWebViewController.h"

@interface NRBaccaratView_workersController ()<GCDAsyncSocketDelegate>

//台桌数据
@property (nonatomic, strong) TableDataInfoView *tableDataInfoV;

//授权验证
@property (nonatomic, strong) EmpowerView *empowerView;

//修改露珠
@property (nonatomic, strong) ModificationResultsView *modifyResultsView;

//加减彩
@property (nonatomic, strong) TableJiaJiancaiView *addOrMinusView;
//筹码信息
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

//六点赢
@property (nonatomic, strong) EPSixWinShowView *sixWinShowView;
//保险弹出
@property (nonatomic, strong) EPINSShowView *insShowView;
@property (nonatomic, strong) EPINSOddsShowView *insOddsShowView;
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
@property (nonatomic, strong) NSMutableArray *luzhuInfoList;

//结算台
@property (nonatomic, strong) UIImageView *settlementImgV;
@property (nonatomic, strong) UILabel *settlementLab;
@property (nonatomic, strong) UIView *settlementV;
@property (nonatomic, strong) UIButton *zhuangBtn;
@property (nonatomic, strong) UIButton *zhuangDuiBtn;
@property (nonatomic, strong) UIButton *sixWinBtn;
@property (nonatomic, strong) UIButton *xianBtn;
@property (nonatomic, strong) UIButton *xianDuiBtn;
@property (nonatomic, strong) UIButton *heBtn;
@property (nonatomic, strong) UIButton *setmentOKBtn;

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
@property (nonatomic, assign) int prePuciCount;

//手动版视图
@property (nonatomic, strong) NRManualManger_workers *manuaManagerView;
@property (nonatomic, assign) BOOL isAutomicGame;//是否手动版
@property (nonatomic, assign) BOOL isFirstEntryGame;//是否刚进入游戏

@property (nonatomic, assign) BOOL isUpdateChip;//是否操作筹码
@property (nonatomic, assign) BOOL isDasanChip;//是否打散筹码
@property (nonatomic, assign) int updateChipCount;//正在操作筹码的数量

//赢
@property (nonatomic, assign) NSInteger bindChipCount;
@property (nonatomic, strong) NSArray *bindChipUIDList;
@property (nonatomic, assign) BOOL isBindChipWashNumber;//是否绑定洗码号
@property (nonatomic, assign) BOOL isBreakUpChip;//是否打散筹码

@property (nonatomic, strong) NSMutableArray *washNumberList;
@property (nonatomic, strong) NSMutableArray *chipTypeList;//筹码类型数据
@property (nonatomic, strong) NSMutableArray *shazhuInfoList;//杀注信息
@property (nonatomic, strong) NSString *curBindChipWashNumber;//需要绑定筹码的洗码号
@property (nonatomic, assign) BOOL winOrLose;

@property (nonatomic, strong) UIButton *zhuang_button;
@property (nonatomic, strong) UIButton *xian_button;
@property (nonatomic, strong) UIButton *zhuangduizi_button;
@property (nonatomic, strong) UIButton *xianduizi_button;
@property (nonatomic, strong) UIButton *he_button;
@property (nonatomic, strong) UIButton *baoxian_button;
@property (nonatomic, strong) UIButton *luckysix_button;

@property (nonatomic, strong) NRCustomerInfo *customerInfo;
@property (nonatomic, assign) BOOL isBaoxian;
@property (nonatomic, assign) BOOL isLucky;//是否幸运6点

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
@property (nonatomic, assign) BOOL isShaZhuAction;//是否杀注操作

@property (nonatomic, strong) NSString *serialnumber;//流水号
@property (nonatomic, strong) EPPopAlertShowView *resultShowView;
@property (nonatomic, strong) EPPopAtipInfoView *recordTipShowView;//识别小费
@property (nonatomic, strong) NSMutableArray *resultList;//

//操作中心
@property (nonatomic, strong) UIImageView *operateCenterImgV;
@property (nonatomic, strong) UILabel *operateCenterLabel;
@property (nonatomic, strong) UIView *operateCenterView;

// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSMutableData *chipUIDData;
@property (nonatomic, assign) CGFloat result_odds;
@property (nonatomic, assign) CGFloat result_yj;
@property (nonatomic, assign) CGFloat identifyValue;//水钱

@end

@implementation NRBaccaratView_workersController

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
            make.left.equalTo(self.operateCenterView).offset(10);
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
            make.left.equalTo(self.operateCenterView).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(160);
        }];
        
        CGFloat result_w = (kScreenWidth -230)/2;
        CGFloat result_h = 98;
        self.zhuang_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.zhuang_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.zhuang_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.zhuang_button.tag = 0;
        [self.zhuang_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_lose_redIcon"] forState:UIControlStateSelected];
        [self.zhuang_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.zhuang_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.zhuang_button];
        [self.zhuang_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.operateCenterView).offset(15);
            make.left.equalTo(self.aTipRecordButton.mas_right).offset(15);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_w);
        }];

        self.xian_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.xian_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.xian_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.xian_button.tag = 1;
        [self.xian_button setBackgroundImage:[UIImage imageNamed:@"tiger_selectedIcon"] forState:UIControlStateSelected];
        [self.xian_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.xian_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.operateCenterView addSubview:self.xian_button];
        [self.xian_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.operateCenterView).offset(15);
            make.right.equalTo(self.operateCenterView).offset(-10);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_w);
        }];

        self.zhuangduizi_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.zhuangduizi_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.zhuangduizi_button.tag = 2;
        self.zhuangduizi_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        [self.zhuangduizi_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_lose_redIcon"] forState:UIControlStateSelected];
        [self.zhuangduizi_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.zhuangduizi_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.zhuangduizi_button];
        [self.zhuangduizi_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.zhuang_button.mas_bottom).offset(42);
            make.left.equalTo(self.aTipRecordButton.mas_right).offset(15);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_w);
        }];

        self.xianduizi_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.xianduizi_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.xianduizi_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        self.xianduizi_button.tag = 3;
        [self.xianduizi_button setBackgroundImage:[UIImage imageNamed:@"tiger_selectedIcon"] forState:UIControlStateSelected];
        [self.xianduizi_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.xianduizi_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.xianduizi_button];
        [self.xianduizi_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.xian_button.mas_bottom).offset(42);
            make.right.equalTo(self.xian_button.mas_right).offset(0);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_w);
        }];

        self.he_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.he_button.tag = 4;
        [self.he_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.he_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        [self.he_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_win_greenIcon"] forState:UIControlStateSelected];
        [self.he_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.he_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.he_button];
        [self.he_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.zhuangduizi_button.mas_bottom).offset(42);
            make.left.equalTo(self.aTipRecordButton.mas_right).offset(15);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_w);
        }];

        self.baoxian_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.baoxian_button.tag = 5;
        [self.baoxian_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.baoxian_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        [self.baoxian_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_baoxian_greenIcon"] forState:UIControlStateSelected];
        [self.baoxian_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.baoxian_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.baoxian_button];
        [self.baoxian_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.xianduizi_button.mas_bottom).offset(42);
            make.right.equalTo(self.xian_button.mas_right).offset(0);
            make.height.mas_equalTo(result_h);
            make.width.mas_offset(result_w);
        }];

        self.luckysix_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.luckysix_button.tag = 6;
        [self.luckysix_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.luckysix_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
        [self.luckysix_button setBackgroundImage:[UIImage imageNamed:@"lucky_selecedIcon"] forState:UIControlStateSelected];
        [self.luckysix_button setBackgroundImage:[UIImage imageNamed:@"operationCenter_btnbg_n"] forState:UIControlStateNormal];
        [self.luckysix_button addTarget:self action:@selector(resultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.automaticShowView addSubview:self.luckysix_button];
        [self.luckysix_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.he_button.mas_bottom).offset(42);
            make.left.equalTo(self.aTipRecordButton.mas_right).offset(15);
            make.right.equalTo(self.xian_button.mas_right).offset(0);
            make.height.mas_equalTo(result_h);
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
        make.width.mas_offset(240);
    }];
    
    self.settlementLab = [UILabel new];
    self.settlementLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.settlementLab.font = [UIFont systemFontOfSize:14];
    self.settlementLab.text = @"结算台Settlement Desk";
    self.settlementLab.textAlignment = NSTextAlignmentCenter;
    [self.automaticShowView addSubview:self.settlementLab];
    [self.settlementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_top).offset(3);
        make.left.equalTo(self.settlementImgV.mas_left).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_offset(240);
    }];
    
    self.settlementV = [UIView new];
    self.settlementV.layer.cornerRadius = 2;
    self.settlementV.backgroundColor = [UIColor colorWithHexString:@"#3e565d"];
    [self.automaticShowView addSubview:self.settlementV];
    [self.settlementV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_bottom).offset(0);
        make.right.equalTo(self.automaticShowView).offset(-10);
        make.height.mas_equalTo(232);
        make.width.mas_offset(240);
    }];
    
    CGFloat setBtn_w = (240-30)/3;
    CGFloat setBtn_h = 50;
    self.zhuangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.zhuangBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.zhuangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.zhuangBtn setTitle:@"B.庄" forState:UIControlStateNormal];
    self.zhuangBtn.tag = 1;
    [self.zhuangBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.zhuangBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuangdui_p"] forState:UIControlStateSelected];
    [self.zhuangBtn addTarget:self action:@selector(result_tableAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.zhuangBtn];
    [self.zhuangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(27);
        make.left.equalTo(self.settlementV).offset(10);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.zhuangDuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangDuiBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.zhuangDuiBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.zhuangDuiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.zhuangDuiBtn setTitle:@"BP.庄对" forState:UIControlStateNormal];
    self.zhuangDuiBtn.tag = 2;
    [self.zhuangDuiBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.zhuangDuiBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuangdui_p"] forState:UIControlStateSelected];
    [self.zhuangDuiBtn addTarget:self action:@selector(result_tableAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.zhuangDuiBtn];
    [self.zhuangDuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(27);
        make.left.equalTo(self.zhuangBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.sixWinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sixWinBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.sixWinBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.sixWinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sixWinBtn setTitle:@"B.6点赢" forState:UIControlStateNormal];
    self.sixWinBtn.tag = 3;
    [self.sixWinBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.sixWinBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuangdui_p"] forState:UIControlStateSelected];
    [self.sixWinBtn addTarget:self action:@selector(result_tableAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.sixWinBtn];
    [self.sixWinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(27);
        make.left.equalTo(self.zhuangDuiBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.xianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianBtn setTitleColor:[UIColor colorWithHexString:@"#2749f5"] forState:UIControlStateNormal];
    [self.xianBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.xianBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.xianBtn setTitle:@"P.闲" forState:UIControlStateNormal];
    self.xianBtn.tag = 4;
    [self.xianBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.xianBtn setBackgroundImage:[UIImage imageNamed:@"settlement_xian_p"] forState:UIControlStateSelected];
    [self.xianBtn addTarget:self action:@selector(result_tableAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.xianBtn];
    [self.xianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBtn.mas_bottom).offset(20);
        make.left.equalTo(self.settlementV).offset(10);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.xianDuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianDuiBtn setTitleColor:[UIColor colorWithHexString:@"#2749f5"] forState:UIControlStateNormal];
    [self.xianDuiBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.xianDuiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.xianDuiBtn setTitle:@"PP.闲对" forState:UIControlStateNormal];
    self.xianDuiBtn.tag = 5;
    [self.xianDuiBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.xianDuiBtn setBackgroundImage:[UIImage imageNamed:@"settlement_xian_p"] forState:UIControlStateSelected];
    [self.xianDuiBtn addTarget:self action:@selector(result_tableAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.xianDuiBtn];
    [self.xianDuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBtn.mas_bottom).offset(20);
        make.left.equalTo(self.xianBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.heBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.heBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.heBtn setTitle:@"T.和" forState:UIControlStateNormal];
    self.heBtn.tag = 6;
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"settlement_Tbtn_n"] forState:UIControlStateSelected];
    [self.heBtn addTarget:self action:@selector(result_tableAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.heBtn];
    [self.heBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBtn.mas_bottom).offset(20);
        make.left.equalTo(self.xianDuiBtn.mas_right).offset(5);
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
        make.bottom.equalTo(self.settlementV).offset(-5);
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
        make.top.equalTo(self.tableInfoV).offset(5);
        make.left.equalTo(self.tableInfoV).offset(15);
    }];
    
    self.xueciLab = [UILabel new];
    self.xueciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xueciLab.font = [UIFont systemFontOfSize:12];
    self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
    [self.tableInfoV addSubview:self.xueciLab];
    [self.xueciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stableIDLab.mas_bottom).offset(2);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.puciLab = [UILabel new];
    self.puciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.puciLab.font = [UIFont systemFontOfSize:12];
    self.puciLab.text = @"铺次:0";
    [self.tableInfoV addSubview:self.puciLab];
    [self.puciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(2);
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
    self.zhuangInfoLab.text = @"6";
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
    [self.sixWinInfoBtn setTitle:@"B.6点赢" forState:UIControlStateNormal];
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
    
    //露珠信息
    self.luzhuImgV = [UIImageView new];
    self.luzhuImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self.automaticShowView addSubview:self.self.luzhuImgV];
    [self.luzhuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.automaticShowView).offset(20);
        make.right.equalTo(self.tableInfoImgV.mas_left).offset(-5);
        make.left.equalTo(self.automaticShowView).offset(10);
        make.height.mas_equalTo(30);
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

- (NRManualManger_workers *)manuaManagerView{
    if (!_manuaManagerView) {
        _manuaManagerView = [[NRManualManger_workers alloc]initWithFrame:CGRectMake(0,94, kScreenWidth, kScreenHeight-94)];
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
- (EPSixWinShowView *)sixWinShowView{
    if (!_sixWinShowView) {
        _sixWinShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPSixWinShowView" owner:nil options:nil]lastObject];
        _sixWinShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _sixWinShowView;
}
- (EPINSShowView *)insShowView{
    if (!_insShowView) {
        _insShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPINSShowView" owner:nil options:nil]lastObject];
        _insShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _insShowView;
}

- (ChipInfoView *)chipInfoView{
    if (!_chipInfoView) {
        _chipInfoView = [[[NSBundle mainBundle]loadNibNamed:@"ChipInfoView" owner:nil options:nil]lastObject];
        _chipInfoView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _chipInfoView;
}

- (EPINSOddsShowView *)insOddsShowView{
    if (!_insOddsShowView) {
        _insOddsShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPINSOddsShowView" owner:nil options:nil]lastObject];
        _insOddsShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _insOddsShowView;
}

- (ModificationResultsView *)modifyResultsView{
    if (!_modifyResultsView) {
        _modifyResultsView = [[[NSBundle mainBundle]loadNibNamed:@"ModificationResultsView" owner:nil options:nil]lastObject];
        _modifyResultsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [_modifyResultsView updateBottomViewBtnWithTag:NO];
    }
    return _modifyResultsView;
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

- (TableJiaJiancaiView *)addOrMinusView{
    if (!_addOrMinusView) {
        _addOrMinusView = [[TableJiaJiancaiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _addOrMinusView;
}

-(JhPageItemView *)solidItemView{
    if (!_solidItemView) {
        
        CGRect femwe =  CGRectMake(0, 0, kScreenWidth-25-156-249, 232);
        JhPageItemView *view =  [[JhPageItemView alloc]initWithFrame:femwe];
        view.backgroundColor = [UIColor whiteColor];
        self.solidItemView = view;
    }
    return _solidItemView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    [self topBarSetUp];
    [self _initParams];
    //传输参数
    [self.manuaManagerView transLoginInfoWithLoginID:self.viewModel.loginInfo.access_token
                                             TableID:self.viewModel.curTableInfo.fid
                                        Serialnumber:self.serialnumber
                                               Peilv:self.viewModel.gameInfo.xz_setting
                                           TableName:self.viewModel.curTableInfo.ftbname];
    
    //默认显示自动版本视图
    [self.view addSubview:self.automaticShowView];
    [self.view addSubview:self.manuaManagerView];
    [self changeLanguageWithType:NO];
    self.manuaManagerView.hidden = YES;
    self.automaticShowView.hidden = NO;
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
    [self showWaitingViewWithText:@"露珠加载中..."];
    [self getBaseTableInfoAndLuzhuInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark --初始化一些参数信息
- (void)_initParams{
    self.xueciCount = 1;
    self.puciCount = 0;
    self.prePuciCount = 1;
    self.isAutomicGame = YES;
    int  curXueciValue = [[LYKeychainTool readKeychainValue:[NSString stringWithFormat:@"%@_Xueci",self.viewModel.curTableInfo.fid]]intValue];
    if (curXueciValue!=0) {
        self.viewModel.curXueci = curXueciValue;
        self.xueciCount = curXueciValue;
    }
    self.chipUIDData = [NSMutableData data];
    self.washNumberList = [NSMutableArray arrayWithCapacity:0];
    self.chipTypeList = [NSMutableArray arrayWithCapacity:0];
    self.shazhuInfoList = [NSMutableArray arrayWithCapacity:0];
    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    self.resultList = [NSMutableArray arrayWithCapacity:0];
    self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
    self.curChipInfo = [[NRChipInfoModel alloc]init];
    self.serialnumber = [NRCommand randomStringWithLength:30];
    self.viewModel.curupdateInfo.cp_result = @"-1";
    self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
    self.customerInfo = [[NRCustomerInfo alloc]init];
    self.customerInfo.tipsTitle = [NSString stringWithFormat:@"提示信息\n%@",[EPStr getStr:kEPTipsInfo note:@"提示信息"]];
    self.customerInfo.tipsInfo = [NSString stringWithFormat:@"请认真核对以上信息，确认是否进行下一步操作\n%@",[EPStr getStr:kEPNextTips note:@"请认真核对以上信息，确认是否进行下一步操作"]];
}

#pragma mark -- 重置结果按钮
- (void)_reSetResultBtnStatus{
    [self.zhuangBtn setSelected:NO];
    [self.zhuangDuiBtn setSelected:NO];
    [self.sixWinBtn setSelected:NO];
    [self.xianBtn setSelected:NO];
    [self.xianDuiBtn setSelected:NO];
    [self.heBtn setSelected:NO];
}

#pragma mark --获取露珠信息和当前台桌基础信息
- (void)getBaseTableInfoAndLuzhuInfo{
    self.isFirstEntryGame = YES;
    [self.viewModel getLastXueCiInfoWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self getLuzhuInfoList];
    }];
}

#pragma mark --获取露珠信息
- (void)getLuzhuInfoList{
    [self.viewModel getLuzhuWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            //UIcollectionview 默认样式
            [self.solidItemView fellLuzhuListWithDataList:self.viewModel.luzhuInfoList];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.zhuangInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.zhuangCount];
                self.zhuangDuiInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.zhuangDuiCount];
                self.sixWinInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.sixCount];
                self.xianInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.xianCount];
                self.xianDuiInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.xianDuiCount];
                self.heInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.heCount];
            });
            if (self.isFirstEntryGame) {
                self.isFirstEntryGame = NO;
                if (self.viewModel.realLuzhuList.count!=0) {
                    if (self.viewModel.lastTableInfoDict.count!=0) {
                        NSDictionary *tableInfo = self.viewModel.lastTableInfoDict;
                        self.viewModel.curXueci = [tableInfo[@"fxueci"]intValue];
                        self.xueciCount = [tableInfo[@"fxueci"]intValue];
                        self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
                        self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
                        //判断结果
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *cp_result = tableInfo[@"fkpresult"];
                            [self.resultList removeAllObjects];
                            [self _reSetResultBtnStatus];
                            NSArray *resultList = [cp_result componentsSeparatedByString:@","];
                            if ([resultList containsObject:@"庄"]) {
                                [self.resultList addObject:[NSNumber numberWithInt:1]];
                                [self.zhuangBtn setSelected:YES];
                            }
                            if ([resultList containsObject:@"庄对"]) {
                                [self.resultList addObject:[NSNumber numberWithInt:2]];
                                [self.zhuangDuiBtn setSelected:YES];
                            }
                            if ([resultList containsObject:@"6点赢"]) {
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
                            self.viewModel.curupdateInfo.cp_name = cp_result;
                            self.serialnumber = tableInfo[@"fpcls"];
                            self.puciCount = [tableInfo[@"fpuci"]intValue];
                            self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
                            self.prePuciCount = self.puciCount+1;
                            self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
                        });
                    }
                }
            }
        }
        [self hideWaitingView];
    }];
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

#pragma mark -- 手自动版切换
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
    }else if (btn.tag==3){//切换手动自动版
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

#pragma mark -- 菜单事件
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

#pragma mark - 更改客人洗码号
- (void)showUpdateWashNumberView{
    self.isUpdateWashNumber = NO;
    [[MJPopTool sharedInstance] popView:self.empowerView animated:YES];
    @weakify(self);
    self.empowerView.sureActionBlock = ^(NSString * _Nonnull adminName, NSString * _Nonnull password) {
        @strongify(self);
        [self showWaitingView];
        [self.viewModel authorizationAccountWitAccountName:adminName Password:password Block:^(BOOL success, NSString *msg, EPSreviceError error) {
            [self hideWaitingView];
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
                                for (int i = 0; i < self.chipUIDList.count; i++) {
                                    self.curChipInfo.chipUID = self.chipUIDList[i];
                                    self.curChipInfo.guestWashesNumber = entryText;
                                    DLOG(@"self.curChipInfo = %@,%@",entryText,self.curChipInfo.guestWashesNumber);
                                    //向指定标签中写入数据（块1）
                                    [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                                    usleep(20 * 3000);
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
        }];
    };
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
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 开始连接服务器
    [self.clientSocket connectToHost:self.viewModel.curTableInfo.bindip onPort:6000 viaInterface:nil withTimeout:-1 error:&error];
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

#pragma mark - 计算赔率或者杀注金额
- (void)caclulateMoney{
    if (self.winOrLose) {
        [self winInfoShow];
    }else{
        NSString *realCashMoney = self.curChipInfo.chipDenomination;
        self.customerInfo.xiazhu = [NSString stringWithFormat:@"%@",realCashMoney];
        self.customerInfo.shazhu = [NSString stringWithFormat:@"%@",realCashMoney];
        self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"0"];
        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.result_odds];
        self.viewModel.curupdateInfo.cp_result = @"-1";
        self.viewModel.curupdateInfo.cp_commission = @"0";
        self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%@",realCashMoney];
    }
}

//识别水钱
- (void)identifyWaterMoney{
    self.isDashui = NO;
    [self winInfoShow];
}

- (void)winInfoShow{
    NSString *realCashMoney = self.curChipInfo.chipDenomination;
    self.viewModel.curupdateInfo.cp_commission = [NSString stringWithFormat:@"%.f",self.result_yj*[realCashMoney floatValue]];
    CGFloat real_beishu = self.result_odds-self.result_yj;
    self.customerInfo.compensateMoney = [NSString stringWithFormat:@"%.f",real_beishu*[realCashMoney floatValue]+self.identifyValue];
    self.customerInfo.compensateCode = [NSString stringWithFormat:@"%.f",real_beishu*[realCashMoney floatValue]];
    self.customerInfo.totalMoney = [NSString stringWithFormat:@"%.f",real_beishu*[realCashMoney floatValue]+self.identifyValue];
    self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%.f",self.identifyValue];
    self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",(real_beishu+1)*[realCashMoney floatValue]];
    [self.payShowView fellViewDataNRCustomerInfo:self.customerInfo];
}

#pragma mark - 还原选择结果按钮状态
- (void)researtResultButtonStatus{
    self.chipUIDList = nil;
    self.payChipUIDList = nil;
    [self.zhuang_button setSelected:NO];
    [self.xian_button setSelected:NO];
    [self.zhuangduizi_button setSelected:NO];
    [self.xianduizi_button setSelected:NO];
    [self.he_button setSelected:NO];
    [self.baoxian_button setSelected:NO];
    [self.luckysix_button setSelected:NO];
    [self.shazhuInfoList removeAllObjects];
}

- (void)resultEntryAction:(UIButton *)btn{
    if (self.puciCount != self.prePuciCount) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    if (self.resultList.count==0) {
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
    NSMutableArray *reslutNameList = [NSMutableArray array];
    for (int i=0; i<self.resultList.count; i++) {
        NSInteger tagResult = [self.resultList[i]integerValue];
        if (tagResult==1) {
            [reslutNameList addObject:@"庄"];
        }else if (tagResult==2){
            [reslutNameList addObject:@"庄对"];
        }else if (tagResult==3){
            [reslutNameList addObject:@"6点赢"];
        }else if (tagResult==4){
            [reslutNameList addObject:@"闲"];
        }else if (tagResult==5){
            [reslutNameList addObject:@"闲对"];
        }else if (tagResult==6){
            [reslutNameList addObject:@"和"];
        }
    }
    NSString * resultNameString = [reslutNameList componentsJoinedByString:@","];
    self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
    self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
    self.viewModel.curupdateInfo.cp_name = resultNameString;
    @weakify(self);
    self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
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

#pragma mark -- 重置台桌信息归0
- (void)_resetTableInfoToZero{
    self.viewModel.zhuangCount=0;//庄赢次数
    self.viewModel.zhuangDuiCount=0;//庄对赢次数
    self.viewModel.sixCount=0;//6点赢次数
    self.viewModel.xianCount=0;//闲赢次数
    self.viewModel.xianDuiCount=0;//闲对赢次数
    self.viewModel.heCount=0;//和赢次数
    self.zhuangInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.zhuangCount];
    self.zhuangDuiInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.zhuangDuiCount];
    self.sixWinInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.sixCount];
    self.xianInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.xianCount];
    self.xianDuiInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.xianDuiCount];
    self.heInfoLab.text = [NSString stringWithFormat:@"%d",self.viewModel.heCount];
}

#pragma mark - 台桌结果
- (void)result_tableAction:(UIButton *)btn{
    if (self.puciCount != self.prePuciCount) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    int winType = (int)btn.tag;
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
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
                    [self.resultList removeObject:[NSNumber numberWithInteger:1]];
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
    }else if (winType==3){//6点赢
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
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
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
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
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
    }
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

#pragma mark - 结果按钮触发事件
- (void)resultBtnAction:(UIButton *)btn{
    [EPSound playWithSoundName:@"click_sound"];
    if (![self canResultBtnAciontNextStep]) {
        return;
    }
    self.result_yj = 0;
    if (btn.tag==5) {//保险
        [self btnBackGroundColorWithBtntag:(int)btn.tag];
    }else if (btn.tag==6){//幸运6点
        if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {//6点赢
            self.winOrLose = YES;
        }else {
            self.winOrLose = NO;
        }
        [self btnBackGroundColorWithBtntag:(int)btn.tag];
    }else{
        //赔率
        NSArray *xz_array = self.viewModel.gameInfo.xz_setting;
        if (xz_array.count!=0&&xz_array.count>btn.tag) {
            self.result_odds = [xz_array[btn.tag][@"fpl"] floatValue];
            if (btn.tag==0) {
                self.result_yj = [xz_array[btn.tag][@"fyj"] floatValue]/100;
            }
        }
        self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.result_odds];
        //庄
        if (btn.tag==0) {
            if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
                [self showMessage:@"不杀不赔" withSuccess:YES];
                return;
            }else{
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]) {//庄
                    self.winOrLose = YES;
                }else {
                    self.winOrLose = NO;
                }
            }
        }else if (btn.tag==1){//闲
            if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
                [self showMessage:@"不杀不赔" withSuccess:YES];
                return;
            }else{
                if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]) {//闲
                    self.winOrLose = YES;
                }else {
                    self.winOrLose = NO;
                }
            }
        }else if (btn.tag==2){//庄对子
            if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {//庄对
                self.winOrLose = YES;
            }else {
                self.winOrLose = NO;
            }
        }else if (btn.tag==3){//闲对子
            if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {//闲对
                self.winOrLose = YES;
            }else {
                self.winOrLose = NO;
            }
        }else if (btn.tag==4){//和
            if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
                self.winOrLose = YES;
            }else {
                self.winOrLose = NO;
            }
        }
        [self btnBackGroundColorWithBtntag:(int)btn.tag];
        [self queryDeviceChips];
    }
}

#pragma mark - 根据结果设置按钮背景颜色
- (void)btnBackGroundColorWithBtntag:(int)btnTag{
    if (btnTag==0) {//庄
        self.isBaoxian = NO;
        self.isLucky = NO;
        self.viewModel.curupdateInfo.cp_Result_name = @"庄";
        [self.zhuang_button setSelected:YES];
        if (self.winOrLose) {
            self.customerInfo.winStatus = @"庄赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            self.customerInfo.winStatus = @"庄输";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.zhuang_button setSelected:NO];
    }
    if (btnTag==1){//闲
        self.isBaoxian = NO;
        self.isLucky = NO;
        [self.xian_button setSelected:YES];
        self.viewModel.curupdateInfo.cp_Result_name = @"闲";
        if (self.winOrLose) {
            self.customerInfo.winStatus = @"闲赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            self.customerInfo.winStatus = @"闲输";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.xian_button setSelected:NO];
    }
    
    if (btnTag==2){//庄对
        self.isBaoxian = NO;
        self.isLucky = NO;
        [self.zhuangduizi_button setSelected:YES];
        self.viewModel.curupdateInfo.cp_Result_name = @"庄对";
        if (self.winOrLose) {
            self.customerInfo.winStatus = @"庄对赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            self.customerInfo.winStatus = @"庄对输";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.zhuangduizi_button setSelected:NO];
    }
    
    if (btnTag==3){//闲对
        self.isBaoxian = NO;
        self.isLucky = NO;
        [self.xianduizi_button setSelected:YES];
        self.viewModel.curupdateInfo.cp_Result_name = @"闲对";
        if (self.winOrLose) {
            self.customerInfo.winStatus = @"闲对赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            self.customerInfo.winStatus = @"闲对输";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.xianduizi_button setSelected:NO];
    }
    
    if (btnTag==4){//和
        self.isBaoxian = NO;
        self.isLucky = NO;
        [self.he_button setSelected:YES];
        self.viewModel.curupdateInfo.cp_Result_name = @"和";
        if (self.winOrLose) {
            self.customerInfo.winStatus = @"和赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            self.customerInfo.winStatus = @"和输";
            self.viewModel.curupdateInfo.cp_result = @"-1";
        }
    }else{
        [self.he_button setSelected:NO];
    }
    
    if (btnTag==5){//保险
        self.isBaoxian = YES;
        self.isLucky = NO;
        [self.baoxian_button setSelected:YES];
        self.viewModel.curupdateInfo.cp_Result_name = @"保险";
        [[MJPopTool sharedInstance] popView:self.insShowView animated:YES];
        @weakify(self);
        self.insShowView.INSResultBlock = ^(BOOL isWin) {
            @strongify(self);
            self.winOrLose = isWin;
            if (isWin) {
                [[MJPopTool sharedInstance] popView:self.insOddsShowView animated:YES];
            }else{
                [self queryDeviceChips];
            }
        };
        self.insOddsShowView.INSOddsResultBlock = ^(CGFloat insOdds) {
            @strongify(self);
            self.result_odds = insOdds;
            [self queryDeviceChips];
        };
    }else{
        [self.baoxian_button setSelected:NO];
    }
    if (btnTag==6){//幸运6点
        self.isBaoxian = NO;
        self.isLucky = YES;
        [self.luckysix_button setSelected:YES];
        [[MJPopTool sharedInstance] popView:self.sixWinShowView animated:YES];
        @weakify(self);
        self.sixWinShowView.sureActionBlock = ^(NSInteger sixWinType) {
            @strongify(self);
            //赔率
            NSArray *xz_array = self.viewModel.gameInfo.xz_setting;
            if (sixWinType==0) {//两张牌
                if (xz_array.count!=0&&xz_array.count>6) {
                    self.result_odds = [xz_array[6][@"fpl"] floatValue];
                }
                self.viewModel.curupdateInfo.cp_Result_name = @"两张牌幸运六点";
            }else{//三张牌
                if (xz_array.count!=0&&xz_array.count>7) {
                    self.result_odds = [xz_array[7][@"fpl"] floatValue];
                }
                self.viewModel.curupdateInfo.cp_Result_name = @"三张牌幸运六点";
            }
            if (self.winOrLose) {
                self.customerInfo.winStatus = @"幸运六点赢";
                self.viewModel.curupdateInfo.cp_result = @"1";
            }else{
                self.customerInfo.winStatus = @"幸运六点输";
                self.viewModel.curupdateInfo.cp_result = @"-1";
            }
            [self queryDeviceChips];
        };
    }else{
        [self.luckysix_button setSelected:NO];
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
    [self.changexueci_button setTitle:[NSString stringWithFormat:@"换靴\n%@",[EPStr getStr:kEPChangeXueci note:@"换靴"]] forState:UIControlStateNormal];
    [self.updateLuzhu_button setTitle:[NSString stringWithFormat:@"修改露珠\n%@",@"Update Results"] forState:UIControlStateNormal];
    [self.daily_button setTitle:[NSString stringWithFormat:@"现金版\nCash model"] forState:UIControlStateNormal];
    [self.nextGame_button setTitle:[NSString stringWithFormat:@"新一局\n%@",[EPStr getStr:kEPNewGame note:@"新一局"]] forState:UIControlStateNormal];
    [self.zhuang_button setTitle:[EPStr getStr:kEPZhuang note:@"庄"] forState:UIControlStateNormal];
    [self.xian_button setTitle:[EPStr getStr:kEPXian note:@"闲"] forState:UIControlStateNormal];
    [self.zhuangduizi_button setTitle:[EPStr getStr:kEPZhuangDuizi note:@"庄对子"] forState:UIControlStateNormal];
    [self.xianduizi_button setTitle:[EPStr getStr:kEPXianDuizi note:@"闲对子"] forState:UIControlStateNormal];
    [self.baoxian_button setTitle:[EPStr getStr:kEPBaoxian note:@"保险"] forState:UIControlStateNormal];
    [self.luckysix_button setTitle:[EPStr getStr:kEPSixWin note:@"幸运6点"] forState:UIControlStateNormal];
    [self.he_button setTitle:[EPStr getStr:kEPHe note:@"和"] forState:UIControlStateNormal];
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
                             [self _reSetResultBtnStatus];
                             self.xueciCount +=1;
                             self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
                             self.puciCount =0;
                             self.prePuciCount = self.puciCount+1;
                             self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
                             [self getLuzhuInfoList];
                             cacheXueciCount = self.xueciCount;
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
                        self.viewModel.curXueci = 1;
                        [LYKeychainTool deleteKeychainValue:[NSString stringWithFormat:@"%@_Xueci",self.viewModel.curTableInfo.fid]];
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
            [self _reSetResultBtnStatus];
            [self researtResultButtonStatus];
            [self.resultList removeAllObjects];
            if (!self.isAutomicGame) {
                self.manuaManagerView.puciCount +=1;
                self.manuaManagerView.prePuciCount = self.manuaManagerView.puciCount;
                self.manuaManagerView.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.manuaManagerView.puciCount];
            }else{
                [self.resultList removeAllObjects];
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

#pragma mark - 识别筹码
- (void)readChipsAction{
    self.chipUIDList = nil;
    self.isShowChipInfo = YES;
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.clientSocket.isConnected) {
        [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
        return;
    }
    [self.chipInfoView clearCurChipInfos];
    [[MJPopTool sharedInstance] popView:self.chipInfoView animated:YES];
    @weakify(self);
    self.chipInfoView.sureActionBlock = ^(NSInteger killConfirmType) {
        @strongify(self);
        if (killConfirmType==1) {//识别筹码
            [self queryDeviceChips];
        }else{
           self.isShowChipInfo = NO;
            self.chipUIDList = nil;
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

#pragma mark - 展示结果信息
- (void)showStatusInfo{
    self.viewModel.curupdateInfo.cp_washNumber = self.curChipInfo.guestWashesNumber;
    self.viewModel.curupdateInfo.cp_benjin = self.curChipInfo.chipDenomination;
    self.customerInfo.chipType = self.curChipInfo.chipType;
    self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.result_odds];
    self.viewModel.curupdateInfo.cp_dianshu = @"0";
    self.customerInfo.hasDashui = YES;
    self.isShowingResult = YES;
    self.customerInfo.odds = 1;
    self.viewModel.curupdateInfo.cp_zhaohuiList = [NSArray array];
    self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
    self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
    self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
    self.viewModel.curupdateInfo.cp_ChipUidList = self.chipUIDList;
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
                self.isShowingResult = NO;
                [self researtResultButtonStatus];
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
                self.isShaZhuAction = YES;
                [self queryDeviceChips];
            }else if (killConfirmType==2){//关闭
                [self clearChipCacheData];
                self.isShowingResult = NO;
                [self researtResultButtonStatus];
            }
        };
    }
}

#pragma mark - 清除筹码数据
- (void)clearChipCacheData{
    self.payChipUIDList = nil;
    self.tipChipUIDList = nil;
    self.shuiqianChipUIDList = nil;
    self.identifyValue = 0;
    self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
}


#pragma mark - 查询设备上的筹码UID
- (void)queryDeviceChips{
    [self showWaitingView];
    [EPSound playWithSoundName:@"click_sound"];
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 识别筹码金额
- (void)readCurChipsMoney{
    //向指定标签中写入数据（所有块）
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
        [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
    }
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

#pragma mark - 提交客人输赢记录
- (void)commitCustomerInfoWithRealChipUIDList:(NSArray *)realChipUIDList{
    self.viewModel.curupdateInfo.cp_chipType = self.curChipInfo.chipType;
    @weakify(self);
    [self.viewModel commitCustomerRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        if (success) {
            self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
            self.serialnumber = [NRCommand randomStringWithLength:30];
            self.isShowingResult = NO;
            self.isUpdateChip = YES;
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
            self.serialnumber = [NRCommand randomStringWithLength:30];
            self.isShowingResult = NO;
            self.isUpdateChip = YES;
            self.updateChipCount = (int)realChipUIDList.count;
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
                        [self.killShowView clearKillShowView];
                        [self.killShowView removeFromSuperview];
                        [self showMessage:[EPStr getStr:kEPShazhuSucceed note:@"杀注成功"] withSuccess:YES];
                        //响警告声音
                        [EPSound playWithSoundName:@"succeed_sound"];
                    }
                    self.chipUIDList = nil;
                    self.payChipUIDList = nil;
                    self.identifyValue = 0;
                    [self researtResultButtonStatus];
                }else{
                    self.isDasanChip = NO;
                    self.updateChipCount = 0;
                    [self hideWaitingView];
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
            self.chipUIDData = nil;
            if (count==0) {
                [self showMessage:@"未检测到筹码"];
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
                [self hideWaitingView];
                return;
            }
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
                        self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                        [self hideWaitingView];
                        [self showMessage:@"未检测到赔付筹码"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                    }else{
                        [self readAllPayChipsInfo];
                    }
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
                    });
                    [self hideWaitingView];
                    [self showMessage:@"未检测到小费筹码"];
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                }else{
                    [self readAllTipChipsInfo];
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
            }else{
                BLEIToll *itool = [[BLEIToll alloc]init];
                //存贮筹码UID
                self.chipUIDList = [itool getDeviceAllChipUIDWithBLEString:chipNumberdataHexStr];
                self.chipCount = self.chipUIDList.count;
                DLOG(@"self.chipCount = %ld",(long)self.chipCount);
                if (self.chipCount==0) {
                    self.isUpdateWashNumber = NO;
                    [self researtResultButtonStatus];
                    [self.chipInfoList removeAllObjects];
                    [self.chipInfoView fellChipViewWithChipList:self.chipInfoList];
                    [self hasNoChipShow];
                    [self hideWaitingView];
                    [self showMessage:@"未检测到筹码"];
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
                            if (![washNumberList containsObject:infoList[4]]) {
                                [washNumberList addObject:infoList[4]];
                            }
                        }else{
                            isWashNumberTrue = NO;
                        }
                        if (![chipTypeList containsObject:chipType]) {
                            [chipTypeList addObject:chipType];
                        }
                    }];
                    if (!isWashNumberTrue) {
                        int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                        self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",benjinMoney];
                        self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                        [self showMessage:@"赔付筹码有误"];
                        //响警告声音
                        [EPSound playWithSoundName:@"wram_sound"];
                        [self hideWaitingView];
                        return;
                    }
                    if (chipTypeList.count>1) {
                        [self showMessage:@"存在多个筹码类型"];
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                        self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",benjinMoney+chipAllMoney];
                        self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",chipAllMoney];
                        NSMutableArray *realChipUIDList = [NSMutableArray array];
                        [realChipUIDList addObjectsFromArray:self.chipUIDList];
                        [realChipUIDList addObjectsFromArray:self.payChipUIDList];
                        self.viewModel.curupdateInfo.cp_ChipUidList = realChipUIDList;
                        [self commitCustomerInfoWithRealChipUIDList:realChipUIDList];
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
                    [self breakUpChip];
                }
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
                        [self researtResultButtonStatus];
                        return;
                    }
                    //筹码类型
                    NSString *chipType = [chipInfo[0][1] NullToBlankString];
                    self.curChipInfo.chipType = chipType;
                    //客人洗码号
                    self.curChipInfo.guestWashesNumber = chipInfo[0][4];
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
}

@end
