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

@interface DealerManagementViewController ()<UITableViewDelegate,UITableViewDataSource,GCDAsyncSocketDelegate>

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
//上级信息
@property (nonatomic, strong) UILabel *superiorInfoLab;
@property (nonatomic, strong) UILabel *superiorNameLab;
@property (nonatomic, strong) UILabel *superiorWashNumberLab;
@property (nonatomic, strong) UILabel *superiorMoneyLab;
@property (nonatomic, strong) UILabel *superiorTellLab;
//当前客人
@property (nonatomic, strong) UILabel *curCustomerInfoLab;
@property (nonatomic, strong) UILabel *curCustomerWashNumberLab;
@property (nonatomic, strong) UILabel *curCustomerNameLab;
@property (nonatomic, strong) UILabel *curCustomerTellLab;

@property (nonatomic, strong) NSMutableArray *cashExchangeList;
@property (nonatomic, strong) UITextField *cashCodeTextField;
@property (nonatomic, strong) UITextField *authorizationTextField;//授权
@property (nonatomic, strong) UITextField *noteTextField;//备注
@property (nonatomic, strong) UIButton *cashExchangeConfirmButton;
@property (nonatomic, strong) UIImageView *exchangeImage;
@property (nonatomic, strong) UILabel *exchangeTipsLab;

@property (nonatomic, strong) NRChipManagerInfo *staticInfo;
@property (nonatomic, strong) NRChipInfoModel *curChipInfo;
@property (nonatomic, assign) NSInteger chipCount;
@property (nonatomic, strong) NSArray *chipUIDList;


@property (nonatomic, strong) NSString *lastTextContent;
@property (nonatomic, assign) BOOL isReadChip;//是否读取筹码
@property (nonatomic, assign) BOOL isIssue;//是否发行
@property (nonatomic, assign) BOOL isDestoryChip;//是否销毁筹码
@property (nonatomic, assign) BOOL isExchangeChip;//是否兑换筹码
@property (nonatomic, assign) BOOL readChipCount;//检测是否有筹码
@property (nonatomic, assign) BOOL isSetUpDeviceModel;//设置读写器模式

// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSMutableData *chipUIDData;

@end

@implementation DealerManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    self.chipUIDData = [NSMutableData data];
    
    self.staticInfo = [[NRChipManagerInfo alloc]init];
    self.staticInfo.serialNumber = @"序列号";
    self.staticInfo.chipType = @"筹码类型";
    self.staticInfo.denomination = @"面额";
    self.staticInfo.batch = @"批次";
    self.staticInfo.status = @"状态";
    
    self.curChipInfo = [[NRChipInfoModel alloc]init];
    self.curChipInfo.fcredit = @"0";
    self.curChipInfo.authorName = @"";
    self.curChipInfo.notes = @"";
    
    self.chipCheckList = [NSMutableArray arrayWithCapacity:0];
    self.chipIssueList = [NSMutableArray arrayWithCapacity:0];
    self.choosedSerNumberList = [NSMutableArray arrayWithCapacity:0];
    self.chipDestructList = [NSMutableArray arrayWithCapacity:0];
    self.cashExchangeList = [NSMutableArray arrayWithCapacity:0];
    
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
    
    //筹码管理界面
    [self chipManagerView];
    //筹码检测界面
    [self chipCheckShowView];
    //筹码销毁界面
    [self chipDestructShowView];
    //筹码兑换界面
    [self chipExchangeShowView];
    
    @weakify(self);
    [self.viewModel getChipTypeWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //筹码发行界面
            [self chipIssueShowView];
        });
    }];
    
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
                                self.superiorNameLab.text = [NSString stringWithFormat:@"代理姓名: %@",self.viewModel.customerInfoDict[@"agent_name"]];
                                self.superiorWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",self.viewModel.customerInfoDict[@"agent_xmh"]];
                                self.superiorMoneyLab.text = [NSString stringWithFormat:@"风 险 金: %@",self.viewModel.customerInfoDict[@"risk_money"]];
                                self.superiorTellLab.text = [NSString stringWithFormat:@"联系电话: %@",self.viewModel.customerInfoDict[@"agent_phone"]];
                                
                                self.curCustomerNameLab.text = [NSString stringWithFormat:@"客人姓名: %@",self.viewModel.customerInfoDict[@"member_name"]];
                                self.curCustomerWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",self.viewModel.customerInfoDict[@"member_xmh"]];
                                self.curCustomerTellLab.text = [NSString stringWithFormat:@"联系电话: %@",self.viewModel.customerInfoDict[@"member_phone"]];
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
    
    
}

#pragma mark -- 清除代理信息
- (void)clearCustomerInfo{
    
    self.superiorNameLab.text = @"代理姓名: --";
    self.superiorWashNumberLab.text = @"洗 码 号: --";
    self.superiorMoneyLab.text = @"风 险 金: --";
    self.superiorTellLab.text = [NSString stringWithFormat:@"联系电话: %@",@"--"];
    
    self.curCustomerNameLab.text = [NSString stringWithFormat:@"客人姓名: %@",@"--"];
    self.curCustomerWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",@"--"];
    self.curCustomerTellLab.text = [NSString stringWithFormat:@"联系电话: %@",@"--"];
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
    self.viewModel.chipInfo.bind_ip = @"192.168.1.192";
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
    [self.serialNumberTextFiled setValue:[UIColor colorWithHexString:@"#ffffff"] forKeyPath:@"_placeholderLabel.textColor"];
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
    [self.batchTextFiled setValue:[UIColor colorWithHexString:@"#ffffff"] forKeyPath:@"_placeholderLabel.textColor"];
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
    [checkButton addTarget:self action:@selector(checkChipAction) forControlEvents:UIControlEventTouchUpInside];
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
        
        self.curCustomerInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.superiorTellLab.frame)+10, label_width, 20)];
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

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    [self.titleBar setTitle:@"VM娱乐桌面跟踪系统"];
    [self setLeftItemForGoBack];
    self.titleBar.showBottomLine = YES;
    [self configureTitleBarToBlack];
    @weakify(self);
    self.titleBar.rightItem = [[EPTitleBarItem alloc]initWithImage:nil BackImage:[UIImage imageNamed:@"button_selected"] Text:@"识别筹码" tintColor:[UIColor whiteColor] block:^{
        @strongify(self);
        [self readCurDeviceChip];
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
    self.viewModel.chipInfo.chipsUIDs = [NSArray array];
    self.isReadChip = YES;
    //查询筹码个数
    [self.clientSocket writeData:[NRCommand nextQueryChipNumbers] withTimeout:- 1 tag:0];
}

#pragma mark - 筹码发行
- (void)chipIssueAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 0;
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
    
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
}

#pragma mark - 立即发行
-(void)chipIssueImmediatelyAction{
    //写入数据
    if ([self.curChipInfo.chipType isEqualToString:@"99"]) {
        [self hideWaitingView];
        [self showMessage:@"不能发行已销毁的筹码"];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    self.isIssue = YES;
    self.curChipInfo.chipBatch = self.batchTextFiled.text;
    self.viewModel.chipInfo.chipsUIDs = self.chipUIDList;
    self.curChipInfo.chipSerialNumber = self.serialNumberTextFiled.text;
    self.viewModel.chipModel = self.curChipInfo;
    [self.viewModel IssueChipsWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            /*创建一个串行队列
             第一个参数：队列名称
             第二个参数：队列类型
             */
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.curChipInfo.chipUID = self.chipUIDList[i];
                        int seriNumber = [self.serialNumberTextFiled.text intValue]+i;
                        NSString *hexString_seriNumber = [NRCommand getHexByDecimal:seriNumber];
                        if (hexString_seriNumber.length==1) {
                            self.curChipInfo.chipSerialNumber = [NSString stringWithFormat:@"0%@",hexString_seriNumber];
                        }else{
                            self.curChipInfo.chipSerialNumber = hexString_seriNumber;
                        }
                        //向指定标签中写入数据（块1）
                        [self.clientSocket writeData:[NRCommand writeInfoToChip1WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                        usleep((int)self.chipUIDList.count * 10000);
                        //向指定标签中写入数据（块2）
                        [self.clientSocket writeData:[NRCommand writeInfoToChip2WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
                        usleep((int)self.chipUIDList.count * 10000);
                    });
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

#pragma mark - 筹码检测
- (void)chipCheckAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 1;
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
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
}

#pragma mark - 开始检测
- (void)checkChipAction{
    [self.viewModel Cmpublish_checkStateWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            [self.chipCheckList removeAllObjects];
            //初始化筹码检测
            NRChipManagerInfo *checkstaticInfo = [[NRChipManagerInfo alloc]init];
            checkstaticInfo.chipType = @"筹码类型";
            checkstaticInfo.batch = @"批次号";
            checkstaticInfo.serialNumber = @"序列号";
            checkstaticInfo.denomination = @"面额";
            checkstaticInfo.washNumber = @"洗码号";
            checkstaticInfo.status = @"状态";
            [self.chipCheckList addObject:checkstaticInfo];
            
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
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
}

#pragma mark - 筹码兑换
- (void)chipExchangeAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipOperationType = 3;
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
    [self.chipIssueButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipCheckButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipDestructButton setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    [self.chipExchangeButton setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
}

#pragma mark - 读取筹码信息
- (void)readAllChipsInfo{
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
    }else if (self.chipOperationType==3){//开始读取d
        if ([self.operationButton.titleLabel.text isEqualToString:@"  开始读取  "]) {
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
                        [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
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
                        [self.clientSocket writeData:[NRCommand writeInfoToChip3WithChipInfo:self.curChipInfo] withTimeout:- 1 tag:0];
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
    BLEIToll *itool = [[BLEIToll alloc]init];
    NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
    if (self.isReadChip) {//正在识别筹码
        self.chipUIDData = nil;
        self.isReadChip = NO;
        if ([chipNumberdataHexStr hasSuffix:@"04000e2cb3"]) {//检测到结束字符,识别筹码UID完毕
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
            if (self.chipOperationType==2||self.chipOperationType==3){
                self.cashCodeTextField.text = @"";
                self.authorizationTextField.text = @"";
                self.noteTextField.text = @"";
                [self readAllChipsInfo];
            }
        }
    }else if ([dataHexStr containsString:@"040000525a"]) {
        NSString *allSucceeddataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        NSInteger succeedCount = [[allSucceeddataHexStr mutableCopy] replaceOccurrencesOfString:@"040000525a"
                                                                              withString:@"040000525a"
                                                                                 options:NSLiteralSearch
                                                                                   range:NSMakeRange(0, [allSucceeddataHexStr length])];
        if (self.isIssue&&(succeedCount==2*self.chipCount)) {
            self.chipUIDData = nil;
            self.isIssue = NO;
            [self showMessage:@"发行成功" withSuccess:YES];
            [self readAllChipsInfo];
            [self hideWaitingView];
            //响警告声音
           [EPSound playWithSoundName:@"succeed_sound"];
        }else if (self.isDestoryChip&&(succeedCount==self.chipCount)){
            self.chipUIDData = nil;
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
        }else if (self.isExchangeChip&&(succeedCount==self.chipCount)){
            self.chipUIDData = nil;
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
        }
    }else if ([dataHexStr hasPrefix:@"13000000"]){
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"040000525a" withString:@""];
        chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"04000e2cb3" withString:@""];
        chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"050020a04feb" withString:@""];
        NSInteger count = [[chipNumberdataHexStr mutableCopy] replaceOccurrencesOfString:@"13000000" // 要查询的字符串中的某个字符
                                                                              withString:@"13000000"
                                                                                 options:NSLiteralSearch
                                                                                   range:NSMakeRange(0, [chipNumberdataHexStr length])];
        if (count==self.chipCount) {
            self.chipUIDData = nil;
            //解析筹码
            NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr WithSplitSize:3];
            DLOG(@"chipInfo = %@",chipInfo);
            if (self.chipOperationType==0) {//筹码发行
                [self.chipIssueList removeAllObjects];
                NRChipManagerInfo *staticInfo = [[NRChipManagerInfo alloc]init];
                staticInfo.serialNumber = @"序列号";
                staticInfo.chipType = @"筹码类型";
                staticInfo.denomination = @"面额";
                staticInfo.batch = @"批次";
                staticInfo.status = @"状态";
                [self.chipIssueList addObject:staticInfo];
            }else if (self.chipOperationType==2){//筹码销毁
                [self hideWaitingView];
                [self.chipDestructList removeAllObjects];
                NRChipManagerInfo *staticInfo = [[NRChipManagerInfo alloc]init];
                staticInfo.serialNumber = @"序列号";
                staticInfo.chipType = @"筹码类型";
                staticInfo.denomination = @"面额";
                staticInfo.batch = @"批次";
                staticInfo.status = @"状态";
                [self.chipDestructList addObject:staticInfo];
            }else if (self.chipOperationType==3){//筹码兑换
                [self.cashExchangeList removeAllObjects];
                //初始化现金兑换筹码的数据
                NRChipManagerInfo *exchangestaticInfo = [[NRChipManagerInfo alloc]init];
                exchangestaticInfo.chipType = @"筹码类型";
                exchangestaticInfo.batch = @"批次号";
                exchangestaticInfo.serialNumber = @"序列号";
                exchangestaticInfo.denomination = @"面额";
                exchangestaticInfo.washNumber = @"洗码号";
                exchangestaticInfo.status = @"状态";
                [self.cashExchangeList addObject:exchangestaticInfo];
            }
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
                if (self.chipOperationType==0) {
                    //发行数据
                    NRChipManagerInfo *chipinfo = [[NRChipManagerInfo alloc]init];
                    chipinfo.serialNumber = serialNumber;
                    chipinfo.chipType = chipType;
                    chipAllMoney += [realmoney intValue];
                    chipinfo.denomination = realmoney;
                    chipinfo.batch = batch;
                    chipinfo.status = statusString;
                    [self.chipIssueList addObject:chipinfo];
                }else if (self.chipOperationType==2){//销毁
                    //销毁数据
                    NRChipManagerInfo *chipinfo = [[NRChipManagerInfo alloc]init];
                    chipinfo.serialNumber = serialNumber;
                    chipinfo.chipType = chipType;
                    chipAllMoney += [realmoney intValue];
                    chipinfo.denomination = realmoney;
                    chipinfo.batch = batch;
                    chipinfo.status = statusString;
                    if ([chipType intValue]!=99) {
                        [self.chipDestructList addObject:chipinfo];
                    }
                }else if (self.chipOperationType==3){//兑换
                    //存储兑换数据
                    NRChipManagerInfo *exchangeInfo = [[NRChipManagerInfo alloc]init];
                    exchangeInfo.chipType = chipType;
                    exchangeInfo.batch = batch;
                    chipAllMoney += [realmoney intValue];
                    exchangeInfo.serialNumber = serialNumber;
                    exchangeInfo.denomination = realmoney;
                    exchangeInfo.washNumber = washNumber;
                    exchangeInfo.status = statusString;
                    [self.cashExchangeList addObject:exchangeInfo];
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.chipOperationType==0) {//发行
                    self.chipIssueTableView.hidden = NO;
                    self.chipIssueView.hidden = YES;
                    self.operationButton.hidden = NO;
                    self.scanChipNumberLab.hidden = YES;
                    [self.operationButton setTitle:@"  继续发行  " forState:UIControlStateNormal];
                    [self.chipIssueTableView reloadData];
                    //响警告声音
                    [EPSound playWithSoundName:@"succeed_sound"];
                    [self hideWaitingView];
                }else if (self.chipOperationType==2){//销毁
                    [self hideWaitingView];
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
                    [self hideWaitingView];
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
                    [self hideWaitingView];
                    [self clearCustomerInfo];
                }
            });
        }
    }
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
