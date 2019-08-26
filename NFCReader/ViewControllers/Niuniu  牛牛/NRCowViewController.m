//
//  NRBaccaratViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRCowViewController.h"
#import "EPPopAlertShowView.h"
#import "NRCustomerInfo.h"
#import "EPPopView.h"
#import "JXButton.h"
#import "EPService.h"
#import "NRLoginInfo.h"
#import "NRCowViewModel.h"
#import "NRChipResultInfo.h"
#import "EPPointsShowView.h"
#import "NRTableInfo.h"
#import "NRGameInfo.h"
#import "NRUpdateInfo.h"
#import "NRGameInfo.h"
#import "EPAppData.h"

#import "EPPopAtipInfoView.h"
#import "GCDAsyncSocket.h"
#import "BLEIToll.h"

@interface NRCowViewController ()<GCDAsyncSocketDelegate>

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

@property (nonatomic, strong) UILabel *chipNumberLab;
@property (nonatomic, strong) UILabel *chipNumberValueLab;
@property (nonatomic, strong) UILabel *compensateLab;
@property (nonatomic, strong) UILabel *compensateValueLab;

@property (nonatomic, strong) UIView *lineView2;

@property (nonatomic, strong) UILabel *winningStatusLab;
@property (nonatomic, strong) UILabel *winningStatusValueLab;
@property (nonatomic, strong) UIButton *identifyButton;
@property (nonatomic, strong) UILabel *identifyValueLab;

@property (nonatomic, strong) UILabel *realLossLab;
@property (nonatomic, strong) UIButton *readChipMoney_button;//识别筹码金额
@property (nonatomic, strong) UILabel *totalSizeLab;

//赢
@property (nonatomic, strong) JXButton *win_button;
@property (nonatomic, assign) BOOL winOrLose;
@property (nonatomic, strong) NSString *winColor;
@property (nonatomic, strong) NSString *normalColor;
@property (nonatomic, strong) NSString *buttonNormalColor;

//输
@property (nonatomic, strong) JXButton *lose_button;
@property (nonatomic, strong) NSString *loseColor;

@property (nonatomic, strong) UIButton *superDouble_button;
@property (nonatomic, strong) UIButton *double_button;
@property (nonatomic, strong) UIButton *flat_button;

@property (nonatomic, strong) UIButton *changexueci_button;
@property (nonatomic, strong) UIButton *bindchouma_button;
@property (nonatomic, strong) UIButton *zhuxiaochouma_button;
@property (nonatomic, strong) UIButton *entry_button;
@property (nonatomic, strong) UIButton *newgame_button;

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

@property (nonatomic, strong) UIButton *washNumber_button;//手动输入洗码号
@property (nonatomic, strong) UIButton *cashEntry_button;//手动输入现金

@property (nonatomic, assign) int xueciCount;//靴次
@property (nonatomic, assign) int puciCount;//铺次

@property (nonatomic, assign) BOOL hasChipRead;//是否有可用筹码被识别
@property (nonatomic, assign) int beishuType;
@property (nonatomic, assign) BOOL isCash;//是否现金交易
@property (nonatomic, assign) BOOL isDashui;//是否打水

@property (nonatomic, strong) NSString *serialnumber;//流水号
@property (nonatomic, assign) CGFloat odds;//倍数
@property (nonatomic, assign) CGFloat yj;//佣金

@property (nonatomic, assign) int chipBLECount;//

@property (nonatomic, strong) UIButton *aTipRecordButton;//小费按钮

@property (nonatomic, strong) EPPopAlertShowView *resultShowView;

@property (nonatomic, strong) EPPopAtipInfoView *recordTipShowView;//识别小费

// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSMutableData *chipUIDData;
@property (nonatomic, assign) BOOL isResultAction;//是否

@end

@implementation NRCowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.xueciCount = 1;
    self.puciCount = 1;
    self.chipUIDData = [NSMutableData data];
    self.BLEDataList = [NSMutableArray arrayWithCapacity:0];
    self.BLEUIDDataList = [NSMutableArray arrayWithCapacity:0];
    self.BLEUIDDataHasPayList = [NSMutableArray array];
    self.BLEDataHasPayList = [NSMutableArray array];
    self.BLEUIDDataTipList = [NSMutableArray array];
    self.BLEDataTipList = [NSMutableArray array];
    self.curChipInfo = [[NRChipInfoModel alloc]init];
    self.serialnumber = [NSString stringWithFormat:@"%ld",(long)[NRCommand getRandomNumber:100000 to:1000000]];
    self.viewModel.curupdateInfo.cp_result = @"-1";
    self.viewModel.curupdateInfo.cp_DashuiUidList = [NSArray array];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    self.winOrLose = NO;
    self.hasChipRead = NO;
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
    self.userNameLab.text = [NSString stringWithFormat:@"当前荷官:%@",self.viewModel.loginInfo.femp_xm];
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
    self.xueciLab.text = @"靴次:01";
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
    self.puciLab.text = @"铺次:01";
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
    self.lastStrawLab.text = @"上一铺杀注:0";
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
    self.berthPaysLab.text = @"上一铺赔付:0";
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
    self.wonOrLostLab.text = @"上一铺输赢:0";
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
    self.currentPrincipalLab.text = @"当前本金:0";
    self.currentPrincipalLab.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.currentPrincipalLab];
    [self.currentPrincipalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-16);
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
    
    self.aTipRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.aTipRecordButton.layer.cornerRadius = 5;
    [self.aTipRecordButton setBackgroundImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateNormal];
    self.aTipRecordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.aTipRecordButton addTarget:self action:@selector(recordTipMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.aTipRecordButton setTitle:@"记录小费" forState:UIControlStateNormal];
    [self.infoView addSubview:self.aTipRecordButton];
    [self.aTipRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView).offset(10);
        make.centerX.equalTo(self.infoView);
        make.height.mas_equalTo(30);
        make.width.mas_offset(100);
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
    
    self.identifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.identifyButton.layer.cornerRadius = 5;
    self.identifyButton.hidden = YES;
    [self.identifyButton setTitle:@"开启水钱识别" forState:UIControlStateNormal];
    [self.identifyButton setTitle:@"关闭水钱识别" forState:UIControlStateSelected];
    [self.identifyButton setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.identifyButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.identifyButton.backgroundColor = [UIColor colorWithHexString:@"#357522"];
    [self.identifyButton addTarget:self action:@selector(identifyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView addSubview:self.identifyButton];
    [self.identifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.winningStatusValueLab.mas_bottom).offset(10);
        make.left.equalTo(self.lineView2.mas_right).offset(40);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width-80);
    }];
    
    self.identifyValueLab = [UILabel new];
    self.identifyValueLab.textColor = [UIColor colorWithHexString:@"#357522"];
    self.identifyValueLab.font = [UIFont systemFontOfSize:26];
    self.identifyValueLab.text = @"#";
    self.identifyValueLab.hidden = YES;
    self.identifyValueLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.identifyValueLab];
    [self.identifyValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identifyButton.mas_bottom).offset(5);
        make.left.equalTo(self.lineView2.mas_right);
        make.height.mas_equalTo(20);
        make.width.mas_offset(info_width);
    }];
    
    CGFloat down_info_width = (kScreenWidth-32-120)/2;
    self.totalSizeLab = [UILabel new];
    self.totalSizeLab.textColor = [UIColor colorWithHexString:@"#357522"];
    self.totalSizeLab.font = [UIFont systemFontOfSize:20];
    self.totalSizeLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.totalSizeLab];
    [self.totalSizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.infoView).offset(-20);
        make.left.equalTo(self.infoView);
        make.width.mas_offset(down_info_width);
    }];
    
    self.readChipMoney_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.readChipMoney_button.layer.cornerRadius = 5;
    self.readChipMoney_button.titleLabel.numberOfLines = 2;
    self.readChipMoney_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.readChipMoney_button setBackgroundImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateNormal];
    self.readChipMoney_button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.readChipMoney_button addTarget:self action:@selector(queryDeviceChips) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView addSubview:self.readChipMoney_button];
    [self.readChipMoney_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.infoView).offset(-15);
        make.left.equalTo(self.totalSizeLab.mas_right);
        make.height.mas_equalTo(40);
        make.width.mas_offset(120);
    }];
    
    self.realLossLab = [UILabel new];
    self.realLossLab.textColor = [UIColor colorWithHexString:@"#cc3023"];
    self.realLossLab.font = [UIFont systemFontOfSize:20];
    self.realLossLab.textAlignment =  NSTextAlignmentCenter;
    [self.infoView addSubview:self.realLossLab];
    [self.realLossLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.infoView).offset(-20);
        make.left.equalTo(self.cashEntry_button.mas_right);
        make.width.mas_offset(down_info_width);
        make.right.equalTo(self.infoView).offset(-5);
    }];
    
    self.win_button = [JXButton buttonWithType:UIButtonTypeCustom];
    self.win_button.layer.cornerRadius = 2;
    [self.win_button setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
    self.win_button.titleLabel.font = [UIFont systemFontOfSize:34];
    self.win_button.backgroundColor = [UIColor colorWithHexString:self.normalColor];
    [self.win_button setImage:[UIImage imageNamed:@"win_icon"] forState:UIControlStateNormal];
    [self.win_button addTarget:self action:@selector(winAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.win_button];
    [self.win_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(170);
        make.width.mas_offset(200);
    }];
    
    self.lose_button = [JXButton buttonWithType:UIButtonTypeCustom];
    self.lose_button.layer.cornerRadius = 2;
    [self.lose_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.lose_button.titleLabel.font = [UIFont systemFontOfSize:34];
    self.lose_button.backgroundColor = [UIColor colorWithHexString:self.loseColor];
    [self.lose_button setImage:[UIImage imageNamed:@"lose_icon_un"] forState:UIControlStateNormal];
    [self.lose_button addTarget:self action:@selector(loseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lose_button];
    [self.lose_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.win_button.mas_bottom);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(170);
        make.width.mas_offset(200);
    }];
    
    CGFloat tapItem_width = kScreenWidth-32-200-20;
    CGFloat tapItem_height = 100;
    CGFloat item_fontsize = 20;
    self.superDouble_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.superDouble_button.layer.cornerRadius = 2;
    self.superDouble_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
    self.superDouble_button.layer.borderWidth = 1;
    [self.superDouble_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.superDouble_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    self.superDouble_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
    [self.superDouble_button addTarget:self action:@selector(superDoubleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.superDouble_button];
    [self.superDouble_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(20);
        make.left.equalTo(self.win_button.mas_right).offset(20);
        make.height.mas_equalTo(tapItem_height);
        make.width.mas_offset(tapItem_width);
    }];
    
    self.double_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.double_button.layer.cornerRadius = 2;
    self.double_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
    self.double_button.layer.borderWidth = 1;
    [self.double_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.double_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    self.double_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
    [self.double_button addTarget:self action:@selector(doubleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.double_button];
    [self.double_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.superDouble_button.mas_bottom).offset(20);
        make.left.equalTo(self.win_button.mas_right).offset(20);
        make.height.mas_equalTo(tapItem_height);
        make.width.mas_offset(tapItem_width);
    }];
    
    self.flat_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flat_button.layer.cornerRadius = 2;
    self.flat_button.layer.borderColor = [UIColor colorWithHexString:self.normalColor].CGColor;
    self.flat_button.layer.borderWidth = 1;
    [self.flat_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.flat_button.titleLabel.font = [UIFont systemFontOfSize:item_fontsize];
    self.flat_button.backgroundColor = [UIColor colorWithHexString:self.buttonNormalColor];
    [self.flat_button addTarget:self action:@selector(flatAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flat_button];
    [self.flat_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.double_button.mas_bottom).offset(20);
        make.left.equalTo(self.win_button.mas_right).offset(20);
        make.height.mas_equalTo(tapItem_height);
        make.width.mas_offset(tapItem_width);
    }];
    
    CGFloat operationItem_width = (kScreenWidth-32-40)/5;
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
        make.top.equalTo(self.lose_button.mas_bottom).offset(40);
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
        make.top.equalTo(self.lose_button.mas_bottom).offset(40);
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
        make.top.equalTo(self.lose_button.mas_bottom).offset(40);
        make.left.equalTo(self.bindchouma_button.mas_right).offset(10);
        make.height.mas_equalTo(operationItem_height);
        make.width.mas_offset(operationItem_width);
    }];
    
    self.entry_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.entry_button.layer.cornerRadius = 2;
    [self.entry_button setTitleColor:[UIColor colorWithHexString:self.normalColor] forState:UIControlStateNormal];
    self.entry_button.titleLabel.font = [UIFont systemFontOfSize:operation_fontsize];
    self.entry_button.titleLabel.numberOfLines = 2;
    self.entry_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.entry_button.backgroundColor = [UIColor colorWithHexString:@"#b0251d"];
    [self.entry_button addTarget:self action:@selector(entryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.entry_button];
    [self.entry_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lose_button.mas_bottom).offset(40);
        make.left.equalTo(self.zhuxiaochouma_button.mas_right).offset(10);
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
        make.top.equalTo(self.lose_button.mas_bottom).offset(40);
        make.left.equalTo(self.entry_button.mas_right).offset(10);
        make.height.mas_equalTo(operationItem_height);
        make.width.mas_offset(operationItem_width);
    }];
    
    [self loadBacaratData];
    [self winAction];
    [self changeLanguageAction:nil];
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

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    [self.titleBar setTitle:@"VM娱乐桌面跟踪系统"];
    [self setLeftItemForGoBack];
    self.titleBar.rightItem = nil;
    self.titleBar.leftItem = nil;
    self.titleBar.showBottomLine = NO;
//    [self configureTitleBarToBlack];
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
    self.tableNumberLab.text = [NSString stringWithFormat:@"台号:%@",self.viewModel.curTableInfo.ftbname];
    self.userNameLab.text = [NSString stringWithFormat:@"当前荷官:%@",self.viewModel.loginInfo.femp_xm];
    self.IDLab.text = [NSString stringWithFormat:@"ID:%@",self.viewModel.loginInfo.fid];
    self.typeLab.text = @"类型:牛牛";
    self.betLimitLab.text = [NSString stringWithFormat:@"超级翻倍限红:%@",self.viewModel.curTableInfo.fnn_cjfb];
    self.heLimitLab.text = [NSString stringWithFormat:@"翻倍限红:%@",self.viewModel.curTableInfo.fnn_fb];
    self.duiLimitLab.text = [NSString stringWithFormat:@"平倍限红:%@",self.viewModel.curTableInfo.fnn_pb];
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
        self.chipNumberValueLab.text = entryText;
        self.viewModel.curupdateInfo.cp_benjin = entryText;
        self.betValueLab.text = entryText;
        self.customerInfo.principalMoney = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPBenjin note:@"本金"],entryText];
    }];
}

- (void)changeCoinAction:(UIButton *)btn{
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
- (void)identifyAction:(UIButton *)btn{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.isCash) {
        return;
    }
    if (!self.isDashui) {
        btn.selected = YES;
        self.isDashui = YES;
        [self showMessage:@"水钱识别模式开启"];
    }else{
        [EPPopView showInWindowWithMessage:[NSString stringWithFormat:@"当前识别水钱%@",self.identifyValueLab.text] handler:^(int buttonType) {
            if (buttonType==0) {
                btn.selected = NO;
                self.isDashui = NO;
                [self showMessage:@"水钱识别模式关闭"];
                [self.BLEUIDDataList removeAllObjects];
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    NSString *chipUID = self.chipUIDList[i];
                    //向指定标签中写入数据（块1）
                    [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                    usleep(20 * 2000);
                }
            }
        }];
    }
}

- (void)showInfoStatusWith:(BOOL)isWin{
    if (isWin) {
        self.totalSizeLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPRealpay note:@"实赔"],@"#"];
        self.realLossLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPAllChip note:@"总码"],@"#"];
//        self.identifyValueLab.hidden = NO;
//        self.identifyButton.hidden = NO;
        self.compensateValueLab.hidden = NO;
        self.compensateLab.hidden = NO;
        self.betValueLab.hidden = NO;
        self.betLab.hidden = NO;
        self.compensateLab.hidden = NO;
    }else{
        self.totalSizeLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPshouldShazhu note:@"应杀注"],@"#"];
        self.realLossLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPShazhu note:@"杀注"],@"#"];
//        self.identifyValueLab.hidden = YES;
//        self.identifyButton.hidden = YES;
        self.compensateValueLab.hidden = YES;
        self.betValueLab.hidden = YES;
        self.betLab.hidden = YES;
        self.compensateLab.hidden = YES;
        self.compensateLab.hidden = YES;
    }
}

- (void)winAction{
    self.winOrLose = YES;
    self.customerInfo.isWinOrLose = YES;
    self.payChipUIDList = [NSArray array];
    self.viewModel.curupdateInfo.cp_result = @"1";
    [self.win_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
    [self.lose_button setBackgroundColor:[UIColor colorWithHexString:self.normalColor]];
    [self showInfoStatusWith:YES];
    
    [self.win_button setImage:[UIImage imageNamed:@"win_icon_un"] forState:UIControlStateNormal];
    [self.lose_button setImage:[UIImage imageNamed:@"lose_icon"] forState:UIControlStateNormal];
    [self.win_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.lose_button setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
    [self.superDouble_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.double_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.flat_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    self.winningStatusValueLab.text = @"#";
    self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.normalColor];
}

- (void)loseAction{

    self.winOrLose = NO;
    self.customerInfo.isWinOrLose = NO;
    self.payChipUIDList = [NSArray array];
    self.viewModel.curupdateInfo.cp_result = @"-1";
    [self.win_button setBackgroundColor:[UIColor colorWithHexString:self.normalColor]];
    [self.lose_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
    [self showInfoStatusWith:NO];
    
    [self.win_button setImage:[UIImage imageNamed:@"win_icon"] forState:UIControlStateNormal];
    [self.lose_button setImage:[UIImage imageNamed:@"lose_icon_un"] forState:UIControlStateNormal];
    [self.win_button setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
    [self.lose_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.superDouble_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.double_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    [self.flat_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
    self.winningStatusValueLab.text = @"#";
    self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.normalColor];
}

#pragma mark - 超级翻倍
- (void)superDoubleAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.isCash) {
        if ([self.guestCodeNumberValueLab.text isEqualToString:@"#"]&&[self.chipNumberValueLab.text isEqualToString:@"#"]) {
            [self showMessage:[EPStr getStr:kEPEntryWashNumber note:@"请输入洗码号"]];
            return;
        }
    }else{
        if (!self.hasChipRead) {
            [self showMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
            return;
        }
    }
    [self ActionQueryDeviceChips];
    self.beishuType = 1;
    if (self.winOrLose) {
        [self.superDouble_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
        [self.double_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        [self.flat_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        self.winningStatusValueLab.text = @"超级翻倍赢";
        self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n超级翻倍赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPDashui note:@"打水"],self.identifyValueLab.text];
    }else{
        [self.superDouble_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
        [self.double_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        [self.flat_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        self.winningStatusValueLab.text = @"超级翻倍输";
        self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.loseColor];
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n超级翻倍输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%@:0",[EPStr getStr:kEPDashui note:@"打水"]];
    }
}

#pragma mark - 翻倍
- (void)doubleAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.isCash) {
        if ([self.guestCodeNumberValueLab.text isEqualToString:@"#"]&&[self.chipNumberValueLab.text isEqualToString:@"#"]) {
            [self showMessage:[EPStr getStr:kEPEntryWashNumber note:@"请输入洗码号"]];
            return;
        }
    }else{
        if (!self.hasChipRead) {
            [self showMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
            return;
        }
    }
    [self ActionQueryDeviceChips];
    self.beishuType = 2;
    if (self.winOrLose) {
        [self.double_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
        [self.superDouble_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        [self.flat_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        self.winningStatusValueLab.text = @"翻倍赢";
        self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n翻倍赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPDashui note:@"打水"],self.identifyValueLab.text];
    }else{
        [self.double_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
        [self.superDouble_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        [self.flat_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        self.winningStatusValueLab.text = @"翻倍输";
        self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.loseColor];
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n翻倍输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%@:0",[EPStr getStr:kEPDashui note:@"打水"]];
    }
}

#pragma mark - 平倍
- (void)flatAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.isCash) {
        if ([self.guestCodeNumberValueLab.text isEqualToString:@"#"]&&[self.chipNumberValueLab.text isEqualToString:@"#"]) {
            [self showMessage:[EPStr getStr:kEPEntryWashNumber note:@"请输入洗码号"]];
            return;
        }
    }else{
        if (!self.hasChipRead) {
            [self showMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
            return;
        }
    }
    [self ActionQueryDeviceChips];
    self.beishuType = 3;
    if (self.winOrLose) {
        [self.flat_button setBackgroundColor:[UIColor colorWithHexString:self.winColor]];
        [self.superDouble_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        [self.double_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        self.winningStatusValueLab.text = @"平倍赢";
        self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.winColor];
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n平倍赢",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPDashui note:@"打水"],self.identifyValueLab.text];
    }else{
        [self.flat_button setBackgroundColor:[UIColor colorWithHexString:self.loseColor]];
        [self.superDouble_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        [self.double_button setBackgroundColor:[UIColor colorWithHexString:self.buttonNormalColor]];
        self.winningStatusValueLab.text = @"平倍输";
        self.winningStatusValueLab.textColor = [UIColor colorWithHexString:self.loseColor];
        self.customerInfo.winStatus = [NSString stringWithFormat:@"%@:\n平倍输",[EPStr getStr:kEPWinStatus note:@"输赢状态"]];
        self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%@:0",[EPStr getStr:kEPDashui note:@"打水"]];
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
    [self.entry_button setTitle:[NSString stringWithFormat:@"输入跟踪端\n%@",[EPStr getStr:kEPEntry note:@"输入跟踪端"]] forState:UIControlStateNormal];
    [self.bindchouma_button setTitle:[NSString stringWithFormat:@"绑定筹码\n%@",[EPStr getStr:kEPBindChip note:@"绑定筹码"]] forState:UIControlStateNormal];
    [self.newgame_button setTitle:[NSString stringWithFormat:@"新一局\n%@",[EPStr getStr:kEPNewGame note:@"新一局"]] forState:UIControlStateNormal];
    [self.zhuxiaochouma_button setTitle:[NSString stringWithFormat:@"注销筹码\n%@",[EPStr getStr:kEPCancellationChip note:@"注销筹码"]] forState:UIControlStateNormal];
    
    self.chipNumberLab.text = [EPStr getStr:kEPCurrentReadMoney note:@"当前识别金额"];
    self.guestCodeNumberLab.text = [EPStr getStr:kEPWashNumber note:@"客人洗码号"];
    [self.superDouble_button setTitle:[EPStr getStr:kEPSuperDouble note:@"超级翻倍"] forState:UIControlStateNormal];
    self.betLab.text = [EPStr getStr:kEPBetch note:@"下注"];
    self.compensateLab.text = [EPStr getStr:kEPCompensate note:@"应赔"];
    self.winningStatusLab.text = [EPStr getStr:kEPWinStatus note:@"输赢状态"];
    [self.double_button setTitle:[EPStr getStr:kEPDouble note:@"翻倍"] forState:UIControlStateNormal];
    [self.lose_button setTitle:[EPStr getStr:kEPLose note:@"输"] forState:UIControlStateNormal];
    [self.flat_button setTitle:[EPStr getStr:kEPPingTimes note:@"平倍 Equal"] forState:UIControlStateNormal];
    [self.readChipMoney_button setTitle:[NSString stringWithFormat:@"识别筹码金额\n%@",[EPStr getStr:kEPReadChipMoney note:@"识别筹码金额"]] forState:UIControlStateNormal];
    [self.win_button setTitle:[EPStr getStr:kEPWin note:@"赢"] forState:UIControlStateNormal];
    
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
                            usleep(20 * 2000);
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

#pragma mark - 输入跟踪端
- (void)entryAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.isCash) {
        if ([self.guestCodeNumberValueLab.text isEqualToString:@"#"]&&[self.chipNumberValueLab.text isEqualToString:@"#"]) {
            [self showMessage:[EPStr getStr:kEPEntryWashNumber note:@"请输入洗码号"]];
            return;
        }
    }else{
        if (!self.hasChipRead) {
            [self showMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
            return;
        }
    }
    self.resultInfo.firstColor = @"#b0251d";
    self.resultInfo.secondColor = @"#4d9738";
    if ([EPAppData sharedInstance].language.languageType==1) {
        self.resultInfo.topTitleList = @[[EPStr getStr:kEPNiuniu note:@"牛牛"],[EPStr getStr:kEPFiveCow note:@"五花牛"],[EPStr getStr:kEPBomb note:@"炸弹"],[EPStr getStr:kEPSmallCow note:@"五小牛"]];
    }else{
        self.resultInfo.topTitleList = @[[NSString stringWithFormat:@"牛牛\n%@",[EPStr getStr:kEPNiuniu note:@"牛牛"]],[NSString stringWithFormat:@"五花牛\n%@",[EPStr getStr:kEPFiveCow note:@"五花牛"]],[NSString stringWithFormat:@"炸弹\n%@",[EPStr getStr:kEPBomb note:@"炸弹"]],[NSString stringWithFormat:@"五小牛\n%@",[EPStr getStr:kEPSmallCow note:@"五小牛"]]];
    }
    
    self.resultInfo.bottomTitleList = @[@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1"];
    @weakify(self);
    [EPPointsShowView showInWindowWithNRChipResultInfo:self.resultInfo handler:^(int buttonType) {
        DLOG(@"buttonType = %d",buttonType);
        @strongify(self);
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
        if (buttonType==99) {
            self.odds = 1;
            self.yj = 0;
        }else{
            self.odds = [[fplDict valueForKey:[NSString stringWithFormat:@"%d",buttonType]]floatValue];
            self.yj = [[fyjDict valueForKey:[NSString stringWithFormat:@"%d",buttonType]]floatValue]/100;
        }
        
        NSString *realCashMoney = @"";
        if (!self.isCash) {
            realCashMoney = self.curChipInfo.chipDenomination;
        }else{
            realCashMoney = self.chipNumberValueLab.text;
        }
        if (self.winOrLose) {
            CGFloat compensateMoney = self.odds*[realCashMoney floatValue];//应赔
            CGFloat yongjinMoney = self.yj*compensateMoney;//佣金
            self.customerInfo.compensateCode = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPCompensate note:@"应赔"],compensateMoney];
            self.viewModel.curupdateInfo.cp_commission = [NSString stringWithFormat:@"%.f",yongjinMoney];//佣金
            self.customerInfo.compensateMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPRealpay note:@"实赔"],compensateMoney-yongjinMoney+[self.identifyValueLab.text floatValue]];
            self.customerInfo.totalMoney = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPAllChip note:@"总码"],[realCashMoney floatValue]+compensateMoney-yongjinMoney+[self.identifyValueLab.text floatValue]];
            self.compensateValueLab.text = [NSString stringWithFormat:@"%.f",compensateMoney];
            self.totalSizeLab.text = [NSString stringWithFormat:@"%@：%.f",[EPStr getStr:kEPAllChip note:@"总码"],[realCashMoney floatValue]+compensateMoney-yongjinMoney+[self.identifyValueLab.text floatValue]];
            self.realLossLab.text = [NSString stringWithFormat:@"%@:%.f",[EPStr getStr:kEPRealpay note:@"实赔"],compensateMoney-yongjinMoney+[self.identifyValueLab.text floatValue]];
            self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",[realCashMoney floatValue]+compensateMoney-yongjinMoney];
        }else{
            self.customerInfo.xiazhu = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPBetch note:@"下注"],realCashMoney];
            self.customerInfo.shazhu = [NSString stringWithFormat:@"%@:%.f",[EPStr getStr:kEPshouldShazhu note:@"应杀注"],self.odds*[realCashMoney floatValue]];
            self.compensateValueLab.text = [NSString stringWithFormat:@"%.f",self.odds*[realCashMoney floatValue]];
            self.totalSizeLab.text = [NSString stringWithFormat:@"%@:%.f",[EPStr getStr:kEPshouldShazhu note:@"应杀注"],self.odds*[realCashMoney floatValue]];
            self.realLossLab.text = [NSString stringWithFormat:@"%@:%@",[EPStr getStr:kEPBetch note:@"下注"],realCashMoney];
            self.viewModel.curupdateInfo.cp_commission = [NSString stringWithFormat:@"0"];
            self.viewModel.curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",self.odds*[realCashMoney floatValue]];
            self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"应加赔:%.f",(self.odds-1)*[realCashMoney floatValue]];
        }
        self.viewModel.curupdateInfo.cp_dianshu = [NSString stringWithFormat:@"%d",buttonType];
        if (buttonType==99) {
            self.viewModel.curupdateInfo.cp_dianshu = [NSString stringWithFormat:@"%d",0];
        }
        
        [self showStatusInfo];
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
            [self.recordTipShowView _hide];
            [self.BLEUIDDataTipList removeAllObjects];
            [self.BLEDataTipList removeAllObjects];
            
            self.viewModel.curupdateInfo.cp_xiaofeiList = self.tipChipUIDList;
            [self.viewModel commitTipResultWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                if (success) {
                    self.isRecordTipMoney = NO;
                    for (int i = 0; i < self.tipChipUIDList.count; i++) {
                        NSString *chipUID = self.tipChipUIDList[i];
                        //向指定标签中写入数据（块1）
                        [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                        usleep(20 * 2000);
                    }
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
            [self getTipChipsUIDList];
        }else if (buttonType==0){
            self.isRecordTipMoney = NO;
            [self.BLEDataTipList removeAllObjects];
            [self.BLEUIDDataTipList removeAllObjects];
        }
    }];
}

#pragma mark - 弹出结果
- (void)showStatusInfo{
    if (!self.isCash) {
        self.viewModel.curupdateInfo.cp_washNumber = self.curChipInfo.guestWashesNumber;
        self.viewModel.curupdateInfo.cp_benjin = self.curChipInfo.chipDenomination;
    }
    self.customerInfo.isCow = YES;
    
    self.isShowingResult = YES;
    @weakify(self);
    self.resultShowView = [EPPopAlertShowView showInWindowWithNRCustomerInfo:self.customerInfo handler:^(int buttonType) {
        DLOG(@"buttonType===%d",buttonType);
        @strongify(self);
        if (buttonType==1) {
            //客户输赢记录
            NSMutableArray *realChipUIDList = [NSMutableArray array];
            if (self.isCash) {
                self.viewModel.curupdateInfo.cp_chipType = @"0";
            }else{
                [realChipUIDList addObjectsFromArray:self.chipUIDList];
                [realChipUIDList addObjectsFromArray:self.payChipUIDList];
                self.viewModel.curupdateInfo.cp_chipType = self.curChipInfo.chipType;
            }
            self.viewModel.curupdateInfo.cp_ChipUidList = realChipUIDList;
            self.viewModel.curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.odds];
            self.viewModel.curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",self.xueciCount];
            self.viewModel.curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",self.puciCount];
            self.viewModel.curupdateInfo.cp_Serialnumber = self.serialnumber;
            [self.viewModel commitCustomerRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                @strongify(self);
                [self hideWaitingView];
                if (success) {
                    self.hasChipRead = NO;
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
                    self.identifyValueLab.text = @"#";
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
                    [self winAction];
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
            [self getPayChipsUIDList];
        }else if (buttonType==0){
            self.isShowingResult = NO;
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
            self.chipUIDList = nil;
            self.payChipUIDList = nil;
            self.tipChipUIDList = nil;
            [self winAction];
        }
    }];
}

#pragma mark - 新一局
- (void)newGameAction{
    [EPSound playWithSoundName:@"click_sound"];
    @weakify(self);
    [EPPopView showInWindowWithMessage:[NSString stringWithFormat:@"是否确定开启新一局？\n%@",[EPStr getStr:kEPSureNextGame note:@"确定开启新一局？"]] handler:^(int buttonType) {
        @strongify(self);
        if (buttonType==0) {
            self.serialnumber = [NSString stringWithFormat:@"%ld",(long)[NRCommand getRandomNumber:100000 to:1000000]];
            self.puciCount +=1;
            self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
            if (self.puciCount<10) {
                self.puciLab.text = [NSString stringWithFormat:@"铺次:0%d",self.puciCount];
            }
            self.identifyValueLab.text = @"#";
            [self showMessage:@"开启新一局成功"];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
        }
    }];
    
}

- (void)ActionQueryDeviceChips{
//    if (!self.isCash) {
//        self.isResultAction = YES;
//        //设置感应盘工作模式
//        [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
//    }
}

#pragma mark - 识别筹码金额
- (void)ActionreadCurChipsMoney{
//    //执行读取命令
//    [self.BLEDataList removeAllObjects];
//    [self.BLEUIDDataList removeAllObjects];
//    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
//    dispatch_async(serialQueue, ^{
//        for (int i = 0; i < self.chipUIDList.count; i++) {
//            NSString *chipID = self.chipUIDList[i];
//            [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
//            usleep(20 * 2000);
//        }
//    });
}

#pragma mark - 查询设备上的筹码UID
- (void)queryDeviceChips{
    [EPSound playWithSoundName:@"click_sound"];
    //设置感应盘工作模式
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 识别筹码金额
- (void)readCurChipsMoney{
    if (self.winOrLose) {
        [self winAction];
    }else{
        [self loseAction];
    }
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
                    [self.BLEUIDDataHasPayList addObjectsFromArray:array];
                    BLEIToll *itool = [[BLEIToll alloc]init];
                    NSString *BLEString = [itool dataStringFromArray:self.BLEUIDDataHasPayList];
                    //存贮筹码UID
                    self.payChipUIDList = [itool getDeviceALlPayChipUIDWithBLEString:BLEString WithUidList:self.chipUIDList WithShuiqianUidList:[NSArray array]];
                    self.payChipCount = self.payChipUIDList.count;
                    if (self.payChipCount==0) {
                        self.payChipUIDList = nil;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.resultShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",[EPStr getStr:kEPPeifuChip note:@"已赔付筹码:"],0];
                            [self showLognMessage:@"未检测到赔付筹码"];
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
                        });
                    }else{
                        [self readAllPayChipsInfo];
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
                            [self winAction];
                            [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
                        }else{
                            if (self.isResultAction) {
                                [self ActionreadCurChipsMoney];
                            }else{
                                [self readCurChipsMoney];
                            }
                            if (!self.isDashui) {
                            }else{
                                self.viewModel.curupdateInfo.cp_DashuiUidList = self.chipUIDList;
                            }
                        }
                    }
                }
            }else{
                self.isShowingResult = NO;
                self.identifyValueLab.text = @"#";
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
                [self winAction];
                [self showLognMessage:[EPStr getStr:kEPNoChip note:@"未检测到筹码"]];
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
            }
        }
    }else if ([dataHexStr hasPrefix:@"13000000"]){
        //展示结果之后
        if (self.isShowingResult) {
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                    self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",benjinMoney+chipAllMoney];
                    self.resultShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",[EPStr getStr:kEPPeifuChip note:@"已赔付筹码:"],chipAllMoney];
                });
                [self showMessage:@"识别赔付筹码成功"];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
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
                            if (!self.isResultAction) {
                                //响警告声音
                                [EPSound playWithSoundName:@"succeed_sound"];
                            }
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
                            if (self.isDashui) {
                                self.identifyValueLab.text = [NSString stringWithFormat:@"%d",chipAllMoney];
                            }else{
                                self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",chipAllMoney];
                                self.guestCodeNumberValueLab.text = self.curChipInfo.guestWashesNumber;
                                self.betValueLab.text = self.curChipInfo.chipDenomination;
                                self.chipNumberValueLab.text = self.curChipInfo.chipDenomination;
                                self.customerInfo.guestNumber = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPWashNumber note:@"客人洗码号"],self.curChipInfo.guestWashesNumber];
                                self.customerInfo.principalMoney = [NSString stringWithFormat:@"%@：%@",[EPStr getStr:kEPBenjin note:@"本金"],self.curChipInfo.chipDenomination];
                            }
                        });
                        
                        if (self.isResultAction) {
                            self.isResultAction = NO;
                        }else{
                            [self showMessage:[EPStr getStr:kEPReadSucceed note:@"识别成功"]];
                            [self hideWaitingView];
                        }
                    }
                }
            }
        }
    }
}

@end
