//
//  NRAddOrMinusChipDetailViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2020/9/19.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRAddOrMinusChipDetailViewController.h"
#import "ChipAddOrMinusView.h"
#import "NRAddOrMinusDetailCell.h"
#import "NRKaiTaiInfo.h"
#import "NRAddOrChipInfo.h"
#import "NRZhangFangInfo.h"
#import "NRKaiTaiInfo.h"
#import "NRSingleChipViewController.h"

@interface NRAddOrMinusChipDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *chipInfoList;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) NRAddOrChipInfo *curAddOrMinusChipInfo;//台桌
@property (nonatomic, strong) NRZhangFangInfo *curZhangFangInfo;//账房
@property (nonatomic, strong) NRKaiTaiInfo *curKaiTaiInfo;//开台

@property (nonatomic, assign) int curSelectedIndex;
@property (nonatomic, strong) NSMutableArray *curOperationChipUidList;
@property (nonatomic, strong) NSString *curPfid;

@end

@implementation NRAddOrMinusChipDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    self.curOperationChipUidList = [NSMutableArray arrayWithCapacity:0];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.confirmBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(80);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(0);
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.confirmBtn.mas_top).offset(0);
    }];
    [self.tableView registerClass:[NRAddOrMinusDetailCell class] forCellReuseIdentifier:@"addOrMinusDetailCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([self.curInfo isKindOfClass:[NRKaiTaiInfo class]]) {
        self.curKaiTaiInfo = (NRKaiTaiInfo *)self.curInfo;
        [self getChipDetailInfoWithDict:self.curKaiTaiInfo.fid];
    }else if ([self.curInfo isKindOfClass:[NRAddOrChipInfo class]]){
        self.curAddOrMinusChipInfo = (NRAddOrChipInfo *)self.curInfo;
        [self getChipDetailInfoWithDict:self.curAddOrMinusChipInfo.fid];
    }else if ([self.curInfo isKindOfClass:[NRZhangFangInfo class]]){
        self.curZhangFangInfo = (NRZhangFangInfo *)self.curInfo;
        [self getAccountChipDetailInfoWithDict:self.curZhangFangInfo.fid SumerId:self.curZhangFangInfo.snumber];
    }
    
}

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    [self.titleBar setTitle:@"VM娱乐筹码管理"];
    [self setLeftItemForGoBack];
    self.titleBar.showBottomLine = YES;
    [self configureTitleBarToBlack];
}

#pragma mark - 获取筹码详情
- (void)getChipDetailInfoWithDict:(NSString *)tableID{
    [PublicHttpTool showWaitingView];
    NSString *actionStr = @"";
    if ([PublicHttpTool shareInstance].operationType==0) {
        actionStr = @"4";
    }else if ([PublicHttpTool shareInstance].operationType==3){
        actionStr = @"1";
    }else if ([PublicHttpTool shareInstance].operationType==4){
        actionStr = @"2";
    }
    NSDictionary * param = @{
            @"access_token":[PublicHttpTool shareInstance].access_token,
            @"foperate_id":tableID,
            @"ftype":actionStr
    };
    [PublicHttpTool queryTable_operate_detailWithParams:param Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [PublicHttpTool hideWaitingView];
        if (success) {
            NSArray *listArray = (NSArray *)data;
            [self fengzhuangChipInfoWithList:listArray];
        }
    }];
}

- (void)fengzhuangChipInfoWithList:(NSArray *)list{
    [self.chipInfoList removeAllObjects];
    NSDictionary *topDict = @{@"fcmtype_id":@"0",@"fnums":@"0",@"fme":@"0"};
    [self.chipInfoList addObject:topDict];
    [list enumerateObjectsUsingBlock:^(NSDictionary *chipInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        self.curPfid = [NSString stringWithFormat:@"%@",chipInfo[@"fid"]];
        NSMutableDictionary *chipInfoDict = [NSMutableDictionary dictionary];
        NSArray *cmDataList = chipInfo[@"cmdata"];
        [chipInfoDict setObject:cmDataList forKey:@"chipList"];
        __block int totalChipNum = 0;
        [cmDataList enumerateObjectsUsingBlock:^(NSDictionary *cmDict, NSUInteger cmidx, BOOL * _Nonnull stop) {
            totalChipNum += [cmDict[@"fnums"] intValue];
            [chipInfoDict setObject:cmDict[@"fcmtype_id"] forKey:@"fcmtype_id"];
        }];
        [chipInfoDict setObject:[NSString stringWithFormat:@"%d",totalChipNum] forKey:@"fnums"];
        [chipInfoDict setObject:chipInfo[@"totalmoney"] forKey:@"totalmoney"];
        [self.chipInfoList addObject:chipInfoDict];
    }];
    [self.tableView reloadData];
}

#pragma mark - 获取柜台筹码详情
- (void)getAccountChipDetailInfoWithDict:(NSString *)tableID SumerId:(NSString *)sumerId{
    [PublicHttpTool showWaitingView];
    NSString *actionType = @"1";
    if ([PublicHttpTool shareInstance].operationType==2) {
        actionType = @"2";
    }
    NSDictionary * param = @{
            @"access_token":[PublicHttpTool shareInstance].access_token,
            @"applyinfo_id":tableID,
            @"action":actionType,
            @"kind":@"1"
    };
    [PublicHttpTool account_operate_detailWithParams:param Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [PublicHttpTool hideWaitingView];
        if (success) {
            NSArray *listArray = (NSArray *)data;
            [self fengzhuangChipInfoWithList:listArray];
        }
    }];
}

- (void)footerBtnAction{
   if ([PublicHttpTool shareInstance].operationType==1||[PublicHttpTool shareInstance].operationType==2){
        [self addOrMinusAccountChip];
    }else{
        [self addOrMinusTableChip];
    }
}

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell.reuseIdentifier isEqualToString:@"addOrMinusDetailCell"]){
        NSDictionary *chipDict = self.chipInfoList[indexPath.row];
        NSString *chipTypeText = @"筹码类型";
        if ([chipDict[@"fcmtype_id"] intValue]==1) {//人民币码
            chipTypeText = @"人民币码";
        }else if ([chipDict[@"fcmtype_id"] intValue]==2){//美金码
            chipTypeText = @"美金码";
        }else if ([chipDict[@"fcmtype_id"] intValue]==6){//人民币
            chipTypeText = @"人民币";
        }else if ([chipDict[@"fcmtype_id"] intValue]==7){//美金
            chipTypeText = @"美金";
        }else if ([chipDict[@"fcmtype_id"] intValue]==8){//RMB贵宾码
            chipTypeText = @"RMB贵宾码";
        }else if ([chipDict[@"fcmtype_id"] intValue]==9){//USD贵宾码
            chipTypeText = @"USD贵宾码";
        }
        NSString *chipMoneyText = [NSString stringWithFormat:@"%@",chipDict[@"totalmoney"]];
        if ([chipMoneyText intValue]==0) {
            chipMoneyText = @"筹码总金额";
        }
        NSString *chipNumText = [NSString stringWithFormat:@"%@",chipDict[@"fnums"]];
        if ([chipNumText intValue]==0) {
            chipNumText = @"筹码总数量";
        }
        NSString *chipMoney = chipMoneyText;
        NSString *chipNum = chipNumText;
        NRAddOrMinusDetailCell *newCell = (NRAddOrMinusDetailCell *)cell;
        [newCell configureWithChipTypeText:chipTypeText ChipMoneyText:chipMoney ChipNumText:chipNum];
    }
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chipInfoList.count;
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
    return [NRAddOrMinusDetailCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"addOrMinusDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.chipInfoList[indexPath.row];
    NRSingleChipViewController *VC = [[NRSingleChipViewController alloc]init];
    VC.infoDict = dict;
    @weakify(self);
    VC.tranChipUIDListBlock = ^(NSArray * _Nonnull chipUIDList) {
        @strongify(self);
        [self.curOperationChipUidList addObjectsFromArray:chipUIDList];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -- 台桌加减彩操作
-(void)addOrMinusTableChip{
    if (self.curOperationChipUidList.count==0) {
        [self showMessage:@"请先完成加码"];
        return;
    }
    [self showWaitingView];
    NSString *chiUIDStr = [self.curOperationChipUidList componentsJoinedByString:@","];
    NSDictionary * param = @{};
    if ([PublicHttpTool shareInstance].operationType==0) {//开台
        param = @{
                @"access_token":[PublicHttpTool shareInstance].access_token,
                @"id":self.curKaiTaiInfo.fid,//台桌ID
                @"pfid":self.curPfid,//台桌ID
                @"hardlist":chiUIDStr
        };
    }else{
        param = @{
                @"access_token":[PublicHttpTool shareInstance].access_token,
                @"id":self.curAddOrMinusChipInfo.fid,//台桌ID
                @"hardlist":chiUIDStr
        };
    }
    [PublicHttpTool tableAddOrMinusChipWithParams:param Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [self hideWaitingView];
        if (success) {
            if ([PublicHttpTool shareInstance].operationType ==4) {
                [self showMessage:@"减彩成功" withSuccess:YES];
            }else{
                if ([PublicHttpTool shareInstance].operationType==0) {
                    [self showMessage:@"开台成功" withSuccess:YES];
                }else{
                    [self showMessage:@"加彩成功" withSuccess:YES];
                }
            }
            if (self.refrashTableBlock) {
                self.refrashTableBlock([PublicHttpTool shareInstance].operationType);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showSoundMessage:msg];
        }
    }];
}

#pragma mark -- 账房加减彩操作
-(void)addOrMinusAccountChip{
    if (self.curOperationChipUidList.count==0) {
        [self showMessage:@"请先完成加码"];
        return;
    }
    [self showWaitingView];
    NSString *chiUIDStr = [self.curOperationChipUidList componentsJoinedByString:@","];
    NSDictionary * param = @{
            @"access_token":[PublicHttpTool shareInstance].access_token,
            @"applyid":self.curZhangFangInfo.fid,
            @"hardlist":chiUIDStr
    };
    [PublicHttpTool addOrMinusChipWithParams:param Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [self hideWaitingView];
        if (success) {
            if ([PublicHttpTool shareInstance].operationType ==2) {
                [self showMessage:@"账房减彩成功" withSuccess:YES];
            }else{
                [self showMessage:@"账房加彩成功" withSuccess:YES];
            }
            if (self.refrashTableBlock) {
                self.refrashTableBlock([PublicHttpTool shareInstance].operationType);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showSoundMessage:msg];
        }
    }];
}

@end
