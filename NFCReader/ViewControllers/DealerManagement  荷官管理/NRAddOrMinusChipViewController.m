//
//  DealerManagementViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/18.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRAddOrMinusChipViewController.h"
#import "NRChipManagerInfo.h"
#import "NRDealerManagerViewModel.h"
#import "NRChipCodeItem.h"
#import "EPService.h"
#import "NRLoginInfo.h"
#import "NRChipInfo.h"
#import "NRChipAllInfo.h"
#import "BLEIToll.h"
#import "ChipManagerLeftItem.h"
#import "ChipInfoListTableView.h"
#import "CustomerInfoFooter.h"
#import "ChipAddOrMinusView.h"
#import "NRAddOrChipInfo.h"
#import "NRZhangFangInfo.h"
#import "NRKaiTaiInfo.h"
#import "NRAddOrMinusChipDetailViewController.h"

@interface NRAddOrMinusChipViewController ()

@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *loginRoleLab;
@property (nonatomic, strong) UILabel *IDLab;
@property (nonatomic, strong) UILabel *scanChipNumberLab;
@property (nonatomic, strong) UILabel *centerTipInfoLab;
@property (nonatomic, strong) UIView *toplineView;
@property (nonatomic, strong) ChipInfoListTableView *chipListTableView;
@property (nonatomic, strong) ChipAddOrMinusView    *chipAddOrMinusView;

//筹码管理
@property (nonatomic, strong) ChipManagerLeftItem *leftItemView;
@property (nonatomic, assign) int chipOperationType;
@property (nonatomic, assign) int lastCacheMoney;

@property (nonatomic, strong) NSMutableArray *kaiTaiInfoList;//开台申请列表
@property (nonatomic, strong) NSMutableArray *zhangFangAddInfoList;//账房加彩
@property (nonatomic, strong) NSMutableArray *zhangFangMinusInfoList;//账房减彩
@property (nonatomic, strong) NSMutableArray *tableAddInfoList;//台桌加彩
@property (nonatomic, strong) NSMutableArray *tableMinusInfoList;//台桌减彩

@end

@implementation NRAddOrMinusChipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.kaiTaiInfoList = [NSMutableArray arrayWithCapacity:0];
    self.zhangFangAddInfoList = [NSMutableArray arrayWithCapacity:0];
    self.zhangFangMinusInfoList = [NSMutableArray arrayWithCapacity:0];
    self.tableAddInfoList = [NSMutableArray arrayWithCapacity:0];
    self.tableMinusInfoList = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    CGFloat fontSize = 16;
    self.userNameLab = [UILabel new];
    self.userNameLab.textColor = [UIColor colorWithHexString:@"#959595"];
    self.userNameLab.font = [UIFont systemFontOfSize:fontSize];
    self.userNameLab.text = [NSString stringWithFormat:@"姓名:%@",self.curLoginInfo.femp_xm];
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
    self.IDLab.text = [NSString stringWithFormat:@"ID:%@",self.curLoginInfo.fid];
    [self.view addSubview:self.IDLab];
    [self.IDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(10);
        make.left.equalTo(self.loginRoleLab.mas_right).offset(60);
        make.height.mas_equalTo(20);
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
    
    self.centerTipInfoLab = [UILabel new];
    self.centerTipInfoLab.textColor = [UIColor colorWithHexString:@"#959595"];
    self.centerTipInfoLab.font = [UIFont systemFontOfSize:30];
    self.centerTipInfoLab.text = @"暂无申请记录";
    [self.view addSubview:self.centerTipInfoLab];
    [self.centerTipInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(0);
        make.centerX.equalTo(self.view).offset(100);
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
    
    //加减彩界面
    self.chipAddOrMinusView = [[ChipAddOrMinusView alloc]initWithFrame:allView_frame];
    self.chipAddOrMinusView.hidden = YES;
    [self.view addSubview:self.chipAddOrMinusView];
    
    //默认获取开台申请数据
    [PublicHttpTool shareInstance].operationType=0;
    [self table_getKaiTaiListdata];
    //左边视图按钮事件
    @weakify(self);
    self.leftItemView.bottomBtnBlock = ^(NSInteger tag) {
        @strongify(self);
        self.chipOperationType = (int)tag;
        self.lastCacheMoney = 0;
        [PublicHttpTool shareInstance].operationType = (int)tag;
        if (tag==0) {
            [self table_getKaiTaiListdata];
        }else if (tag==1||tag==2) {//账房加彩
            [self Account_getAccountAddOrMinusChipdata];
        }else if (tag==3){//台桌加彩
            [self Table_getaddChipdata];
        }else if (tag==4){//台桌减彩
            [self Table_getMinusChipdata];
        }
    };
    
    //加减彩列表
    self.chipAddOrMinusView.addOrMinusBlock = ^(NSInteger curIndex) {
        @strongify(self);
        NRAddOrMinusChipDetailViewController *VC = [[NRAddOrMinusChipDetailViewController alloc]init];
        if (self.chipOperationType==0) {
            VC.curInfo = self.kaiTaiInfoList[curIndex];
        }else if (self.chipOperationType==1) {
            VC.curInfo = self.zhangFangAddInfoList[curIndex];
        }else if (self.chipOperationType==2){
            VC.curInfo = self.zhangFangMinusInfoList[curIndex];
        }else if (self.chipOperationType==3){
            VC.curInfo = self.tableAddInfoList[curIndex];
        }else if (self.chipOperationType==4){
            VC.curInfo = self.tableMinusInfoList[curIndex];
        }
        VC.refrashTableBlock = ^(int refrashType) {
            if (refrashType==0) {
                [self table_getKaiTaiListdata];
            }else if (refrashType==1||refrashType==2){
                 [self Account_getAccountAddOrMinusChipdata];
            }else if (refrashType==3){
                 [self Table_getaddChipdata];
            }else if (refrashType==4){
                 [self Table_getMinusChipdata];
            }
        };
        [self.navigationController pushViewController:VC animated:YES];
    };
}

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    [self.titleBar setTitle:@"VM娱乐筹码管理"];
    [self setLeftItemForGoBack];
    self.titleBar.showBottomLine = YES;
    [self configureTitleBarToBlack];
}


#pragma mark -- 获取开台申请列表
-(void)table_getKaiTaiListdata{
    [self showWaitingView];
    NSDictionary * param = @{
            @"access_token":[PublicHttpTool shareInstance].access_token,
            @"limit":@"100",
            @"ftype":@"4",
            @"page":@"1"
    };
    [PublicHttpTool queryKaitaiApplyListWithParams:param Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [self hideWaitingView];
        if (success) {
            NSDictionary *tableOperateDict = (NSDictionary *)data;
            NSArray * allValues = [NSArray yy_modelArrayWithClass:[NRKaiTaiInfo class] json:tableOperateDict[@"data"]];
            if (allValues.count!=0) {
                self.chipAddOrMinusView.hidden = NO;
                self.chipListTableView.hidden = YES;
                [self.kaiTaiInfoList removeAllObjects];
                [self.kaiTaiInfoList addObject:[self addOrMinusInfo]];
                [self.kaiTaiInfoList addObjectsFromArray:allValues];
                [self.chipAddOrMinusView fellWithInfoList:self.kaiTaiInfoList];
            }else{
                self.chipAddOrMinusView.hidden = YES;
                self.chipListTableView.hidden = YES;
            }
        }
    }];
}

#pragma mark -- 获取账房加减彩申请列表
-(void)Account_getAccountAddOrMinusChipdata{
    [self showWaitingView];
    NSString *actionStr = [NSString stringWithFormat:@"%d",self.chipOperationType];
    NSDictionary * param = @{
            @"access_token":[PublicHttpTool shareInstance].access_token,
            @"kind":@"1",
            @"action":actionStr,
            @"limit":@"100",
            @"page":@"1"
    };
    [PublicHttpTool Customer_getapplyinfoWithParams:param Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [self hideWaitingView];
        if (success) {
            NSDictionary *tableOperateDict = (NSDictionary *)data;
            NSArray * allValues = [NSArray yy_modelArrayWithClass:[NRZhangFangInfo class] json:tableOperateDict[@"data"]];
            if (allValues.count!=0) {
                self.chipAddOrMinusView.hidden = NO;
                self.chipListTableView.hidden = YES;
                if (self.chipOperationType==1) {
                    [self.zhangFangAddInfoList removeAllObjects];
                    [self.zhangFangAddInfoList addObject:[self accounAddOrMinusInfo]];
                    [self.zhangFangAddInfoList addObjectsFromArray:allValues];
                    [self.chipAddOrMinusView fellWithInfoList:self.zhangFangAddInfoList];
                }else{
                    [self.zhangFangMinusInfoList removeAllObjects];
                    [self.zhangFangMinusInfoList addObject:[self accounAddOrMinusInfo]];
                    [self.zhangFangMinusInfoList addObjectsFromArray:allValues];
                    [self.chipAddOrMinusView fellWithInfoList:self.zhangFangMinusInfoList];
                }
            }else{
                self.chipAddOrMinusView.hidden = YES;
                self.chipListTableView.hidden = YES;
            }
        }
    }];
}

#pragma mark -- 获取台桌加彩申请
-(void)Table_getaddChipdata{
    [self showWaitingView];
    NSDictionary * param = @{
            @"access_token":[PublicHttpTool shareInstance].access_token,
            @"page":@"1",
            @"limit":@"100"
    };
    [PublicHttpTool Table_getaddchipdataWithParams:param Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [self hideWaitingView];
        if (success) {
            NSDictionary *tableOperateDict = (NSDictionary *)data;
            NSArray * allValues = [NSArray yy_modelArrayWithClass:[NRAddOrChipInfo class] json:tableOperateDict[@"data"]];
            DLOG(@"allValues = %@",allValues);
            if (allValues.count!=0) {
                self.chipAddOrMinusView.hidden = NO;
                self.chipListTableView.hidden = YES;
                [self.tableAddInfoList removeAllObjects];
                [self.tableAddInfoList addObject:[self addOrMinusInfo]];
                [self.tableAddInfoList addObjectsFromArray:allValues];
                [self.chipAddOrMinusView fellWithInfoList:self.tableAddInfoList];
            }else{
                self.chipAddOrMinusView.hidden = YES;
                self.chipListTableView.hidden = YES;
            }
        }
    }];
}

#pragma mark -- 获取台桌减彩申请
-(void)Table_getMinusChipdata{
    [self showWaitingView];
    NSDictionary * param = @{
            @"access_token":[PublicHttpTool shareInstance].access_token,
            @"page":@"1",
            @"limit":@"100"
    };
    [PublicHttpTool Table_getMinuschipdataWithParams:param Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [self hideWaitingView];
        if (success) {
            NSDictionary *tableOperateDict = (NSDictionary *)data;
            NSArray * allValues = [NSArray yy_modelArrayWithClass:[NRAddOrChipInfo class] json:tableOperateDict[@"data"]];
            DLOG(@"allValues = %@",allValues);
            if (allValues.count!=0) {
                self.chipAddOrMinusView.hidden = NO;
                self.chipListTableView.hidden = YES;
                [self.tableMinusInfoList removeAllObjects];
                [self.tableMinusInfoList addObject:[self addOrMinusInfo]];
                [self.tableMinusInfoList addObjectsFromArray:allValues];
                [self.chipAddOrMinusView fellWithInfoList:self.tableMinusInfoList];
            }else{
                self.chipAddOrMinusView.hidden = YES;
                self.chipListTableView.hidden = YES;
            }
        }
    }];
}

- (NRAddOrChipInfo *)addOrMinusInfo{
    //存储检测未知数据
    NRAddOrChipInfo *checkInfo = [[NRAddOrChipInfo alloc]init];
    checkInfo.ftbname = @"台桌名称";
    checkInfo.totalmoney = @"总金额";
    checkInfo.fadd_time = @"开台时间";
    return checkInfo;
}

- (NRZhangFangInfo *)accounAddOrMinusInfo{
    //存储检测未知数据
    NRZhangFangInfo *checkInfo = [[NRZhangFangInfo alloc]init];
    checkInfo.applyname = @"账户名称";
    checkInfo.tbtag = @"申请名称";
    checkInfo.totalmoney = @"总金额";
    checkInfo.addtime = @"申请时间";
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
