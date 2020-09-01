//
//  NRGameBaseViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2020/6/23.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRGameBaseViewController.h"
#import "BLEIToll.h"
#import "EPPayShowView.h"
#import "EPINSShowView.h"
#import "EPINSOddsShowView.h"
#import "EPSixWinShowView.h"
#import "EPCowPointChooseShowView.h"

static int chipSleepTime = 150000;

@interface NRGameBaseViewController ()<SGSocketManagerDelegate>

//绑定筹码
@property (nonatomic, assign) NSInteger bindChipCount;
@property (nonatomic, strong) NSArray *bindChipUIDList;
@property (nonatomic, strong) NSString *curBindChipWashNumber;//需要绑定筹码的洗码号

@property (nonatomic, strong) NSMutableArray *washNumberList;//洗码号数据
@property (nonatomic, strong) NSMutableArray *chipTypeList;//筹码类型数据
@property (nonatomic, strong) NSMutableArray *shazhuInfoList;//杀注信息

@property (nonatomic, assign) NSInteger chipCount;
@property (nonatomic, strong) NSArray *chipUIDList;
//水钱
@property (nonatomic, assign) NSInteger shuiqianChipCount;
@property (nonatomic, strong) NSArray *shuiqianChipUIDList;
@property (nonatomic, assign) CGFloat identifyValue;//水钱

//是否识别筹码
@property (nonatomic, strong) NSMutableArray *chipInfoList;
@property (nonatomic, strong) NRCustomerInfo *customerInfo;
@property (nonatomic, strong) NRChipInfoModel *curChipInfo;
//赔付筹码
@property (nonatomic, assign) NSInteger payChipCount;
@property (nonatomic, strong) NSArray *payChipUIDList;
//找回筹码
@property (nonatomic, assign) NSInteger zhaoHuiChipCount;
@property (nonatomic, strong) NSArray *zhaoHuiChipUIDList;

@property (nonatomic, strong) EPPayShowView *payShowView;
@property (nonatomic, strong) ChipInfoView *chipInfoView;

@property (nonatomic, strong) EPKillShowView *killShowView;

@property (nonatomic, assign) CGFloat result_odds;//倍数
@property (nonatomic, assign) CGFloat result_yj;//佣金
@property (nonatomic, strong) EPPopAtipInfoView *recordTipShowView;//识别小费
@property (nonatomic, assign) CGFloat benjinMoney;//找回筹码金额
@property (nonatomic, strong) NSMutableData *chipUIDData;

@property (nonatomic, assign) __block int  hasZhaoHuiValue;//已经找回金额

@property (nonatomic, assign) BOOL isShaZhuAction;//是否杀注操作
@property (nonatomic, assign) BOOL hasShowResult;//是否弹出赔付或者杀注框
@property (nonatomic, assign) BOOL isReadChipUID;//是否正在识别筹码UID
@property (nonatomic, assign) BOOL isReadChipInfo;//是否正在识别筹码信息
@property (nonatomic, assign) BOOL isOperateChip;//是否操作筹码
@property (nonatomic, assign) BOOL isDasanChip;//是否打散筹码
@property (nonatomic, assign) int  operateChipCount;//正在操作筹码的数量
@property (nonatomic, assign) BOOL isUpdateWashNumber;//是否更改洗码号

@end

@implementation NRGameBaseViewController

#pragma mark - 自动版视图
- (UIView *)automaticShowView{
    if (!_automaticShowView) {
        _automaticShowView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dewInfoView.frame)+20, kScreenWidth, kScreenHeight-CGRectGetMaxY(self.dewInfoView.frame)-20)];
        _automaticShowView.backgroundColor = [UIColor clearColor];
        //操作中心
        self.operationInfoView = [[OperationInfoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _automaticShowView.frame.size.height)];
        [_automaticShowView addSubview:self.operationInfoView];
    }
    return _automaticShowView;
}

- (void)configureTitleBar {
    self.titleBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    UIImageView *bgImg = [UIImageView new];
    bgImg.image = [UIImage imageNamed:@"NRbg"];
    [self.view addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //顶部Bar
    self.topBarView = [[TopBarView alloc]initWithFrame:CGRectMake(0, [EPTitleBar heightForStatuBar], kScreenWidth, [EPTitleBar heightForTitleBarPlusStatuBar])];
    [self.view addSubview:self.topBarView];
    //台桌信息
    [self _setupTableInfo];
    
    //默认显示自动版本视图
    [self.view addSubview:self.automaticShowView];
    [self _initParams];
    
    @weakify(self);
    self.topBarView.barBtnBlock = ^(NSInteger tag, int BtnType,BOOL isChange) {
        @strongify(self);
        if (BtnType==0) {//顶部按钮
            if (tag==0) {//换靴
                [self PermissionVerifyWithVerifyType:2];
            }else if (tag==1){//修改露珠
                [self uddateCurGameLuzhu];
            } else if (tag==2){//手自版本切换
                [self automoticChangeAction:isChange];
            }else if (tag==3){//新一局
                [self newGameAction];
            }
        }else{//更多
            if (tag==0) {//日结
                [self PermissionVerifyWithVerifyType:3];
            }else if (tag==1){//切换语言
                [self changeLanguageWithType:isChange];
            }else if (tag==2){//换班
                [self logOutTableWithTag:1];
            }else if (tag==3){//换桌
                 [self logOutTableWithTag:2];
            }else if (tag==4){//查看注单
                EPWebViewController *webVC = [[EPWebViewController alloc]init];
                webVC.webTitle = @"查看注单";
                webVC.link = [NSString stringWithFormat:@"http://%@/admin/customerrec/all.html?access_token=%@&ftable_id=%@",kHTTPCookieDomain,[PublicHttpTool shareInstance].access_token,[PublicHttpTool shareInstance].fid];
                [self.navigationController pushViewController:webVC animated:YES];
            }else if (tag==5){//查看台面数据
                [self showWaitingView];
                [PublicHttpTool queryTableDataWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                    [self hideWaitingView];
                    if (success) {
                        TableDataInfoView *tableDataInfoV = [[AppDelegate shareInstance]tableDataInfoV];
                        [[MJPopTool sharedInstance] popView:tableDataInfoV animated:YES];
                        [tableDataInfoV fellTableInfoDataWithTableList:(NSDictionary *)data];
                    }else{
                        [self showSoundMessage:msg];
                    }
                }];
            }else if (tag==6){//点码
                TableJiaJiancaiView *addOrMinusView = [[AppDelegate shareInstance]addOrMinusView];
                [addOrMinusView fellViewDataWithLoginID:[PublicHttpTool shareInstance].access_token TableID:[PublicHttpTool shareInstance].fid ChipFmeList:[PublicHttpTool shareInstance].chipFmeList];
                [addOrMinusView fellListWithType:1];
                [[MJPopTool sharedInstance] popView:addOrMinusView animated:YES];
            }else if (tag==7){//台面加减彩
                [self showWaitingView];
                [PublicHttpTool queryOperate_listWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                    [self hideWaitingView];
                    if (success) {
                        TableJiaJiancaiView *addOrMinusView = [[AppDelegate shareInstance]addOrMinusView];
                        [addOrMinusView fellViewDataWithLoginID:[PublicHttpTool shareInstance].access_token TableID:[PublicHttpTool shareInstance].fid ChipFmeList:[PublicHttpTool shareInstance].chipFmeList];
                        [addOrMinusView fellListWithType:0];
                        [[MJPopTool sharedInstance] popView:addOrMinusView animated:YES];
                    }else{
                        [self showSoundMessage:msg];
                    }
                }];
            }else if (tag==8){//开台和收台
                [PublicHttpTool tableStateWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                    if (success) {
                        if ([PublicHttpTool shareInstance].hasFoundingStatus==2) {
                            [self showMessage:@"请先日结" withSuccess:NO];
                            return;
                        }
                       TableJiaJiancaiView *addOrMinusView = [[AppDelegate shareInstance]addOrMinusView];
                       [addOrMinusView fellViewDataWithLoginID:[PublicHttpTool shareInstance].access_token TableID:[PublicHttpTool shareInstance].fid ChipFmeList:[PublicHttpTool shareInstance].chipFmeList];
                       [addOrMinusView fellListWithType:2];
                       [[MJPopTool sharedInstance] popView:addOrMinusView animated:YES];
                       @weakify(self);
                       addOrMinusView.kaiShoutaiBock = ^(int hasKaitaiStatus) {
                           @strongify(self);
                           if (hasKaitaiStatus==1) {//收台
                               [self.navigationController popToRootViewControllerAnimated:YES];
                           }
                       };
                    }
                }];
            }else if (tag==9){//修改洗码号
                if ([PublicHttpTool socketNoConnectedShow]) {
                    self.isUpdateWashNumber = YES;
                    [self queryDeviceChipsUID];
                }
            }
        }
    };
    self.platFormInfoView.platformBtnBlock = ^(NSInteger tag, int BtnType) {
        @strongify(self);
        DLOG(@"tag===%ld,BtnType=%d",(long)tag,BtnType);
        if (tag==0) {
            if ([PublicHttpTool canStepToNextStep]) {
                if ([PublicHttpTool chooseKaipaiResult]) {
                    [self EnterOpeningResult];
                }
            }
        }else{
            if ([PublicHttpTool shareInstance].curGameType<3) {
                NSMutableArray *reslutNameList = [NSMutableArray array];
                for (int i=0; i<[PublicHttpTool shareInstance].resultList.count; i++) {
                    NSInteger tagResult = [[PublicHttpTool shareInstance].resultList[i]integerValue];
                    if (tagResult==1) {
                        [reslutNameList addObject:@"庄"];
                    }else if (tagResult==2){
                        [reslutNameList addObject:@"庄对"];
                    }else if (tagResult==3){
                        if ([PublicHttpTool shareInstance].curGameType==2) {
                            [reslutNameList addObject:@"Lucky6"];
                        }else{
                            [reslutNameList addObject:@"6点赢"];
                        }
                    }else if (tagResult==4){
                        [reslutNameList addObject:@"闲"];
                    }else if (tagResult==5){
                        [reslutNameList addObject:@"闲对"];
                    }else if (tagResult==6){
                        [reslutNameList addObject:@"和"];
                    }
                }
                [PublicHttpTool shareInstance].curupdateInfo.cp_name = [reslutNameList componentsJoinedByString:@","];
            }else if ([PublicHttpTool shareInstance].curGameType==3){//龙虎
                if (tag==1){
                    [PublicHttpTool shareInstance].curupdateInfo.cp_name = @"龙";
                    [PublicHttpTool shareInstance].tiger_resultTag = 1;
                }else if (tag==2){
                    [PublicHttpTool shareInstance].curupdateInfo.cp_name = @"虎";
                    [PublicHttpTool shareInstance].tiger_resultTag = 2;
                }else{
                    [PublicHttpTool shareInstance].curupdateInfo.cp_name = @"和";
                    [PublicHttpTool shareInstance].tiger_resultTag = 3;
                }
            }else if ([PublicHttpTool shareInstance].curGameType==4||[PublicHttpTool shareInstance].curGameType==5){//牛牛,三公
                [PublicHttpTool shareInstance].tiger_resultTag = (int)tag;
                self.customerInfo.isCow = YES;
            }
        }
    };
    //操作中心
    self.operationInfoView.operationBtnBlock = ^(NSInteger tag, int BtnType) {
        DLOG(@"tag==%ld,BtnType==%d",(long)tag,BtnType);
        @strongify(self);
        self.isUpdateWashNumber = NO;
        if (tag<3) {//左边按钮事件
            if (tag==0) {//记录小费
                [PublicHttpTool shareInstance].exchangeMoneyFirstStep = NO;
                [PublicHttpTool shareInstance].recordTips = YES;
            }else if (tag==1){//换钱第一步(识别需要兑换的筹码)
                [PublicHttpTool shareInstance].exchangeMoneyFirstStep = YES;
                [PublicHttpTool shareInstance].recordTips = NO;
            }else{//筹码识别
                [PublicHttpTool shareInstance].exchangeMoneyFirstStep = NO;
                [PublicHttpTool shareInstance].recordTips = NO;
                [self detectionChipShowView];
                return;
            }
        }else{
            self.identifyValue = 0;
            //赔率
            NSArray *xz_array = [PublicHttpTool shareInstance].curXz_setting;
            NSArray *result_List = [PublicHttpTool shareInstance].resultList;
            int odds_number = (int)tag-10;
            if (BtnType==1||BtnType==2) {//免佣百家乐
                self.result_yj = 0;
                __block BOOL hasWinOrLose = NO;
                if (xz_array.count!=0&&xz_array.count>odds_number) {
                    self.result_odds = [xz_array[odds_number][@"fpl"] floatValue];
                    self.result_yj = [xz_array[odds_number][@"fyj"] floatValue]/100.0;
                }
                if (odds_number!=4) {
                    if ([result_List containsObject:[NSNumber numberWithInteger:6]]) {//和
                        [self showMessage:@"不杀不赔" withSuccess:YES];
                        return;
                    }else{
                        if (odds_number==0) {//庄
                            if ([result_List containsObject:[NSNumber numberWithInteger:1]]) {
                                if (odds_number==0) {//庄
                                    if ([PublicHttpTool shareInstance].curGameType==1) {//免佣百家乐
                                        if ([result_List containsObject:[NSNumber numberWithInteger:3]]) {//庄6点赢
                                            self.result_odds = [xz_array[6][@"fpl"] floatValue];
                                            self.result_yj = [xz_array[6][@"fyj"] floatValue]/100.0;
                                        }
                                    }
                                }
                                hasWinOrLose = YES;
                            }else {
                                hasWinOrLose = NO;
                            }
                        }else if (odds_number==1){//闲
                            if ([result_List containsObject:[NSNumber numberWithInteger:4]]) {
                                hasWinOrLose = YES;
                            }else {
                                hasWinOrLose = NO;
                            }
                        }else if (odds_number==2){//庄对子
                            if ([result_List containsObject:[NSNumber numberWithInteger:2]]) {
                                hasWinOrLose = YES;
                            }else {
                                hasWinOrLose = NO;
                            }
                        }else if (odds_number==3){//闲对子
                            if ([result_List containsObject:[NSNumber numberWithInteger:5]]) {
                                hasWinOrLose = YES;
                            }else {
                                hasWinOrLose = NO;
                            }
                        }else if (odds_number==4){//和
                            if ([result_List containsObject:[NSNumber numberWithInteger:6]]) {
                                hasWinOrLose = YES;
                            }else {
                                hasWinOrLose = NO;
                            }
                        }else if (odds_number==5){//保险
                            EPINSShowView *insShowView = [[AppDelegate shareInstance]cowResultShowView];
                            [[MJPopTool sharedInstance] popView:insShowView animated:YES];
                            @weakify(self);
                            insShowView.INSResultBlock = ^(BOOL isWin) {
                                @strongify(self);
                                hasWinOrLose = isWin;
                                [PublicHttpTool shareInstance].winOrLose = hasWinOrLose;
                                if (isWin) {
                                    EPINSOddsShowView *insOddsShowView = [[AppDelegate shareInstance]insOddsShowView];
                                    [[MJPopTool sharedInstance] popView:insOddsShowView animated:YES];
                                    insOddsShowView.INSOddsResultBlock = ^(CGFloat insOdds) {
                                        @strongify(self);
                                        self.result_odds = insOdds;
                                        [self queryDeviceChipsUID];
                                    };
                                }else{
                                    [self queryDeviceChipsUID];
                                }
                            };
                            return;
                        }else if (odds_number==6){//幸运6点
                            if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:3]]) {//6点赢
                                hasWinOrLose = YES;
                            }else {
                                hasWinOrLose = NO;
                            }[PublicHttpTool shareInstance].winOrLose = hasWinOrLose;
                            EPSixWinShowView *sixWinShowView = [[AppDelegate shareInstance]sixWinShowView];
                            [[MJPopTool sharedInstance] popView:sixWinShowView animated:YES];
                            @weakify(self);
                            sixWinShowView.sureActionBlock = ^(NSInteger sixWinType) {
                                @strongify(self);
                                if (sixWinType==0) {//两张牌
                                    if (xz_array.count!=0&&xz_array.count>8) {
                                        self.result_odds = [xz_array[8][@"fpl"] floatValue];
                                    }
                                    [PublicHttpTool shareInstance].curupdateInfo.cp_Result_name = @"两张牌幸运六点";
                                }else{//三张牌
                                    if (xz_array.count!=0&&xz_array.count>7) {
                                        self.result_odds = [xz_array[7][@"fpl"] floatValue];
                                    }
                                    [PublicHttpTool shareInstance].curupdateInfo.cp_Result_name = @"三张牌幸运六点";
                                }
                                [self queryDeviceChipsUID];
                            };
                            return;
                        }
                    }
                }else{
                    if ([result_List containsObject:[NSNumber numberWithInteger:6]]) {//和
                        hasWinOrLose = YES;
                    }else {
                        hasWinOrLose = NO;
                    }
                }
                [PublicHttpTool shareInstance].winOrLose = hasWinOrLose;
            }else if (BtnType==3){//龙虎
                self.result_odds = 1;
                self.customerInfo.isTiger = NO;
                if ((odds_number+1)==[PublicHttpTool shareInstance].tiger_resultTag) {
                    [PublicHttpTool shareInstance].winOrLose = YES;
                }else{
                    [PublicHttpTool shareInstance].winOrLose = NO;
                }
                if (odds_number==2) {
                    if (xz_array.count>2) {
                        self.result_odds = [xz_array[2][@"fpl"] floatValue];
                        self.result_yj = [xz_array[2][@"fyj"] floatValue]/100.0;
                    }
                }else{
                    if (![PublicHttpTool shareInstance].winOrLose) {
                        if ([PublicHttpTool shareInstance].tiger_resultTag==3) {
                            self.result_odds = 0.5;
                            self.customerInfo.isTiger = YES;
                        }
                    }
                }
            }else if (BtnType==4){//牛牛
                [PublicHttpTool shareInstance].tiger_resultTag = (odds_number+1);
                [self CalcuteChipMoneyWithPoint];
                return;
            }
        }
        [self queryDeviceChipsUID];
    };
    [self openOrCloseSocket];//开启socket
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showWaitingViewWithText:@"露珠加载中..."];
        [self getBaseTableInfoAndLuzhuInfo];
    });
}

#pragma mark -- 台桌信息
- (void)_setupTableInfo{
    CGFloat top_adjust_h = CGRectGetMaxY(self.topBarView.frame)+20;
    CGFloat top_infoV_h = 262;
    //露珠信息
    self.dewInfoView = [[DewInfoView alloc]initWithFrame:CGRectMake(10, top_adjust_h, kScreenWidth-30-156-249, top_infoV_h)];
    [self.view addSubview:self.dewInfoView];
    
    //台桌信息
    self.tableInfoView = [[TableInfoView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dewInfoView.frame)+5, top_adjust_h, 156, top_infoV_h)];
    [self.tableInfoView updateTableInfo];
    [self.view addSubview:self.tableInfoView];
    
    //结算台
    self.platFormInfoView = [[SetPlatformView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tableInfoView.frame)+5, top_adjust_h, 249, top_infoV_h)];
    [self.view addSubview:self.platFormInfoView];
}

#pragma mark -- 开启或者关闭Sockket
- (void)openOrCloseSocket{
    [SGSocketManager ConnectSocketWithConfigM:[SGSocketConfigM ShareInstance] complation:^(NSError *error) {
        DLOG(@"error===%@",error);
        if (!error) {
            [self closeDeviceWorkModel];
        }
    }];
    [SGSocketManager shareInstance].delegate = self;
    [[SGSocketManager shareInstance] startPingTimer];//开启心跳
}

#pragma mark --初始化一些参数信息
- (void)_initParams{
    [PublicHttpTool shareInstance].cowPoint = 99;
    [PublicHttpTool shareInstance].xueciCount = 1;
    [PublicHttpTool shareInstance].puciCount = 0;
    [PublicHttpTool shareInstance].prePuciCount = 1;
    self.chipUIDData = [NSMutableData data];
    self.washNumberList = [NSMutableArray arrayWithCapacity:0];
    self.chipTypeList = [NSMutableArray arrayWithCapacity:0];
    self.shazhuInfoList = [NSMutableArray arrayWithCapacity:0];
    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    self.curChipInfo = [[NRChipInfoModel alloc]init];
    self.customerInfo = [[NRCustomerInfo alloc]init];
    [self fellCustomerInfo];
    self.customerInfo.chipType = @"01";
   
}

#pragma mark -- 封装客人基本信息
- (void)fellCustomerInfo{
    self.customerInfo.tipsTitle = [NSString stringWithFormat:@"提示信息\n%@",[EPStr getStr:kEPTipsInfo note:@"提示信息"]];
    self.customerInfo.tipsInfo = [NSString stringWithFormat:@"请认真核对以上信息，确认是否进行下一步操作\n%@",[EPStr getStr:kEPNextTips note:@"请认真核对以上信息，确认是否进行下一步操作"]];
}

#pragma mark --手自动版切换
- (void)automoticChangeAction:(BOOL)isChange{
}

#pragma mark - 根据点数计算赔率
- (void)CalcuteChipMoneyWithPoint{
    EPCowPointChooseShowView *cowPointShowView = [[AppDelegate shareInstance]cowPointShowView];
    [[MJPopTool sharedInstance] popView:cowPointShowView animated:YES];
    @weakify(self);
    cowPointShowView.pointsResultBlock = ^(int curPoint) {
        @strongify(self);
        [PublicHttpTool shareInstance].customerPoint = 0;
        if (curPoint!=99) {
            [PublicHttpTool shareInstance].customerPoint = curPoint;
        }
        if ([PublicHttpTool shareInstance].cowPoint==[PublicHttpTool shareInstance].customerPoint) {
            [self cowResultShow];
        }else{
            if ([PublicHttpTool shareInstance].cowPoint>[PublicHttpTool shareInstance].customerPoint) {
                [PublicHttpTool shareInstance].winOrLose = NO;
            }else{
                [PublicHttpTool shareInstance].winOrLose = YES;
            }
            [self fengzhuangCowValue];
        }
    };
}

#pragma mark--牛牛输赢选择弹出
- (void)cowResultShow{
    EPINSShowView *cowResultShowView = [[AppDelegate shareInstance]cowResultShowView];
    [cowResultShowView showWithCowType];
    [[MJPopTool sharedInstance] popView:cowResultShowView animated:YES];
    @weakify(self);
    cowResultShowView.INSResultBlock = ^(BOOL isWin) {
        @strongify(self);
        [PublicHttpTool shareInstance].winOrLose = isWin;
        [self fengzhuangCowValue];
    };
}

- (void)fengzhuangCowValue{
    //赔率
    int realCowPoint = 0;
    if ([PublicHttpTool shareInstance].winOrLose) {
        realCowPoint = [PublicHttpTool shareInstance].customerPoint;
    }else{
        realCowPoint = [PublicHttpTool shareInstance].cowPoint;
    }
    NSArray *xz_array = [PublicHttpTool shareInstance].curXz_setting;;
    NSDictionary *fplDict = nil;
    NSDictionary *fyjDict = nil;
    if ([PublicHttpTool shareInstance].tiger_resultTag==1) {//超级翻倍
        self.customerInfo.winStatus = @"超级翻倍";
        fplDict = xz_array[2][@"fpl"];
        fyjDict = xz_array[2][@"fyj"];
    }else if ([PublicHttpTool shareInstance].tiger_resultTag==2){//翻倍
        self.customerInfo.winStatus = @"翻倍";
        fplDict = xz_array[1][@"fpl"];
        fyjDict = xz_array[1][@"fyj"];
    }else{
        self.customerInfo.winStatus = @"平倍";
        fplDict = xz_array[0][@"fpl"];
        fyjDict = xz_array[0][@"fyj"];
    }
    
    if ([PublicHttpTool shareInstance].customerPoint==99) {
        self.result_odds = 1;
        self.result_yj = 0;
        [PublicHttpTool shareInstance].curupdateInfo.cp_dianshu = [NSString stringWithFormat:@"%d",0];
        [PublicHttpTool showSoundMessage:@"请选择闲家点数"];
        return;
    }else{
        self.result_odds = [[fplDict valueForKey:[NSString stringWithFormat:@"%d",realCowPoint]]floatValue];
        if ([PublicHttpTool shareInstance].winOrLose) {
            self.result_yj = [[fyjDict valueForKey:[NSString stringWithFormat:@"%d",realCowPoint]]floatValue]/100.0;
        }else{
            self.result_yj = 0;
        }
        [PublicHttpTool shareInstance].curupdateInfo.cp_dianshu = [NSString stringWithFormat:@"%d",realCowPoint];
    }
    [self queryDeviceChipsUID];
}

#pragma mark --获取露珠信息和当前台桌基础信息
- (void)getBaseTableInfoAndLuzhuInfo{
    @weakify(self);
    [PublicHttpTool getLastXueCiInfoWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            @strongify(self);
            NSDictionary *tableInfo = (NSDictionary *)data;
            NSString *realResult = @"";
            if ([tableInfo[@"table"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *CurtableInfo = tableInfo[@"table"];
                NSString *fnew_xueci = CurtableInfo[@"fnew_xueci"];
                NSString *cp_result = CurtableInfo[@"fkpresult"];
                [PublicHttpTool shareInstance].prePuciCount = [PublicHttpTool shareInstance].puciCount;
                if([fnew_xueci intValue]!=0) {
                    //在这里进行操作
                    int curNewXueci = [fnew_xueci intValue];
                    [PublicHttpTool shareInstance].xueciCount = curNewXueci;
                    [PublicHttpTool shareInstance].puciCount = [CurtableInfo[@"fpuci"]intValue];
                    if ([fnew_xueci intValue]==[CurtableInfo[@"fxueci"]intValue]) {
                        realResult = cp_result;
                        [PublicHttpTool shareInstance].hasNewGameEntry = YES;
                        [PublicHttpTool shareInstance].curupdateInfo.cp_name = cp_result;
                        [PublicHttpTool shareInstance].cp_tableIDString = [NSString stringWithFormat:@"%@",CurtableInfo[@"fqpid"]];
                        [PublicHttpTool shareInstance].cp_Serialnumber = CurtableInfo[@"fpcls"];
                        if ([PublicHttpTool shareInstance].curGameType>3) {
                            [self.tableInfoView _setPlatFormBtnNormalStatusWithResult:cp_result];
                        }else{
                             [self.platFormInfoView _setPlatFormBtnNormalStatusWithResult:cp_result];
                        }
                    }else{
                        [self clearNewGameInfo];
                    }
                }else{
                    [PublicHttpTool shareInstance].puciCount = [CurtableInfo[@"fpuci"]intValue];
                    int fXueci = [CurtableInfo[@"fxueci"]intValue];
                    [PublicHttpTool shareInstance].xueciCount = fXueci;
                    if ([CurtableInfo[@"fpuci"]intValue]>0) {
                        realResult = cp_result;
                        [PublicHttpTool shareInstance].hasNewGameEntry = YES;
                        [PublicHttpTool shareInstance].curupdateInfo.cp_name = cp_result;
                        [PublicHttpTool shareInstance].cp_tableIDString = [NSString stringWithFormat:@"%@",CurtableInfo[@"fqpid"]];
                        [PublicHttpTool shareInstance].cp_Serialnumber = CurtableInfo[@"fpcls"];
                        if ([PublicHttpTool shareInstance].curGameType>3) {
                            [self.tableInfoView _setPlatFormBtnNormalStatusWithResult:cp_result];
                        }else{
                            [self.platFormInfoView _setPlatFormBtnNormalStatusWithResult:cp_result];
                        }
                    }else{
                        [PublicHttpTool shareInstance].prePuciCount +=1;
                    }
                }
            }else{
                [self clearNewGameInfo];
            }
        }else{
            [self clearNewGameInfo];
        }
        [PublicHttpTool shareInstance].curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].xueciCount];
        [PublicHttpTool shareInstance].curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].puciCount];
        [self.tableInfoView updateTableInfo];
        [self getCurGameLuZhuList];
    }];
}

- (void)clearNewGameInfo{
    [PublicHttpTool shareInstance].hasNewGameEntry = NO;
    [PublicHttpTool shareInstance].puciCount = 0;
    [PublicHttpTool shareInstance].curupdateInfo.cp_name = @"";
    [PublicHttpTool shareInstance].prePuciCount =[PublicHttpTool shareInstance].puciCount+1;
}

#pragma mark - 权限调用验证(1修改洗码号，2更换靴次，3日结)
- (void)PermissionVerifyWithVerifyType:(int)verifyType{
    [EPSound playWithSoundName:@"click_sound"];
    EmpowerView *empowerView = [[AppDelegate shareInstance]empowerView];
    [[MJPopTool sharedInstance] popView:empowerView animated:YES];
    @weakify(self);
    empowerView.sureActionBlock = ^(NSString * _Nonnull adminName, NSString * _Nonnull password) {
        @strongify(self);
        [PublicHttpTool shareInstance].curupdateInfo.femp_num = adminName;
        [PublicHttpTool shareInstance].curupdateInfo.femp_pwd = password;
        [self showWaitingView];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [PublicHttpTool authorizationAccountWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                [self hideWaitingView];
                if (success) {
                    if (verifyType==1) {
                        [EPPopView showEntryInView:self.view WithTitle:@"请输入洗码号" handler:^(NSString *entryText) {
                            @strongify(self);
                            if ([[entryText NullToBlankString]length]==0) {
                                [self showMessage:@"请输入洗码号"];
                            }else{
                                [self showWaitingView];
                                [PublicHttpTool updateCustomerWashNumberWithChipList:self.chipUIDList CurWashNumber:entryText Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                                    @strongify(self);
                                    if (success) {
                                        self.operateChipCount = (int)self.chipUIDList.count;
                                        self.curChipInfo.guestWashesNumber = entryText;
                                        [self writeChipWashNumberList:self.chipUIDList];
                                    }else{
                                        [self showSoundMessage:msg];
                                    }
                                }];
                            }
                        }];
                    }else if (verifyType==2){
                        [PublicHttpTool clearLuzhuWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                            [self hideWaitingView];
                            if (success) {
                                [PublicHttpTool shareInstance].xueciCount +=1;
                                [PublicHttpTool shareInstance].puciCount =0;
                                [PublicHttpTool shareInstance].curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].xueciCount];
                                [self.tableInfoView updateTableInfo];
                                [self postNewXueciAndClear];
                                [self.platFormInfoView _setPlatFormBtnNormalStatusWithResult:@""];
                            }else{
                                [self showSoundMessage:msg];
                            }
                        }];
                    }else if (verifyType==3){
                        [PublicHttpTool commitDailyWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                            [self hideWaitingView];
                            if (success) {
                                [PublicHttpTool shareInstance].xueciCount =1;
                                [PublicHttpTool shareInstance].curupdateInfo.cp_xueci = [NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].xueciCount];
                                [PublicHttpTool postNewxueciWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                                }];
                                [self showMessage:@"日结成功" withSuccess:YES];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }else{
                                [self showSoundMessage:msg];
                            }
                        }];
                    }
                }else{
                    [self showSoundMessage:msg];
                }
            }];
        });
    };
}

#pragma mark -- 写入洗码号
- (void)writeChipWashNumberList:(NSArray *)list{
    for (int i = 0; i < list.count; i++) {
        self.curChipInfo.chipUID = list[i];
        //向指定标签中写入数据（块1）
        [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip4WithChipInfo:self.curChipInfo WithBlockNumber:@"04"]];
        usleep(chipSleepTime);
        [SGSocketManager SendDataWithData:[NRCommand writeInfoToChip4WithChipInfo:self.curChipInfo WithBlockNumber:@"05"]];
        usleep(chipSleepTime);
    }
}

#pragma mark -- 清除洗码号
- (void)clearChipWashNumberList:(NSArray *)list{
    for (int i = 0; i < list.count; i++) {
        NSString *chipUID = list[i];
        [SGSocketManager SendDataWithData:[NRCommand clearWashNumberWithChipInfo:chipUID WithBlockNumber:@"04"]];
        usleep(chipSleepTime);
        [SGSocketManager SendDataWithData:[NRCommand clearWashNumberWithChipInfo:chipUID WithBlockNumber:@"05"]];
        usleep(chipSleepTime);
    }
}

#pragma mark --录入开牌结果
- (void)EnterOpeningResult{
    @weakify(self);
    [PublicHttpTool commitkpResultWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        @strongify(self);
        [self hideWaitingView];
        if (success) {
            [PublicHttpTool shareInstance].prePuciCount = [PublicHttpTool shareInstance].puciCount+1;
            [PublicHttpTool showSucceedSoundMessage:@"结果录入成功"];
            [self getCurGameLuZhuList];
        }else{
            [self showSoundMessage:msg];
        }
    }];
}

#pragma mark - 新一局
- (void)newGameAction{
    [EPSound playWithSoundName:@"click_sound"];
    [PublicHttpTool tableStateWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            if ([PublicHttpTool shareInstance].hasFoundingStatus==1) {
                [self showMessage:@"请先开台" withSuccess:NO];
                return;
            }else if ([PublicHttpTool shareInstance].hasFoundingStatus==3){
                [self showMessage:@"请先收台" withSuccess:NO];
                return;
            }
            if ([PublicHttpTool shareInstance].prePuciCount==[PublicHttpTool shareInstance].puciCount) {
                [self showMessage:@"请先提交开牌结果" withSuccess:NO];
                return;
            }
            @weakify(self);
            [EPPopView showInWindowWithMessage:[NSString stringWithFormat:@"是否确定开启新一局？\n%@",[EPStr getStr:kEPSureNextGame note:@"确定开启新一局？"]] handler:^(int buttonType) {
                @strongify(self);
                if (buttonType==0) {
                    [PublicHttpTool shareInstance].curupdateInfo.cp_name = @"";
                    [PublicHttpTool shareInstance].puciCount +=1;
                    [PublicHttpTool shareInstance].prePuciCount = [PublicHttpTool shareInstance].puciCount;
                    [self.tableInfoView updateTableInfo];
                    [PublicHttpTool shareInstance].curupdateInfo.cp_puci = [NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].puciCount];
                    [PublicHttpTool shareInstance].cp_tableIDString = @"";
                    [PublicHttpTool shareInstance].hasNewGameEntry = YES;
                    [PublicHttpTool showSucceedSoundMessage:@"开启新一局成功"];
                    [self.platFormInfoView _setPlatFormBtnNormalStatusWithResult:@""];
                    [self.tableInfoView clearCowPoint];
                }
            }];
        }
    }];
}

#pragma mark --退出桌面
- (void)logOutTableWithTag:(int)tag{
    [EPSound playWithSoundName:@"click_sound"];
    [self showWaitingView];
    [PublicHttpTool otherTableWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [self hideWaitingView];
        if (success) {
            //重新选桌要把开牌结果置空
            [PublicHttpTool shareInstance].cp_tableIDString = @"";
            if (tag==1) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self showSoundMessage:msg];
        }
    }];
}

#pragma mark -- 中英文切换
- (void)changeLanguageWithType:(BOOL)isEnglish{
    [EPSound playWithSoundName:@"click_sound"];
    [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:isEnglish?0:1];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:isEnglish?0:1] forKey:@"languageKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //结算台
    [self.platFormInfoView showBtnsTitleInfo];
    //台桌信息
    [self.tableInfoView showTableTitleInfo];
    //操作中心
    [self.operationInfoView showPublicBtnTitle];
    [self.operationInfoView showBtnsTitleInfo];
}

#pragma mark -- 修改露珠
- (void)uddateCurGameLuzhu{
}

#pragma mark -- 获取当前最新露珠
- (void)getCurGameLuZhuList{
}

#pragma mark -- 上传最新靴次
- (void)postNewXueciAndClear{
}

#pragma mark--更新露珠
- (void)updateLuzhuInfoWithList:(NSArray *)luzhuList{
    [self.dewInfoView updateLuzhuInfoWithLuzhuList:luzhuList];
}

#pragma mark -- 更新台桌信息
- (void)updateTableInfoWithTableType:(int)type CountList:(NSArray *)list{
    if (type==1) {//龙虎
        [self.tableInfoView updateTigerCountWithCountList:list];
    }else if (type==2){//免佣百家乐
        [self.tableInfoView updateBaccaratCountWithCountList:list];
    }
}

#pragma mark -- 重新刷新台桌信息
- (void)refrashCurTableInfo{
    [self getBaseTableInfoAndLuzhuInfo];
}

#pragma mark -- 封装参数
- (void)fellViewModelUpdateInfo{
    NSString *realCashMoney = self.curChipInfo.chipDenomination;
    NSString *washNumber = self.washNumberList.firstObject;
    //筹码类型
    NSString *chipType = [self.chipTypeList.firstObject NullToBlankString];
    [PublicHttpTool shareInstance].curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.result_odds];
    [PublicHttpTool shareInstance].curupdateInfo.cp_result = [NSString stringWithFormat:@"%@",[PublicHttpTool shareInstance].winOrLose?@"1":@"-1"];
    [PublicHttpTool shareInstance].curupdateInfo.cp_washNumber = washNumber;
    [PublicHttpTool shareInstance].curupdateInfo.cp_benjin = realCashMoney;
    [PublicHttpTool shareInstance].curupdateInfo.cp_ChipUidList = self.chipUIDList;
    [PublicHttpTool shareInstance].curupdateInfo.cp_chipType = chipType;
    self.customerInfo.xiazhu = [NSString stringWithFormat:@"%@",realCashMoney];
    self.customerInfo.shazhu = [NSString stringWithFormat:@"%@",realCashMoney];
    self.curChipInfo.chipType = chipType;
    self.customerInfo.chipType = chipType;
    self.customerInfo.guestNumber = washNumber;
    //客人洗码号
    self.curChipInfo.guestWashesNumber = washNumber;
    self.customerInfo.principalMoney = realCashMoney;
    self.customerInfo.chipInfoList = self.shazhuInfoList;
    if ([PublicHttpTool shareInstance].curGameType>3) {//牛牛,三公
        if ([PublicHttpTool shareInstance].cowPoint==99) {
            [PublicHttpTool shareInstance].curupdateInfo.cp_dianshu = @"0";
        }else{
            [PublicHttpTool shareInstance].curupdateInfo.cp_dianshu = [NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint];
        }
    }else{
        [PublicHttpTool shareInstance].curupdateInfo.cp_dianshu = @"0";
    }
    self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%.f",self.identifyValue];
    self.customerInfo.hasDashui = YES;
    self.customerInfo.odds = self.result_odds;
    NSString *winResultStatus = [NSString stringWithFormat:@"%@ %@",[PublicHttpTool shareInstance].curupdateInfo.cp_Result_name,[PublicHttpTool shareInstance].winOrLose?@"赢":@"输"];
    self.customerInfo.winStatus = winResultStatus;
    if ([PublicHttpTool shareInstance].curGameType==4) {//牛牛
        if (self.result_odds>1&&![PublicHttpTool shareInstance].winOrLose) {
            self.customerInfo.isCow = YES;
        }else{
            self.customerInfo.isCow = NO;
        }
        [self identifyWaterMoney];
    }else{
        if ([PublicHttpTool shareInstance].winOrLose) {
            [self identifyWaterMoney];
        }else{
            self.customerInfo.add_chipMoney = @"0";
            [PublicHttpTool shareInstance].curupdateInfo.cp_commission = @"0";
            if ([PublicHttpTool shareInstance].curGameType==3) {
                [PublicHttpTool shareInstance].curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",self.result_odds*[realCashMoney floatValue]];
            }else{
                [PublicHttpTool shareInstance].curupdateInfo.cp_money = realCashMoney;
            }
        }
    }
}

//识别水钱
- (void)identifyWaterMoney{
    NSString *realCashMoney = self.curChipInfo.chipDenomination;
    int yjResult = ceil(self.result_yj*[realCashMoney floatValue]);
    [PublicHttpTool shareInstance].curupdateInfo.cp_commission = [NSString stringWithFormat:@"%d",yjResult];
    CGFloat real_beishu = self.result_odds-self.result_yj;
    self.customerInfo.compensateMoney = [NSString stringWithFormat:@"%.f",floor(real_beishu*[realCashMoney floatValue])+self.identifyValue];
    self.customerInfo.compensateCode = [NSString stringWithFormat:@"%.f",floor(real_beishu*[realCashMoney floatValue])];
    self.customerInfo.totalMoney = [NSString stringWithFormat:@"%.f",floor((real_beishu+1)*[realCashMoney floatValue])+self.identifyValue];
    self.customerInfo.drawWaterMoney = [NSString stringWithFormat:@"%.f",self.identifyValue];
    [PublicHttpTool shareInstance].curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",floor((real_beishu+1)*[realCashMoney floatValue])];
    if ([PublicHttpTool shareInstance].curGameType==4) {//牛牛
        if (![PublicHttpTool shareInstance].winOrLose) {
            [self cowLoseCalucateValue];
            [self.killShowView fellViewDataNRCustomerInfo:self.customerInfo];
            return;
        }
    }
    [self.payShowView fellViewDataNRCustomerInfo:self.customerInfo];
}

#pragma mark -- 计算牛牛输的金额
- (void)cowLoseCalucateValue{
    NSString *realCashMoney = self.curChipInfo.chipDenomination;
    self.customerInfo.xiazhu = [NSString stringWithFormat:@"%@",realCashMoney];
    self.customerInfo.shazhu = [NSString stringWithFormat:@"%.f",self.result_odds*[realCashMoney floatValue]];
    self.customerInfo.add_chipMoney = [NSString stringWithFormat:@"%.f",(self.result_odds-1)*[realCashMoney floatValue]];
    [PublicHttpTool shareInstance].curupdateInfo.cp_beishu = [NSString stringWithFormat:@"%.2f",self.result_odds];
    [PublicHttpTool shareInstance].curupdateInfo.cp_result = @"-1";
    [PublicHttpTool shareInstance].curupdateInfo.cp_commission = @"0";
    [PublicHttpTool shareInstance].curupdateInfo.cp_money = [NSString stringWithFormat:@"%.f",self.result_odds*[realCashMoney floatValue]];
}

#pragma mark -- 弹出赔付或者杀注界面
- (void)showPayOrKillView{
    [self fellViewModelUpdateInfo];
    self.hasShowResult = YES;
    if ([PublicHttpTool shareInstance].winOrLose) {
        if (![self chipInfoCheck]) {
            return;
        }
        [PublicHttpTool shareInstance].isShaZhuOperation = NO;
        self.payShowView = [[AppDelegate shareInstance]payShowView];
        [[MJPopTool sharedInstance] popView:self.payShowView animated:YES];
        [self.payShowView fellViewDataNRCustomerInfo:self.customerInfo];
        @weakify(self);
        self.payShowView.sureActionBlock = ^(NSInteger payConfirmType) {
            @strongify(self);
            if (payConfirmType==3){//识别水钱
                [PublicHttpTool shareInstance].isDaShuiOperation = YES;
            }else{
                [PublicHttpTool shareInstance].isDaShuiOperation = NO;
            }
            if (payConfirmType!=2) {
                [self queryDeviceChipsUID];
            }else{
                [self clearAllStepsJudge];
                [self.operationInfoView _resetBtnStatus];
            }
        };
    }else{
        self.killShowView = [[AppDelegate shareInstance]killShowView];
        [[MJPopTool sharedInstance] popView:self.killShowView animated:YES];
        [self.killShowView fellViewDataNRCustomerInfo:self.customerInfo];
        @weakify(self);
        self.killShowView.sureActionBlock = ^(NSInteger killConfirmType) {
            @strongify(self);
            if (killConfirmType==1) {//确认
                if (self.customerInfo.isTiger) {//杀一半
                    [PublicHttpTool shareInstance].isShaZhuOperation = NO;
                    [PublicHttpTool shareInstance].isZhaoHuiChip = YES;
                }else if (self.customerInfo.isCow){//牛牛
                    [PublicHttpTool shareInstance].isShaZhuOperation = NO;
                }else{
                    [PublicHttpTool shareInstance].isShaZhuOperation = YES;
                }
                 [self queryDeviceChipsUID];
            }else if (killConfirmType==3){//识别找回筹码
                [PublicHttpTool shareInstance].isZhaoHuiChip = YES;
                [self queryDeviceChipsUID];
            }else{
                [self clearAllStepsJudge];
                [self.operationInfoView _resetBtnStatus];
            }
        };
    }
}

#pragma mark - 更改客人洗码号
- (void)showUpdateWashNumberView{
    EmpowerView *empowerView = [[AppDelegate shareInstance]empowerView];
    [[MJPopTool sharedInstance] popView:empowerView animated:YES];
    @weakify(self);
    empowerView.sureActionBlock = ^(NSString * _Nonnull adminName, NSString * _Nonnull password) {
        @strongify(self);
        [PublicHttpTool shareInstance].curupdateInfo.femp_num = adminName;
        [PublicHttpTool shareInstance].curupdateInfo.femp_pwd = password;
        [self showWaitingView];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [PublicHttpTool authorizationAccountWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                [self hideWaitingView];
                if (success) {
                    [EPPopView showEntryInView:self.view WithTitle:@"请输入洗码号" handler:^(NSString *entryText) {
                        @strongify(self);
                        if ([[entryText NullToBlankString]length]==0) {
                            [self showMessage:@"请输入洗码号"];
                        }else{
                            [PublicHttpTool showWaitingView];
                            [PublicHttpTool updateCustomerWashNumberWithChipList:self.chipUIDList CurWashNumber:entryText Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                                @strongify(self);
                                if (success) {
                                    self.curChipInfo.guestWashesNumber = entryText;
                                    self.operateChipCount = (int)self.chipUIDList.count;
                                    [self writeChipWashNumberList:self.chipUIDList];
                                }else{
                                    [PublicHttpTool showSoundMessage:msg];
                                }
                            }];
                        }
                    }];
                }else{
                    [PublicHttpTool showSoundMessage:msg];
                }
            }];
        });
    };
}

#pragma mark - 筹码信息检测
- (BOOL)chipInfoCheck{
    if (self.washNumberList.count>1) {
        [PublicHttpTool showSoundMessage:@"不能出现多种洗码号"];
        return NO;
    }
    if (self.chipTypeList.count>1) {
        [PublicHttpTool showSoundMessage:@"不能出现两种筹码类型"];
        return NO;
    }
    return YES;
}

#pragma mark - 查询设备上的筹码UID
- (void)queryDeviceChipsUID{
    [EPSound playWithSoundName:@"click_sound"];
    [self showWaitingView];
    self.chipUIDData = nil;
    self.isReadChipUID = YES;
    self.isReadChipInfo = NO;
    [SGSocketManager SendDataWithData:[NRCommand nextQueryChipNumbers]];
}

#pragma mark - 读取设备上的筹码内容
- (void)readChipsInfoWithChipList:(NSArray *)chipList{
    //执行读取命令
    [PublicHttpTool checkChipIsTrueWithChipList:chipList Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            self.isReadChipUID = NO;
            self.chipUIDData = nil;
            dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
            dispatch_async(serialQueue, ^{
                //向指定标签中写入数据（所有块）
                for (int i = 0; i < chipList.count; i++) {
                    NSString *chipID = chipList[i];
                    [SGSocketManager SendDataWithData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID]];
                    usleep(chipSleepTime);
                }
            });
        }else{
            [self showSoundMessage:msg];
        }
    }];
}

#pragma mark ***************************小费模块******************************
#pragma mark - 小费弹出框
- (void)showTipsInfoView{
    self.recordTipShowView = [EPPopAtipInfoView showInWindowWithNRCustomerInfo:self.customerInfo handler:^(int buttonType) {
        if (buttonType==1) {
            [PublicHttpTool showWaitingView];
            [self.recordTipShowView _hide];
            [PublicHttpTool shareInstance].curupdateInfo.cp_xiaofeiList = self.chipUIDList;
            [PublicHttpTool commitTipResultWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                if (success) {
                    [PublicHttpTool showSucceedSoundMessage:@"提交成功"];
                }else{
                    [PublicHttpTool showSoundMessage:msg];
                }
            }];
        }
    }];
}

#pragma mark - 识别筹码
- (void)detectionChipShowView{
    self.chipInfoView = [[AppDelegate shareInstance]chipInfoView];
    [[MJPopTool sharedInstance] popView:self.chipInfoView animated:YES];
    @weakify(self);
    self.chipInfoView.sureActionBlock = ^(NSInteger killConfirmType) {
        @strongify(self);
        [PublicHttpTool shareInstance].detectionChip = killConfirmType;
        if (killConfirmType==1) {//识别筹码
            [self queryDeviceChipsUID];
        }
    };
}

#pragma mark -- 换钱
- (void)distoryOrbindChipInfo{
    [PublicHttpTool changeChipWashNumberWithChipList:self.chipUIDList WashNumber:self.curBindChipWashNumber ChangChipList:self.bindChipUIDList Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [PublicHttpTool shareInstance].exchangeMoneySecondStep = NO;
        [self hideWaitingView];
        if (success) {
            self.isDasanChip = YES;
            self.curChipInfo.guestWashesNumber = self.curBindChipWashNumber;
            self.operateChipCount = (int)self.chipUIDList.count+(int)self.bindChipUIDList.count;
            [self clearChipWashNumberList:self.chipUIDList];
            usleep(chipSleepTime);
            [self writeChipWashNumberList:self.bindChipUIDList];
        }else{
            [self showSoundMessage:msg];
        }
    }];
}

#pragma mark - 绑定筹码
- (void)bindChipsWithWashNumber{
    [PublicHttpTool shareInstance].exchangeMoneyFirstStep = NO;
    @weakify(self);
    self.daSanInfoView = [EPDaSanInfoView showInWindowWithNRCustomerInfo:self.curChipInfo handler:^(int buttonType) {
        @strongify(self);
        if (buttonType==1) {
            [PublicHttpTool shareInstance].exchangeMoneySecondStep = YES;
            self.hasShowResult = YES;
            [self queryDeviceChipsUID];
        }else{
            self.hasShowResult = NO;
        }
    }];
}

#pragma mark--写入赔付筹码洗码号
- (void)writePayChipsWashNumberCommand{
    self.isOperateChip = YES;
    self.isReadChipInfo = NO;
    self.operateChipCount = (int)self.payChipUIDList.count+(int)self.shuiqianChipUIDList.count;
    [self writeChipWashNumberList:self.payChipUIDList];
    [self clearChipWashNumberList:self.shuiqianChipUIDList];
}

#pragma mark - 提交客人输赢记录
- (void)commitCustomerInfoWithRealChipUIDList:(NSArray *)realChipUIDList{
    @weakify(self);
    [PublicHttpTool commitCustomerRecord_AutoWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        @strongify(self);
        if (success) {
            if ([PublicHttpTool shareInstance].winOrLose) {
                [self writePayChipsWashNumberCommand];
            }else{
                [self clearShazhuChipsWashNumberCommand];
            }
        }else{
            [PublicHttpTool hideWaitingView];
            if ([msg isEqualToString:@"筹码金额和应付金额不一致"]&&self.customerInfo.isTiger) {
                int shoudZhaohuiValue = [[PublicHttpTool shareInstance].curupdateInfo.cp_benjin intValue]- [[PublicHttpTool shareInstance].curupdateInfo.cp_money intValue];
                [self showSoundMessage:[NSString stringWithFormat:@"需找回筹码:%d",shoudZhaohuiValue]];
            }else{
                [self showSoundMessage:msg];
            }
        }
    }];
}

#pragma mark--清除杀注筹码洗码号
- (void)clearShazhuChipsWashNumberCommand{
    self.isOperateChip = YES;
    self.chipUIDData = nil;
    self.isReadChipUID = NO;
    self.isReadChipInfo = NO;
    self.operateChipCount = (int)[PublicHttpTool shareInstance].curupdateInfo.cp_ChipUidList.count;
    if (self.customerInfo.isTiger||self.customerInfo.isCow) {
        [PublicHttpTool shareInstance].shouldZhaoHuiValue = 0;
        self.operateChipCount = (int)self.zhaoHuiChipUIDList.count+(int)self.chipUIDList.count;
        [self writeChipWashNumberList:self.zhaoHuiChipUIDList];
        usleep(chipSleepTime);
    }
    [self clearChipWashNumberList:[PublicHttpTool shareInstance].curupdateInfo.cp_ChipUidList];
}

#pragma mark - 提交客人输赢记录（杀注）
- (void)commitCustomerInfo_ShaZhuWithRealChipUIDList:(NSArray *)realChipUIDList{
    @weakify(self);
    [PublicHttpTool commitCustomerRecord_ShaZhuWithWashNumberList:self.washNumberList Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        @strongify(self);
        if (success) {
            self.operateChipCount = (int)realChipUIDList.count;
            [self clearShazhuChipsWashNumberCommand];
        }else{
            [self showSoundMessage:msg];
        }
    }];
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
    if ([dataHexStr isEqualToString:@"040000525a"]&&[SGSocketManager shareInstance].closeDeviceAuto) {
        [SGSocketManager shareInstance].closeDeviceAuto = NO;
        return NO;
    }
    return YES;
}

#pragma mark -- 清除所有判断条件
- (void)clearAllStepsJudge{
    self.hasShowResult = NO;
    self.isReadChipUID = NO;
    self.isShaZhuAction = NO;
    self.isReadChipUID = NO;
    self.isReadChipInfo = NO;
    self.isOperateChip = NO;
    self.isDasanChip = NO;
    self.isUpdateWashNumber = NO;
    self.identifyValue = 0;
    [PublicHttpTool shareInstance].curupdateInfo.cp_zhaohuiList = [NSArray array];
    [PublicHttpTool shareInstance].curupdateInfo.cp_DashuiUidList = [NSArray array];
}

#pragma mark -- 检测筹码是否正确
- (BOOL)hasChipCorrect{
    if ([BLEIToll calculateChipNumberWithHexData:self.chipUIDData]==0) {//设备上没有筹码
        NSString *msg = @"未检测到筹码";
        if ([PublicHttpTool shareInstance].recordTips) {
            msg = @"未检测到小费筹码";
        }
        [self.operationInfoView _resetBtnStatus];
        [self showSoundMessage:msg];
        return NO;
    }else{
        return YES;
    }
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
    [self.chipUIDData appendData:data];
    DLOG(@"self.chipUIDData = %@",self.chipUIDData);
    NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
    BLEIToll *itool = [[BLEIToll alloc]init];
    if (self.isReadChipUID) {//正在识别筹码UI
        if ([chipNumberdataHexStr hasSuffix:@"04000e2cb3"]) {//检测到结束字符,识别筹码UID完毕
            if (![self hasChipCorrect]) {
                return;
            }
            self.isReadChipUID = NO;
            if (self.hasShowResult) {//已经弹出杀赔框
                if ([PublicHttpTool shareInstance].isDaShuiOperation){//识别水钱
                    self.shuiqianChipUIDList = [itool getDeviceRealShuiqianChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithPayUidList:self.payChipUIDList];
                    self.shuiqianChipCount = self.shuiqianChipUIDList.count;
                    if (self.shuiqianChipCount==0) {//没有水钱筹码
                        [PublicHttpTool shareInstance].isDaShuiOperation = NO;
                        [PublicHttpTool showSoundMessage:@"未检测到水钱筹码"];
                    }else{
                        self.isReadChipInfo = YES;
                        [PublicHttpTool shareInstance].curupdateInfo.cp_DashuiUidList = self.shuiqianChipUIDList;
                        [self readChipsInfoWithChipList:self.shuiqianChipUIDList];
                    }
                }else if ([PublicHttpTool shareInstance].isShaZhuOperation){//杀注界面
                    if ([BLEIToll calculateChipNumberWithHexData:self.chipUIDData] != self.chipUIDList.count) {
                        [PublicHttpTool shareInstance].isShaZhuOperation = NO;
                        [PublicHttpTool showSoundMessage:@"筹码金额不一致"];
                        return;
                    }
                    [self commitCustomerInfo_ShaZhuWithRealChipUIDList:self.chipUIDList];
                }else if ([PublicHttpTool shareInstance].isZhaoHuiChip){
                    //找回筹码UID
                    self.zhaoHuiChipUIDList = [itool getDeviceALlPayChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithShuiqianUidList:self.payChipUIDList];
                    self.zhaoHuiChipCount = self.zhaoHuiChipUIDList.count;
                    if (self.zhaoHuiChipCount==0) {
                        [PublicHttpTool shareInstance].isZhaoHuiChip = NO;
                        self.killShowView.cowZhaohuiMoneyLab.text = [NSString stringWithFormat:@"%@:%d",@"已找回",0];
                        [PublicHttpTool showSoundMessage:@"未检测到找回筹码"];
                    }else{
                        self.isReadChipInfo = YES;
                        [self readChipsInfoWithChipList:self.zhaoHuiChipUIDList];
                    }
                }else if ([PublicHttpTool shareInstance].exchangeMoneySecondStep){//换钱
                    //存贮筹码UID
                    self.bindChipUIDList = [itool getDeviceALlPayChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithShuiqianUidList:[NSArray array]];
                    self.bindChipCount = self.bindChipUIDList.count;
                    if (self.bindChipCount==0) {
                        [PublicHttpTool shareInstance].exchangeMoneyFirstStep = NO;
                        [PublicHttpTool showSoundMessage:@"未检测到与打散筹码相同金额的筹码"];
                        return;
                    }else{
                        [self hideWaitingView];
                        self.isReadChipInfo = YES;
                        [self readChipsInfoWithChipList:self.bindChipUIDList];
                    }
                }else{
                    //赔付筹码UID
                    self.payChipUIDList = [itool getDeviceCow_ALlPayChipUIDWithBLEString:chipNumberdataHexStr WithUidList:self.chipUIDList WithShuiqianUidList:self.shuiqianChipUIDList WithZhaoHuiUidList:self.zhaoHuiChipUIDList];
                    self.payChipCount = self.payChipUIDList.count;
                    if (self.payChipCount==0) {
                        if (self.customerInfo.isCow) {
                            self.killShowView.cowHadMoneyLab.text = [NSString stringWithFormat:@"%@:0",@"已加赔"];
                            [PublicHttpTool showSoundMessage:@"未检测到加赔筹码"];
                        }else{
                            self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                            [PublicHttpTool showSoundMessage:@"未检测到赔付筹码"];
                        }
                    }else{
                        self.isReadChipInfo = YES;
                        [self readChipsInfoWithChipList:self.payChipUIDList];
                    }
                }
            }else{
                self.chipUIDList = [itool getDeviceAllChipUIDWithBLEString:chipNumberdataHexStr];
                self.chipCount = self.chipUIDList.count;
                if (self.isUpdateWashNumber) {//修改洗码号
                    [self hideWaitingView];
                    self.isReadChipInfo = NO;
                    [self showUpdateWashNumberView];
                }else{
                    self.isReadChipInfo = YES;
                    [self readChipsInfoWithChipList:self.chipUIDList];
                }
            }
        }
    }else if (self.isReadChipInfo){//识别筹码信息
        NSInteger infoByteLength = 60;
        if (self.hasShowResult) {//已经弹出结果展示界面
            if ([PublicHttpTool shareInstance].isDaShuiOperation){//识别水钱
                infoByteLength = self.shuiqianChipCount*infoByteLength;
            }else if ([PublicHttpTool shareInstance].isZhaoHuiChip){//找回筹码
                infoByteLength = self.zhaoHuiChipCount*infoByteLength;
            }else if ([PublicHttpTool shareInstance].exchangeMoneySecondStep){//打散筹码
                infoByteLength = self.bindChipCount*infoByteLength;
            }else{
                infoByteLength = self.payChipCount*infoByteLength;
            }
        }else{//本金
            infoByteLength = self.chipCount*infoByteLength;
        }
        if (chipNumberdataHexStr.length==infoByteLength) {//数据长度相同，筹码信息已经接受完毕
            self.chipUIDData = nil;
            NSArray *chipInfo = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr];
            DLOG(@"ChipInfo = %@",chipInfo);
            __block BOOL isWashNumberTrue = YES;
            __block BOOL isPayWashNumberTrue = YES;
            __block int chipAllMoney = 0;
            [self.chipTypeList removeAllObjects];
            [self.washNumberList removeAllObjects];
            [chipInfo enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *chipType = infoList[1];
                NSString *chipWashNumber = infoList[4];
                if ([[chipWashNumber NullToBlankString]length]==0||[chipWashNumber isEqualToString:@"0"]) {
                    isWashNumberTrue = NO;
                }
                if (![chipWashNumber isEqualToString:@"0"]){
                    if (!self.customerInfo.isCow) {
                        isPayWashNumberTrue = NO;
                    }
                }
                if (![self.chipTypeList containsObject:chipType]) {
                    [self.chipTypeList addObject:chipType];
                }
                if (![self.washNumberList containsObject:chipWashNumber]) {
                    [self.washNumberList addObject:chipWashNumber];
                }
                NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                chipAllMoney += [realmoney intValue];
            }];
            if (self.hasShowResult) {//弹出杀赔框
                if ([PublicHttpTool shareInstance].isDaShuiOperation) {//识别水钱
                    if (!isWashNumberTrue) {
                        [PublicHttpTool shareInstance].isDaShuiOperation = NO;
                        self.shuiqianChipUIDList = nil;
                        self.identifyValue = 0;
                        [PublicHttpTool showSoundMessage:@"水钱筹码错误"];
                        return;
                    }
                    self.identifyValue = chipAllMoney;
                    [self identifyWaterMoney];
                    [self hideWaitingView];
                    [EPSound playWithSoundName:@"succeed_sound"];
                }else if ([PublicHttpTool shareInstance].isZhaoHuiChip){//杀注找回筹码
                    [PublicHttpTool shareInstance].isZhaoHuiChip = NO;
                    if (!isPayWashNumberTrue) {
                        [PublicHttpTool showSoundMessage:@"找回筹码不正确"];
                        return;
                    }
                    if (self.washNumberList.count>1) {
                        [PublicHttpTool showSoundMessage:@"不能出现多种洗码号"];
                        return;
                    }
                    if (self.chipTypeList.count>1) {
                        [PublicHttpTool showSoundMessage:@"存在多个筹码类型"];
                        return;
                    }
                    if (![self.chipTypeList.firstObject isEqualToString:self.curChipInfo.chipType]) {
                        [PublicHttpTool showSoundMessage:@"找回筹码类型与本金筹码类型不一致"];
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [PublicHttpTool shareInstance].curupdateInfo.cp_zhaohuiList = self.zhaoHuiChipUIDList;
                        self.curChipInfo.hasKillZhaohuiMoney = [NSString stringWithFormat:@"%d",chipAllMoney];
                        self.killShowView.havepayChipLab.text = [NSString stringWithFormat:@"%@:%d",@"已找回",chipAllMoney];
                        if (self.customerInfo.isTiger) {
                            [self commitCustomerInfoWithRealChipUIDList:self.chipUIDList];
                        }else{
                            self.hasZhaoHuiValue = chipAllMoney;
                            self.killShowView.cowZhaohuiMoneyLab.text = [NSString stringWithFormat:@"%@:%d",@"已找回",chipAllMoney];
                            [PublicHttpTool showSucceedSoundMessage:@"识别找回筹码成功"];
                        }
                    });
                }else if ([PublicHttpTool shareInstance].exchangeMoneySecondStep){
                    if (!isPayWashNumberTrue) {
                        [PublicHttpTool shareInstance].exchangeMoneySecondStep = NO;
                        [self showSoundMessage:@"打散筹码有误"];
                        return;
                    }
                    self.daSanInfoView.hasPayMoneyLab.text = [NSString stringWithFormat:@"已放入金额:%d",chipAllMoney];
                    int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                    if (chipAllMoney != benjinMoney) {
                        [PublicHttpTool shareInstance].exchangeMoneySecondStep = NO;
                        [self showSoundMessage:@"打散金额不匹配,请检查筹码金额是否正确"];
                        return;
                    }
                    self.isReadChipInfo = NO;
                    self.isReadChipUID  = NO;
                    [self distoryOrbindChipInfo];
                }else{//赔付筹码
                    if (!isPayWashNumberTrue) {
                        self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",0];
                        [self showSoundMessage:@"赔付筹码有误"];
                        return;
                    }
                    if (self.chipTypeList.count>1) {
                        [self showSoundMessage:@"存在多个筹码类型"];
                        return;
                    }
                    if (![self.chipTypeList.firstObject isEqualToString:self.curChipInfo.chipType]) {
                        [self showSoundMessage:@"赔付筹码类型与本金筹码类型不一致"];
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        int benjinMoney = [self.curChipInfo.chipDenomination intValue];
                        if (self.customerInfo.isCow) {
                            self.killShowView.cowHadMoneyLab.text = [NSString stringWithFormat:@"%@:%d",@"已加赔",chipAllMoney];
                            if ([PublicHttpTool shareInstance].shouldZhaoHuiValue>0) {
                                if ([PublicHttpTool shareInstance].shouldZhaoHuiValue>self.hasZhaoHuiValue) {
                                    [self showSoundMessage:@"请增加找回筹码金额"];
                                    return;
                                }
                            }else{
                                if ([self.killShowView calculateZhaoHuiMoneyWithRealJaiPeiMoney:chipAllMoney]==-1) {//需要找回筹码
                                    [self showSoundMessage:@"加赔金额过大，需要找回筹码"];
                                    return;
                                }else if ([self.killShowView calculateZhaoHuiMoneyWithRealJaiPeiMoney:chipAllMoney]==0){
                                    [self showSoundMessage:@"请增加加赔筹码金额"];
                                    return;
                                }
                                int calu_jiapeiValue = chipAllMoney - [self.customerInfo.add_chipMoney intValue];
                                if ([self.curChipInfo.chipType intValue]==1) {
                                    [self.killShowView calculateTotalMoneyWithJiapei_UsdValue:0 jiaPei_rmbValue:calu_jiapeiValue];
                                }else{
                                    [self.killShowView calculateTotalMoneyWithJiapei_UsdValue:calu_jiapeiValue jiaPei_rmbValue:0];
                                }
                            }
                        }else{
                            self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",benjinMoney+chipAllMoney];
                            self.payShowView.havPayedAmountLab.text = [NSString stringWithFormat:@"%@:%d",@"已赔付筹码/Amount already paid",chipAllMoney];
                        }
                        NSMutableArray *realChipUIDList = [NSMutableArray array];
                        [realChipUIDList addObjectsFromArray:self.chipUIDList];
                        [realChipUIDList addObjectsFromArray:self.payChipUIDList];
                        [PublicHttpTool shareInstance].curupdateInfo.cp_ChipUidList = realChipUIDList;
                        [self commitCustomerInfoWithRealChipUIDList:realChipUIDList];
                    });
                }
            }else if ([PublicHttpTool shareInstance].exchangeMoneyFirstStep){//打散筹码
                if (!isWashNumberTrue) {
                    [PublicHttpTool shareInstance].exchangeMoneyFirstStep = NO;
                    [self showSoundMessage:@"检测到有异常洗码号的筹码"];
                    return;
                }
                //客人洗码号
                self.curChipInfo.guestWashesNumber = chipInfo[0][4];
                NSString *chipType = [self.chipTypeList.firstObject NullToBlankString];
                self.curChipInfo.chipType = chipType;
                self.curBindChipWashNumber = self.curChipInfo.guestWashesNumber;
                self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",chipAllMoney];
                [self hideWaitingView];
                [self bindChipsWithWashNumber];
            }else if ([PublicHttpTool shareInstance].recordTips){//记录小费
                if (!isWashNumberTrue) {
                    [PublicHttpTool shareInstance].recordTips = NO;
                    [self showSoundMessage:@"小费筹码错误"];
                    return;
                }
                self.curChipInfo.tipWashesNumber = chipInfo[0][4];
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
                [self hideWaitingView];
                if ([PublicHttpTool shareInstance].detectionChip) {//查询筹码信息
                    [PublicHttpTool shareInstance].detectionChip = NO;
                    [self.chipInfoList removeAllObjects];
                    [self.chipInfoList addObjectsFromArray:chipInfo];
                    //响警告声音
                    [EPSound playWithSoundName:@"succeed_sound"];
                    [self.chipInfoView fellChipViewWithChipList:self.chipInfoList];
                }else{
                    [self.shazhuInfoList removeAllObjects];
                    NSArray *chip_shazhuList = [BLEIToll shaiXuanShazhuListWithOriginalList:chipInfo];
                    [self.shazhuInfoList addObjectsFromArray:chip_shazhuList];
                    if ((!isWashNumberTrue)||self.washNumberList.count==0) {
                        [self showSoundMessage:@"检测到有异常洗码号的筹码"];
                        [self.operationInfoView _resetBtnStatus];
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.curChipInfo.chipDenomination = [NSString stringWithFormat:@"%d",chipAllMoney];
                        [self showPayOrKillView];
                    });
                }
            }
        }
    }else{
        int statusCount = [NRCommand showBackStatusCountWithHexStatus:chipNumberdataHexStr AllChipCount:2*self.operateChipCount];
        if (statusCount==1) {//正常
            [self hideWaitingView];
            if (self.isOperateChip) {//正在操作筹码，赔付或者杀注
                if ([PublicHttpTool shareInstance].winOrLose) {//闲家赢
                    [self.payShowView removeFromSuperview];
                    [PublicHttpTool showSucceedSoundMessage:@"赔付成功"];
                }else{//庄家赢
                    [self.killShowView removeFromSuperview];
                    [PublicHttpTool showSucceedSoundMessage:[EPStr getStr:kEPShazhuSucceed note:@"杀注成功"]];
                }
                [self.operationInfoView _resetBtnStatus];
            }else if (self.isDasanChip){//打散筹码
                [self.daSanInfoView _hide];
                [PublicHttpTool showSucceedSoundMessage:@"打散成功"];
            }else if (self.isUpdateWashNumber){//修改洗码号
                [PublicHttpTool showSucceedSoundMessage:@"修改成功"];
            }
            [self clearAllStepsJudge];
        }else if (statusCount==2){//有异常
            [self hideWaitingView];
            if (self.isOperateChip) {
                self.isOperateChip = NO;
                NSString *showTipMsg = @"杀注成功,但是筹码数据清除异常，请检查!!!";
                if ([PublicHttpTool shareInstance].winOrLose) {//闲家赢
                    [self.payShowView removeFromSuperview];
                    showTipMsg = @"赔付成功,但是筹码数据写入洗码号异常，请检查!!!";
                }else{
                    [self.killShowView removeFromSuperview];
                }
                [EPPopView showInWindowWithMessage:showTipMsg handler:^(int buttonType) {
                    [self.operationInfoView _resetBtnStatus];
                }];
                [EPSound playWithSoundName:@"succeed_sound"];
            }else if (self.isDasanChip){//打散筹码
                [self.daSanInfoView _hide];
                [PublicHttpTool showSucceedSoundMessage:@"打散成功,但是筹码数据写入异常，请检查!!!"];
            }else if (self.isUpdateWashNumber){//修改洗码号
                [PublicHttpTool showSucceedSoundMessage:@"修改成功,但是筹码数据修改异常，请检查!!!"];
            }
            [self clearAllStepsJudge];
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
    [SGSocketManager shareInstance].closeDeviceAuto = YES;
    [SGSocketManager SendDataWithData:[NRCommand setDeviceWorkModel]];
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
