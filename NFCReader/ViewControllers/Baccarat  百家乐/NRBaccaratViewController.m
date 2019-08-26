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

@interface NRBaccaratViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *tableNumberLab;
@property (nonatomic, strong) UILabel *IDLab;
@property (nonatomic, strong) UIButton *changeIDButton;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UIButton *changeTableButton;
@property (nonatomic, strong) UILabel *coinTypeLab;
@property (nonatomic, strong) UIButton *changeCoinButton;

@property (nonatomic, strong) UILabel *xueciLab;
@property (nonatomic, strong) UILabel *puciLab;
@property (nonatomic, strong) UILabel *betLimitLab;
@property (nonatomic, strong) UILabel *heLimitLab;
@property (nonatomic, strong) UILabel *duiLimitLab;
@property (nonatomic, strong) UILabel *languageLab;
@property (nonatomic, strong) UIButton *changeLanguageButton;
@property (nonatomic, strong) UILabel *lastStrawLab;
@property (nonatomic, strong) UILabel *berthPaysLab;
@property (nonatomic, strong) UILabel *wonOrLostLab;
@property (nonatomic, strong) UILabel *currentPrincipalLab;

@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *guestCodeNumberLab;
@property (nonatomic, strong) UILabel *guestCodeNumberValueLab;
@property (nonatomic, strong) UILabel *betLab;
@property (nonatomic, strong) UILabel *betValueLab;

@property (nonatomic, strong) UIView *lineView1;

@property (nonatomic, strong) UIButton *aTipRecordButton;//小费按钮

@property (nonatomic, strong) UILabel *chipNumberLab;
@property (nonatomic, strong) UILabel *chipNumberValueLab;
@property (nonatomic, strong) UILabel *compensateLab;
@property (nonatomic, strong) UILabel *compensateValueLab;

@property (nonatomic, strong) UIView *lineView2;

@property (nonatomic, strong) UILabel *winningStatusLab;
@property (nonatomic, strong) UILabel *winningStatusValueLab;

@property (nonatomic, strong) UILabel *realLossLab;
@property (nonatomic, strong) UILabel *totalSizeLab;

//赢
@property (nonatomic, strong) UIButton *readluzhu_button;
@property (nonatomic, assign) BOOL winOrLose;
@property (nonatomic, strong) NSString *winColor;
@property (nonatomic, strong) NSString *normalColor;
@property (nonatomic, strong) NSString *buttonNormalColor;

//输
@property (nonatomic, strong) UIButton *daily_button;
@property (nonatomic, strong) NSString *loseColor;

@property (nonatomic, strong) UIButton *zhuang_button;
@property (nonatomic, strong) UIButton *xian_button;
@property (nonatomic, strong) UIButton *zhuangduizi_button;
@property (nonatomic, strong) UIButton *xianduizi_button;
@property (nonatomic, strong) UIButton *he_button;
@property (nonatomic, strong) UIButton *baoxian_button;
@property (nonatomic, strong) UIButton *luckysix_button;
@property (nonatomic, strong) UIButton *zhuangsix_button;

@property (nonatomic, strong) UIButton *changexueci_button;
@property (nonatomic, strong) UIButton *bindchouma_button;
@property (nonatomic, strong) UIButton *zhuxiaochouma_button;
@property (nonatomic, strong) UIButton *newgame_button;

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

@property (nonatomic, strong) UIButton *washNumber_button;//手动输入洗码号
@property (nonatomic, strong) UIButton *cashEntry_button;//手动输入现金
@property (nonatomic, assign) BOOL isCash;//是否现金交易

@property (nonatomic, assign) int xueciCount;//靴次
@property (nonatomic, assign) int puciCount;//铺次

@property (nonatomic, assign) BOOL hasChipRead;//是否有可用筹码被识别

@property (nonatomic, strong) NSString *serialnumber;//流水号
@property (nonatomic, assign) CGFloat odds;//倍数
@property (nonatomic, assign) CGFloat yj;//佣金

@property (nonatomic, assign) BOOL isUIDAppending;//是否
@property (nonatomic, assign) int chipBLECount;//

@property (nonatomic, strong) EPPopAlertShowView *resultShowView;

@property (nonatomic, strong) EPPopAtipInfoView *recordTipShowView;//识别小费

@property (nonatomic, strong) NSMutableArray *retultList;//

/** item数组 */
@property (nonatomic, strong) JhPageItemView *solidItemView;
@property (nonatomic, strong) JhPageItemView *hollowItemView;

// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSMutableData *chipUIDData;

@property (nonatomic, assign) CGFloat result_odds;
@property (nonatomic, assign) CGFloat result_yj;

@property (nonatomic, assign) CGFloat identifyValue;//水钱

@end

@implementation NRBaccaratViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    CGFloat fontSize = 14;
    self.userNameLab = [UILabel new];
    self.userNameLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.userNameLab.font = [UIFont systemFontOfSize:fontSize];
    [self.view addSubview:self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    self.tableNumberLab = [UILabel new];
    self.tableNumberLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.tableNumberLab.font = [UIFont systemFontOfSize:fontSize];
    [self.view addSubview:self.tableNumberLab];
    [self.tableNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.left.equalTo(self.userNameLab.mas_right).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    self.IDLab = [UILabel new];
    self.IDLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.IDLab.font = [UIFont systemFontOfSize:fontSize];
    [self.view addSubview:self.IDLab];
    [self.IDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.left.equalTo(self.tableNumberLab.mas_right).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    self.changeIDButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeIDButton.layer.cornerRadius = 5;
    [self.changeIDButton setTitle:@"换班" forState:UIControlStateNormal];
    [self.changeIDButton setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.changeIDButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.changeIDButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.changeIDButton addTarget:self action:@selector(changeIDAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeIDButton];
    [self.changeIDButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.left.equalTo(self.IDLab.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_offset(60);
    }];
    
    self.typeLab = [UILabel new];
    self.typeLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.typeLab.font = [UIFont systemFontOfSize:fontSize];
    [self.view addSubview:self.typeLab];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.left.equalTo(self.changeIDButton.mas_right).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    self.changeTableButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeTableButton.layer.cornerRadius = 5;
    [self.changeTableButton setTitle:@"换桌" forState:UIControlStateNormal];
    [self.changeTableButton setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.changeTableButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.changeTableButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.changeTableButton addTarget:self action:@selector(changeTableAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeTableButton];
    [self.changeTableButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.left.equalTo(self.typeLab.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_offset(60);
    }];
    
    self.changeCoinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeCoinButton.layer.cornerRadius = 5;
    [self.changeCoinButton setTitle:@"切换" forState:UIControlStateNormal];
    [self.changeCoinButton setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
    self.changeCoinButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.changeCoinButton.backgroundColor = [UIColor colorWithHexString:@"#fdf752"];
    [self.changeCoinButton addTarget:self action:@selector(changeCoinAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeCoinButton];
    [self.changeCoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(20);
        make.width.mas_offset(60);
    }];
    
    self.coinTypeLab = [UILabel new];
    self.coinTypeLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.coinTypeLab.font = [UIFont systemFontOfSize:fontSize];
    self.coinTypeLab.text = @"币种:筹码";
    [self.view addSubview:self.coinTypeLab];
    [self.coinTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.right.equalTo(self.changeCoinButton.mas_left).offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    self.xueciLab = [UILabel new];
    self.xueciLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.xueciLab.font = [UIFont systemFontOfSize:fontSize];
    self.xueciLab.text = @"靴次:0";
    [self.view addSubview:self.xueciLab];
    [self.xueciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(20);
        make.width.mas_offset(80);
    }];
    
    self.puciLab = [UILabel new];
    self.puciLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.puciLab.font = [UIFont systemFontOfSize:fontSize];
    self.puciLab.text = @"铺次:1";
    [self.view addSubview:self.puciLab];
    [self.puciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(50);
        make.left.equalTo(self.xueciLab.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_offset(80);
    }];
    
    CGFloat label_width = (kScreenWidth-32-20-160-140)/3;
    self.betLimitLab = [UILabel new];
    self.betLimitLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.betLimitLab.font = [UIFont systemFontOfSize:fontSize];
    [self.view addSubview:self.betLimitLab];
    [self.betLimitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(50);
        make.left.equalTo(self.puciLab.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_offset(label_width);
    }];
    
    self.heLimitLab = [UILabel new];
    self.heLimitLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.heLimitLab.font = [UIFont systemFontOfSize:fontSize];
    [self.view addSubview:self.heLimitLab];
    [self.heLimitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(50);
        make.left.equalTo(self.betLimitLab.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_offset(label_width);
    }];
    
    self.duiLimitLab = [UILabel new];
    self.duiLimitLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.duiLimitLab.font = [UIFont systemFontOfSize:fontSize];
    [self.view addSubview:self.duiLimitLab];
    [self.duiLimitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(50);
        make.left.equalTo(self.heLimitLab.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_offset(label_width);
    }];
    
    self.changeLanguageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeLanguageButton.layer.cornerRadius = 5;
    [self.changeLanguageButton setTitle:@"切换" forState:UIControlStateNormal];
    [self.changeLanguageButton setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
    self.changeLanguageButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.changeLanguageButton.backgroundColor = [UIColor colorWithHexString:@"#fdf752"];
    [self.changeLanguageButton addTarget:self action:@selector(changeLanguageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeLanguageButton];
    [self.changeLanguageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(50);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(20);
        make.width.mas_offset(60);
    }];
    
    self.languageLab = [UILabel new];
    self.languageLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.languageLab.font = [UIFont systemFontOfSize:fontSize];
    self.languageLab.text = @"English";
    [self.view addSubview:self.languageLab];
    [self.languageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(50);
        make.right.equalTo(self.changeLanguageButton.mas_left).offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    CGFloat label_width_down = (kScreenWidth-32-15-300)/3;
    self.lastStrawLab = [UILabel new];
    self.lastStrawLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.lastStrawLab.font = [UIFont systemFontOfSize:fontSize];
    
    [self.view addSubview:self.lastStrawLab];
    [self.lastStrawLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(20);
        make.width.mas_offset(label_width_down);
    }];
    
    self.berthPaysLab = [UILabel new];
    self.berthPaysLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.berthPaysLab.font = [UIFont systemFontOfSize:fontSize];
    
    [self.view addSubview:self.berthPaysLab];
    [self.berthPaysLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(20);
        make.left.equalTo(self.lastStrawLab.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_offset(label_width_down);
    }];
    
    self.wonOrLostLab = [UILabel new];
    self.wonOrLostLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.wonOrLostLab.font = [UIFont systemFontOfSize:fontSize];
    
    [self.view addSubview:self.wonOrLostLab];
    [self.wonOrLostLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(20);
        make.left.equalTo(self.berthPaysLab.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_offset(label_width_down);
    }];
    
    self.currentPrincipalLab = [UILabel new];
    self.currentPrincipalLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.currentPrincipalLab.font = [UIFont systemFontOfSize:fontSize];
    self.currentPrincipalLab.numberOfLines = 0;
    self.currentPrincipalLab.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.currentPrincipalLab];
    [self.currentPrincipalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(20);
        make.left.equalTo(self.wonOrLostLab.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_offset(300);
    }];
    
    self.infoView = [UIView new];
    self.infoView.backgroundColor = [UIColor colorWithHexString:@"#1f272f"];
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lastStrawLab.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(16);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(220);
    }];
    
    CGFloat info_width = (kScreenWidth - 32)/3;
    CGFloat info_font = 22;
    self.guestCodeNumberLab = [UILabel new];
    self.guestCodeNumberLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.guestCodeNumberLab.font = [UIFont systemFontOfSize:fontSize];
    self.guestCodeNumberLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.guestCodeNumberLab];
    [self.guestCodeNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView).offset(40);
        make.left.equalTo(self.infoView);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.guestCodeNumberValueLab = [UILabel new];
    self.guestCodeNumberValueLab.textColor = [UIColor colorWithHexString:@"#357522"];
    self.guestCodeNumberValueLab.font = [UIFont systemFontOfSize:info_font];
    self.guestCodeNumberValueLab.text = @"#";
    self.guestCodeNumberValueLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.guestCodeNumberValueLab];
    [self.guestCodeNumberValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guestCodeNumberLab.mas_bottom).offset(5);
        make.left.equalTo(self.infoView);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.washNumber_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.washNumber_button addTarget:self action:@selector(washNumberAction) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView addSubview:self.washNumber_button];
    [self.washNumber_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guestCodeNumberLab.mas_bottom).offset(5);
        make.left.equalTo(self.infoView);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.betLab = [UILabel new];
    self.betLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.betLab.font = [UIFont systemFontOfSize:fontSize];
    self.betLab.hidden = YES;
    self.betLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.betLab];
    [self.betLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guestCodeNumberValueLab.mas_bottom).offset(10);
        make.left.equalTo(self.infoView);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.betValueLab = [UILabel new];
    self.betValueLab.textColor = [UIColor colorWithHexString:@"#357522"];
    self.betValueLab.font = [UIFont systemFontOfSize:info_font];
    self.betValueLab.text = @"#";
    self.betValueLab.hidden = YES;
    self.betValueLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.betValueLab];
    [self.betValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.betLab.mas_bottom).offset(5);
        make.left.equalTo(self.infoView);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.lineView1 = [UIView new];
    self.lineView1.backgroundColor = [UIColor colorWithHexString:@"#2b323a"];
    [self.infoView addSubview:self.lineView1];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView).offset(40);
        make.left.equalTo(self.betValueLab.mas_right);
        make.height.mas_equalTo(100);
        make.width.mas_offset(2);
    }];
    
    self.chipNumberLab = [UILabel new];
    self.chipNumberLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.chipNumberLab.font = [UIFont systemFontOfSize:fontSize];
    self.chipNumberLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.chipNumberLab];
    [self.chipNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView).offset(40);
        make.left.equalTo(self.lineView1.mas_right);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.chipNumberValueLab = [UILabel new];
    self.chipNumberValueLab.textColor = [UIColor colorWithHexString:@"#357522"];
    self.chipNumberValueLab.font = [UIFont systemFontOfSize:info_font];
    self.chipNumberValueLab.text = @"#";
    self.chipNumberValueLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.chipNumberValueLab];
    [self.chipNumberValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipNumberLab.mas_bottom).offset(5);
        make.left.equalTo(self.lineView1.mas_right);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.cashEntry_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cashEntry_button addTarget:self action:@selector(cashEntryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView addSubview:self.cashEntry_button];
    [self.cashEntry_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipNumberLab.mas_bottom).offset(5);
        make.left.equalTo(self.lineView1.mas_right);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.compensateLab = [UILabel new];
    self.compensateLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.compensateLab.font = [UIFont systemFontOfSize:fontSize];
    self.compensateLab.hidden = YES;
    self.compensateLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.compensateLab];
    [self.compensateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipNumberValueLab.mas_bottom).offset(10);
        make.left.equalTo(self.lineView1.mas_right);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.compensateValueLab = [UILabel new];
    self.compensateValueLab.textColor = [UIColor colorWithHexString:@"#357522"];
    self.compensateValueLab.font = [UIFont systemFontOfSize:info_font];
    self.compensateValueLab.text = @"#";
    self.compensateValueLab.hidden = YES;
    self.compensateValueLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.compensateValueLab];
    [self.compensateValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.compensateLab.mas_bottom).offset(5);
        make.left.equalTo(self.lineView1.mas_right);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.lineView2 = [UIView new];
    self.lineView2.backgroundColor = [UIColor colorWithHexString:@"#2b323a"];
    [self.infoView addSubview:self.lineView2];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView).offset(40);
        make.left.equalTo(self.chipNumberLab.mas_right);
        make.height.mas_equalTo(100);
        make.width.mas_offset(2);
    }];
    
    self.winningStatusLab = [UILabel new];
    self.winningStatusLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.winningStatusLab.font = [UIFont systemFontOfSize:fontSize];
    self.winningStatusLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.winningStatusLab];
    [self.winningStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView).offset(40);
        make.left.equalTo(self.lineView2.mas_right);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    self.winningStatusValueLab = [UILabel new];
    self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.normalColor];
    self.winningStatusValueLab.font = [UIFont systemFontOfSize:26];
    self.winningStatusValueLab.text = @"#";
    self.winningStatusValueLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.winningStatusValueLab];
    [self.winningStatusValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.winningStatusLab.mas_bottom).offset(5);
        make.left.equalTo(self.lineView2.mas_right);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    CGFloat down_info_width = (kScreenWidth-32-120)/2;
    self.totalSizeLab = [UILabel new];
    self.totalSizeLab.textColor = [UIColor colorWithHexString:@"#357522"];
    self.totalSizeLab.font = [UIFont systemFontOfSize:20];
    self.totalSizeLab.textAlignment =  NSTextAlignmentCenter;
    self.totalSizeLab.numberOfLines = 0;
    [self.infoView addSubview:self.totalSizeLab];
    [self.totalSizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.infoView).offset(-20);
        make.left.equalTo(self.infoView);
        make.width.mas_offset(down_info_width);
    }];
    
    self.realLossLab = [UILabel new];
    self.realLossLab.textColor = [UIColor colorWithHexString:@"#cc3023"];
    self.realLossLab.font = [UIFont systemFontOfSize:20];
    self.realLossLab.textAlignment =  NSTextAlignmentCenter;
    self.realLossLab.numberOfLines = 0;
    [self.infoView addSubview:self.realLossLab];
    [self.realLossLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.infoView).offset(-20);
        make.left.equalTo(self.cashEntry_button.mas_right);
        make.width.mas_offset(down_info_width);
        make.right.equalTo(self.infoView).offset(-5);
    }];
    
    CGFloat tapItem_width = (kScreenWidth-32-200-20-10)/2;
    CGFloat tapItem_height = 80;
    CGFloat item_fontsize = 20;
    
    self.readluzhu_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.readluzhu_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.readluzhu_button.titleLabel.numberOfLines = 0;
    [self.readluzhu_button setBackgroundImage:[UIImage imageNamed:@"login_text_bg"] forState:UIControlStateNormal];
    self.readluzhu_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.readluzhu_button addTarget:self action:@selector(lookLuzhuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.readluzhu_button];
    [self.readluzhu_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(tapItem_height+30);
        make.width.mas_offset(200);
    }];
    
    self.aTipRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.aTipRecordButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.aTipRecordButton.titleLabel.numberOfLines = 0;
    [self.aTipRecordButton setBackgroundImage:[UIImage imageNamed:@"login_text_bg"] forState:UIControlStateNormal];
    self.aTipRecordButton.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.aTipRecordButton addTarget:self action:@selector(recordTipMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.aTipRecordButton];
    [self.aTipRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.readluzhu_button.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(tapItem_height+30);
        make.width.mas_offset(200);
    }];
    
    self.daily_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.daily_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.daily_button.titleLabel.numberOfLines = 0;
    [self.daily_button setBackgroundImage:[UIImage imageNamed:@"login_text_bg"] forState:UIControlStateNormal];
    self.daily_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    [self.daily_button addTarget:self action:@selector(daliyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.daily_button];
    [self.daily_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aTipRecordButton.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(tapItem_height+30);
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
    [self.view addSubview:self.zhuang_button];
    [self.zhuang_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(20);
        make.left.equalTo(self.readluzhu_button.mas_right).offset(20);
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
    [self.view addSubview:self.xian_button];
    [self.xian_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(20);
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
    [self.view addSubview:self.zhuangduizi_button];
    [self.zhuangduizi_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuang_button.mas_bottom).offset(20);
        make.left.equalTo(self.readluzhu_button.mas_right).offset(20);
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
    [self.view addSubview:self.xianduizi_button];
    [self.xianduizi_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuang_button.mas_bottom).offset(20);
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
    [self.view addSubview:self.he_button];
    [self.he_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangduizi_button.mas_bottom).offset(20);
        make.left.equalTo(self.readluzhu_button.mas_right).offset(20);
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
    [self.view addSubview:self.baoxian_button];
    [self.baoxian_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangduizi_button.mas_bottom).offset(20);
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
    [self.view addSubview:self.luckysix_button];
    [self.luckysix_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baoxian_button.mas_bottom).offset(20);
        make.left.equalTo(self.readluzhu_button.mas_right).offset(20);
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
        [self.view addSubview:self.zhuangsix_button];
        [self.zhuangsix_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baoxian_button.mas_bottom).offset(20);
            make.left.equalTo(self.luckysix_button.mas_right).offset(10);
            make.height.mas_equalTo(tapItem_height);
            make.width.mas_offset(tapItem_width);
        }];
    }
    
    CGFloat operationItem_width = (kScreenWidth-32-40)/4;
    CGFloat operationItem_height = 80;
    CGFloat operation_fontsize = 16;
    self.changexueci_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changexueci_button.layer.cornerRadius = 2;
    self.changexueci_button.titleLabel.numberOfLines = 2;
    self.changexueci_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.changexueci_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.changexueci_button.titleLabel.font = [UIFont systemFontOfSize:operation_fontsize];
    self.changexueci_button.backgroundColor = [UIColor colorWithHexString:@"#274560"];
    [self.changexueci_button addTarget:self action:@selector(changexueciAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changexueci_button];
    [self.changexueci_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(operationItem_height);
        make.width.mas_offset(operationItem_width);
    }];
    
    self.bindchouma_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bindchouma_button.layer.cornerRadius = 2;
    self.bindchouma_button.titleLabel.numberOfLines = 2;
    self.bindchouma_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bindchouma_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.bindchouma_button.titleLabel.font = [UIFont systemFontOfSize:operation_fontsize];
    self.bindchouma_button.backgroundColor = [UIColor colorWithHexString:@"#274560"];
    [self.bindchouma_button addTarget:self action:@selector(bindChipAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bindchouma_button];
    [self.bindchouma_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.changexueci_button.mas_right).offset(10);
        make.height.mas_equalTo(operationItem_height);
        make.width.mas_offset(operationItem_width);
    }];
    
    self.zhuxiaochouma_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zhuxiaochouma_button.layer.cornerRadius = 2;
    self.zhuxiaochouma_button.titleLabel.numberOfLines = 2;
    self.zhuxiaochouma_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.zhuxiaochouma_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.zhuxiaochouma_button.titleLabel.font = [UIFont systemFontOfSize:operation_fontsize];
    self.zhuxiaochouma_button.backgroundColor = [UIColor colorWithHexString:@"#274560"];
    [self.zhuxiaochouma_button addTarget:self action:@selector(zhuxiaoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zhuxiaochouma_button];
    [self.zhuxiaochouma_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.bindchouma_button.mas_right).offset(10);
        make.height.mas_equalTo(operationItem_height);
        make.width.mas_offset(operationItem_width);
    }];
    
    self.newgame_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.newgame_button.layer.cornerRadius = 2;
    self.newgame_button.titleLabel.numberOfLines = 2;
    self.newgame_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.newgame_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.newgame_button.titleLabel.font = [UIFont systemFontOfSize:operation_fontsize];
    self.newgame_button.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.newgame_button addTarget:self action:@selector(newGameAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.newgame_button];
    [self.newgame_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.zhuxiaochouma_button.mas_right).offset(10);
        make.height.mas_equalTo(operationItem_height);
        make.width.mas_offset(operationItem_width);
    }];
    
    [self loadBacaratData];
    [self changeLanguageAction:nil];
}

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    [self.titleBar setTitle:@"VM娱乐桌面跟踪系统"];
    [self setLeftItemForGoBack];
    self.titleBar.rightItem = nil;
    self.titleBar.showBottomLine = NO;
    self.titleBar.leftItem = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.clientSocket disconnect];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self connectToServer];
}

- (void)connectToServer{
    // 准备创建客户端socket
    NSError *error = nil;
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 开始连接服务器
    [self.clientSocket connectToHost:@"192.168.1.192" onPort:6000 viaInterface:nil withTimeout:-1 error:&error];
}

- (void)loadBacaratData{
    self.lastStrawLab.text = [NSString stringWithFormat:@"上一铺杀注:%@",self.viewModel.gameInfo.lastsz];
    self.berthPaysLab.text = [NSString stringWithFormat:@"上一铺赔付:%@",self.viewModel.gameInfo.lastpf];
    self.wonOrLostLab.text = [NSString stringWithFormat:@"上一铺输赢:%@",self.viewModel.gameInfo.lastsy];
    NSArray *cur_money = self.viewModel.gameInfo.cur_money;
    NSString *CashString = @"0";
    NSString *RMBString = @"0";
    NSString *USDString = @"0";
    if (cur_money.count>=3) {
        CashString = cur_money[0][@"fcur_money"];
        RMBString = cur_money[1][@"fcur_money"];
        USDString = cur_money[2][@"fcur_money"];
    }
    self.currentPrincipalLab.text = [NSString stringWithFormat:@"当前本金:%@Cash %@RMB %@USD",CashString,RMBString,USDString];
    self.userNameLab.text = [NSString stringWithFormat:@"当前荷官:%@",self.viewModel.loginInfo.femp_xm];
    self.IDLab.text = [NSString stringWithFormat:@"ID:%@",self.viewModel.loginInfo.fid];
    self.typeLab.text = @"类型:百家乐";
    if (self.isYouyong.boolValue) {
        self.typeLab.text = @"类型:有佣百家乐";
    }
    self.tableNumberLab.text = [NSString stringWithFormat:@"台号:%@",self.viewModel.curTableInfo.ftbname];
    self.betLimitLab.text = [NSString stringWithFormat:@"下注限红:%@",self.viewModel.curTableInfo.fbjl_xzxh];
    self.heLimitLab.text = [NSString stringWithFormat:@"和限红:%@",self.viewModel.curTableInfo.fbjl_hxh];
    self.duiLimitLab.text = [NSString stringWithFormat:@"对限红:%@",self.viewModel.curTableInfo.fbjl_dxh];
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

- (void)washNumberAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.isCash) {
        return;
    }
    @weakify(self);
    [EPPopView showEntryInView:self.view WithTitle:[NSString stringWithFormat:@"提示信息\n%@",[EPStr getStr:kEPTipsInfo note:@"提示信息"]] handler:^(NSString *entryText) {
        @strongify(self);
        [EPSound playWithSoundName:@"click_sound"];
        self.guestCodeNumberValueLab.text = entryText;
        self.viewModel.curupdateInfo.cp_washNumber = entryText;
        self.customerInfo.guestNumber = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPWashNumber note:@"客人洗码号"],entryText];
    }];
}

- (void)cashEntryAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (!self.isCash) {
        return;
    }
    @weakify(self);
    [EPPopView showEntryInView:self.view WithTitle:@"请输入现金额" handler:^(NSString *entryText) {
        @strongify(self);
        [EPSound playWithSoundName:@"click_sound"];
        self.chipNumberValueLab.text = entryText;
        self.viewModel.curupdateInfo.cp_benjin = entryText;
        self.betValueLab.text = entryText;
        self.customerInfo.principalMoney = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPBenjin note:@"本金"],entryText];
    }];
}

- (void)changeCoinAction:(UIButton *)btn{
    [EPSound playWithSoundName:@"click_sound"];
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.isCash = YES;
        self.coinTypeLab.text = @"币种:现金";
        [self showMessage:@"当前已经切换成现金模式"];
    }else{
        self.isCash = NO;
        self.coinTypeLab.text = @"币种:筹码";
        [self showMessage:@"当前已经切换成筹码模式"];
    }
}

//识别水钱
- (void)identifyWaterMoney{
    self.isDashui = NO;
    [self winInfoShow];
}

- (void)showInfoStatusWith:(BOOL)isWin{
    if (isWin) {
        self.compensateValueLab.text = @"#";
        self.compensateValueLab.hidden = NO;
        self.compensateLab.hidden = NO;
        self.betValueLab.hidden = NO;
        self.betLab.hidden = NO;
        self.compensateLab.hidden = NO;
    }else{
        self.compensateValueLab.text = @"#";
        self.compensateValueLab.hidden = YES;
        self.betValueLab.hidden = YES;
        self.betLab.hidden = YES;
        self.compensateLab.hidden = YES;
        self.compensateLab.hidden = YES;
    }
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
    self.winningStatusValueLab.text = @"#";
    self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.normalColor];
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
            
            [self hollowItemView];
            self.hollowItemView.dataArray = self.viewModel.luzhuDownList;
            
            NFPopupContainView *customView = [[NFPopupContainView alloc] init];
            [customView addSubview: self.solidItemView];
            [customView addSubview: self.hollowItemView];
            DSHPopupContainer *container = [[DSHPopupContainer alloc] initWithCustomPopupView:customView];
            container.maskColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
            [container show];
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

-(JhPageItemView *)hollowItemView{
    if (!_hollowItemView) {
        
        CGRect femwe =  CGRectMake(0, 420, kScreenWidth-40, 300);
        JhPageItemView *view =  [[JhPageItemView alloc]initWithFrame:femwe];
        view.backgroundColor = [UIColor whiteColor];
        self.hollowItemView = view;
    }
    return _hollowItemView;
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
    NSString *realCashMoney = @"";
    if (!self.isCash) {
        realCashMoney = self.curChipInfo.chipDenomination;
    }else{
        realCashMoney = self.chipNumberValueLab.text;
    }
    self.viewModel.curupdateInfo.cp_commission = [NSString stringWithFormat:@"%.f",self.result_yj*[realCashMoney floatValue]];
    self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
    CGFloat real_beishu = self.result_odds-self.result_yj;
    self.customerInfo.compensateMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPRealpay note:@"实赔"],real_beishu*[realCashMoney floatValue]+self.identifyValue];
    self.customerInfo.compensateCode = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPCompensate note:@"应赔"],real_beishu*[realCashMoney floatValue]];
    self.customerInfo.totalMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPAllChip note:@"总码"],real_beishu*[realCashMoney floatValue]+self.identifyValue];
    self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPDashui note:@"打水"],self.identifyValue];
    self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",(real_beishu+1)*[realCashMoney floatValue]];
    self.compensateValueLab.text = [NSString stringWithFormat:@"%.f",real_beishu*[realCashMoney floatValue]];
    self.totalSizeLab.text = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPRealpay note:@"实赔"],real_beishu*[realCashMoney floatValue]+self.identifyValue];
    self.realLossLab.text = [NSString stringWithFormat:@"%@:%.f",[EPStr getStr:kEPAllChip note:@"总码"],(real_beishu+1)*[realCashMoney floatValue]+self.identifyValue];
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
        NSString *realCashMoney = @"";
        if (!self.isCash) {
            realCashMoney = self.curChipInfo.chipDenomination;
        }else{
            realCashMoney = self.chipNumberValueLab.text;
        }
        self.customerInfo.xiazhu = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPBetch note:@"下注"],realCashMoney];
        self.customerInfo.shazhu = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPshouldShazhu note:@"应杀注"],realCashMoney];
        self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"应加赔:0"];
        self.compensateValueLab.text = [NSString stringWithFormat:@"%@",realCashMoney];
        self.totalSizeLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPBetch note:@"下注"],realCashMoney];
        self.realLossLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPshouldShazhu note:@"应杀注"],realCashMoney];
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
    if (self.isCash) {
        if ([self.guestCodeNumberValueLab.text isEqualToString:@"#"]&&[self.chipNumberValueLab.text isEqualToString:@"#"]) {
            [self showMessage:[EPStr getStr:kEPEntryWashNumber note:@"请输入洗码号"]];
            return;
        }
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
            self.winningStatusValueLab.text = [EPStr getStr:kEPZhuangWin note:@"庄赢"];
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n庄赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"庄赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.zhuang_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.winningStatusValueLab.text = [EPStr getStr:kEPZhuangWin note:@"庄输"];
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.loseColor];
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
            self.winningStatusValueLab.text = [EPStr getStr:kEPXianWin note:@"闲赢"];
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n闲赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"闲赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.xian_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.winningStatusValueLab.text = [EPStr getStr:kEPXianshu note:@"闲输"];
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.loseColor];
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
            self.winningStatusValueLab.text = @"庄对子赢";
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
            self.customerInfo.winStatus =[NSString stringWithFormat:@"%@:\n庄对子赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"庄对子";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.zhuangduizi_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.winningStatusValueLab.text = @"庄对子输";
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.loseColor];
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
            self.winningStatusValueLab.text = @"闲对子赢";
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n闲对子赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"闲对子";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.xianduizi_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.winningStatusValueLab.text = @"闲对子输";
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.loseColor];
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
            self.winningStatusValueLab.text = @"和赢";
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n和赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.viewModel.curupdateInfo.cp_name = @"和";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.he_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.winningStatusValueLab.text = @"和输";
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.loseColor];
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
                self.winningStatusValueLab.text = @"保险赢";
                self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
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
                self.winningStatusValueLab.text = @"保险输";
                self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.loseColor];
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
            self.winningStatusValueLab.text = @"幸运6点赢";
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n幸运6点赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
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
            self.winningStatusValueLab.text = @"幸运6点输";
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
            self.winningStatusValueLab.text = @"庄6点赢赢";
            self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n庄6点赢赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
            self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
            self.viewModel.curupdateInfo.cp_name = @"庄6点赢赢";
            self.viewModel.curupdateInfo.cp_result = @"1";
        }else{
            [self.zhuangsix_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
            self.winningStatusValueLab.text = @"庄6点赢输";
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
            self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
            if (self.xueciCount<10) {
                self.xueciLab.text = [NSString stringWithFormat:@"靴次:0%d",self.xueciCount];
            }
            [self showLognMessage:[EPStr getStr:kEPChangeXueciSucceed note:@"更换靴次成功"]];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
        }
    }];
}

- (void)changeLanguageAction:(UIButton *)btn{
    [EPSound playWithSoundName:@"click_sound"];
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.languageLab.text = @"中文";
        [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:0];
    }else{
        [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:1];
        self.languageLab.text = @"English";
    }
    [self.changexueci_button setTitle:[NSString stringWithFormat:@"更换靴次\n%@",[EPStr getStr:kEPChangeXueci note:@"更换靴次"]] forState:UIControlStateNormal];
    [self.bindchouma_button setTitle:[NSString stringWithFormat:@"绑定筹码\n%@",[EPStr getStr:kEPBindChip note:@"绑定筹码"]] forState:UIControlStateNormal];
    [self.newgame_button setTitle:[NSString stringWithFormat:@"新一局\n%@",[EPStr getStr:kEPNewGame note:@"新一局"]] forState:UIControlStateNormal];
    [self.zhuxiaochouma_button setTitle:[NSString stringWithFormat:@"注销筹码\n%@",[EPStr getStr:kEPCancellationChip note:@"注销筹码"]] forState:UIControlStateNormal];
    
    self.chipNumberLab.text = [EPStr getStr:kEPCurrentReadMoney note:@"当前识别金额"];
    self.guestCodeNumberLab.text = [EPStr getStr:kEPWashNumber note:@"客人洗码号"];
    [self.zhuang_button setTitle:[EPStr getStr:kEPZhuang note:@"庄"] forState:UIControlStateNormal];
    self.betLab.text = [EPStr getStr:kEPBetch note:@"下注"];
    self.compensateLab.text = [EPStr getStr:kEPCompensate note:@"应赔"];
    self.winningStatusLab.text = [EPStr getStr:kEPWinStatus note:@"输赢状态"];
    [self.xian_button setTitle:[EPStr getStr:kEPXian note:@"闲"] forState:UIControlStateNormal];
    [self.zhuangduizi_button setTitle:[EPStr getStr:kEPZhuangDuizi note:@"庄对子"] forState:UIControlStateNormal];
    [self.aTipRecordButton setTitle:[NSString stringWithFormat:@"记录小费\n%@",[EPStr getStr:kEPRecordTipsFee note:@"记录小费"]] forState:UIControlStateNormal];
    [self.daily_button setTitle:[NSString stringWithFormat:@"日结\n%@",[EPStr getStr:kEPDaily note:@"日结"]] forState:UIControlStateNormal];
    [self.xianduizi_button setTitle:[EPStr getStr:kEPXianDuizi note:@"闲对子"] forState:UIControlStateNormal];
    [self.baoxian_button setTitle:[EPStr getStr:kEPBaoxian note:@"保险"] forState:UIControlStateNormal];
    [self.readluzhu_button setTitle:[NSString stringWithFormat:@"查看露珠\n%@",[EPStr getStr:kEPLookluzhu note:@"查看露珠"]] forState:UIControlStateNormal];
    [self.zhuangsix_button setTitle:[EPStr getStr:kEPZhuangSixWin note:@"庄6点赢"] forState:UIControlStateNormal];
    [self.luckysix_button setTitle:[EPStr getStr:kEPSixWin note:@"幸运6点"] forState:UIControlStateNormal];
    [self.he_button setTitle:[EPStr getStr:kEPHe note:@"和"] forState:UIControlStateNormal];
    
    if (self.winOrLose) {
        self.totalSizeLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPRealpay note:@"实赔"]];
        self.realLossLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPAllChip note:@"总码"]];
    }else{
        self.realLossLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPBetch note:@"下注"]];
        self.totalSizeLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPshouldShazhu note:@"应杀注"]];
    }
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
    
    if (!self.isCash) {
        self.viewModel.curupdateInfo.cp_washNumber = self.curChipInfo.guestWashesNumber;
        self.viewModel.curupdateInfo.cp_benjin = self.curChipInfo.chipDenomination;
    }
    self.customerInfo.isCash = self.isCash;
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
            self.guestCodeNumberValueLab.text = @"#";
            self.betValueLab.text = @"#";
            self.chipNumberValueLab.text = @"#";
            self.compensateValueLab.text = @"#";
            if (self.winOrLose) {
                self.realLossLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPRealpay note:@"实赔"]];
                self.totalSizeLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPAllChip note:@"总码"]];
            }else{
                
                self.realLossLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPBetch note:@"下注"]];
                self.totalSizeLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPshouldShazhu note:@"应杀注"]];
            }
            [self researtResultButtonStatus];
        }
    }];
}

- (void)payChipMoney{
    NSMutableArray *realChipUIDList = [NSMutableArray array];
    if (self.isCash) {
        self.viewModel.curupdateInfo.cp_chipType = @"0";
    }else{
        [realChipUIDList addObjectsFromArray:self.chipUIDList];
        [realChipUIDList addObjectsFromArray:self.payChipUIDList];
        self.viewModel.curupdateInfo.cp_chipType = self.curChipInfo.chipType;
    }
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
                self.guestCodeNumberValueLab.text = @"#";
                self.betValueLab.text = @"#";
                self.chipNumberValueLab.text = @"#";
                self.compensateValueLab.text = @"#";
                if (self.winOrLose) {
                    self.realLossLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPRealpay note:@"实赔"]];
                    self.totalSizeLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPAllChip note:@"总码"]];
                }else{
                    
                    self.realLossLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPBetch note:@"下注"]];
                    self.totalSizeLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPshouldShazhu note:@"应杀注"]];
                }
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
                        self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
                        if (self.puciCount<10) {
                            self.puciLab.text = [NSString stringWithFormat:@"铺次:0%d",self.puciCount];
                        }
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
                            self.guestCodeNumberValueLab.text = @"#";
                            self.betValueLab.text = @"#";
                            self.chipNumberValueLab.text = @"#";
                            self.compensateValueLab.text = @"#";
                            if (self.winOrLose) {
                                self.realLossLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPRealpay note:@"实赔"]];
                                self.totalSizeLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPAllChip note:@"总码"]];
                            }else{
                                [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPBetch note:@"下注"]];
                                self.totalSizeLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPshouldShazhu note:@"应杀注"]];
                            }
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
                self.guestCodeNumberValueLab.text = @"#";
                self.betValueLab.text = @"#";
                self.chipNumberValueLab.text = @"#";
                self.compensateValueLab.text = @"#";
                if (self.winOrLose) {
                    self.realLossLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPRealpay note:@"实赔"]];
                    self.totalSizeLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPAllChip note:@"总码"]];
                }else{
                    
                    self.realLossLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPBetch note:@"下注"]];
                    self.totalSizeLab.text = [NSString stringWithFormat:@"%@:#",[EPStr getStr:kEPshouldShazhu note:@"应杀注"]];
                }
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
                            self.guestCodeNumberValueLab.text = self.curChipInfo.guestWashesNumber;
                            self.betValueLab.text = self.curChipInfo.chipDenomination;
                            self.chipNumberValueLab.text = self.curChipInfo.chipDenomination;
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
