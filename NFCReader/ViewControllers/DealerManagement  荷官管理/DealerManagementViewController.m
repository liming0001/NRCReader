//
//  DealerManagementViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/18.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "DealerManagementViewController.h"
#import "NRChipManagerTableViewCell.h"
#import "NRChipDestrutTableViewCell.h"
#import "NRCashExchangeTableViewCell.h"
#import "NRChipManagerInfo.h"
#import "NRDealerManagerViewModel.h"
#import "NRChipCodeItem.h"
#import "EPService.h"
#import "NRLoginInfo.h"
#import "NRChipInfo.h"
#import "NRChipAllInfo.h"
#import "EPPopView.h"
#import "GCDAsyncSocket.h"
#import "BLEIToll.h"

#define channelOnPeropheralView @"peripheralView"

@interface DealerManagementViewController ()<UITableViewDelegate,UITableViewDataSource,GCDAsyncSocketDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *loginRoleLab;
@property (nonatomic, strong) UILabel *IDLab;

@property (nonatomic, strong) UIView *toplineView;
@property (nonatomic, strong) UIView *leftButtonView;
//筹码管理
@property (nonatomic, strong) UIButton *chipManagerButton;
@property (nonatomic, strong) UIView *chipManagerlineView;
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, assign) int chipOperationType;

//筹码发行
@property (nonatomic, strong) UITableView *chipIssueTableView;
@property (nonatomic, strong) UIButton *chipIssueButton;
@property (nonatomic, strong) UIView *chipIssueView;
@property (nonatomic, strong) UIView *chipIssue_typeView;
@property (nonatomic, strong) UIView *chipIssue_fmeView;
@property (nonatomic, strong) NSMutableArray *chipFmeList;
@property (nonatomic, strong) UILabel *scanChipNumberLab;
@property (nonatomic, strong) NSMutableArray *chipIssueList;
@property (nonatomic, strong) NSMutableArray *chipTypeItemList;
@property (nonatomic, strong) NSMutableArray *chipFmeItemList;
@property (nonatomic, strong) NRChipCodeItem *chipTypeSelectedItem;
@property (nonatomic, strong) NRChipCodeItem *chipFmeSelectedItem;
//筹码类型
@property (nonatomic, strong) UILabel *cashTypeLab;

//筹码面额
@property (nonatomic, strong) UILabel *cashValueLab;
@property (nonatomic, strong) UILabel *serialNumberLab;
@property (nonatomic, strong) UITextField *serialNumberTextFiled;
@property (nonatomic, strong) UILabel *batchLab;
@property (nonatomic, strong) UITextField *batchTextFiled;
@property (nonatomic, strong) UIButton *chipissueButton;

//筹码检测
@property (nonatomic, strong) UITableView *chipCheckTableView;
@property (nonatomic, strong) UIButton *chipCheckButton;
@property (nonatomic, strong) UIView *chipCheckView;
@property (nonatomic, strong) NSMutableArray *chipCheckList;

//筹码销毁
@property (nonatomic, strong) UITableView *chipDestructTableView;
@property (nonatomic, strong) UIButton *chipDestructButton;
@property (nonatomic, strong) UIView *chipDestructView;
@property (nonatomic, strong) NSMutableArray *chipDestructList;
@property (nonatomic, strong) NSMutableArray *choosedSerNumberList;
@property (nonatomic, strong) UIImageView *destructImage;
@property (nonatomic, strong) UILabel *destructTipsLab;
@property (nonatomic, strong) UIButton *readChipButton;

//筹码兑换
@property (nonatomic, strong) UITableView *chipExchangeTableView;
@property (nonatomic, strong) UIButton *chipExchangeButton;
@property (nonatomic, strong) UIView *chipExchangeView;
@property (nonatomic, strong) UIButton *cashExchangeChipButton;
@property (nonatomic, strong) UIButton *chipExchangeCashButton;
@property (nonatomic, strong) UIButton *creditCodeButton;

@property (nonatomic, strong) UIView *chipExchangeTableHeadView;
@property (nonatomic, strong) UIView *chipExchangeFootView;
@property (nonatomic, strong) UILabel *exchangNumberLab;
@property (nonatomic, strong) UILabel *exchangTotalMoneyLab;
@property (nonatomic, strong) UILabel *exchangMoneyLab;

//结算小费
@property (nonatomic, strong) UITableView *tipSettlementTableView;
@property (nonatomic, strong) UIButton *tipSettlementButton;
@property (nonatomic, strong) UIView *tipSettlementView;
@property (nonatomic, strong) NSMutableArray *tipSettlementList;
@property (nonatomic, strong) UIImageView *tipSettlementImage;
@property (nonatomic, strong) UILabel *tipSettlementTipsLab;
@property (nonatomic, strong) UIButton *tipSettlementReadButton;

@property (nonatomic, strong) UIView *tipSettlementTableHeadView;
@property (nonatomic, strong) UIView *tipSettlementFootView;
@property (nonatomic, strong) UILabel *tipSettlementNumberLab;
@property (nonatomic, strong) UILabel *tipSettlementTotalMoneyLab;
@property (nonatomic, strong) UIButton *tipSoonSettlementButton;

//存储筹码
@property (nonatomic, strong) UITableView *storageChipTableView;
@property (nonatomic, strong) UIButton *storageChipButton;
@property (nonatomic, strong) UIView *storageChipView;
@property (nonatomic, strong) NSMutableArray *storageChipList;
@property (nonatomic, strong) UIImageView *storageChipImage;
@property (nonatomic, strong) UILabel *storageChipTipsLab;
@property (nonatomic, strong) UIButton *storageChipReadButton;

@property (nonatomic, strong) UIView *storageChipTableHeadView;
@property (nonatomic, strong) UIView *storageChipFootView;
@property (nonatomic, strong) UILabel *storageChipNumberLab;
@property (nonatomic, strong) UILabel *storageChipTotalMoneyLab;
@property (nonatomic, strong) UIButton *storageChipSoonButton;

//取出筹码
@property (nonatomic, strong) UITableView *takeOutChipTableView;
@property (nonatomic, strong) UIButton *takeOutChipButton;
@property (nonatomic, strong) UIView *takeOutChipView;
@property (nonatomic, strong) NSMutableArray *takeOutChipList;
@property (nonatomic, strong) UIImageView *takeOutChipImage;
@property (nonatomic, strong) UILabel *takeOutChipTipsLab;
@property (nonatomic, strong) UIButton *takeOutChipReadButton;

@property (nonatomic, strong) UIView *takeOutChipTableHeadView;
@property (nonatomic, strong) UIView *takeOutChipFootView;
@property (nonatomic, strong) UILabel *takeOutChipNumberLab;
@property (nonatomic, strong) UILabel *takeOutChipMoneyLab;
@property (nonatomic, strong) UILabel *takeOutChipMoneyValueLab;
@property (nonatomic, strong) UILabel *takeOutChipTotalMoneyLab;
@property (nonatomic, strong) UIButton *takeOutChipConfirmButton;

//调节功率
@property (nonatomic, strong) UIButton *adjustPowerButton;
@property (nonatomic, strong) UIView *adjustPowerView;
@property (nonatomic, strong) UITextField *adjustPowerTextField;
@property (nonatomic, strong) UIButton *adjustPowerSoonButton;

//上级信息
@property (nonatomic, strong) UILabel *takeOutsuperiorInfoLab;
@property (nonatomic, strong) UILabel *takeOutsuperiorNameLab;
@property (nonatomic, strong) UILabel *takeOutsuperiorWashNumberLab;
@property (nonatomic, strong) UILabel *takeOutsuperiorMoneyLab;
@property (nonatomic, strong) UILabel *takeOutsuperiorTellLab;
//当前客人
@property (nonatomic, strong) UILabel *takeOutcurCustomerInfoLab;
@property (nonatomic, strong) UILabel *takeOutcurCustomerWashNumberLab;
@property (nonatomic, strong) UILabel *takeOutcurCustomerNameLab;
@property (nonatomic, strong) UILabel *takeOutcurCustomerTellLab;

@property (nonatomic, strong) NSMutableArray *takeOutcashExchangeList;
@property (nonatomic, strong) UITextField *takeOutWashNumberTextField;
@property (nonatomic, strong) UITextField *takeOutPassWordTextField;

//上级信息
@property (nonatomic, strong) UILabel *superiorInfoLab;
@property (nonatomic, strong) UILabel *superiorNameLab;
@property (nonatomic, strong) UILabel *superiorWashNumberLab;
@property (nonatomic, strong) UILabel *superiorMoneyLab;
@property (nonatomic, strong) UILabel *superiorTellLab;
@property (nonatomic, strong) UILabel *codeLinesLab;//出码额度
//当前客人
@property (nonatomic, strong) UILabel *curCustomerInfoLab;
@property (nonatomic, strong) UILabel *curCustomerWashNumberLab;
@property (nonatomic, strong) UILabel *curCustomerNameLab;
@property (nonatomic, strong) UILabel *curCustomerTellLab;
@property (nonatomic, strong) UILabel *curCodeLinesLab;//客人出码额度

@property (nonatomic, strong) NSMutableArray *cashExchangeList;
@property (nonatomic, strong) UITextField *cashCodeTextField;
@property (nonatomic, strong) UITextField *authorizationTextField;//授权
@property (nonatomic, strong) UITextField *noteTextField;//备注
@property (nonatomic, strong) UIButton *cashExchangeConfirmButton;
@property (nonatomic, strong) UIImageView *exchangeImage;
@property (nonatomic, strong) UILabel *exchangeTipsLab;
@property (nonatomic, strong) NRChipInfoModel *curChipInfo;
@property (nonatomic, assign) NSInteger chipCount;
@property (nonatomic, strong) NSArray *chipUIDList;


@property (nonatomic, strong) NSString *lastTextContent;
@property (nonatomic, assign) BOOL isReadChip;//是否读取筹码
@property (nonatomic, assign) BOOL isIssue;//是否发行
@property (nonatomic, assign) BOOL isDestoryChip;//是否销毁筹码
@property (nonatomic, assign) BOOL isExchangeChip;//是否兑换筹码
@property (nonatomic, assign) BOOL isAdjustPower;//是否设置功率
@property (nonatomic, assign) BOOL isSettlementTipChip;//是否结算筹码
@property (nonatomic, assign) BOOL isStorageChip;//是否存入筹码
@property (nonatomic, assign) BOOL isTakeOutChip;//是否取出筹码
@property (nonatomic, assign) BOOL readChipCount;//检测是否有筹码
@property (nonatomic, assign) BOOL isSetUpDeviceModel;//设置读写器模式
@property (nonatomic, assign) NSInteger allUserTotalMoney;//总金额

// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSMutableData *chipUIDData;

@end

@implementation DealerManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    
    self.curChipInfo = [[NRChipInfoModel alloc]init];
    self.curChipInfo.fcredit = @"0";
    self.curChipInfo.authorName = @"";
    self.curChipInfo.notes = @"";
    
    self.chipCheckList = [NSMutableArray arrayWithCapacity:0];
    self.chipIssueList = [NSMutableArray arrayWithCapacity:0];
    self.choosedSerNumberList = [NSMutableArray arrayWithCapacity:0];
    self.chipDestructList = [NSMutableArray arrayWithCapacity:0];
    self.cashExchangeList = [NSMutableArray arrayWithCapacity:0];
    self.tipSettlementList = [NSMutableArray arrayWithCapacity:0];
    self.storageChipList = [NSMutableArray arrayWithCapacity:0];
    self.takeOutChipList = [NSMutableArray arrayWithCapacity:0];
    
    CGFloat fontSize = 16;
    self.userNameLab = [UILabel new];
    self.userNameLab.textColor = [UIColor colorWithHexString:@"#959595"];
    self.userNameLab.font = [UIFont systemFontOfSize:fontSize];
    self.userNameLab.text = [NSString stringWithFormat:@"姓名:%@",self.viewModel.chipInfo.femp_xm];
    [self.view addSubview:self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    self.loginRoleLab = [UILabel new];
    self.loginRoleLab.textColor = [UIColor colorWithHexString:@"#959595"];
    self.loginRoleLab.font = [UIFont systemFontOfSize:fontSize];
    self.loginRoleLab.text = @"当前登录角色:码房管理员";
    [self.view addSubview:self.loginRoleLab];
    [self.loginRoleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(10);
        make.left.equalTo(self.userNameLab.mas_right).offset(60);
        make.height.mas_equalTo(20);
    }];
    
    self.IDLab = [UILabel new];
    self.IDLab.textColor = [UIColor colorWithHexString:@"#959595"];
    self.IDLab.font = [UIFont systemFontOfSize:fontSize];
    self.IDLab.text = [NSString stringWithFormat:@"ID:%@",self.viewModel.chipInfo.fid];
    [self.view addSubview:self.IDLab];
    [self.IDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(10);
        make.left.equalTo(self.loginRoleLab.mas_right).offset(60);
        make.height.mas_equalTo(20);
    }];
    
    self.operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.operationButton setTitle:@"  继续发行  " forState:UIControlStateNormal];
    self.operationButton.layer.cornerRadius = 5;
    self.operationButton.hidden = YES;
    self.operationButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.operationButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.operationButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    self.operationButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.operationButton addTarget:self action:@selector(operationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.operationButton];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(5);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    self.scanChipNumberLab = [UILabel new];
    self.scanChipNumberLab.textColor = [UIColor colorWithHexString:@"#b0251d"];
    self.scanChipNumberLab.font = [UIFont systemFontOfSize:fontSize];
    [self.view addSubview:self.scanChipNumberLab];
    [self.scanChipNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(20);
    }];
    
    NSString *lingColor = @"#959595";
    self.toplineView = [UIView new];
    self.toplineView.backgroundColor = [UIColor colorWithHexString:lingColor];
    [self.view addSubview:self.toplineView];
    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(40);
        make.left.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.mas_offset(0.5);
    }];
    
    self.leftButtonView = [UIView new];
    self.leftButtonView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    [self.view addSubview:self.leftButtonView];
    [self.leftButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_offset(200);
    }];
    
    self.chipManagerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chipManagerButton setTitle:@"筹码管理" forState:UIControlStateNormal];
    [self.chipManagerButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.chipManagerButton.titleLabel.font = [UIFont systemFontOfSize:26];
    [self.leftButtonView addSubview:self.chipManagerButton];
    [self.chipManagerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftButtonView);
        make.left.equalTo(self.leftButtonView);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.leftButtonView);
    }];
    self.chipManagerlineView = [UIView new];
    self.chipManagerlineView.backgroundColor = [UIColor colorWithHexString:lingColor];
    [self.leftButtonView addSubview:self.chipManagerlineView];
    [self.chipManagerlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipManagerButton.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView);
        make.centerX.equalTo(self.leftButtonView);
        make.height.mas_offset(1);
    }];
    
    self.chipIssueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chipIssueButton setTitle:@"   筹码发行" forState:UIControlStateNormal];
    self.chipIssueButton.selected = YES;
    [self.chipIssueButton setImage:[UIImage imageNamed:@"chipIssue_icon"] forState:UIControlStateNormal];
    [self.chipIssueButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    self.chipIssueButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.chipIssueButton addTarget:self action:@selector(chipIssueAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButtonView addSubview:self.chipIssueButton];
    [self.chipIssueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipManagerlineView.mas_bottom);
        make.left.equalTo(self.leftButtonView);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.leftButtonView);
    }];
    
    self.chipCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chipCheckButton setTitle:@"   筹码检测" forState:UIControlStateNormal];
    [self.chipCheckButton setImage:[UIImage imageNamed:@"chipCheck_icon"] forState:UIControlStateNormal];
    [self.chipCheckButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.chipCheckButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.chipCheckButton addTarget:self action:@selector(chipCheckAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButtonView addSubview:self.chipCheckButton];
    [self.chipCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssueButton.mas_bottom);
        make.left.equalTo(self.leftButtonView);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.leftButtonView);
    }];
    
    self.chipDestructButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chipDestructButton setTitle:@"   筹码销毁" forState:UIControlStateNormal];
    [self.chipDestructButton setImage:[UIImage imageNamed:@"chip_descruct_icon"] forState:UIControlStateNormal];
    [self.chipDestructButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.chipDestructButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.chipDestructButton addTarget:self action:@selector(chipDestructAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButtonView addSubview:self.chipDestructButton];
    [self.chipDestructButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipCheckButton.mas_bottom);
        make.left.equalTo(self.leftButtonView);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.leftButtonView);
    }];
    
    self.chipExchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chipExchangeButton setTitle:@"   筹码兑换" forState:UIControlStateNormal];
    [self.chipExchangeButton setImage:[UIImage imageNamed:@"chipExchange_icon"] forState:UIControlStateNormal];
    [self.chipExchangeButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.chipExchangeButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.chipExchangeButton addTarget:self action:@selector(chipExchangeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButtonView addSubview:self.chipExchangeButton];
    [self.chipExchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipDestructButton.mas_bottom);
        make.left.equalTo(self.leftButtonView);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.leftButtonView);
    }];
    
    self.tipSettlementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tipSettlementButton setTitle:@"   小费结算" forState:UIControlStateNormal];
    [self.tipSettlementButton setImage:[UIImage imageNamed:@"chipExchange_icon"] forState:UIControlStateNormal];
    [self.tipSettlementButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.tipSettlementButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.tipSettlementButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.tipSettlementButton addTarget:self action:@selector(tipSettlementAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButtonView addSubview:self.tipSettlementButton];
    [self.tipSettlementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipExchangeButton.mas_bottom);
        make.left.equalTo(self.leftButtonView);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.leftButtonView);
    }];
    
    self.storageChipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.storageChipButton setTitle:@"   存入筹码" forState:UIControlStateNormal];
    [self.storageChipButton setImage:[UIImage imageNamed:@"chipExchange_icon"] forState:UIControlStateNormal];
    [self.storageChipButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.storageChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.storageChipButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.storageChipButton addTarget:self action:@selector(storegeChipAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButtonView addSubview:self.storageChipButton];
    [self.storageChipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipSettlementButton.mas_bottom);
        make.left.equalTo(self.leftButtonView);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.leftButtonView);
    }];
    
    self.takeOutChipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.takeOutChipButton setTitle:@"   取出筹码" forState:UIControlStateNormal];
    [self.takeOutChipButton setImage:[UIImage imageNamed:@"chipExchange_icon"] forState:UIControlStateNormal];
    [self.takeOutChipButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.takeOutChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.takeOutChipButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.takeOutChipButton addTarget:self action:@selector(takeOutChipAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButtonView addSubview:self.takeOutChipButton];
    [self.takeOutChipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storageChipButton.mas_bottom);
        make.left.equalTo(self.leftButtonView);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.leftButtonView);
    }];
    
    self.adjustPowerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.adjustPowerButton setTitle:@"   设置功率" forState:UIControlStateNormal];
    [self.adjustPowerButton setImage:[UIImage imageNamed:@"chipExchange_icon"] forState:UIControlStateNormal];
    [self.adjustPowerButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.adjustPowerButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.adjustPowerButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.adjustPowerButton addTarget:self action:@selector(adjustPowerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButtonView addSubview:self.adjustPowerButton];
    [self.adjustPowerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storageChipButton.mas_bottom);
        make.left.equalTo(self.leftButtonView);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.leftButtonView);
    }];
    
    //筹码管理界面
    [self chipManagerView];
    //筹码检测界面
    [self chipCheckShowView];
    //筹码销毁界面
    [self chipDestructShowView];
    //筹码兑换界面
    [self chipExchangeShowView];
    //小费结算界面
    [self tipSettlementShowView];
    //存储筹码界面
    [self storageChipShowView];
    //取出筹码界面
    [self takeOutChipShowView];
    //调节功率
    [self adjustPowerShowView];
    
    @weakify(self);
    [self.viewModel getChipTypeWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            //筹码发行界面
            [self chipIssueShowView];
        });
    }];
    
    //筹码兑换界面
    [[self.cashCodeTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if ([[x NullToBlankString] length]!=0) {
            if ((![NRCRCString isWashCodeValidWithWashNumber:self.cashCodeTextField.text])||[self.cashCodeTextField.text length]>8) {
                
            }else{
                self.curChipInfo.guestWashesNumber = x;
                self.viewModel.chipModel = self.curChipInfo;
                [self.viewModel getInfoByXmhWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                    @strongify(self);
                    if (success) {
                        if ([self.viewModel.customerInfoDict count]!=0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.curChipInfo.guestWashesNumber = self.viewModel.customerInfoDict[@"member_xmh"];
                                if (self.chipOperationType==3) {
                                    self.superiorNameLab.text = [NSString stringWithFormat:@"代理姓名: %@",self.viewModel.customerInfoDict[@"agent_name"]];
                                    self.superiorWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",self.viewModel.customerInfoDict[@"agent_xmh"]];
                                    self.superiorMoneyLab.text = [NSString stringWithFormat:@"风 险 金: %@",self.viewModel.customerInfoDict[@"risk_money"]];
                                    self.superiorTellLab.text = [NSString stringWithFormat:@"联系电话: %@",self.viewModel.customerInfoDict[@"agent_phone"]];
                                    self.codeLinesLab.text = [NSString stringWithFormat:@"出码额度: %@",self.viewModel.customerInfoDict[@"agent_cm"]];
                                    
                                    self.curCustomerNameLab.text = [NSString stringWithFormat:@"客人姓名: %@",self.viewModel.customerInfoDict[@"member_name"]];
                                    self.curCustomerWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",self.viewModel.customerInfoDict[@"member_xmh"]];
                                    self.curCustomerTellLab.text = [NSString stringWithFormat:@"联系电话: %@",self.viewModel.customerInfoDict[@"member_phone"]];
                                    self.curCodeLinesLab.text = [NSString stringWithFormat:@"出码额度: %@",self.viewModel.customerInfoDict[@"member_cm"]];
                                }
                            });
                        }else{
                            self.curChipInfo.guestWashesNumber = @"";
                            self.viewModel.chipModel = self.curChipInfo;
                            [self clearCustomerInfo];
                        }
                    }
                }];
            }
        }
    }];
    
    [[self.authorizationTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if ([[x NullToBlankString] length]!=0) {
            self.curChipInfo.authorName = x;
        }
    }];
    
    [[self.noteTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if ([[x NullToBlankString] length]!=0) {
            self.curChipInfo.notes = x;
        }
    }];
    
    //筹码取出
    [[self.takeOutWashNumberTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if ([[x NullToBlankString] length]!=0) {
            if ((![NRCRCString isWashCodeValidWithWashNumber:self.takeOutWashNumberTextField.text])||[self.takeOutWashNumberTextField.text length]>8) {
                
            }else{
                self.curChipInfo.guestWashesNumber = x;
                self.viewModel.chipModel = self.curChipInfo;
                [self.viewModel getInfoByXmhWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                    @strongify(self);
                    if (success) {
                        if ([self.viewModel.customerInfoDict count]!=0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.curChipInfo.guestWashesNumber = self.viewModel.customerInfoDict[@"member_xmh"];
                                if (self.chipOperationType==6){
                                    self.takeOutsuperiorNameLab.text = [NSString stringWithFormat:@"代理姓名: %@",self.viewModel.customerInfoDict[@"agent_name"]];
                                    self.takeOutsuperiorWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",self.viewModel.customerInfoDict[@"agent_xmh"]];
                                    self.takeOutsuperiorMoneyLab.text = [NSString stringWithFormat:@"风 险 金: %@",self.viewModel.customerInfoDict[@"risk_money"]];
                                    self.takeOutsuperiorTellLab.text = [NSString stringWithFormat:@"联系电话: %@",self.viewModel.customerInfoDict[@"agent_phone"]];
                                    
                                    self.takeOutcurCustomerNameLab.text = [NSString stringWithFormat:@"客人姓名: %@",self.viewModel.customerInfoDict[@"member_name"]];
                                    self.takeOutcurCustomerWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",self.viewModel.customerInfoDict[@"member_xmh"]];
                                    self.takeOutcurCustomerTellLab.text = [NSString stringWithFormat:@"联系电话: %@",self.viewModel.customerInfoDict[@"member_phone"]];
                                    NSArray *takeOutList = self.viewModel.customerInfoDict[@"deposit"];
                                    if (takeOutList.count!=0) {
                                        __block NSString * rmbMoney = @"0";
                                        __block NSString * usdMoney = @"0";
                                        [takeOutList enumerateObjectsUsingBlock:^(NSDictionary *moneyDict, NSUInteger idx, BOOL * _Nonnull stop) {
                                            if ([moneyDict[@"fcmtype"]intValue]==1) {
                                                rmbMoney = moneyDict[@"fmoney"];
                                            }
                                            if ([moneyDict[@"fcmtype"]intValue]==2) {
                                                usdMoney = moneyDict[@"fmoney"];
                                            }
                                        }];
                                        self.takeOutChipMoneyValueLab.text = [NSString stringWithFormat:@"rmb:%@,usd:%@",rmbMoney,usdMoney];
                                    }else{
                                        self.takeOutChipMoneyValueLab.text = [NSString stringWithFormat:@"%d",0];
                                    }
                                }
                            });
                        }else{
                            self.curChipInfo.guestWashesNumber = @"";
                            self.viewModel.chipModel = self.curChipInfo;
                            [self clearCustomerInfo];
                        }
                    }
                }];
            }
        }
    }];
    
    [[self.takeOutPassWordTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if ([[x NullToBlankString] length]!=0) {
            self.viewModel.chipInfo.takeOutPassword = x;
        }
    }];
}

#pragma mark -- 清除代理信息
- (void)clearCustomerInfo{
    if (self.chipOperationType==3){
        self.superiorNameLab.text = @"代理姓名: --";
        self.superiorWashNumberLab.text = @"洗 码 号: --";
        self.superiorMoneyLab.text = @"风 险 金: --";
        self.superiorTellLab.text = [NSString stringWithFormat:@"联系电话: %@",@"--"];
        
        self.curCustomerNameLab.text = [NSString stringWithFormat:@"客人姓名: %@",@"--"];
        self.curCustomerWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",@"--"];
        self.curCustomerTellLab.text = [NSString stringWithFormat:@"联系电话: %@",@"--"];
    }else if (self.chipOperationType==6){
        self.takeOutsuperiorNameLab.text = [NSString stringWithFormat:@"代理姓名: --"];
        self.takeOutsuperiorWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: --"];
        self.takeOutsuperiorMoneyLab.text = [NSString stringWithFormat:@"风 险 金: --"];
        self.takeOutsuperiorTellLab.text = [NSString stringWithFormat:@"联系电话: --"];
        
        self.takeOutcurCustomerNameLab.text = [NSString stringWithFormat:@"客人姓名: --"];
        self.takeOutcurCustomerWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: --"];
        self.takeOutcurCustomerTellLab.text = [NSString stringWithFormat:@"联系电话: --"];
        self.takeOutChipMoneyLab.text = [NSString stringWithFormat:@"%d",0];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.clientSocket disconnect];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self connectToServer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //YES：允许右滑返回  NO：禁止右滑返回
    return NO;
}

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    [self.titleBar setTitle:@"VM娱乐筹码管理"];
    [self setLeftItemForGoBack];
    self.titleBar.showBottomLine = YES;
    [self configureTitleBarToBlack];
    @weakify(self);
    self.titleBar.rightItem = [[EPTitleBarItem alloc]initWithImage:nil BackImage:[UIImage imageNamed:@"button_selected"] Text:@"识别筹码" tintColor:[UIColor whiteColor] block:^{
        @strongify(self);
        [self readCurDeviceChip];
    }];
}

- (void)connectToServer{
    // 准备创建客户端socket
    NSError *error = nil;
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    self.viewModel.chipInfo.bind_ip = @"192.168.1.192";
    // 开始连接服务器
    [self.clientSocket connectToHost:self.viewModel.chipInfo.bind_ip onPort:6000 viaInterface:nil withTimeout:-1 error:&error];
}

#pragma mark - 筹码管理界面
- (void)chipManagerView{
    self.chipIssueTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.chipIssueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.chipIssueTableView.hidden = YES;
    self.chipIssueTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.chipIssueTableView];
    [self.chipIssueTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.chipIssueTableView registerClass:[NRChipManagerTableViewCell class] forCellReuseIdentifier:@"managerCell"];
    self.chipIssueTableView.delegate = self;
    self.chipIssueTableView.dataSource = self;
}

#pragma mark - 筹码发行界面
- (void)chipIssueShowView{
    self.chipTypeItemList = [NSMutableArray arrayWithCapacity:0];
    self.chipIssueView = [UIView new];
    self.chipIssueView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.chipIssueView];
    [self.chipIssueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    int chip_row = 0;
    int listCount = (int)self.viewModel.chipInfoList.count;
    if ((listCount/3) != 0) {
        chip_row = listCount/3+1;
    }else{
        chip_row = listCount/3;
    }
    
    int typeView_h = 40 + chip_row*(40+20);
    self.chipIssue_typeView = [UIView new];
    self.chipIssue_typeView.backgroundColor = [UIColor clearColor];
    [self.chipIssueView addSubview:self.chipIssue_typeView];
    [self.chipIssue_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssueView).offset(80);
        make.left.equalTo(self.chipIssueView);
        make.right.equalTo(self.chipIssueView);
        make.height.mas_equalTo(typeView_h);
    }];
    
    self.cashTypeLab = [UILabel new];
    self.cashTypeLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.cashTypeLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.cashTypeLab.textAlignment = NSTextAlignmentRight;
    self.cashTypeLab.numberOfLines = 0;
    self.cashTypeLab.text = @"筹码类型:";
    [self.chipIssue_typeView addSubview:self.cashTypeLab];
    [self.cashTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssue_typeView).offset(0);
        make.left.equalTo(self.chipIssue_typeView).offset(40);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    CGFloat item_width = (kScreenWidth-200-80-40-40-40-20)/3;
    int chipTypeCount = 0;
    for (int i=0; i<listCount; i++) {
        NSInteger rowCount =3;
        NRChipAllInfo *chipallInfo = self.viewModel.chipInfoList[i];
        NRChipCodeItem *prechipCode = [[NRChipCodeItem alloc]initWithTitle:chipallInfo.fcmtype_name];
        [self.chipTypeItemList addObject:prechipCode];
        if (i==0) {
            self.chipFmeList = [NSMutableArray arrayWithCapacity:0];
            [self.chipFmeList addObjectsFromArray:chipallInfo.list];
            [prechipCode checkSelected];
            self.chipTypeSelectedItem = prechipCode;
            NRChipAllInfo *chipallInfo = self.viewModel.chipInfoList[i];
            int intType = [chipallInfo.fcmtype intValue];
            if (intType<10) {
                self.curChipInfo.chipType = [NSString stringWithFormat:@"0%d",intType];
            }else{
                self.curChipInfo.chipType = [NSString stringWithFormat:@"%d",intType];
            }
            
        }
        prechipCode.tag = i+100;
        [self.chipIssue_typeView addSubview:prechipCode];
        if (i <= (rowCount -1)) {
            [prechipCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.chipIssue_typeView).offset(0);
                if (i== 0) {
                    make.left.equalTo(self.cashTypeLab.mas_right).offset(40);
                }else if(i == 1){
                    make.left.equalTo(self.cashTypeLab.mas_right).offset(item_width+40+20);
                }else if(i ==2){
                    make.right.equalTo(self.chipIssue_typeView.mas_right).offset(-20);
                }
                make.width.mas_equalTo(item_width);
                make.height.mas_equalTo(40);
            }];
            if (i == rowCount - 1 )
            {
                chipTypeCount = i;
            }
        }else if(i>(rowCount-1))
        {
            NRChipCodeItem *topchipCode = (NRChipCodeItem *)[self.chipIssue_typeView viewWithTag:chipTypeCount+100];
            [prechipCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(topchipCode.mas_bottom).offset(20);
                if(i%rowCount == 0){
                    make.left.equalTo(self.cashTypeLab.mas_right).with.offset(40);
                }
                else if(i%rowCount == 1){
                    make.left.equalTo(self.cashTypeLab.mas_right).offset(item_width+40+20);
                }else if(i%rowCount == 2){
                    make.right.equalTo(self.chipIssue_typeView.mas_right).offset(-20);
                }
                make.width.mas_equalTo(item_width);
                make.height.mas_equalTo(40);
            }];
            if(i%rowCount == 2){
                chipTypeCount = i;
            }
        }
    }
    //展示    初始化界面
    [self displayChipFme];
    //筹码类型
    for (int i=0; i<self.chipTypeItemList.count; i++) {
        NRChipCodeItem *chipType = self.chipTypeItemList[i];
        @weakify(self);
        [chipType.selectSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if (chipType!=self.chipTypeSelectedItem) {
                [self.chipTypeSelectedItem checkSelectUn];
                [chipType checkSelected];
                self.chipTypeSelectedItem = chipType;
            }else{
                [self.chipTypeSelectedItem checkSelected];
            }
            NRChipAllInfo *chipallInfo = self.viewModel.chipInfoList[i];
            [self.chipFmeList removeAllObjects];
            [self.chipFmeList addObjectsFromArray:chipallInfo.list];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self displayChipFme];
            });
            int intType = [chipallInfo.fcmtype intValue];
            if (intType<10) {
                self.curChipInfo.chipType = [NSString stringWithFormat:@"0%d",intType];
            }else{
                self.curChipInfo.chipType = [NSString stringWithFormat:@"%d",intType];
            }
        }];
    }
}

#pragma mark - 展示筹码面额
- (void)displayChipFme{
    int chip_fme_row = 0;
    int list_fme_Count = (int)self.chipFmeList.count;
    if ((list_fme_Count%3) != 0) {//不可以整除
        chip_fme_row = list_fme_Count/3;
    }else{//可以整除
        chip_fme_row = list_fme_Count/3;
        if (chip_fme_row>0) {
            chip_fme_row-=1;
        }
    }
    int typeView_fme_h = 40 + chip_fme_row*(40+20);
    [self.chipIssue_fmeView  removeFromSuperview];
    self.chipIssue_fmeView = nil;
    self.chipIssue_fmeView = [UIView new];
    self.chipIssue_fmeView.backgroundColor = [UIColor clearColor];
    [self.chipIssueView addSubview:self.chipIssue_fmeView];
    [self.chipIssue_fmeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssue_typeView.mas_bottom).offset(20);
        make.left.equalTo(self.chipIssueView);
        make.right.equalTo(self.chipIssueView);
        make.height.mas_equalTo(typeView_fme_h);
    }];
    
    [self.chipIssue_fmeView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (!self.cashValueLab) {
        self.cashValueLab = [UILabel new];
    }
    self.cashValueLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.cashValueLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.cashValueLab.textAlignment = NSTextAlignmentRight;
    self.cashValueLab.numberOfLines = 0;
    self.cashValueLab.text = @"筹码面额:";
    [self.chipIssue_fmeView addSubview:self.cashValueLab];
    [self.cashValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssue_typeView.mas_bottom).offset(20);
        make.left.equalTo(self.chipIssue_typeView).offset(40);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    self.chipFmeItemList = [NSMutableArray arrayWithCapacity:0];
    CGFloat item_width = (kScreenWidth-200-80-40-40-40-20)/3;
    int chipType_fme_Count = 0;
    for (int i=0; i<self.chipFmeList.count; i++) {
        NSInteger rowCount =3;
        NRChipInfo *chipallInfo = self.chipFmeList[i];
        NRChipCodeItem *prechipCode = [[NRChipCodeItem alloc]initWithTitle:chipallInfo.fme];
        [self.chipFmeItemList addObject:prechipCode];
        if (i==0) {
            [prechipCode checkSelected];
            self.chipFmeSelectedItem = prechipCode;
            NRChipInfo *chipallInfo = self.chipFmeList[i];
            self.curChipInfo.chipDenomination = chipallInfo.fme;
        }
        prechipCode.tag = i+1000;
        [self.chipIssue_fmeView addSubview:prechipCode];
        if (i <= (rowCount -1)) {
            [prechipCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.chipIssue_fmeView).offset(0);
                if (i== 0) {
                    make.left.equalTo(self.cashValueLab.mas_right).offset(40);
                }else if(i == 1){
                    make.left.equalTo(self.cashValueLab.mas_right).offset(item_width+40+20);
                }else if(i ==2){
                    make.right.equalTo(self.chipIssue_fmeView.mas_right).offset(-20);
                }
                make.width.mas_equalTo(item_width);
                make.height.mas_equalTo(40);
            }];
            if (i == rowCount - 1 )
            {
                chipType_fme_Count = i;
            }
        }else if(i>(rowCount-1))
        {
            NRChipCodeItem *topchipCode = (NRChipCodeItem *)[self.chipIssue_fmeView viewWithTag:chipType_fme_Count+1000];
            [prechipCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(topchipCode.mas_bottom).offset(20);
                if(i%rowCount == 0){
                    make.left.equalTo(self.cashValueLab.mas_right).with.offset(40);
                }
                else if(i%rowCount == 1){
                    make.left.equalTo(self.cashValueLab.mas_right).offset(item_width+40+20);
                }else if(i%rowCount == 2){
                    make.right.equalTo(self.chipIssue_fmeView.mas_right).offset(-20);
                }
                make.width.mas_equalTo(item_width);
                make.height.mas_equalTo(40);
            }];
            if(i%rowCount == 2){
                chipType_fme_Count = i;
            }
        }
    }
    if (!self.serialNumberLab) {
        self.serialNumberLab = [UILabel new];
    }
    self.serialNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.serialNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.serialNumberLab.textAlignment = NSTextAlignmentRight;
    self.serialNumberLab.numberOfLines = 0;
    self.serialNumberLab.text = @"序号:";
    [self.chipIssueView addSubview:self.serialNumberLab];
    [self.serialNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssue_fmeView.mas_bottom).offset(60);
        make.left.equalTo(self.chipIssueView).offset(40);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    if (!self.serialNumberTextFiled) {
        self.serialNumberTextFiled = [UITextField new];
    }
    self.serialNumberTextFiled.layer.cornerRadius = 5;
    self.serialNumberTextFiled.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.serialNumberTextFiled.layer.borderWidth = 1;
    self.serialNumberTextFiled.text = @"01";
    self.serialNumberTextFiled.enabled = NO;
    self.serialNumberTextFiled.textColor = [UIColor colorWithHexString:@"#ffffff"];
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.serialNumberTextFiled.leftView = leftview;
    self.serialNumberTextFiled.leftViewMode = UITextFieldViewModeAlways;
    [self.chipIssueView addSubview:self.serialNumberTextFiled];
    [self.serialNumberTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssue_fmeView.mas_bottom).offset(55);
        make.left.equalTo(self.serialNumberLab.mas_right).offset(40);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    if (!self.batchLab) {
        self.batchLab = [UILabel new];
    }
    self.batchLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.batchLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.batchLab.textAlignment = NSTextAlignmentRight;
    self.batchLab.numberOfLines = 0;
    self.batchLab.text = @"批次:";
    [self.chipIssueView addSubview:self.batchLab];
    [self.batchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serialNumberLab.mas_bottom).offset(50);
        make.left.equalTo(self.chipIssueView).offset(40);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    if (!self.batchTextFiled) {
        self.batchTextFiled = [UITextField new];
    }
    self.batchTextFiled.layer.cornerRadius = 5;
    self.batchTextFiled.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.batchTextFiled.layer.borderWidth = 1;
    NSString *batchString = [NRCommand getCurrentTimes];
    self.batchTextFiled.text = batchString;
    self.batchTextFiled.textColor = [UIColor colorWithHexString:@"#ffffff"];
    UIView *batchleftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.batchTextFiled.leftView = batchleftview;
    self.batchTextFiled.leftViewMode = UITextFieldViewModeAlways;
    [self.chipIssueView addSubview:self.batchTextFiled];
    [self.batchTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serialNumberTextFiled.mas_bottom).offset(40);
        make.left.equalTo(self.batchLab.mas_right).offset(40);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    if (!self.chipissueButton) {
        self.chipissueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [self.chipissueButton setTitle:@"立即发行" forState:UIControlStateNormal];
    self.chipissueButton.layer.cornerRadius = 5;
    self.chipissueButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.chipissueButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.chipissueButton setTitleColor:[UIColor colorWithHexString:@"#52a938"] forState:UIControlStateSelected];
    self.chipissueButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.chipissueButton addTarget:self action:@selector(chipIssueImmediatelyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.chipIssueView addSubview:self.chipissueButton];
    [self.chipissueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.batchTextFiled.mas_bottom).offset(50);
        make.left.equalTo(self.chipIssueView).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.chipIssueView);
    }];
    
    //筹码面值
    for (int i=0; i<self.chipFmeItemList.count; i++) {
        NRChipCodeItem *chipFme = self.chipFmeItemList[i];
        @weakify(self);
        [chipFme.selectSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if (chipFme!=self.chipFmeSelectedItem) {
                [self.chipFmeSelectedItem checkSelectUn];
                [chipFme checkSelected];
                self.chipFmeSelectedItem = chipFme;
            }else{
                [self.chipFmeSelectedItem checkSelected];
            }
            NRChipInfo *chipallInfo = self.chipFmeList[i];
            self.curChipInfo.chipDenomination = chipallInfo.fme;
        }];
    }
    
    @weakify(self);
    [[self.batchTextFiled rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if ([[x NullToBlankString] length]==8) {
            self.curChipInfo.chipBatch = self.batchTextFiled.text;
            self.viewModel.chipModel = self.curChipInfo;
            [self.viewModel getOrderByBatchWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                @strongify(self);
                if (success) {
                    if ([[self.viewModel.lastNumber NullToBlankString]length]!=0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.serialNumberTextFiled.text = self.viewModel.lastNumber;
                        });
                    }
                }
            }];
        }
    }];
}

#pragma mark - 筹码检测界面
- (void)chipCheckShowView{
    self.chipCheckTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.chipCheckTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.chipCheckTableView.hidden = YES;
    self.chipCheckTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.chipCheckTableView];
    [self.chipCheckTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.chipCheckTableView registerClass:[NRCashExchangeTableViewCell class] forCellReuseIdentifier:@"checkCell"];
    self.chipCheckTableView.delegate = self;
    self.chipCheckTableView.dataSource = self;
    
    self.chipCheckView = [UIView new];
    self.chipCheckView.backgroundColor = [UIColor clearColor];
    self.chipCheckView.hidden = YES;
    [self.view addSubview:self.chipCheckView];
    [self.chipCheckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UIImageView *checkImage = [UIImageView new];
    checkImage.contentMode = UIViewContentModeScaleToFill;
    checkImage.image = [UIImage imageNamed:@"douhao_icon"];
    [self.chipCheckView addSubview:checkImage];
    [checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipCheckView).offset(120);
        make.width.height.mas_equalTo(150);
        make.centerX.equalTo(self.chipCheckView);
    }];
    
    UILabel *checkTipsLab = [UILabel new];
    checkTipsLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    checkTipsLab.textColor = [UIColor colorWithHexString:@"#747474"];
    checkTipsLab.textAlignment = NSTextAlignmentCenter;
    checkTipsLab.numberOfLines = 0;
    checkTipsLab.text = @"请将需要检测的筹码平整放置在感应托盘中!";
    [self.chipCheckView addSubview:checkTipsLab];
    [checkTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkImage.mas_bottom).offset(60);
        make.left.equalTo(self.chipCheckView).offset(20);
        make.centerX.equalTo(self.chipCheckView);
    }];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setTitle:@"开始检测" forState:UIControlStateNormal];
    checkButton.layer.cornerRadius = 5;
    checkButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [checkButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [checkButton setTitleColor:[UIColor colorWithHexString:@"#52a938"] forState:UIControlStateSelected];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [checkButton addTarget:self action:@selector(readCurDeviceChip) forControlEvents:UIControlEventTouchUpInside];
    [self.chipCheckView addSubview:checkButton];
    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkTipsLab.mas_bottom).offset(40);
        make.left.equalTo(self.leftButtonView.mas_right).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.chipCheckView);
    }];
}

#pragma mark - 筹码销毁界面
- (void)chipDestructShowView{
    
    self.chipDestructTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.chipDestructTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.chipDestructTableView.hidden = YES;
    self.chipDestructTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.chipDestructTableView];
    [self.chipDestructTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.chipDestructTableView registerClass:[NRChipDestrutTableViewCell class] forCellReuseIdentifier:@"destrutCell"];
    self.chipDestructTableView.delegate = self;
    self.chipDestructTableView.dataSource = self;
    
    self.chipDestructView = [UIView new];
    self.chipDestructView.backgroundColor = [UIColor clearColor];
    self.chipDestructView.hidden = YES;
    [self.view addSubview:self.chipDestructView];
    [self.chipDestructView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.destructImage = [UIImageView new];
    self.destructImage.contentMode = UIViewContentModeScaleToFill;
    self.destructImage.image = [UIImage imageNamed:@"douhao_icon"];
    [self.chipDestructView addSubview:self.destructImage];
    [self.destructImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipDestructView).offset(120);
        make.width.height.mas_equalTo(150);
        make.centerX.equalTo(self.chipDestructView);
    }];
    
    self.destructTipsLab = [UILabel new];
    self.destructTipsLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.destructTipsLab.textColor = [UIColor colorWithHexString:@"#747474"];
    self.destructTipsLab.textAlignment = NSTextAlignmentCenter;
    self.destructTipsLab.numberOfLines = 0;
    self.destructTipsLab.text = @"请将需要销毁的筹码平整放置在感应托盘中!";
    [self.chipDestructView addSubview:self.destructTipsLab];
    [self.destructTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.destructImage.mas_bottom).offset(60);
        make.left.equalTo(self.chipDestructView).offset(20);
        make.centerX.equalTo(self.chipDestructView);
    }];
    
    self.readChipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.readChipButton setTitle:@"开始读取" forState:UIControlStateNormal];
    self.readChipButton.layer.cornerRadius = 5;
    self.readChipButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.readChipButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.readChipButton setTitleColor:[UIColor colorWithHexString:@"#52a938"] forState:UIControlStateSelected];
    self.readChipButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.readChipButton addTarget:self action:@selector(readCurDeviceChip) forControlEvents:UIControlEventTouchUpInside];
    [self.chipDestructView addSubview:self.readChipButton];
    [self.readChipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.destructTipsLab.mas_bottom).offset(40);
        make.left.equalTo(self.leftButtonView.mas_right).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.chipCheckView);
    }];
}

#pragma mark - 筹码兑换界面
- (void)chipExchangeShowView{
    self.chipExchangeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.chipExchangeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.chipExchangeTableView.hidden = YES;
    self.chipExchangeTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.chipExchangeTableView];
    [self.chipExchangeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(5);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.chipExchangeTableView registerClass:[NRCashExchangeTableViewCell class] forCellReuseIdentifier:@"cashExchangeCell"];
    self.chipExchangeTableView.delegate = self;
    self.chipExchangeTableView.dataSource = self;
    self.chipExchangeTableView.tableFooterView = self.chipExchangeFootView;
    self.chipExchangeTableView.tableHeaderView = self.chipExchangeTableHeadView;

    self.chipExchangeView = [UIView new];
    self.chipExchangeView.backgroundColor = [UIColor clearColor];
    self.chipExchangeView.hidden = YES;
    [self.view addSubview:self.chipExchangeView];
    [self.chipExchangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.exchangeImage = [UIImageView new];
    self.exchangeImage.contentMode = UIViewContentModeScaleToFill;
    self.exchangeImage.image = [UIImage imageNamed:@"douhao_icon"];
    self.exchangeImage.hidden = YES;
    [self.chipExchangeView addSubview:self.exchangeImage];
    [self.exchangeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipExchangeView).offset(120);
        make.width.height.mas_equalTo(150);
        make.centerX.equalTo(self.chipExchangeView);
    }];
    
    self.exchangeTipsLab = [UILabel new];
    self.exchangeTipsLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.exchangeTipsLab.textColor = [UIColor colorWithHexString:@"#747474"];
    self.exchangeTipsLab.textAlignment = NSTextAlignmentCenter;
    self.exchangeTipsLab.numberOfLines = 0;
    self.exchangeTipsLab.hidden = YES;
    self.exchangeTipsLab.text = @"请将筹码放置在托盘进行读取";
    [self.chipExchangeView addSubview:self.exchangeTipsLab];
    [self.exchangeTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exchangeImage.mas_bottom).offset(60);
        make.left.equalTo(self.chipExchangeView).offset(20);
        make.centerX.equalTo(self.chipExchangeView);
    }];
    
    self.cashExchangeChipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cashExchangeChipButton setTitle:@"现金兑换筹码" forState:UIControlStateNormal];
    self.cashExchangeChipButton.layer.cornerRadius = 5;
    self.cashExchangeChipButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.cashExchangeChipButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.cashExchangeChipButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.cashExchangeChipButton addTarget:self action:@selector(cashExchangeChipAction) forControlEvents:UIControlEventTouchUpInside];
    [self.chipExchangeView addSubview:self.cashExchangeChipButton];
    [self.cashExchangeChipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipExchangeView).offset(140);
        make.left.equalTo(self.leftButtonView.mas_right).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.chipExchangeView);
    }];
    
    self.chipExchangeCashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chipExchangeCashButton setTitle:@"筹码兑换现金" forState:UIControlStateNormal];
    self.chipExchangeCashButton.layer.cornerRadius = 5;
    self.chipExchangeCashButton.backgroundColor = [UIColor colorWithHexString:@"#3e54af"];
    [self.chipExchangeCashButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.chipExchangeCashButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.chipExchangeCashButton addTarget:self action:@selector(chipExchangeCashAction) forControlEvents:UIControlEventTouchUpInside];
    [self.chipExchangeView addSubview:self.chipExchangeCashButton];
    [self.chipExchangeCashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cashExchangeChipButton.mas_bottom).offset(60);
        make.left.equalTo(self.leftButtonView.mas_right).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.chipExchangeView);
    }];
    
    self.creditCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.creditCodeButton setTitle:@"信用出码" forState:UIControlStateNormal];
    self.creditCodeButton.layer.cornerRadius = 5;
    self.creditCodeButton.backgroundColor = [UIColor colorWithHexString:@"#ef8b4a"];
    [self.creditCodeButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.creditCodeButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.creditCodeButton addTarget:self action:@selector(creditCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.chipExchangeView addSubview:self.creditCodeButton];
    [self.creditCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipExchangeCashButton.mas_bottom).offset(60);
        make.left.equalTo(self.leftButtonView.mas_right).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.chipExchangeView);
    }];
    
}

#pragma mark - 筹码兑换头部信息
- (UIView *)chipExchangeTableHeadView{
    if (!_chipExchangeTableHeadView) {
        _chipExchangeTableHeadView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-210, 110)];
        _chipExchangeTableHeadView.backgroundColor = [UIColor colorWithHexString:@"#666666"];
        _chipExchangeTableHeadView.layer.cornerRadius = 5;
        
        self.exchangNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 20)];
        self.exchangNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.exchangNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.exchangNumberLab.numberOfLines = 0;
        self.exchangNumberLab.text = @"筹码数量:0枚";
        [_chipExchangeTableHeadView addSubview:self.exchangNumberLab];
        
        self.exchangTotalMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.exchangNumberLab.frame), 20, 200, 20)];
        self.exchangTotalMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.exchangTotalMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.exchangTotalMoneyLab.numberOfLines = 0;
        self.exchangTotalMoneyLab.text = @"筹码总额:0";
        [_chipExchangeTableHeadView addSubview:self.exchangTotalMoneyLab];
        
        self.exchangMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.exchangNumberLab.frame)+15, 300, 40)];
        self.exchangMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:30];
        self.exchangMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.exchangMoneyLab.numberOfLines = 0;
        [_chipExchangeTableHeadView addSubview:self.exchangMoneyLab];
    }
    return _chipExchangeTableHeadView;
}
#pragma mark - 筹码兑换信息
- (UIView *)chipExchangeFootView{
    if (!_chipExchangeFootView) {
        _chipExchangeFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-200, 600)];
        _chipExchangeFootView.backgroundColor = [UIColor clearColor];
        
        CGFloat label_width = 200;
        self.superiorInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, label_width, 20)];
        self.superiorInfoLab.font = [UIFont fontWithName:@"PingFang SC" size:22];
        self.superiorInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.superiorInfoLab.numberOfLines = 0;
        self.superiorInfoLab.text = @"上级信息";
        [_chipExchangeFootView addSubview:self.superiorInfoLab];
        
        self.superiorNameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.superiorInfoLab.frame)+5, label_width, 20)];
        self.superiorNameLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.superiorNameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.superiorNameLab.numberOfLines = 0;
        self.superiorNameLab.text = @"代理姓名: --";
        [_chipExchangeFootView addSubview:self.superiorNameLab];
        
        self.superiorWashNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.superiorNameLab.frame)+5, label_width, 20)];
        self.superiorWashNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.superiorWashNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.superiorWashNumberLab.numberOfLines = 0;
        self.superiorWashNumberLab.text = @"洗 码 号: --";
        [_chipExchangeFootView addSubview:self.superiorWashNumberLab];
        
        self.superiorMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.superiorWashNumberLab.frame)+5, label_width, 20)];
        self.superiorMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.superiorMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.superiorMoneyLab.numberOfLines = 0;
        self.superiorMoneyLab.text = @"风 险 金: --";
        [_chipExchangeFootView addSubview:self.superiorMoneyLab];
        
        self.superiorTellLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.superiorMoneyLab.frame)+5, label_width, 20)];
        self.superiorTellLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.superiorTellLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.superiorTellLab.numberOfLines = 0;
        self.superiorTellLab.text = @"联系电话: --";
        [_chipExchangeFootView addSubview:self.superiorTellLab];
        
        self.codeLinesLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.superiorTellLab.frame)+5, label_width, 20)];
        self.codeLinesLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.codeLinesLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.codeLinesLab.numberOfLines = 0;
        self.codeLinesLab.text = @"出码额度: --";
        [_chipExchangeFootView addSubview:self.codeLinesLab];
        
        self.curCustomerInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.codeLinesLab.frame)+10, label_width, 20)];
        self.curCustomerInfoLab.font = [UIFont fontWithName:@"PingFang SC" size:22];
        self.curCustomerInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.curCustomerInfoLab.numberOfLines = 0;
        self.curCustomerInfoLab.text = @"当前客人";
        [_chipExchangeFootView addSubview:self.curCustomerInfoLab];
        
        self.curCustomerWashNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.curCustomerInfoLab.frame)+5, label_width, 20)];
        self.curCustomerWashNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.curCustomerWashNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.curCustomerWashNumberLab.numberOfLines = 0;
        self.curCustomerWashNumberLab.text = @"洗 码 号: --";
        [_chipExchangeFootView addSubview:self.curCustomerWashNumberLab];
        
        self.curCustomerNameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.curCustomerWashNumberLab.frame)+5, label_width, 20)];
        self.curCustomerNameLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.curCustomerNameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.curCustomerNameLab.numberOfLines = 0;
        self.curCustomerNameLab.text = @"客人姓名: --";
        [_chipExchangeFootView addSubview:self.curCustomerNameLab];
        
        self.curCustomerTellLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.curCustomerNameLab.frame)+5, label_width, 20)];
        self.curCustomerTellLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.curCustomerTellLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.curCustomerTellLab.numberOfLines = 0;
        self.curCustomerTellLab.text = @"联系电话: --";
        [_chipExchangeFootView addSubview:self.curCustomerTellLab];
        
        self.curCodeLinesLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.curCustomerTellLab.frame)+5, label_width, 20)];
        self.curCodeLinesLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.curCodeLinesLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.curCodeLinesLab.numberOfLines = 0;
        self.curCodeLinesLab.text = @"出码额度: --";
        [_chipExchangeFootView addSubview:self.curCodeLinesLab];
        
        self.cashCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(330, 10, 200, 35)];
        self.cashCodeTextField.placeholder = @"请输入客人洗码号";
        self.cashCodeTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.cashCodeTextField.layer.cornerRadius = 5;
        self.cashCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.cashCodeTextField.leftView = leftview;
        self.cashCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        [_chipExchangeFootView addSubview:self.cashCodeTextField];
        
        self.authorizationTextField = [[UITextField alloc]initWithFrame:CGRectMake(330, CGRectGetMaxY(self.cashCodeTextField.frame)+10, 200, 35)];
        self.authorizationTextField.placeholder = @"请输入授权人姓名";
        self.authorizationTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.authorizationTextField.layer.cornerRadius = 5;
        UIView *artoleftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.authorizationTextField.leftView = artoleftview;
        self.authorizationTextField.leftViewMode = UITextFieldViewModeAlways;
        [_chipExchangeFootView addSubview:self.authorizationTextField];
        
        self.noteTextField = [[UITextField alloc]initWithFrame:CGRectMake(330, CGRectGetMaxY(self.authorizationTextField.frame)+10, 200, 60)];
        self.noteTextField.placeholder = @"请输入备注";
        self.noteTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.noteTextField.layer.cornerRadius = 5;
        UIView *noteleftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.noteTextField.leftView = noteleftview;
        self.noteTextField.leftViewMode = UITextFieldViewModeAlways;
        [_chipExchangeFootView addSubview:self.noteTextField];
        
        self.cashExchangeConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cashExchangeConfirmButton setTitle:@"确认现金换筹码" forState:UIControlStateNormal];
        self.cashExchangeConfirmButton.frame = CGRectMake(150, CGRectGetMaxY(self.curCustomerTellLab.frame)+20, kScreenWidth-200-300, 40);
        self.cashExchangeConfirmButton.layer.cornerRadius = 5;
        self.cashExchangeConfirmButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
        [self.cashExchangeConfirmButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.cashExchangeConfirmButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.cashExchangeConfirmButton addTarget:self action:@selector(cashExchangeConfirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self.chipExchangeFootView addSubview:self.cashExchangeConfirmButton];
    }
    return _chipExchangeFootView;
}

#pragma mark - 结算小费界面
- (void)tipSettlementShowView{
    
    self.tipSettlementTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tipSettlementTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tipSettlementTableView.hidden = YES;
    self.tipSettlementTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tipSettlementTableView];
    [self.tipSettlementTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.tipSettlementTableView registerClass:[NRCashExchangeTableViewCell class] forCellReuseIdentifier:@"tipSettlementCell"];
    self.tipSettlementTableView.delegate = self;
    self.tipSettlementTableView.dataSource = self;
    self.tipSettlementTableView.tableFooterView = self.tipSettlementFootView;
    self.tipSettlementTableView.tableHeaderView = self.tipSettlementTableHeadView;
    
    self.tipSettlementView = [UIView new];
    self.tipSettlementView.backgroundColor = [UIColor clearColor];
    self.tipSettlementView.hidden = YES;
    [self.view addSubview:self.tipSettlementView];
    [self.tipSettlementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.tipSettlementImage = [UIImageView new];
    self.tipSettlementImage.contentMode = UIViewContentModeScaleToFill;
    self.tipSettlementImage.image = [UIImage imageNamed:@"douhao_icon"];
    [self.tipSettlementView addSubview:self.tipSettlementImage];
    [self.tipSettlementImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipSettlementView).offset(120);
        make.width.height.mas_equalTo(150);
        make.centerX.equalTo(self.tipSettlementView);
    }];
    
    self.tipSettlementTipsLab = [UILabel new];
    self.tipSettlementTipsLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.tipSettlementTipsLab.textColor = [UIColor colorWithHexString:@"#747474"];
    self.tipSettlementTipsLab.textAlignment = NSTextAlignmentCenter;
    self.tipSettlementTipsLab.numberOfLines = 0;
    self.tipSettlementTipsLab.text = @"请将需要结算的筹码平整放置在感应托盘中!";
    [self.tipSettlementView addSubview:self.tipSettlementTipsLab];
    [self.tipSettlementTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipSettlementImage.mas_bottom).offset(60);
        make.left.equalTo(self.tipSettlementView).offset(20);
        make.centerX.equalTo(self.tipSettlementView);
    }];
    
    self.tipSettlementReadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tipSettlementReadButton setTitle:@"开始结算" forState:UIControlStateNormal];
    self.tipSettlementReadButton.layer.cornerRadius = 5;
    self.tipSettlementReadButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.tipSettlementReadButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.tipSettlementReadButton setTitleColor:[UIColor colorWithHexString:@"#52a938"] forState:UIControlStateSelected];
    self.tipSettlementReadButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.tipSettlementReadButton addTarget:self action:@selector(readCurDeviceChip) forControlEvents:UIControlEventTouchUpInside];
    [self.tipSettlementView addSubview:self.tipSettlementReadButton];
    [self.tipSettlementReadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipSettlementTipsLab.mas_bottom).offset(40);
        make.left.equalTo(self.leftButtonView.mas_right).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.tipSettlementView);
    }];
}

#pragma mark - 小费结算头部信息
- (UIView *)tipSettlementTableHeadView{
    if (!_tipSettlementTableHeadView) {
        _tipSettlementTableHeadView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-210, 110)];
        _tipSettlementTableHeadView.backgroundColor = [UIColor colorWithHexString:@"#666666"];
        _tipSettlementTableHeadView.layer.cornerRadius = 5;
        
        self.tipSettlementNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 20)];
        self.tipSettlementNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.tipSettlementNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.tipSettlementNumberLab.numberOfLines = 0;
        self.tipSettlementNumberLab.text = @"筹码数量:0枚";
        [_tipSettlementTableHeadView addSubview:self.tipSettlementNumberLab];
        
        self.tipSettlementTotalMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tipSettlementNumberLab.frame)+15, 300, 40)];
        self.tipSettlementTotalMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:30];
        self.tipSettlementTotalMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.tipSettlementTotalMoneyLab.numberOfLines = 0;
        [_tipSettlementTableHeadView addSubview:self.tipSettlementTotalMoneyLab];
    }
    return _tipSettlementTableHeadView;
}

#pragma mark - 小费结算脚部信息
- (UIView *)tipSettlementFootView{
    if (!_tipSettlementFootView) {
        _tipSettlementFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-200, 100)];
        _tipSettlementFootView.backgroundColor = [UIColor clearColor];
        
        self.tipSoonSettlementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tipSoonSettlementButton setTitle:@"立即结算" forState:UIControlStateNormal];
        self.tipSoonSettlementButton.frame = CGRectMake(150, 50, kScreenWidth-200-300, 40);
        self.tipSoonSettlementButton.layer.cornerRadius = 5;
        self.tipSoonSettlementButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
        [self.tipSoonSettlementButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.tipSoonSettlementButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.tipSoonSettlementButton addTarget:self action:@selector(tipSettlementSoonConfirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self.tipSettlementFootView addSubview:self.tipSoonSettlementButton];
    }
    return _tipSettlementFootView;
}

#pragma mark - 存储筹码界面
- (void)storageChipShowView{
    
    self.storageChipTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.storageChipTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.storageChipTableView.hidden = YES;
    self.storageChipTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.storageChipTableView];
    [self.storageChipTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.storageChipTableView registerClass:[NRCashExchangeTableViewCell class] forCellReuseIdentifier:@"storageChipCell"];
    self.storageChipTableView.delegate = self;
    self.storageChipTableView.dataSource = self;
    self.storageChipTableView.tableFooterView = self.storageChipFootView;
    self.storageChipTableView.tableHeaderView = self.storageChipTableHeadView;
    
    self.storageChipView = [UIView new];
    self.storageChipView.backgroundColor = [UIColor clearColor];
    self.storageChipView.hidden = YES;
    [self.view addSubview:self.storageChipView];
    [self.storageChipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.storageChipImage = [UIImageView new];
    self.storageChipImage.contentMode = UIViewContentModeScaleToFill;
    self.storageChipImage.image = [UIImage imageNamed:@"douhao_icon"];
    [self.storageChipView addSubview:self.storageChipImage];
    [self.storageChipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storageChipView).offset(120);
        make.width.height.mas_equalTo(150);
        make.centerX.equalTo(self.tipSettlementView);
    }];
    
    self.storageChipTipsLab = [UILabel new];
    self.storageChipTipsLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.storageChipTipsLab.textColor = [UIColor colorWithHexString:@"#747474"];
    self.storageChipTipsLab.textAlignment = NSTextAlignmentCenter;
    self.storageChipTipsLab.numberOfLines = 0;
    self.storageChipTipsLab.text = @"请将需要存入的筹码平整放置在感应托盘中!";
    [self.storageChipView addSubview:self.storageChipTipsLab];
    [self.storageChipTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storageChipImage.mas_bottom).offset(60);
        make.left.equalTo(self.storageChipView).offset(20);
        make.centerX.equalTo(self.storageChipView);
    }];
    
    self.storageChipReadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.storageChipReadButton setTitle:@"开始存入" forState:UIControlStateNormal];
    self.storageChipReadButton.layer.cornerRadius = 5;
    self.storageChipReadButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.storageChipReadButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.storageChipReadButton setTitleColor:[UIColor colorWithHexString:@"#52a938"] forState:UIControlStateSelected];
    self.storageChipReadButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.storageChipReadButton addTarget:self action:@selector(readCurDeviceChip) forControlEvents:UIControlEventTouchUpInside];
    [self.storageChipView addSubview:self.storageChipReadButton];
    [self.storageChipReadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storageChipTipsLab.mas_bottom).offset(40);
        make.left.equalTo(self.leftButtonView.mas_right).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.storageChipView);
    }];
}

#pragma mark - 存储筹码头部信息
- (UIView *)storageChipTableHeadView{
    if (!_storageChipTableHeadView) {
        _storageChipTableHeadView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-210, 110)];
        _storageChipTableHeadView.backgroundColor = [UIColor colorWithHexString:@"#666666"];
        _storageChipTableHeadView.layer.cornerRadius = 5;
        
        self.storageChipNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 20)];
        self.storageChipNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.storageChipNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.storageChipNumberLab.numberOfLines = 0;
        self.storageChipNumberLab.text = @"筹码数量:0枚";
        [_storageChipTableHeadView addSubview:self.storageChipNumberLab];
        
        self.storageChipTotalMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tipSettlementNumberLab.frame)+15, 300, 40)];
        self.storageChipTotalMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:30];
        self.storageChipTotalMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.storageChipTotalMoneyLab.numberOfLines = 0;
        [_storageChipTableHeadView addSubview:self.storageChipTotalMoneyLab];
    }
    return _storageChipTableHeadView;
}

#pragma mark - 存贮筹码脚部信息
- (UIView *)storageChipFootView{
    if (!_storageChipFootView) {
        _storageChipFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-200, 100)];
        _storageChipFootView.backgroundColor = [UIColor clearColor];
        
        self.storageChipSoonButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.storageChipSoonButton setTitle:@"立即存入" forState:UIControlStateNormal];
        self.storageChipSoonButton.frame = CGRectMake(150, 50, kScreenWidth-200-300, 40);
        self.storageChipSoonButton.layer.cornerRadius = 5;
        self.storageChipSoonButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
        [self.storageChipSoonButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.storageChipSoonButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.storageChipSoonButton addTarget:self action:@selector(storageChipSoonConfirmAction) forControlEvents:UIControlEventTouchUpInside];
        [_storageChipFootView addSubview:self.storageChipSoonButton];
    }
    return _storageChipFootView;
}

#pragma mark - 取出筹码界面
- (void)takeOutChipShowView{
    self.takeOutChipTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.takeOutChipTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.takeOutChipTableView.hidden = YES;
    self.takeOutChipTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.takeOutChipTableView];
    [self.takeOutChipTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(5);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.takeOutChipTableView registerClass:[NRCashExchangeTableViewCell class] forCellReuseIdentifier:@"takeOutChipCell"];
    self.takeOutChipTableView.delegate = self;
    self.takeOutChipTableView.dataSource = self;
    self.takeOutChipTableView.tableFooterView = self.takeOutChipFootView;
    self.takeOutChipTableView.tableHeaderView = self.takeOutChipTableHeadView;

    self.takeOutChipView = [UIView new];
    self.takeOutChipView.backgroundColor = [UIColor clearColor];
    self.takeOutChipView.hidden = YES;
    [self.view addSubview:self.takeOutChipView];
    [self.takeOutChipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.takeOutChipImage = [UIImageView new];
    self.takeOutChipImage.contentMode = UIViewContentModeScaleToFill;
    self.takeOutChipImage.image = [UIImage imageNamed:@"douhao_icon"];
    [self.takeOutChipView addSubview:self.takeOutChipImage];
    [self.takeOutChipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takeOutChipView).offset(120);
        make.width.height.mas_equalTo(150);
        make.centerX.equalTo(self.takeOutChipView);
    }];
    
    self.takeOutChipTipsLab = [UILabel new];
    self.takeOutChipTipsLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.takeOutChipTipsLab.textColor = [UIColor colorWithHexString:@"#747474"];
    self.takeOutChipTipsLab.textAlignment = NSTextAlignmentCenter;
    self.takeOutChipTipsLab.numberOfLines = 0;
    self.takeOutChipTipsLab.text = @"请将需要取出的筹码平整放置在感应托盘中!";
    [self.takeOutChipView addSubview:self.takeOutChipTipsLab];
    [self.takeOutChipTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takeOutChipImage.mas_bottom).offset(60);
        make.left.equalTo(self.takeOutChipView).offset(20);
        make.centerX.equalTo(self.takeOutChipView);
    }];
    
    self.takeOutChipReadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.takeOutChipReadButton setTitle:@"开始取出" forState:UIControlStateNormal];
    self.takeOutChipReadButton.layer.cornerRadius = 5;
    self.takeOutChipReadButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.takeOutChipReadButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.takeOutChipReadButton setTitleColor:[UIColor colorWithHexString:@"#52a938"] forState:UIControlStateSelected];
    self.takeOutChipReadButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.takeOutChipReadButton addTarget:self action:@selector(readCurDeviceChip) forControlEvents:UIControlEventTouchUpInside];
    [self.takeOutChipView addSubview:self.takeOutChipReadButton];
    [self.takeOutChipReadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takeOutChipTipsLab.mas_bottom).offset(40);
        make.left.equalTo(self.leftButtonView.mas_right).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.takeOutChipView);
    }];
    
}

#pragma mark - 取出筹码头部信息
- (UIView *)takeOutChipTableHeadView{
    if (!_takeOutChipTableHeadView) {
        _takeOutChipTableHeadView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-210, 110)];
        _takeOutChipTableHeadView.backgroundColor = [UIColor colorWithHexString:@"#666666"];
        _takeOutChipTableHeadView.layer.cornerRadius = 5;
        
        self.takeOutChipNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 20)];
        self.takeOutChipNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.takeOutChipNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutChipNumberLab.numberOfLines = 0;
        self.takeOutChipNumberLab.text = @"筹码数量:0枚";
        [_takeOutChipTableHeadView addSubview:self.takeOutChipNumberLab];
        
        self.takeOutChipTotalMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.takeOutChipNumberLab.frame), 20, 200, 20)];
        self.takeOutChipTotalMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.takeOutChipTotalMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutChipTotalMoneyLab.numberOfLines = 0;
        self.takeOutChipTotalMoneyLab.text = @"筹码总额:0";
        [_takeOutChipTableHeadView addSubview:self.takeOutChipTotalMoneyLab];
        
        self.takeOutChipMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.takeOutChipNumberLab.frame)+15, 210, 40)];
        self.takeOutChipMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:28];
        self.takeOutChipMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutChipMoneyLab.numberOfLines = 0;
        self.takeOutChipMoneyLab.text = [NSString stringWithFormat:@"客人可取出金额:"];
        [_takeOutChipTableHeadView addSubview:self.takeOutChipMoneyLab];
        
        self.takeOutChipMoneyValueLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.takeOutChipMoneyLab.frame), CGRectGetMaxY(self.takeOutChipNumberLab.frame)+20, kScreenWidth-210-40-150, 40)];
        self.takeOutChipMoneyValueLab.font = [UIFont fontWithName:@"PingFang SC" size:20];
        self.takeOutChipMoneyValueLab.textColor = [UIColor redColor];
        self.takeOutChipMoneyValueLab.numberOfLines = 0;
        self.takeOutChipMoneyValueLab.text = [NSString stringWithFormat:@"%d",0];
        [_takeOutChipTableHeadView addSubview:self.takeOutChipMoneyValueLab];
    }
    return _takeOutChipTableHeadView;
}

#pragma mark - 取出筹码脚部信息
- (UIView *)takeOutChipFootView{
    if (!_takeOutChipFootView) {
        _takeOutChipFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-200, 600)];
        _takeOutChipFootView.backgroundColor = [UIColor clearColor];
        
        CGFloat label_width = 200;
        self.takeOutsuperiorInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, label_width, 20)];
        self.takeOutsuperiorInfoLab.font = [UIFont fontWithName:@"PingFang SC" size:22];
        self.takeOutsuperiorInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutsuperiorInfoLab.numberOfLines = 0;
        self.takeOutsuperiorInfoLab.text = @"上级信息";
        [_takeOutChipFootView addSubview:self.takeOutsuperiorInfoLab];
        
        self.takeOutsuperiorNameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.takeOutsuperiorInfoLab.frame)+5, label_width, 20)];
        self.takeOutsuperiorNameLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.takeOutsuperiorNameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutsuperiorNameLab.numberOfLines = 0;
        self.takeOutsuperiorNameLab.text = @"代理姓名: --";
        [_takeOutChipFootView addSubview:self.takeOutsuperiorNameLab];
        
        self.takeOutsuperiorWashNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.takeOutsuperiorNameLab.frame)+5, label_width, 20)];
        self.takeOutsuperiorWashNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.takeOutsuperiorWashNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutsuperiorWashNumberLab.numberOfLines = 0;
        self.takeOutsuperiorWashNumberLab.text = @"洗 码 号: --";
        [_takeOutChipFootView addSubview:self.takeOutsuperiorWashNumberLab];
        
        self.takeOutsuperiorMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.takeOutsuperiorWashNumberLab.frame)+5, label_width, 20)];
        self.takeOutsuperiorMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.takeOutsuperiorMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutsuperiorMoneyLab.numberOfLines = 0;
        self.takeOutsuperiorMoneyLab.text = @"风 险 金: --";
        [_takeOutChipFootView addSubview:self.takeOutsuperiorMoneyLab];
        
        self.takeOutsuperiorTellLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.takeOutsuperiorMoneyLab.frame)+5, label_width, 20)];
        self.takeOutsuperiorTellLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.takeOutsuperiorTellLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutsuperiorTellLab.numberOfLines = 0;
        self.takeOutsuperiorTellLab.text = @"联系电话: --";
        [_takeOutChipFootView addSubview:self.takeOutsuperiorTellLab];
        
        self.takeOutcurCustomerInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.takeOutsuperiorTellLab.frame)+10, label_width, 20)];
        self.takeOutcurCustomerInfoLab.font = [UIFont fontWithName:@"PingFang SC" size:22];
        self.takeOutcurCustomerInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutcurCustomerInfoLab.numberOfLines = 0;
        self.takeOutcurCustomerInfoLab.text = @"当前客人";
        [_takeOutChipFootView addSubview:self.takeOutcurCustomerInfoLab];
        
        self.takeOutcurCustomerWashNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.takeOutcurCustomerInfoLab.frame)+5, label_width, 20)];
        self.takeOutcurCustomerWashNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.takeOutcurCustomerWashNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutcurCustomerWashNumberLab.numberOfLines = 0;
        self.takeOutcurCustomerWashNumberLab.text = @"洗 码 号: --";
        [_takeOutChipFootView addSubview:self.takeOutcurCustomerWashNumberLab];
        
        self.takeOutcurCustomerNameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.takeOutcurCustomerWashNumberLab.frame)+5, label_width, 20)];
        self.takeOutcurCustomerNameLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.takeOutcurCustomerNameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutcurCustomerNameLab.numberOfLines = 0;
        self.takeOutcurCustomerNameLab.text = @"客人姓名: --";
        [_takeOutChipFootView addSubview:self.takeOutcurCustomerNameLab];
        
        self.takeOutcurCustomerTellLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.takeOutcurCustomerNameLab.frame)+5, label_width, 20)];
        self.takeOutcurCustomerTellLab.font = [UIFont fontWithName:@"PingFang SC" size:14];
        self.takeOutcurCustomerTellLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutcurCustomerTellLab.numberOfLines = 0;
        self.takeOutcurCustomerTellLab.text = @"联系电话: --";
        [_takeOutChipFootView addSubview:self.takeOutcurCustomerTellLab];
        
        self.takeOutWashNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(330, 10, 200, 35)];
        self.takeOutWashNumberTextField.placeholder = @"请输入客人洗码号";
        self.takeOutWashNumberTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutWashNumberTextField.layer.cornerRadius = 5;
        self.takeOutWashNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.takeOutWashNumberTextField.leftView = leftview;
        self.takeOutWashNumberTextField.leftViewMode = UITextFieldViewModeAlways;
        [_takeOutChipFootView addSubview:self.takeOutWashNumberTextField];
        
        self.takeOutPassWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(330, 60, 200, 35)];
        self.takeOutPassWordTextField.placeholder = @"请输入客人密码";
        self.takeOutPassWordTextField.secureTextEntry = YES;
        self.takeOutPassWordTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.takeOutPassWordTextField.layer.cornerRadius = 5;
        self.takeOutPassWordTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIView *takeleftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.takeOutPassWordTextField.leftView = takeleftview;
        self.takeOutPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
        [_takeOutChipFootView addSubview:self.takeOutPassWordTextField];
        
        self.takeOutChipConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.takeOutChipConfirmButton setTitle:@"确认取出" forState:UIControlStateNormal];
        self.takeOutChipConfirmButton.frame = CGRectMake(150, CGRectGetMaxY(self.takeOutcurCustomerTellLab.frame)+20, kScreenWidth-200-300, 40);
        self.takeOutChipConfirmButton.layer.cornerRadius = 5;
        self.takeOutChipConfirmButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
        [self.takeOutChipConfirmButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.takeOutChipConfirmButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.takeOutChipConfirmButton addTarget:self action:@selector(takeOutConfirmAction) forControlEvents:UIControlEventTouchUpInside];
        [_takeOutChipFootView addSubview:self.takeOutChipConfirmButton];
    }
    return _takeOutChipFootView;
}

#pragma mark - 设置功率界面
- (void)adjustPowerShowView{
    self.adjustPowerView = [UIView new];
    self.adjustPowerView.backgroundColor = [UIColor clearColor];
    self.adjustPowerView.hidden = YES;
    [self.view addSubview:self.adjustPowerView];
    [self.adjustPowerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplineView.mas_bottom).offset(0);
        make.left.equalTo(self.leftButtonView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.adjustPowerTextField = [UITextField new];
    self.adjustPowerTextField.placeholder = @"请输入1-5的数字";
    self.adjustPowerTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.adjustPowerTextField.layer.cornerRadius = 5;
    self.adjustPowerTextField.keyboardType = UIKeyboardTypeNumberPad;
    UIView *takeleftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.adjustPowerTextField.leftView = takeleftview;
    self.adjustPowerTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.adjustPowerView addSubview:self.adjustPowerTextField];
    [self.adjustPowerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adjustPowerView).offset(80);
        make.left.equalTo(self.adjustPowerView).offset(40);
        make.centerX.equalTo(self.adjustPowerView);
        make.height.mas_equalTo(40);
    }];
    
    self.adjustPowerSoonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.adjustPowerSoonButton setTitle:@"开始设置" forState:UIControlStateNormal];
    self.adjustPowerSoonButton.layer.cornerRadius = 5;
    self.adjustPowerSoonButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.adjustPowerSoonButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.adjustPowerSoonButton setTitleColor:[UIColor colorWithHexString:@"#52a938"] forState:UIControlStateSelected];
    self.adjustPowerSoonButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.adjustPowerSoonButton addTarget:self action:@selector(setDevicePower) forControlEvents:UIControlEventTouchUpInside];
    [self.adjustPowerView addSubview:self.adjustPowerSoonButton];
    [self.adjustPowerSoonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adjustPowerTextField.mas_bottom).offset(40);
        make.left.equalTo(self.leftButtonView.mas_right).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.takeOutChipView);
    }];
    
}

#pragma mark -- 识别当前筹码个数
- (void)readCurDeviceChip{
    if (!self.clientSocket.isConnected) {
        [self showMessage:@"未连接上设备，请检查设备网络或IP地址是否对应" withSuccess:NO];
        return;
    }
    [self showWaitingView];
    [EPSound playWithSoundName:@"click_sound"];
    self.chipUIDList = nil;
    self.chipUIDData = nil;
    self.viewModel.chipInfo.chipsUIDs = [NSArray array];
    self.isReadChip = YES;
    //查询筹码个数
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 筹码发行
- (void)chipIssueAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 0;
    self.allUserTotalMoney = 0;
    self.isAdjustPower = NO;
    self.titleBar.rightItem.hidden = NO;
    if (self.chipIssueList.count!=0) {
        self.chipIssueTableView.hidden = NO;
        self.operationButton.hidden = NO;
        self.chipIssueView.hidden = YES;
        self.scanChipNumberLab.hidden = YES;
        [self.operationButton setTitle:@"  继续发行  " forState:UIControlStateNormal];
        [self.chipIssueTableView reloadData];
    }else{
        self.chipIssueTableView.hidden = YES;
        self.operationButton.hidden = YES;
        self.chipIssueView.hidden = NO;
        self.scanChipNumberLab.hidden = NO;
    }
    self.chipDestructTableView.hidden = YES;
    self.chipCheckTableView.hidden = YES;
    self.chipExchangeTableView.hidden = YES;
    self.chipExchangeView.hidden = YES;
    self.chipDestructView.hidden = YES;
    self.chipCheckView.hidden = YES;
    self.tipSettlementTableView.hidden = YES;
    self.tipSettlementView.hidden = YES;
    self.storageChipTableView.hidden = YES;
    self.storageChipView.hidden = YES;
    self.takeOutChipTableView.hidden = YES;
    self.takeOutChipView.hidden = YES;
    self.adjustPowerView.hidden = YES;
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.tipSettlementButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.storageChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.takeOutChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.adjustPowerButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
}

#pragma mark - 立即发行
-(void)chipIssueImmediatelyAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.chipUIDList.count==0) {
        [self showMessage:@"请先识别筹码"];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    [self showWaitingView];
    self.isIssue = YES;
    self.isAdjustPower = NO;
    self.curChipInfo.chipBatch = self.batchTextFiled.text;
    self.viewModel.chipInfo.chipsUIDs = self.chipUIDList;
    self.curChipInfo.chipSerialNumber = self.serialNumberTextFiled.text;
    self.viewModel.chipModel = self.curChipInfo;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //写入数据
            [self.viewModel IssueChipsWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                if (success) {
                    int sleepTime = (int)self.chipUIDList.count * 10000;
                    if (self.chipUIDList.count<5) {
                        sleepTime = (int)self.chipUIDList.count * 20000;
                    }
                    for (int i = 0; i < self.chipUIDList.count; i++) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.curChipInfo.chipUID = self.chipUIDList[i];
                            int seriNumber = [self.serialNumberTextFiled.text intValue]+i;
                            NSString *hexString_seriNumber = [NRCommand getHexByDecimal:seriNumber];
                            self.curChipInfo.chipSerialNumber = hexString_seriNumber;
                            //向指定标签中写入数据（块1(筹码序列号，类型)）
                            [self.clientSocket writeData:[NRCommand writeInfoToChip1WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                            usleep(sleepTime);
                            //向指定标签中写入数据（块2(筹码金额)）
                            [self.clientSocket writeData:[NRCommand writeInfoToChip2WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                            usleep(sleepTime);
                            //向指定标签中写入数据（块3(筹码批次号)）
                            [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                            usleep(sleepTime);
                        });
                    }
                }else{
                    self.isIssue = NO;
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
        });
    });
}

#pragma mark - 筹码检测
- (void)chipCheckAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 1;
    self.allUserTotalMoney = 0;
    self.isAdjustPower = NO;
    self.titleBar.rightItem.hidden = YES;
    if (self.chipCheckList.count!=0) {
        self.chipCheckTableView.hidden = NO;
        self.chipCheckView.hidden = YES;
        [self.chipCheckTableView reloadData];
        self.operationButton.hidden = NO;
        [self.operationButton setTitle:@"  继续检测  " forState:UIControlStateNormal];
    }else{
        self.operationButton.hidden = YES;
        self.chipCheckTableView.hidden = YES;
        self.chipCheckView.hidden = NO;
    }
    self.chipDestructTableView.hidden = YES;
    self.chipIssueTableView.hidden = YES;
    self.chipExchangeTableView.hidden = YES;
    self.chipExchangeView.hidden = YES;
    self.chipDestructView.hidden = YES;
    self.scanChipNumberLab.hidden = YES;
    self.chipIssueView.hidden = YES;
    self.tipSettlementTableView.hidden = YES;
    self.tipSettlementView.hidden = YES;
    self.storageChipTableView.hidden = YES;
    self.storageChipView.hidden = YES;
    self.takeOutChipTableView.hidden = YES;
    self.takeOutChipView.hidden = YES;
    self.adjustPowerView.hidden = YES;
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.tipSettlementButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.storageChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.takeOutChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.adjustPowerButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
}

#pragma mark - 开始检测
- (void)checkChipAction{
    [self.viewModel Cmpublish_checkStateWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            [self.chipCheckList removeAllObjects];
            [self.chipCheckList addObject:[self managerModel]];
            NSArray *checkList = [self.viewModel.checkChipDict valueForKey:@"data"];
            [checkList enumerateObjectsUsingBlock:^(NSDictionary *curChip, NSUInteger idx, BOOL * _Nonnull stop) {
                //存储检测数据
                NRChipManagerInfo *checkInfo = [[NRChipManagerInfo alloc]init];
                int chiType = [curChip[@"fcmtype"] intValue];
                checkInfo.chipType = [NSString stringWithFormat:@"%d",chiType];
                checkInfo.batch = [NSString stringWithFormat:@"%@",curChip[@"fbatch"]];
                checkInfo.serialNumber = [NSString stringWithFormat:@"%@",curChip[@"forder"]];
                checkInfo.denomination = [NSString stringWithFormat:@"%@",curChip[@"fme"]];
                checkInfo.washNumber = [NSString stringWithFormat:@"%@",curChip[@"fxmh"]];
                if ([curChip[@"fstate"]integerValue]==1) {
                    checkInfo.status = @"正常";
                }else if ([curChip[@"fstate"]integerValue]==0){
                    checkInfo.status = @"销毁";
                }
                [self.chipCheckList addObject:checkInfo];
            }];
            
            for (int i=0; i<self.chipUIDList.count-checkList.count; i++) {
                //存储检测未知数据
                NRChipManagerInfo *checkInfo = [[NRChipManagerInfo alloc]init];
                checkInfo.chipType = @"#";
                checkInfo.batch = @"#";
                checkInfo.serialNumber = @"#";
                checkInfo.denomination = @"#";
                checkInfo.washNumber = @"#";
                checkInfo.status = @"非法";
                [self.chipCheckList addObject:checkInfo];
            }
            self.chipCheckView.hidden = YES;
            self.scanChipNumberLab.hidden = YES;
            self.operationButton.hidden = NO;
            self.chipCheckTableView.hidden = NO;
            [self.operationButton setTitle:@"  继续检测  " forState:UIControlStateNormal];
            [self.chipCheckTableView reloadData];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
            [self hideWaitingView];
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

#pragma mark - 筹码销毁
- (void)chipDestructAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 2;
    self.allUserTotalMoney = 0;
    self.isAdjustPower = NO;
    self.titleBar.rightItem.hidden = YES;
    if (self.chipDestructList.count>1) {
        self.chipDestructTableView.hidden = NO;
        self.chipDestructView.hidden = YES;
        [self.chipDestructTableView reloadData];
        self.operationButton.hidden = NO;
        [self.operationButton setTitle:@"  全部销毁  " forState:UIControlStateNormal];
    }else{
        self.operationButton.hidden = YES;
        self.chipDestructTableView.hidden = YES;
        self.chipDestructView.hidden = NO;
    }
    self.chipIssueTableView.hidden = YES;
    self.chipCheckTableView.hidden = YES;
    self.chipExchangeTableView.hidden = YES;
    self.chipExchangeView.hidden = YES;
    self.chipIssueView.hidden = YES;
    self.chipCheckView.hidden = YES;
    self.scanChipNumberLab.hidden = YES;
    self.tipSettlementTableView.hidden = YES;
    self.tipSettlementView.hidden = YES;
    self.storageChipTableView.hidden = YES;
    self.storageChipView.hidden = YES;
    self.takeOutChipTableView.hidden = YES;
    self.takeOutChipView.hidden = YES;
    self.adjustPowerView.hidden = YES;
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.tipSettlementButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.storageChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.takeOutChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.adjustPowerButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
}

#pragma mark - 筹码兑换
- (void)chipExchangeAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 3;
    self.allUserTotalMoney = 0;
    self.isAdjustPower = NO;
    self.titleBar.rightItem.hidden = YES;
    if (self.cashExchangeList.count!=0) {
        self.chipExchangeTableView.hidden = NO;
        self.operationButton.hidden = NO;
        self.chipExchangeView.hidden = YES;
        [self.operationButton setTitle:@"  继续兑换  " forState:UIControlStateNormal];
        [self.chipExchangeTableView reloadData];
    }else{
        self.exchangeTipsLab.hidden = YES;
        self.exchangeImage.hidden = YES;
        self.cashExchangeChipButton.hidden = NO;
        self.chipExchangeCashButton.hidden = NO;
        self.creditCodeButton.hidden = NO;
        self.chipExchangeTableView.hidden = YES;
        self.chipExchangeView.hidden = NO;
        self.operationButton.hidden = YES;
    }
    
    self.chipDestructView.hidden = YES;
    self.chipDestructTableView.hidden = YES;
    self.chipCheckTableView.hidden = YES;
    self.chipIssueTableView.hidden = YES;
    self.scanChipNumberLab.hidden = YES;
    self.chipIssueView.hidden = YES;
    self.chipCheckView.hidden = YES;
    self.tipSettlementTableView.hidden = YES;
    self.tipSettlementView.hidden = YES;
    self.storageChipTableView.hidden = YES;
    self.storageChipView.hidden = YES;
    self.takeOutChipTableView.hidden = YES;
    self.takeOutChipView.hidden = YES;
    self.adjustPowerView.hidden = YES;
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    [self.tipSettlementButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.storageChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.takeOutChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.adjustPowerButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
}

#pragma mark - 小费结算
- (void)tipSettlementAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 4;
    self.allUserTotalMoney = 0;
    self.isAdjustPower = NO;
    self.titleBar.rightItem.hidden = YES;
    if (self.tipSettlementList.count>1) {
        self.tipSettlementTableView.hidden = NO;
        self.tipSettlementView.hidden = YES;
        self.operationButton.hidden = NO;
        [self.operationButton setTitle:@"  继续结算  " forState:UIControlStateNormal];
        [self.tipSettlementTableView reloadData];
    }else{
        self.operationButton.hidden = YES;
        self.tipSettlementTableView.hidden = YES;
        self.tipSettlementView.hidden = NO;
    }
    self.chipIssueTableView.hidden = YES;
    self.chipCheckTableView.hidden = YES;
    self.chipExchangeTableView.hidden = YES;
    self.chipDestructTableView.hidden = YES;
    self.chipExchangeView.hidden = YES;
    self.chipIssueView.hidden = YES;
    self.chipCheckView.hidden = YES;
    self.chipDestructView.hidden = YES;
    self.scanChipNumberLab.hidden = YES;
    self.storageChipTableView.hidden = YES;
    self.storageChipView.hidden = YES;
    self.takeOutChipTableView.hidden = YES;
    self.takeOutChipView.hidden = YES;
    self.adjustPowerView.hidden = YES;
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.tipSettlementButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    [self.storageChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.takeOutChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.adjustPowerButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
}

#pragma mark - 存入筹码
- (void)storegeChipAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 5;
    self.allUserTotalMoney = 0;
    self.isAdjustPower = NO;
    self.titleBar.rightItem.hidden = YES;
    if (self.storageChipList.count>1) {
        self.storageChipTableView.hidden = NO;
        self.storageChipView.hidden = YES;
        self.operationButton.hidden = NO;
        [self.operationButton setTitle:@"  继续存入  " forState:UIControlStateNormal];
        [self.storageChipTableView reloadData];
    }else{
        self.operationButton.hidden = YES;
        self.storageChipTableView.hidden = YES;
        self.storageChipView.hidden = NO;
    }
    self.chipIssueTableView.hidden = YES;
    self.chipCheckTableView.hidden = YES;
    self.chipExchangeTableView.hidden = YES;
    self.chipDestructTableView.hidden = YES;
    self.chipExchangeView.hidden = YES;
    self.chipIssueView.hidden = YES;
    self.chipCheckView.hidden = YES;
    self.chipDestructView.hidden = YES;
    self.scanChipNumberLab.hidden = YES;
    self.tipSettlementTableView.hidden = YES;
    self.tipSettlementView.hidden = YES;
    self.takeOutChipTableView.hidden = YES;
    self.takeOutChipView.hidden = YES;
    self.adjustPowerView.hidden = YES;
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.tipSettlementButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.storageChipButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    [self.takeOutChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.adjustPowerButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
}

#pragma mark - 取出筹码
- (void)takeOutChipAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 6;
    self.allUserTotalMoney = 0;
    self.isAdjustPower = NO;
    self.titleBar.rightItem.hidden = YES;
    if (self.takeOutChipList.count>1) {
        self.takeOutChipTableView.hidden = NO;
        self.takeOutChipView.hidden = YES;
        self.operationButton.hidden = NO;
        [self.operationButton setTitle:@"  继续识别  " forState:UIControlStateNormal];
        [self.takeOutChipTableView reloadData];
    }else{
        self.operationButton.hidden = YES;
        self.takeOutChipTableView.hidden = YES;
        self.takeOutChipView.hidden = NO;
    }
    self.chipIssueTableView.hidden = YES;
    self.chipCheckTableView.hidden = YES;
    self.chipExchangeTableView.hidden = YES;
    self.chipDestructTableView.hidden = YES;
    self.chipExchangeView.hidden = YES;
    self.chipIssueView.hidden = YES;
    self.chipCheckView.hidden = YES;
    self.chipDestructView.hidden = YES;
    self.scanChipNumberLab.hidden = YES;
    self.tipSettlementTableView.hidden = YES;
    self.tipSettlementView.hidden = YES;
    self.storageChipTableView.hidden = YES;
    self.storageChipView.hidden = YES;
    self.adjustPowerView.hidden = YES;
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.tipSettlementButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.storageChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.takeOutChipButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    [self.adjustPowerButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
}

#pragma mark - 设置功率
- (void)adjustPowerAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 7;
    self.allUserTotalMoney = 0;
    self.adjustPowerView.hidden = NO;
    self.chipIssueTableView.hidden = YES;
    self.chipCheckTableView.hidden = YES;
    self.chipExchangeTableView.hidden = YES;
    self.chipDestructTableView.hidden = YES;
    self.chipExchangeView.hidden = YES;
    self.chipIssueView.hidden = YES;
    self.chipCheckView.hidden = YES;
    self.chipDestructView.hidden = YES;
    self.scanChipNumberLab.hidden = YES;
    self.tipSettlementTableView.hidden = YES;
    self.tipSettlementView.hidden = YES;
    self.storageChipTableView.hidden = YES;
    self.storageChipView.hidden = YES;
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.tipSettlementButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.storageChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.takeOutChipButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.adjustPowerButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
}


#pragma mark -- 立即结算
- (void)tipSettlementSoonConfirmAction{
    self.isSettlementTipChip = YES;
    [self showWaitingView];
    [self.viewModel TipSettlementWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    NSString *chipUID = self.chipUIDList[i];
                    //向指定标签中写入数据（块1）
                    [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                    usleep((int)self.chipUIDList.count * 10000);
                }
            });
        }else{
            self.isSettlementTipChip = NO;
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

#pragma mark -- 立即存入
- (void)storageChipSoonConfirmAction{
    self.isStorageChip = YES;
    [self showWaitingView];
    [self.viewModel AccessChipWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    NSString *chipUID = self.chipUIDList[i];
                    //向指定标签中写入数据（块1）
                    [self.clientSocket writeData:[NRCommand clearWashNumberWithChipInfo:chipUID] withTimeout:- 1 tag:0];
                    usleep((int)self.chipUIDList.count * 10000);
                }
            });
        }else{
            self.isStorageChip = NO;
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

#pragma mark -- 立即取出
- (void)takeOutConfirmAction{
    if ([[self.takeOutWashNumberTextField.text NullToBlankString]length]==0) {
        [self showMessage:@"请输入洗码号"];
        return;
    }
    if ([[self.takeOutPassWordTextField.text NullToBlankString]length]==0) {
        [self showMessage:@"请输入密码"];
        return;
    }
    self.isTakeOutChip = YES;
    [self showWaitingView];
    [self.viewModel AccessChipWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    self.curChipInfo.chipUID = self.chipUIDList[i];
                    [self.clientSocket writeData:[NRCommand writeInfoToChip4WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                    usleep((int)self.chipUIDList.count * 10000);
                }
            });
        }else{
            self.isTakeOutChip = NO;
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

#pragma mark - 读取筹码信息
- (void)readAllChipsInfo{
    self.chipUIDData = nil;
    [self.chipIssueList removeAllObjects];
    for (int i = 0; i < self.chipUIDList.count; i++) {
        NSString *chipID = self.chipUIDList[i];
        [self.clientSocket writeData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID] withTimeout:- 1 tag:0];
        usleep((int)self.chipUIDList.count * 10000);
    }
}

#pragma mark - 操作步骤
- (void)operationAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.chipOperationType==0) {//继续发行
        self.chipIssueTableView.hidden = YES;
        self.chipIssueView.hidden = NO;
        self.scanChipNumberLab.hidden = NO;
        self.operationButton.hidden = YES;
    }else if (self.chipOperationType==1){//继续检测
        self.chipCheckTableView.hidden = YES;
        self.chipCheckView.hidden = NO;
        self.operationButton.hidden = YES;
    }else if (self.chipOperationType==2){//确定销毁
        if ([self.operationButton.titleLabel.text isEqualToString:@"  继续销毁  "]) {
            self.operationButton.hidden = YES;
            self.chipDestructView.hidden = NO;
            self.destructImage.image = [UIImage imageNamed:@"douhao_icon"];
            self.readChipButton.hidden = NO;
            self.destructTipsLab.hidden = NO;
            self.destructTipsLab.text = @"请将需要销毁的筹码平整放置在感应托盘中!";
        }else{
            @weakify(self);
            [EPPopView showInWindowWithMessage:@"确定销毁?" handler:^(int buttonType) {
                DLOG(@"buttonType = %d",buttonType);
                @strongify(self);
                if (buttonType==0) {
                    self.isDestoryChip = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showWaitingViewWithText:@"销毁中..."];
                    });
                    self.viewModel.chipModel = self.curChipInfo;
                    [self.viewModel cmDestoryWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                        if (success) {
                            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
                            dispatch_async(serialQueue, ^{
                                for (int i = 0; i < self.chipUIDList.count; i++) {
                                    NSString *chipUID = self.chipUIDList[i];
                                    //向指定标签中写入数据（块1）
                                    [self.clientSocket writeData:[NRCommand destructInfoToChip1WithChipUID:chipUID] withTimeout:- 1 tag:0];
                                    usleep(20 * 2000);
                                }
                            });
                        }else{
                            self.isDestoryChip = NO;
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
        }
    }else if (self.chipOperationType==3){//筹码兑换
        if ([self.operationButton.titleLabel.text isEqualToString:@"  开始读取  "]) {
            [self readCurDeviceChip];
        }else if ([self.operationButton.titleLabel.text isEqualToString:@"  继续兑换  "]){
            self.chipExchangeTableView.hidden = YES;
            self.chipExchangeView.hidden = NO;
            self.operationButton.hidden = YES;
            self.cashExchangeChipButton.hidden = NO;
            self.chipExchangeCashButton.hidden = NO;
            self.creditCodeButton.hidden = NO;
            self.exchangeTipsLab.hidden = YES;
            self.exchangeImage.hidden = YES;
        }
    }else if (self.chipOperationType==4){//继续结算小费
        self.tipSettlementTableView.hidden = YES;
        self.tipSettlementView.hidden = NO;
        self.chipExchangeTableView.hidden = YES;
        self.chipExchangeView.hidden = YES;
        self.operationButton.hidden = YES;
        self.cashExchangeChipButton.hidden = YES;
        self.chipExchangeCashButton.hidden = YES;
        self.creditCodeButton.hidden = YES;
        self.exchangeTipsLab.hidden = YES;
        self.exchangeImage.hidden = YES;
    }else if (self.chipOperationType==5){//继续存入筹码
        self.storageChipTableView.hidden = YES;
        self.storageChipView.hidden = NO;
        self.tipSettlementTableView.hidden = YES;
        self.tipSettlementView.hidden = YES;
        self.chipExchangeTableView.hidden = YES;
        self.chipExchangeView.hidden = YES;
        self.operationButton.hidden = YES;
        self.cashExchangeChipButton.hidden = YES;
        self.chipExchangeCashButton.hidden = YES;
        self.creditCodeButton.hidden = YES;
        self.exchangeTipsLab.hidden = YES;
        self.exchangeImage.hidden = YES;
    }else if (self.chipOperationType==6){//继续识别筹码
        [self readCurDeviceChip];
    }
}

#pragma mark - 现金兑换筹码
- (void)cashExchangeChipAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.curChipInfo.fcredit = @"0";
    self.cashCodeTextField.hidden = NO;
    self.authorizationTextField.hidden = YES;
    self.noteTextField.hidden = YES;
    [self.cashExchangeConfirmButton setTitle:@"确认现金换筹码" forState:UIControlStateNormal];
    self.cashExchangeConfirmButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    self.exchangeImage.image = [UIImage imageNamed:@"douhao_icon"];
    self.cashExchangeChipButton.hidden = YES;
    self.chipExchangeCashButton.hidden = YES;
    self.creditCodeButton.hidden = YES;
    self.exchangeTipsLab.hidden = NO;
    self.exchangeTipsLab.text = @"请将筹码放置在托盘进行读取";
    self.exchangeImage.hidden = NO;
    self.operationButton.hidden = NO;
    [self.operationButton setTitle:@"  开始读取  " forState:UIControlStateNormal];
}

#pragma mark - 筹码兑换现金
- (void)chipExchangeCashAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.cashCodeTextField.hidden = YES;
    self.authorizationTextField.hidden = YES;
    self.noteTextField.hidden = YES;
    [self.cashExchangeConfirmButton setTitle:@"确认筹码换现金" forState:UIControlStateNormal];
    self.cashExchangeConfirmButton.backgroundColor = [UIColor colorWithHexString:@"#3e54af"];
    
    self.exchangeImage.image = [UIImage imageNamed:@"douhao_icon"];
    self.cashExchangeChipButton.hidden = YES;
    self.chipExchangeCashButton.hidden = YES;
    self.creditCodeButton.hidden = YES;
    self.exchangeTipsLab.hidden = NO;
    self.exchangeImage.hidden = NO;
    self.operationButton.hidden = NO;
    [self.operationButton setTitle:@"  开始读取  " forState:UIControlStateNormal];
}

#pragma mark - 信用出码
- (void)creditCodeAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.curChipInfo.fcredit = @"1";
    self.cashCodeTextField.hidden = NO;
    self.authorizationTextField.hidden = NO;
    self.noteTextField.hidden = NO;
    [self.cashExchangeConfirmButton setTitle:@"确认信用出码" forState:UIControlStateNormal];
    self.cashExchangeConfirmButton.backgroundColor = [UIColor colorWithHexString:@"#ef8b4a"];
    
    self.exchangeImage.image = [UIImage imageNamed:@"douhao_icon"];
    self.cashExchangeChipButton.hidden = YES;
    self.chipExchangeCashButton.hidden = YES;
    self.creditCodeButton.hidden = YES;
    self.exchangeTipsLab.hidden = NO;
    self.exchangeImage.hidden = NO;
    self.operationButton.hidden = NO;
    [self.operationButton setTitle:@"  开始读取  " forState:UIControlStateNormal];
}

#pragma mark - 确认现金换筹码
- (void)cashExchangeConfirmAction{
    [EPSound playWithSoundName:@"click_sound"];
    [self showWaitingViewWithText:@"兑换中..."];
    if ([self.cashExchangeConfirmButton.titleLabel.text isEqualToString:@"确认现金换筹码"]||[self.cashExchangeConfirmButton.titleLabel.text isEqualToString:@"确认信用出码"]) {
        self.curChipInfo.guestWashesNumber = self.cashCodeTextField.text;
        self.isExchangeChip = YES;
        self.viewModel.chipInfo.chipsUIDs = self.chipUIDList;
        self.viewModel.chipModel = self.curChipInfo;
        [self.viewModel CashExchangeChipWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
            if (success) {
                dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
                dispatch_async(serialQueue, ^{
                    for (int i = 0; i < self.chipUIDList.count; i++) {
                        self.curChipInfo.chipUID = self.chipUIDList[i];
                        [self.clientSocket writeData:[NRCommand writeInfoToChip4WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                        usleep((int)self.chipUIDList.count * 10000);
                    }
                });
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
    }else{
        self.curChipInfo.guestWashesNumber = @"000";
        self.isExchangeChip = YES;
        self.viewModel.chipInfo.chipsUIDs = self.chipUIDList;
        self.viewModel.chipModel = self.curChipInfo;
        [self.viewModel ChipExchangeCashWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
            if (success) {
                dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
                dispatch_async(serialQueue, ^{
                    for (int i = 0; i < self.chipUIDList.count; i++) {
                        self.curChipInfo.chipUID = self.chipUIDList[i];
                        //向指定标签中写入数据（块1）
                        [self.clientSocket writeData:[NRCommand writeInfoToChip4WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                        usleep((int)self.chipUIDList.count * 10000);
                    }
                });
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
}

#pragma mark -- 设置功率
- (void)setDevicePower{
    [EPSound playWithSoundName:@"click_sound"];
    int powerInt = [self.adjustPowerTextField.text intValue];
    if (powerInt<=0||powerInt>5) {
        [self showMessage:@"请输入1-5的数字"];
        return;
    }
    [self showWaitingView];
    self.isAdjustPower = YES;
    [self.clientSocket writeData:[NRCommand setDeviceWorkPowerWithPower:powerInt] withTimeout:- 1 tag:0];
}

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (self.chipOperationType==0) {
        if ([cell.reuseIdentifier isEqualToString:@"managerCell"]) {
            NRChipManagerTableViewCell *newCell = (NRChipManagerTableViewCell *)cell;
            NRChipManagerInfo *managerInfo = self.chipIssueList[indexPath.row];
            [newCell configureWithSerialNumberText:managerInfo.serialNumber
                                      ChipTypeText:managerInfo.chipType
                                  DenominationText:managerInfo.denomination
                                         BatchText:managerInfo.batch
                                        StatusText:managerInfo.status
                                      chipTypeList:self.viewModel.chipInfoList];
        }
    }else if (self.chipOperationType==1){
        if ([cell.reuseIdentifier isEqualToString:@"checkCell"]) {
            NRCashExchangeTableViewCell *newCell = (NRCashExchangeTableViewCell *)cell;
            NRChipManagerInfo *managerInfo = self.chipCheckList[indexPath.row];
            [newCell configureWithBatchText:managerInfo.batch
                           SerialNumberText:managerInfo.serialNumber
                               ChipTypeText:managerInfo.chipType
                           DenominationText:managerInfo.denomination
                             WashNumberText:managerInfo.washNumber
                                 StatusText:managerInfo.status
                               chipTypeList:self.viewModel.chipInfoList];
        }
    }else if (self.chipOperationType==2){
        if ([cell.reuseIdentifier isEqualToString:@"destrutCell"]) {
            NRChipDestrutTableViewCell *newCell = (NRChipDestrutTableViewCell *)cell;
            NRChipManagerInfo *managerInfo = self.chipDestructList[indexPath.row];
            [newCell configureWithSerialNumberText:managerInfo.serialNumber
                                      ChipTypeText:managerInfo.chipType
                                  DenominationText:managerInfo.denomination
                                         BatchText:managerInfo.batch
                                         StatusText:managerInfo.status
                                       chipTypeList:self.viewModel.chipInfoList];
        }
    }else if (self.chipOperationType==3){
        if ([cell.reuseIdentifier isEqualToString:@"cashExchangeCell"]) {
            NRCashExchangeTableViewCell *newCell = (NRCashExchangeTableViewCell *)cell;
            NRChipManagerInfo *managerInfo = self.cashExchangeList[indexPath.row];
            [newCell configureWithBatchText:managerInfo.batch
                           SerialNumberText:managerInfo.serialNumber
                               ChipTypeText:managerInfo.chipType
                           DenominationText:managerInfo.denomination
                             WashNumberText:managerInfo.washNumber
                                 StatusText:managerInfo.status
                               chipTypeList:self.viewModel.chipInfoList];
        }
    }else if (self.chipOperationType==4){
        if ([cell.reuseIdentifier isEqualToString:@"tipSettlementCell"]) {
            NRCashExchangeTableViewCell *newCell = (NRCashExchangeTableViewCell *)cell;
            NRChipManagerInfo *managerInfo = self.tipSettlementList[indexPath.row];
            [newCell configureWithBatchText:managerInfo.batch
                           SerialNumberText:managerInfo.serialNumber
                               ChipTypeText:managerInfo.chipType
                           DenominationText:managerInfo.denomination
                             WashNumberText:managerInfo.washNumber
                                 StatusText:managerInfo.status
                               chipTypeList:self.viewModel.chipInfoList];
        }
    }else if (self.chipOperationType==5){
        if ([cell.reuseIdentifier isEqualToString:@"storageChipCell"]) {
            NRCashExchangeTableViewCell *newCell = (NRCashExchangeTableViewCell *)cell;
            NRChipManagerInfo *managerInfo = self.storageChipList[indexPath.row];
            [newCell configureWithBatchText:managerInfo.batch
                           SerialNumberText:managerInfo.serialNumber
                               ChipTypeText:managerInfo.chipType
                           DenominationText:managerInfo.denomination
                             WashNumberText:managerInfo.washNumber
                                 StatusText:managerInfo.status
                               chipTypeList:self.viewModel.chipInfoList];
        }
    }else if (self.chipOperationType==6){
        if ([cell.reuseIdentifier isEqualToString:@"takeOutChipCell"]) {
            NRCashExchangeTableViewCell *newCell = (NRCashExchangeTableViewCell *)cell;
            NRChipManagerInfo *managerInfo = self.takeOutChipList[indexPath.row];
            [newCell configureWithBatchText:managerInfo.batch
                           SerialNumberText:managerInfo.serialNumber
                               ChipTypeText:managerInfo.chipType
                           DenominationText:managerInfo.denomination
                             WashNumberText:managerInfo.washNumber
                                 StatusText:managerInfo.status
                               chipTypeList:self.viewModel.chipInfoList];
        }
    }
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.chipIssueTableView]) {
        return self.chipIssueList.count;
    }else if ([tableView isEqual:self.chipCheckTableView]){
        return self.chipCheckList.count;
    }else if ([tableView isEqual:self.chipDestructTableView]){
        return self.chipDestructList.count;
    }else if ([tableView isEqual:self.chipExchangeTableView]){
        return self.cashExchangeList.count;
    }else if ([tableView isEqual:self.tipSettlementTableView]){
        return self.tipSettlementList.count;
    }else if ([tableView isEqual:self.storageChipTableView]){
        return self.storageChipList.count;
    }else if ([tableView isEqual:self.takeOutChipTableView]){
        return self.takeOutChipList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01; // ios9 need > 0
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01; // ios9 need > 0
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NRChipManagerTableViewCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.chipIssueTableView]) {
        NSString *cellId = @"managerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }else if ([tableView isEqual:self.chipCheckTableView]){
        NSString *cellId = @"checkCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }else if ([tableView isEqual:self.chipDestructTableView]){
        NSString *cellId = @"destrutCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }else if ([tableView isEqual:self.chipExchangeTableView]){
        NSString *cellId = @"cashExchangeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }else if ([tableView isEqual:self.tipSettlementTableView]){
        NSString *cellId = @"tipSettlementCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }else if ([tableView isEqual:self.storageChipTableView]){
        NSString *cellId = @"storageChipCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }else if ([tableView isEqual:self.takeOutChipTableView]){
        NSString *cellId = @"takeOutChipCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray *)shaiXuanWithList:(NSArray *)list{
    NSMutableArray *array = [NSMutableArray arrayWithArray:list];
    NSMutableArray *dateMutablearray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i ++) {
        NRChipManagerInfo *chipInfo = array[i];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        [tempArray addObject:chipInfo];
        for (int j = i+1; j < array.count; j ++) {
            NRChipManagerInfo *jChipInfo = array[j];
            if([chipInfo.money isEqualToString:jChipInfo.money]&&[chipInfo.chipType isEqualToString:jChipInfo.chipType]){
                [tempArray addObject:jChipInfo];
                [array removeObjectAtIndex:j];
                j -= 1;
            }
        }
        [dateMutablearray addObject:tempArray];
    }
    return dateMutablearray;
}


#pragma mark - 设置硬盘工作模式
- (void)sendDeviceWorkModel{
    //设置感应盘工作模式
    self.isSetUpDeviceModel = YES;
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
    [self sendDeviceWorkModel];
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
    NSString *dataHexStr = [NRCommand hexStringFromData:data];
    if (!self.chipUIDData) {
        self.chipUIDData = [NSMutableData data];
    }
    DLOG(@"data = %@",data);
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
    if (self.isAdjustPower) {
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"040000525a" withString:@"040000525a"
           options:NSLiteralSearch
             range:NSMakeRange(0, [chipNumberdataHexStr length])];
        if (count==1) {
            [self hideWaitingView];
            self.isAdjustPower= NO;
            self.chipUIDData = nil;
            [self showMessage:@"功率设置成功" withSuccess:YES];
        }
        return;
    }
    BLEIToll *itool = [[BLEIToll alloc]init];
    NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
    if (self.isReadChip) {//正在识别筹码
        if ([chipNumberdataHexStr hasSuffix:@"04000e2cb3"]) {//检测到结束字符,识别筹码UID完毕
            self.chipUIDData = nil;
            self.isReadChip = NO;
            chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"04000e2cb3" withString:@""];
            chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"040000525a" withString:@""];
            NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"0d000000" withString:@"0d000000"
               options:NSLiteralSearch
                 range:NSMakeRange(0, [chipNumberdataHexStr length])];
            if (count==0) {
                [self showMessage:@"未检测到筹码"];
                //响警告声音
                [EPSound playWithSoundName:@"wram_sound"];
                [self hideWaitingView];
                return;
            }
            //存贮筹码UID
            self.chipUIDList = [itool getDeviceAllChipUIDWithBLEString:chipNumberdataHexStr];
            self.viewModel.chipInfo.chipsUIDs = self.chipUIDList;
            self.chipCount = self.chipUIDList.count;
            self.scanChipNumberLab.text = [NSString stringWithFormat:@"*当前已识别筹码%ld枚*",(long)self.chipCount];
            
            if (self.chipOperationType==0) {
                [EPSound playWithSoundName:@"succeed_sound"];
                [self hideWaitingView];
            }else if (self.chipOperationType==1){
                [self checkChipAction];
            }else{
                self.cashCodeTextField.text = @"";
                self.authorizationTextField.text = @"";
                self.noteTextField.text = @"";
                [self readAllChipsInfo];
            }
        }
    }else if (self.isIssue||self.isDestoryChip||self.isExchangeChip||self.isSettlementTipChip||self.isStorageChip||self.isTakeOutChip) {
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        int allChipCount = (int)self.chipCount;
        if (self.isIssue) {
            allChipCount = (int)(3*self.chipCount);
        }
        int statusCount = [NRCommand showBackStatusCountWithHexStatus:chipNumberdataHexStr AllChipCount:allChipCount];
        if (statusCount==1||statusCount==2) {
            self.chipUIDData = nil;
            if (self.isIssue) {
                self.isIssue = NO;
                [self showMessage:@"发行成功" withSuccess:YES];
                [self readAllChipsInfo];
                [self hideWaitingView];
                //响警告声音
               [EPSound playWithSoundName:@"succeed_sound"];
            }else if (self.isDestoryChip){
                self.isDestoryChip =  NO;
                [self.chipDestructList removeAllObjects];
                self.chipDestructView.hidden = NO;
                self.operationButton.hidden = NO;
                self.chipDestructTableView.hidden = YES;
                [self.operationButton setTitle:@"  继续销毁  " forState:UIControlStateNormal];
                self.destructImage.image = [UIImage imageNamed:@"chipSuccess_icon"];
                self.readChipButton.hidden = YES;
                self.destructTipsLab.hidden = NO;
                self.destructTipsLab.text = @"销毁成功";
                [self showMessage:@"销毁成功" withSuccess:YES];
                [self hideWaitingView];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
            }else if (self.isExchangeChip){
                self.isExchangeChip = NO;
                [self showMessage:@"兑换成功" withSuccess:YES];
                [self.cashExchangeList removeAllObjects];
                self.chipExchangeView.hidden = NO;
                self.operationButton.hidden = NO;
                self.chipExchangeTableView.hidden = YES;
                self.exchangeImage.image = [UIImage imageNamed:@"chipSuccess_icon"];
                self.exchangeTipsLab.hidden = NO;
                self.exchangeTipsLab.text = @"兑换成功";
                [self hideWaitingView];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
                [self clearCustomerInfo];
            }else if (self.isSettlementTipChip){
                self.isSettlementTipChip = NO;
                [self showMessage:@"结算成功" withSuccess:YES];
                [self.tipSettlementList removeAllObjects];
                self.tipSettlementView.hidden = NO;
                self.operationButton.hidden = YES;
                self.tipSettlementTableView.hidden = YES;
                self.tipSettlementTipsLab.hidden = NO;
                [self hideWaitingView];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
            }else if (self.isStorageChip){
                self.isStorageChip = NO;
                [self showMessage:@"存入成功" withSuccess:YES];
                [self.storageChipList removeAllObjects];
                self.storageChipView.hidden = NO;
                self.operationButton.hidden = YES;
                self.storageChipTableView.hidden = YES;
                self.storageChipTipsLab.hidden = NO;
                [self hideWaitingView];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
            }else if (self.isTakeOutChip){
                self.isTakeOutChip = NO;
                [self showMessage:@"取出成功" withSuccess:YES];
                [self.takeOutChipList removeAllObjects];
                self.takeOutChipView.hidden = NO;
                self.operationButton.hidden = YES;
                self.takeOutChipTableView.hidden = YES;
                self.takeOutChipTipsLab.hidden = NO;
                [self hideWaitingView];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
                [self clearCustomerInfo];
            }
        }
    }else {
        NSInteger infoByteLength = 50 * self.chipCount;
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        if (chipNumberdataHexStr.length==infoByteLength) {//数据长度相同，筹码信息已经接受完毕
            self.chipUIDData = nil;
            if (self.chipOperationType==0) {//筹码发行
                [self.chipIssueList removeAllObjects];
                [self.chipIssueList addObject:[self managerModel]];
            }else if (self.chipOperationType==2){//筹码销毁
                [self.chipDestructList removeAllObjects];
                [self.chipDestructList addObject:[self managerModel]];
            }else if (self.chipOperationType==3){//筹码兑换
                [self.cashExchangeList removeAllObjects];
                //初始化现金兑换筹码的数据
                [self.cashExchangeList addObject:[self managerModel]];
            }else if (self.chipOperationType==4){//小费结算
                [self.tipSettlementList removeAllObjects];
                //初始化现金兑换筹码的数据
                [self.tipSettlementList addObject:[self managerModel]];
            }else if (self.chipOperationType==5){//存入筹码
                [self.storageChipList removeAllObjects];
                //初始化现金兑换筹码的数据
                [self.storageChipList addObject:[self managerModel]];
            }else if (self.chipOperationType==6){//取出筹码
                [self.takeOutChipList removeAllObjects];
                //初始化现金兑换筹码的数据
                [self.takeOutChipList addObject:[self managerModel]];
            }
            //解析筹码
            NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr];
            DLOG(@"chipInfo = %@",chipInfo);
            __block int chipAllMoney = 0;
            NSMutableArray *washNumberList = [NSMutableArray array];
            [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                //存储发行数据
                //序列号
                NSString *serialNumber = [infoList[0]NullToBlankString];
                //类型
                NSString *chipType = [infoList[1] NullToBlankString];
                //面额
                NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                //批次
                NSString *batch = [infoList[3] NullToBlankString];
                //洗码号
                NSString *washNumber = [infoList[4] NullToBlankString];
                if (![washNumberList containsObject:washNumber]) {
                    [washNumberList addObject:washNumber];
                }
                //状态
                NSString *statusString = @"正常";
                if ([chipType intValue]==99) {
                    statusString = @"已销毁";
                }
                NRChipManagerInfo *chipinfo = [[NRChipManagerInfo alloc]init];
                chipinfo.serialNumber = serialNumber;
                chipinfo.chipType = chipType;
                chipAllMoney += [realmoney intValue];
                chipinfo.denomination = realmoney;
                chipinfo.batch = batch;
                chipinfo.status = statusString;
                chipinfo.washNumber = washNumber;
                self.curChipInfo.guestWashesNumber = washNumber;
                if (self.chipOperationType==0) {//筹码发行
                    [self.chipIssueList addObject:chipinfo];
                }else if (self.chipOperationType==2){//筹码销毁
                    if ([chipType intValue]!=99) {
                        [self.chipDestructList addObject:chipinfo];
                    }
                }else if (self.chipOperationType==3){//筹码兑换
                    [self.cashExchangeList addObject:chipinfo];
                }else if (self.chipOperationType==4){//小费结算
                    [self.tipSettlementList addObject:chipinfo];
                }else if (self.chipOperationType==5){//存入筹码
                    [self.storageChipList addObject:chipinfo];
                }else if (self.chipOperationType==6){//取出筹码
                    [self.takeOutChipList addObject:chipinfo];
                }
            }];
            self.allUserTotalMoney = chipAllMoney;
            if (self.chipOperationType==0) {//发行
                self.chipIssueTableView.hidden = NO;
                self.chipIssueView.hidden = YES;
                self.operationButton.hidden = NO;
                self.scanChipNumberLab.hidden = YES;
                [self.operationButton setTitle:@"  继续发行  " forState:UIControlStateNormal];
                [self.chipIssueTableView reloadData];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
            }else if (self.chipOperationType==2){//销毁
                if (self.chipDestructList.count>1) {
                    self.chipDestructView.hidden = YES;
                    self.operationButton.hidden = NO;
                    self.chipDestructTableView.hidden = NO;
                    [self.operationButton setTitle:@"  全部销毁  " forState:UIControlStateNormal];
                    [self.chipDestructTableView reloadData];
                    //响警告声音
                    [EPSound playWithSoundName:@"succeed_sound"];
                }else{
                    [self showLognMessage:@"未检测到可销毁筹码"];
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                }
                self.scanChipNumberLab.hidden = YES;
            }else if (self.chipOperationType==3){//兑换
                self.chipExchangeTableView.hidden = NO;
                self.operationButton.hidden = NO;
                self.chipExchangeView.hidden = YES;
                [self.operationButton setTitle:@"  继续兑换  " forState:UIControlStateNormal];
                [self.chipExchangeTableView reloadData];
                //兑换信息
                self.exchangNumberLab.text = [NSString stringWithFormat:@"筹码数量:%ld",(long)self.chipCount];
                self.exchangTotalMoneyLab.text = [NSString stringWithFormat:@"筹码总额:%d",chipAllMoney];
                self.exchangMoneyLab.text = [NSString stringWithFormat:@"应付金额:%d",chipAllMoney];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
                [self clearCustomerInfo];
            }else if (self.chipOperationType==4){//结算小费
                self.tipSettlementTableView.hidden = NO;
                self.operationButton.hidden = NO;
                self.tipSettlementView.hidden = YES;
                [self.operationButton setTitle:@"  继续结算  " forState:UIControlStateNormal];
                [self.tipSettlementTableView reloadData];
                //结算信息
                self.tipSettlementNumberLab.text = [NSString stringWithFormat:@"筹码数量:%ld",(long)self.chipCount];
                self.tipSettlementTotalMoneyLab.text = [NSString stringWithFormat:@"筹码总额:%d",chipAllMoney];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
            }else if (self.chipOperationType==5){//存入筹码
                self.storageChipTableView.hidden = NO;
                self.operationButton.hidden = NO;
                self.storageChipView.hidden = YES;
                [self.operationButton setTitle:@"  继续存入  " forState:UIControlStateNormal];
                [self.storageChipTableView reloadData];
                //结算信息
                self.storageChipNumberLab.text = [NSString stringWithFormat:@"筹码数量:%ld",(long)self.chipCount];
                self.storageChipTotalMoneyLab.text = [NSString stringWithFormat:@"筹码总额:%d",chipAllMoney];
                self.viewModel.chipInfo.userAllMoney = [NSString stringWithFormat:@"%d",chipAllMoney];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
            }else if (self.chipOperationType==6){//取出筹码
                self.takeOutChipTableView.hidden = NO;
                self.operationButton.hidden = NO;
                self.takeOutChipView.hidden = YES;
                [self.operationButton setTitle:@"  继续识别  " forState:UIControlStateNormal];
                [self.takeOutChipTableView reloadData];
                //结算信息
                self.takeOutChipNumberLab.text = [NSString stringWithFormat:@"筹码数量:%ld",(long)self.chipCount];
                self.takeOutChipTotalMoneyLab.text = [NSString stringWithFormat:@"筹码总额:%d",chipAllMoney];
                //响警告声音
                [EPSound playWithSoundName:@"succeed_sound"];
                self.viewModel.chipInfo.userAllMoney = [NSString stringWithFormat:@"-%d",chipAllMoney];
            }
            [self hideWaitingView];
        }
    }
}

#pragma mark -- 模型模版
- (NRChipManagerInfo *)managerModel{
    NRChipManagerInfo *staticInfo = [[NRChipManagerInfo alloc]init];
    staticInfo.chipType = @"筹码类型";
    staticInfo.batch = @"批次号";
    staticInfo.serialNumber = @"序列号";
    staticInfo.denomination = @"面额";
    staticInfo.washNumber = @"洗码号";
    staticInfo.status = @"状态";
    return staticInfo;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
