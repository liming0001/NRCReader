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
#import "BLEIToll.h"
#import "ChipManagerLeftItem.h"
#import "ChipIssueView.h"
#import "ChipNormalReadView.h"
#import "ChipExchangeView.h"
#import "ChipInfoListTableView.h"
#import "CustomerInfoFooter.h"

#define channelOnPeropheralView @"peripheralView"

@interface DealerManagementViewController ()<SGSocketManagerDelegate>

@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *loginRoleLab;
@property (nonatomic, strong) UILabel *IDLab;
@property (nonatomic, strong) UILabel *scanChipNumberLab;
@property (nonatomic, strong) UIView *toplineView;
@property (nonatomic, strong) ChipInfoListTableView *chipListTableView;

//筹码管理
@property (nonatomic, strong) ChipManagerLeftItem *leftItemView;
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, assign) int chipOperationType;

//筹码发行
@property (nonatomic, strong) ChipIssueView *chipIssueView;
@property (nonatomic, strong) NSMutableArray *chipIssueList;
//筹码检测
@property (nonatomic, strong) ChipNormalReadView *chipNormalReadView;
@property (nonatomic, strong) NSMutableArray *chipCheckList;//筹码检测
@property (nonatomic, strong) NSMutableArray *chipDestroyList;//筹码销毁
@property (nonatomic, strong) NSMutableArray *tipSettlementList;//小费结算
@property (nonatomic, strong) NSMutableArray *storageChipList;//存入筹码
@property (nonatomic, strong) NSMutableArray *takeOutChipList;//取出筹码
//筹码兑换
@property (nonatomic, strong) ChipExchangeView *chipExchangeView;
@property (nonatomic, strong) NSMutableArray *chipExchangeList;

@property (nonatomic, assign) NSInteger chipCount;
@property (nonatomic, strong) NSArray *chipUIDList;

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
@property (nonatomic, strong) NSMutableData *chipUIDData;

@end

@implementation DealerManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chipIssueList = [NSMutableArray arrayWithCapacity:0];
    self.chipCheckList = [NSMutableArray arrayWithCapacity:0];
    self.chipDestroyList = [NSMutableArray arrayWithCapacity:0];
    self.chipExchangeList = [NSMutableArray arrayWithCapacity:0];
    self.tipSettlementList = [NSMutableArray arrayWithCapacity:0];
    self.storageChipList = [NSMutableArray arrayWithCapacity:0];
    self.takeOutChipList = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    CGFloat fontSize = 16;
    self.userNameLab = [UILabel new];
    self.userNameLab.textColor = [UIColor colorWithHexString:@"#959595"];
    self.userNameLab.font = [UIFont systemFontOfSize:fontSize];
    self.userNameLab.text = [NSString stringWithFormat:@"姓名:%@",self.viewModel.loginInfo.femp_xm];
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
    self.IDLab.text = [NSString stringWithFormat:@"ID:%@",self.viewModel.loginInfo.fid];
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
    self.scanChipNumberLab.text = @"";
    [self.view addSubview:self.scanChipNumberLab];
    [self.scanChipNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-140);
        make.height.mas_equalTo(20);
    }];
    
    self.toplineView = [UIView new];
    self.toplineView.backgroundColor = [UIColor colorWithHexString:@"#959595"];
    [self.view addSubview:self.toplineView];
    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(40);
        make.left.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.mas_offset(0.5);
    }];
    
    CGFloat item_topMas = [EPTitleBar heightForTitleBarPlusStatuBar]+40;
    CGFloat item_ViewH = kScreenHeight- item_topMas;
    CGFloat item_ViewW = kScreenWidth- 200;
    CGRect allView_frame = CGRectMake(200, item_topMas, item_ViewW, item_ViewH);
    self.leftItemView = [[ChipManagerLeftItem alloc]initWithFrame:CGRectMake(0, item_topMas, 200, item_ViewH)];
    [self.view addSubview:self.leftItemView];
    
    //筹码信息列表界面
    self.chipListTableView = [[ChipInfoListTableView alloc]initWithFrame:allView_frame];
    self.chipListTableView.hidden = YES;
    [self.view addSubview:self.chipListTableView];
    
    //筹码发行界面
    self.chipIssueView = [[ChipIssueView alloc]initWithFrame:allView_frame];
    [self.view addSubview:self.chipIssueView];
    
    //筹码检测界面
    self.chipNormalReadView = [[ChipNormalReadView alloc]initWithFrame:allView_frame];
    self.chipNormalReadView.hidden = YES;
    [self.view addSubview:self.chipNormalReadView];
    
    //筹码兑换
    self.chipExchangeView = [[ChipExchangeView alloc]initWithFrame:allView_frame];
    self.chipExchangeView.hidden = YES;
    [self.view addSubview:self.chipExchangeView];
    
    //连接Socket
    [self openOrCloseSocket];
    
    //左边视图按钮事件
    @weakify(self);
    self.leftItemView.bottomBtnBlock = ^(NSInteger tag) {
        @strongify(self);
        self.chipOperationType = (int)tag;
        if (tag==0) {//发行
            self.chipNormalReadView.hidden = YES;
            self.chipExchangeView.hidden = YES;
            if (self.chipIssueList.count!=0) {
                self.scanChipNumberLab.hidden = NO;
                self.chipIssueView.hidden = YES;
                self.chipListTableView.hidden = NO;
                self.operationButton.hidden = NO;
                [self.chipListTableView fellWithInfoList:self.chipIssueList WithType:(int)tag];
                [self.operationButton setTitle:@"  继续发行  " forState:UIControlStateNormal];
            }else{
                self.operationButton.hidden = YES;
                self.chipIssueView.hidden = NO;
                self.chipListTableView.hidden = YES;
            }
        }else if (tag==3){//兑换
            self.chipListTableView.hidden = YES;
            self.chipIssueView.hidden = YES;
            self.chipNormalReadView.hidden = YES;
            self.chipExchangeView.hidden = NO;
            if (self.chipExchangeList.count!=0) {
                self.operationButton.hidden = NO;
                self.chipExchangeView.hidden = YES;
                self.chipListTableView.hidden = NO;
                [self.chipListTableView fellWithInfoList:self.chipExchangeList WithType:(int)tag];
                [self.operationButton setTitle:@"  继续兑换  " forState:UIControlStateNormal];
            }else{
                self.operationButton.hidden = YES;
                self.chipExchangeView.hidden = NO;
                self.chipListTableView.hidden = YES;
            }
        }else{
            self.chipIssueView.hidden = YES;
            self.chipExchangeView.hidden = YES;
            NSArray *normalList = nil;
            if (tag==1) {//筹码检测
                normalList = self.chipCheckList;
                [self.operationButton setTitle:@"  继续检测  " forState:UIControlStateNormal];
            }else if (tag==2){
                normalList = self.chipDestroyList;
                [self.operationButton setTitle:@"  继续销毁  " forState:UIControlStateNormal];
            }else if (tag==4){
                normalList = self.tipSettlementList;
                [self.operationButton setTitle:@"  继续结算  " forState:UIControlStateNormal];
            }else if (tag==5){
                [PublicHttpTool shareInstance].isStoreOrTakeOutChip = YES;
                [PublicHttpTool shareInstance].userAllMoney = [NSString stringWithFormat:@"%d",[[PublicHttpTool shareInstance].userAllMoney intValue]];
                normalList = self.storageChipList;
                [self.operationButton setTitle:@"  继续存入  " forState:UIControlStateNormal];
            }else if (tag==6){
                [PublicHttpTool shareInstance].isStoreOrTakeOutChip = NO;
                [PublicHttpTool shareInstance].userAllMoney = [NSString stringWithFormat:@"%d",-[[PublicHttpTool shareInstance].userAllMoney intValue]];
                normalList = self.takeOutChipList;
                [self.operationButton setTitle:@"  继续取出  " forState:UIControlStateNormal];
            }
            if (normalList.count!=0) {
                self.operationButton.hidden = NO;
                self.chipNormalReadView.hidden = YES;
                self.chipListTableView.hidden = NO;
                [self.chipListTableView fellWithInfoList:normalList WithType:(int)tag];
            }else{
                self.operationButton.hidden = YES;
                self.chipNormalReadView.hidden = NO;
                self.chipListTableView.hidden = YES;
            }
            [self.chipNormalReadView _setUpChipViewWithTag:tag];
        }
    };
    //兑换界面按钮事件
    self.chipExchangeView.exchangeBtnBlock = ^(NSInteger tag) {
        @strongify(self);
        self.chipExchangeView.hidden = YES;
        self.chipNormalReadView.hidden = NO;
        [PublicHttpTool shareInstance].exchangeChipType = (int)tag;
        [self.chipNormalReadView _setUpChipViewWithTag:3];
        if (tag==0) {
            [PublicHttpTool shareInstance].fcredit = @"0";
        }else{
            [PublicHttpTool shareInstance].fcredit = @"1";
        }
    };
    //筹码发行事件
    self.chipIssueView.issueBtnBlock = ^(NSDictionary * _Nonnull issueDict) {
        @strongify(self);
        self.viewModel.chipModel.chipBatch = issueDict[@"chipBatch"];
        self.viewModel.chipModel.chipSerialNumber = issueDict[@"chipSerialNumber"];
        self.viewModel.chipModel.chipDenomination = issueDict[@"chipMoney"];
        self.viewModel.chipModel.chipType = issueDict[@"chipType"];
        [self readCurDeviceChipNumbers];
    };
    //筹码读取事件
    self.chipNormalReadView.chipReadBtnBlock = ^(NSInteger tag) {
        @strongify(self);
        [self _resetAllOpretionConditions];
        [self readCurDeviceChipNumbers];
    };
    //列表展示事件
    self.chipListTableView.chipTableBlock = ^(NSInteger tag) {
        @strongify(self);
        DLOG(@"tag==%ld",tag);
        if (tag==2) {//筹码销毁
            [self destoryChipListAction];
        }else if (tag==3){//筹码兑换
            [self cashExchangeConfirmAction];
        }else if (tag==4){//小费结算
            [self tipSettlementSoonConfirmAction];
        }else if (tag==5){//存入筹码
            [self storageChipSoonConfirmAction];
        }else if (tag==6){//取出筹码
            [self takeOutConfirmAction];
        }
    };
}

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    [self.titleBar setTitle:@"VM娱乐筹码管理"];
    [self setLeftItemForGoBack];
    self.titleBar.showBottomLine = YES;
    [self configureTitleBarToBlack];
}

#pragma mark -- 开启或者关闭Sockket
- (void)openOrCloseSocket{
//    [EPAppData sharedInstance].bind_ip = @"192.168.1.192";
    [EPAppData sharedInstance].bind_port = 6000;
    [SGSocketManager ConnectSocketWithConfigM:[SGSocketConfigM ShareInstance] complation:^(NSError *error) {
        DLOG(@"error===%@",error);
        if (!error) {
            [self closeDeviceWorkModel];
        }
    }];
    [SGSocketManager shareInstance].delegate = self;
    [[SGSocketManager shareInstance] startPingTimer];//开启心跳
}

#pragma mark -- 重置所有操作判断条件
- (void)_resetAllOpretionConditions{
    self.isReadChip = NO;
    self.isIssue = NO;
    self.isDestoryChip = NO;
    self.isExchangeChip = NO;
    self.isAdjustPower = NO;
    self.isSettlementTipChip = NO;
    self.isStorageChip = NO;
    self.isTakeOutChip = NO;
    self.readChipCount = NO;
    self.isSetUpDeviceModel = NO;
}

#pragma mark -- 识别当前筹码个数
- (void)readCurDeviceChipNumbers{
    if (![PublicHttpTool socketNoConnectedShow]) {
        return;
    }
    [PublicHttpTool showWaitingView];
    self.chipUIDList = nil;
    self.chipUIDData = nil;
    self.isReadChip = YES;
    //查询筹码个数
    [SGSocketManager SendDataWithData:[NRCommand nextQueryChipNumbers]];
}

#pragma mark - 立即发行
-(void)chipIssueImmediatelyAction{
    self.isIssue = YES;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //写入数据
            [self.viewModel IssueChipsWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                if (success) {
                    int sleepTime = (int)self.chipUIDList.count * 15000;
                    for (int i = 0; i < self.chipUIDList.count; i++) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            int seriNumber = [self.viewModel.chipModel.chipSerialNumber intValue]+i;
                            NSString *hexString_seriNumber = [NRCommand getHexByDecimal:seriNumber];
                            self.viewModel.chipModel.chipSerialNumber = hexString_seriNumber;
                            self.viewModel.chipModel.chipUID = self.chipUIDList[i];
                            //向指定标签中写入数据（块1(筹码序列号，类型)）
                            [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip1WithChipInfo:self.viewModel.chipModel]];
                            usleep(sleepTime);
                            //向指定标签中写入数据（块2(筹码金额)）
                            [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip2WithChipInfo:self.viewModel.chipModel]];
                            usleep(sleepTime);
                            //向指定标签中写入数据（块3(筹码批次号)）
                            [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip3WithChipInfo:self.viewModel.chipModel]];
                            usleep(sleepTime);
                        });
                    }
                }else{
                    [PublicHttpTool showSoundMessage:msg];
                }
            }];
        });
    });
}

#pragma mark - 筹码检测
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
                [self.chipCheckList addObject:[self errorChipinfoModel]];
            }
            self.chipNormalReadView.hidden = YES;
            self.chipListTableView.hidden = NO;
            [self.chipListTableView fellWithInfoList:self.chipCheckList WithType:1];
            self.operationButton.hidden = NO;
            [self.operationButton setTitle:@"  继续检测  " forState:UIControlStateNormal];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
            [self hideWaitingView];
        }else{
            [PublicHttpTool showSoundMessage:msg];
        }
    }];
}

#pragma mark -- 销毁筹码
- (void)destoryChipListAction{
    @weakify(self);
    [EPPopView showInWindowWithMessage:@"确定销毁?" handler:^(int buttonType) {
        DLOG(@"buttonType = %d",buttonType);
        @strongify(self);
        if (buttonType==0) {
            self.isDestoryChip = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showWaitingViewWithText:@"销毁中..."];
            });
            [self.viewModel cmDestoryWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                if (success) {
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            //写入数据
                            int sleepTime = (int)self.chipUIDList.count * 15000;
                            for (int i = 0; i < self.chipUIDList.count; i++) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.viewModel.chipModel.guestWashesNumber= @"99";
                                    self.viewModel.chipModel.chipUID = self.chipUIDList[i];
                                    [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip4WithChipInfo:self.viewModel.chipModel WithBlockNumber:@"04"]];
                                    usleep(sleepTime);
                                    [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip4WithChipInfo:self.viewModel.chipModel WithBlockNumber:@"05"]];
                                    usleep(sleepTime);
                                });
                            }
                        });
                    });
                }else{
                    self.isDestoryChip = NO;
                    [PublicHttpTool showSoundMessage:msg];
                }
            }];
        }
    }];
}

#pragma mark - 确认现金换筹码
- (void)cashExchangeConfirmAction{
    if ([PublicHttpTool shareInstance].exchangeChipType==0||[PublicHttpTool shareInstance].exchangeChipType==2) {//现金换筹码||信用出码
        if ([[PublicHttpTool shareInstance].exchangeWashNumber length]==0) {
            [PublicHttpTool showSoundMessage:@"洗码号错误"];
            return;
        }
        self.viewModel.chipModel.guestWashesNumber  = [PublicHttpTool shareInstance].exchangeWashNumber;
        [EPSound playWithSoundName:@"click_sound"];
        if ([PublicHttpTool shareInstance].exchangeChipType==2) {
            [self showWaitingViewWithText:@"出码中..."];
        }else{
            [self showWaitingViewWithText:@"兑换中..."];
        }
        self.isExchangeChip = YES;
        [self.viewModel CashExchangeChipWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
            if (success) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        //写入数据
                        int sleepTime = (int)self.chipUIDList.count * 15000;
                        for (int i = 0; i < self.chipUIDList.count; i++) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.viewModel.chipModel.chipUID = self.chipUIDList[i];
                                [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip4WithChipInfo:self.viewModel.chipModel WithBlockNumber:@"04"]];
                                usleep(sleepTime);
                                [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip4WithChipInfo:self.viewModel.chipModel WithBlockNumber:@"05"]];
                                usleep(sleepTime);
                            });
                        }
                    });
                });
            }else{
                [PublicHttpTool showSoundMessage:msg];
            }
        }];
    }else if ([PublicHttpTool shareInstance].exchangeChipType==1){//筹码换现金
        self.viewModel.chipModel.guestWashesNumber  = @"00000000";
        [self showWaitingViewWithText:@"兑换中..."];
        self.isExchangeChip = YES;
        [self.viewModel ChipExchangeCashWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
            if (success) {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        //写入数据
                        int sleepTime = (int)self.chipUIDList.count * 15000;
                        for (int i = 0; i < self.chipUIDList.count; i++) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.viewModel.chipModel.chipUID = self.chipUIDList[i];
                                [SGSocketManager SendDataWithData:[NRCommand clearWashNumberWithChipInfo:self.viewModel.chipModel.chipUID WithBlockNumber:@"04"]];
                                usleep(sleepTime);
                                [SGSocketManager SendDataWithData:[NRCommand clearWashNumberWithChipInfo:self.viewModel.chipModel.chipUID WithBlockNumber:@"05"]];
                                usleep(sleepTime);
                            });
                        }
                    });
                });
            }else{
                [PublicHttpTool showSoundMessage:msg];
            }
        }];
    }
    
}

#pragma mark -- 立即结算
- (void)tipSettlementSoonConfirmAction{
    self.isSettlementTipChip = YES;
    [PublicHttpTool showWaitingView];
    [self.viewModel TipSettlementWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                int sleepTime = (int)self.chipUIDList.count * 15000;
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *chipUID = self.chipUIDList[i];
                        //向指定标签中写入数据（块1）
                        [SGSocketManager SendDataWithData:[NRCommand clearWashNumberWithChipInfo:chipUID WithBlockNumber:@"04"]];
                        usleep(sleepTime);
                        [SGSocketManager SendDataWithData:[NRCommand clearWashNumberWithChipInfo:chipUID WithBlockNumber:@"05"]];
                        usleep(sleepTime);
                    });
                }
            });
        }else{
            self.isSettlementTipChip = NO;
            [PublicHttpTool showSoundMessage:msg];
        }
    }];
}

#pragma mark -- 立即存入
- (void)storageChipSoonConfirmAction{
    self.isStorageChip = YES;
    [PublicHttpTool showWaitingView];
    [self.viewModel AccessChipWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                int sleepTime = (int)self.chipUIDList.count * 15000;
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    NSString *chipUID = self.chipUIDList[i];
                    //向指定标签中写入数据（块1）
                    [SGSocketManager SendDataWithData:[NRCommand clearWashNumberWithChipInfo:chipUID WithBlockNumber:@"04"]];
                    usleep(sleepTime);
                    [SGSocketManager SendDataWithData:[NRCommand clearWashNumberWithChipInfo:chipUID WithBlockNumber:@"05"]];
                    usleep(sleepTime);
                }
            });
        }else{
            self.isStorageChip = NO;
            [PublicHttpTool showSoundMessage:msg];
        }
    }];
}

#pragma mark -- 立即取出
- (void)takeOutConfirmAction{
    if ([PublicHttpTool shareInstance].exchangeWashNumber.length==0) {
        [self showMessage:@"请输入洗码号"];
        return;
    }
    if ([[[PublicHttpTool shareInstance].takeOutPsd NullToBlankString]length]==0) {
        [self showMessage:@"请输入密码"];
        return;
    }
    self.viewModel.chipModel.guestWashesNumber  = [PublicHttpTool shareInstance].exchangeWashNumber;
    [EPSound playWithSoundName:@"click_sound"];
    self.isTakeOutChip = YES;
    [PublicHttpTool showWaitingView];
    [self.viewModel AccessChipWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                int sleepTime = (int)self.chipUIDList.count * 15000;
                for (int i = 0; i < self.chipUIDList.count; i++) {
                    self.viewModel.chipModel.chipUID = self.chipUIDList[i];
                    [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip4WithChipInfo:self.viewModel.chipModel WithBlockNumber:@"04"]];
                    usleep(sleepTime);
                    [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip4WithChipInfo:self.viewModel.chipModel WithBlockNumber:@"05"]];
                    usleep(sleepTime);
                }
            });
        }else{
            self.isTakeOutChip = NO;
            [PublicHttpTool showSoundMessage:msg];
        }
    }];
}

#pragma mark - 读取筹码信息
- (void)readAllChipsInfo{
    self.chipUIDData = nil;
    [self.chipIssueList removeAllObjects];
    for (int i = 0; i < self.chipUIDList.count; i++) {
        NSString *chipID = self.chipUIDList[i];
        [SGSocketManager SendDataWithData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID]];
        usleep((int)self.chipUIDList.count * 10000);
    }
}

#pragma mark - 操作步骤
- (void)operationAction{
    [EPSound playWithSoundName:@"click_sound"];
    self.chipListTableView.hidden = YES;
    self.operationButton.hidden = YES;
    if (self.chipOperationType==0) {//继续发行
        [self.chipIssueList removeAllObjects];
        self.chipNormalReadView.hidden = YES;
        self.chipExchangeView.hidden = YES;
        self.chipIssueView.hidden = NO;
    }else if (self.chipOperationType==3){//筹码兑换
        [self.chipExchangeList removeAllObjects];
        self.chipNormalReadView.hidden = YES;
        self.chipExchangeView.hidden = NO;
        self.chipIssueView.hidden = YES;
    }else{
        self.chipNormalReadView.hidden = NO;
        self.chipExchangeView.hidden = YES;
        self.chipIssueView.hidden = YES;
        if (self.chipOperationType==1){//筹码检测
            [self.chipCheckList removeAllObjects];
        }else if (self.chipOperationType==2){
            [self.chipDestroyList removeAllObjects];
        }else if (self.chipOperationType==4){//继续结算小费
            [self.tipSettlementList removeAllObjects];
        }else if (self.chipOperationType==5){//继续存入筹码
            [self.storageChipList removeAllObjects];
        }else if (self.chipOperationType==6){//继续取出筹码
            [self.takeOutChipList removeAllObjects];
        }
    }
}

#pragma mark -- 判断数据是否正确
- (BOOL)canReadNextWithData:(NSData *)data{
    if (!self.chipUIDData) {
        self.chipUIDData = [NSMutableData data];
    }
    NSString *dataHexStr = [NRCommand hexStringFromData:data];
    if ([dataHexStr isEqualToString:@"050020a04feb"]) {
        return NO;
    }
    if ([dataHexStr isEqualToString:@"040000525a"]&&[SGSocketManager shareInstance].hasKeepLive) {
        [SGSocketManager shareInstance].hasKeepLive = NO;
        return NO;
    }
    return YES;
}

- (BOOL)isWorkModelOrPowerSetWithHex:(NSString *)hex{
    if (self.isSetUpDeviceModel||self.isAdjustPower) {
        if (self.isAdjustPower){
            [PublicHttpTool showSucceedSoundMessage:@"功率设置成功"];
        }
        return NO;
    }
    return YES;
}

- (BOOL)noChipInDeviceWithHex:(NSString *)hex{
    hex = [hex stringByReplacingOccurrencesOfString:@"04000e2cb3" withString:@""];
    hex = [hex stringByReplacingOccurrencesOfString:@"040000525a" withString:@""];
    NSInteger count = [[hex mutableCopy] replaceOccurrencesOfString:@"0d000000" withString:@"0d000000"
       options:NSLiteralSearch
         range:NSMakeRange(0, [hex length])];
    if (count==0) {
        [PublicHttpTool showSoundMessage:@"未检测到筹码"];
        return NO;
    }
    return YES;
}

/**
 收到数据

 @param data <#data description#>
 @param tag <#tag description#>
 */
-(void)socketManagerSuccessToReceiveMsg:(NSData *)data withTag:(long)tag{
    DLOG(@"data = %@",data);
    if (![self canReadNextWithData:data]) {
        return;
    }
    //将数据存入缓存区
    [self.chipUIDData appendData:data];
    NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
    if (![self isWorkModelOrPowerSetWithHex:chipNumberdataHexStr]) {
        return;
    }
    BLEIToll *itool = [[BLEIToll alloc]init];
    if (self.isReadChip) {//正在识别筹码
        if ([chipNumberdataHexStr hasSuffix:@"04000e2cb3"]) {//检测到结束字符,识别筹码UID完毕
            self.isReadChip  = NO;
            if (![self noChipInDeviceWithHex:chipNumberdataHexStr]) {
                return;
            }
            //存贮筹码UID
            self.chipUIDList = [itool getDeviceAllChipUIDWithBLEString:chipNumberdataHexStr];
            self.viewModel.chipModel.chipsUIDs = self.chipUIDList;
            self.chipCount = self.chipUIDList.count;
            if (self.chipCount==0) {
                [PublicHttpTool showSoundMessage:@"未检测到筹码"];
                return;
            }
            self.scanChipNumberLab.text = [NSString stringWithFormat:@"*当前已识别筹码%ld枚*",(long)self.chipCount];
            if (self.chipOperationType==0) {//筹码发行
                [self chipIssueImmediatelyAction];
            }else if (self.chipOperationType==1){//筹码检测
                [self checkChipAction];
            }else{
                [self readAllChipsInfo];
            }
        }
    }else if (self.isIssue||self.isDestoryChip||self.isExchangeChip||self.isSettlementTipChip||self.isStorageChip||self.isTakeOutChip) {
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        int allChipCount = (int)self.chipCount;
        if (self.isIssue) {
            allChipCount = (int)(3*self.chipCount);
        }else {
            allChipCount = (int)(2*self.chipCount);
        }
        int statusCount = [NRCommand showBackStatusCountWithHexStatus:chipNumberdataHexStr AllChipCount:allChipCount];
        if (statusCount==1||statusCount==2) {
            if (self.isIssue) {
                self.isIssue = NO;
                [self readAllChipsInfo];
            }else{
                self.chipNormalReadView.hidden = NO;
                self.chipListTableView.hidden = YES;
                self.operationButton.hidden = YES;
                if (self.isDestoryChip){
                    self.isDestoryChip = NO;
                    [self.chipDestroyList removeAllObjects];
                    [PublicHttpTool showSucceedSoundMessage:@"销毁成功"];
                }else if (self.isExchangeChip){
                    self.isExchangeChip = NO;
                    [self.chipExchangeList removeAllObjects];
                    [self.chipListTableView clearCustomerFooterInfo];
                    self.chipExchangeView.hidden = NO;
                    self.chipNormalReadView.hidden = YES;
                    if ([PublicHttpTool shareInstance].exchangeChipType==2) {
                        [PublicHttpTool showSucceedSoundMessage:@"信用出码成功"];
                    }else{
                        [PublicHttpTool showSucceedSoundMessage:@"兑换成功"];
                    }
                }else if (self.isSettlementTipChip){
                    self.isSettlementTipChip = NO;
                    [self.tipSettlementList removeAllObjects];
                    [PublicHttpTool showSucceedSoundMessage:@"结算成功"];
                }else if (self.isStorageChip){
                    self.isStorageChip = NO;
                    [self.storageChipList removeAllObjects];
                    [PublicHttpTool showSucceedSoundMessage:@"存入成功"];
                }else if (self.isTakeOutChip){
                    self.isTakeOutChip = NO;
                    [self.takeOutChipList removeAllObjects];
                    [self.chipListTableView clearCustomerFooterInfo];
                    [PublicHttpTool showSucceedSoundMessage:@"取出成功"];
                }
            }
        }
    }else {
        NSInteger infoByteLength = 60 * self.chipCount;
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"040000525a" withString:@""];
        if (infoByteLength>0&&(chipNumberdataHexStr.length==infoByteLength)) {//数据长度相同，筹码信息已经接受完毕
            if (self.chipOperationType==0) {//筹码发行
                [self.chipIssueList removeAllObjects];
                [self.chipIssueList addObject:[self managerModel]];
            }else if (self.chipOperationType==2){//筹码销毁
                [self.chipDestroyList removeAllObjects];
                [self.chipDestroyList addObject:[self managerModel]];
            }else if (self.chipOperationType==3){//筹码兑换
                [self.chipExchangeList removeAllObjects];
                //初始化现金兑换筹码的数据
                [self.chipExchangeList addObject:[self managerModel]];
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
            __block BOOL  hasCompanyChip = NO;//判断是否有公司筹码
            NSMutableArray *washNumberList = [NSMutableArray array];
            [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
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
                if ([washNumber isEqualToString:@"0"]||[washNumber length]==0) {
                    hasCompanyChip = YES;
                }
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
                if (self.chipOperationType==0) {//筹码发行
                    [self.chipIssueList addObject:chipinfo];
                }else if (self.chipOperationType==2){//筹码销毁
                    if ([chipType intValue]!=99) {
                        [self.chipDestroyList addObject:chipinfo];
                    }
                }else if (self.chipOperationType==3){//筹码兑换
                    //初始化现金兑换筹码的数据
                    [self.chipExchangeList addObject:chipinfo];
                }else if (self.chipOperationType==4){//小费结算
                    [self.tipSettlementList addObject:chipinfo];
                }else if (self.chipOperationType==5){//存入筹码
                    [self.storageChipList addObject:chipinfo];
                }else if (self.chipOperationType==6){//取出筹码
                    [self.takeOutChipList addObject:chipinfo];
                }
            }];
            if (self.chipOperationType==3&&[PublicHttpTool shareInstance].exchangeChipType==1) {//筹码换现金
                if (hasCompanyChip) {
                    [self.chipExchangeList removeAllObjects];
                    [PublicHttpTool showSoundMessage:@"存在公司筹码，不能进行兑换!"];
                    return;
                }else{
                    [self.chipListTableView.customerFooter showBottomInfoWithXMH:washNumberList.firstObject];
                }
            }else if (self.chipOperationType==4){//小费结算
                if (hasCompanyChip) {
                    [self.tipSettlementList removeAllObjects];
                    [PublicHttpTool showSoundMessage:@"存在公司筹码，不能进行小费结算!"];
                    return;
                }
            }else if (self.chipOperationType==5){
                if (hasCompanyChip) {
                    [self.storageChipList removeAllObjects];
                    [PublicHttpTool showSoundMessage:@"存入筹码有误，请检查"];
                    return;
                }else{
                    [PublicHttpTool shareInstance].exchangeWashNumber = washNumberList.firstObject;
                }
            }
            NSDictionary *infoDict = @{@"chipNumber":[NSString stringWithFormat:@"筹码数量:%ld",(long)self.chipCount],
                                       @"chipTotalMoney":[NSString stringWithFormat:@"筹码总额:%d",chipAllMoney]
            };
            NSArray *tableInfoList = [NSArray array];
            NSString *operateTitle = @"";
            self.chipListTableView.hidden = NO;
            self.operationButton.hidden = NO;
            if (self.chipOperationType==0) {//发行
                tableInfoList = self.chipIssueList;
                self.chipIssueView.hidden = YES;
                operateTitle = @"  继续发行  ";
                [PublicHttpTool showSucceedSoundMessage:@"发行成功"];
            }else if (self.chipOperationType==2){//销毁
                self.chipNormalReadView.hidden = YES;
                tableInfoList = self.chipDestroyList;
                operateTitle = @"  继续销毁  ";
            }else if (self.chipOperationType==3){//兑换
                self.chipExchangeView.hidden = YES;
                self.chipNormalReadView.hidden = YES;
                self.chipListTableView.hidden = NO;
                operateTitle = @"  继续兑换  ";
                tableInfoList = self.chipExchangeList;
                [self.chipListTableView clearCustomerFooterInfo];
            }else if (self.chipOperationType==4){//结算小费
                self.chipNormalReadView.hidden = YES;
                operateTitle = @"  继续结算  ";
                tableInfoList = self.tipSettlementList;
            }else if (self.chipOperationType==5){//存入筹码
                self.chipNormalReadView.hidden = YES;
                operateTitle = @"  继续存入  ";
                [PublicHttpTool shareInstance].userAllMoney = [NSString stringWithFormat:@"%d",chipAllMoney];
                tableInfoList = self.storageChipList;
            }else if (self.chipOperationType==6){//取出筹码
                self.chipNormalReadView.hidden = YES;
                operateTitle = @"  继续识别  ";
                tableInfoList = self.takeOutChipList;
                [PublicHttpTool shareInstance].userAllMoney = [NSString stringWithFormat:@"-%d",chipAllMoney];
                [self.chipListTableView clearCustomerFooterInfo];
            }
            [self.operationButton setTitle:operateTitle forState:UIControlStateNormal];
            [self.chipListTableView fellHeaderInfoWithDict:infoDict];
            [self.chipListTableView fellWithInfoList:tableInfoList WithType:self.chipOperationType];
            [EPSound playWithSoundName:@"succeed_sound"];
            [PublicHttpTool hideWaitingView];
        }
    }
}

/**
 心跳事件，需实现此代理方法，自己组装心跳报文发送
 */
-(void)socketManagerPingTimerAction{
    [SGSocketManager shareInstance].hasKeepLive = YES;
    [SGSocketManager SendDataWithData:[NRCommand keepDeviceAlive]];
}

#pragma mark - 关闭设备自动感应
- (void)closeDeviceWorkModel{
    //设置感应盘工作模式
    [SGSocketManager SendDataWithData:[NRCommand setDeviceWorkModel]];
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

- (NSArray *)createTestModel{
    NSMutableArray *testList = [NSMutableArray array];
    [testList addObject:[self managerModel]];
    NRChipManagerInfo *chipinfo = [[NRChipManagerInfo alloc]init];
    chipinfo.serialNumber = @"89";
    chipinfo.chipType = @"01";
    chipinfo.denomination = @"200";
    chipinfo.batch = @"20200728";
    chipinfo.status = @"正常";
    chipinfo.washNumber = @"888";
    [testList addObject:chipinfo];
    return testList;
}

- (NRChipManagerInfo *)errorChipinfoModel{
    //存储检测未知数据
    NRChipManagerInfo *checkInfo = [[NRChipManagerInfo alloc]init];
    checkInfo.chipType = @"#";
    checkInfo.batch = @"#";
    checkInfo.serialNumber = @"#";
    checkInfo.denomination = @"#";
    checkInfo.washNumber = @"#";
    checkInfo.status = @"非法";
    return checkInfo;
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
