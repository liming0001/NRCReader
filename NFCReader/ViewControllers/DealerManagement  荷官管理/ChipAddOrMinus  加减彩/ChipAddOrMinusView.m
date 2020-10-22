//
//  ChipAddOrMinusView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/9/6.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "ChipAddOrMinusView.h"
#import "NRAddOrMinusCell.h"
#import "NRAddOrChipInfo.h"
#import "NRZhangFangInfo.h"
#import "NRKaiTaiInfo.h"
#import "ChipInfoView.h"

@interface ChipAddOrMinusView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *chipList;
@property (nonatomic, strong) ChipInfoView *chipInfoView;
@property (nonatomic, strong) NSMutableArray *chipInfoList;

@end

@implementation ChipAddOrMinusView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self).offset(0);
    }];
    [self.tableView registerClass:[NRAddOrMinusCell class] forCellReuseIdentifier:@"addOrMinusCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)fellWithInfoList:(NSArray *)infoList{
    self.chipList = infoList;
    [self.tableView reloadData];
}

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([self.chipList[indexPath.row] isKindOfClass:[NRAddOrChipInfo class]]) {
        NRAddOrChipInfo *managerInfo = self.chipList[indexPath.row];
        if ([cell.reuseIdentifier isEqualToString:@"addOrMinusCell"]){
            NSString *chipTypeText = @"美金码";
            if ([managerInfo.ftype intValue]==1) {
                chipTypeText = @"人民币码";
            }
            if ([managerInfo.ftype isEqualToString:@"筹码类型"]) {
                chipTypeText = managerInfo.ftype;
            }
            
            NSString *tableNameStr = managerInfo.ftbname;
            if (tableNameStr.length==0) {
                NSDictionary *table = managerInfo.table;
                tableNameStr = table[@"ftbname"];
            }
            NSString *chipMoney = [NSString stringWithFormat:@"%@",managerInfo.totalmoney];
            NRAddOrMinusCell *newCell = (NRAddOrMinusCell *)cell;
            [newCell configureWithTableNameText:tableNameStr
                                   ChipTypeText:chipTypeText
                               DenominationText:chipMoney
                                       TimeText:managerInfo.fadd_time];
        }
    }else if ([self.chipList[indexPath.row] isKindOfClass:[NRKaiTaiInfo class]]){
        NRKaiTaiInfo *kaiTaiInfo = self.chipList[indexPath.row];
        if ([cell.reuseIdentifier isEqualToString:@"addOrMinusCell"]){
            NSString *chipTypeText = @"美金码";
            if ([kaiTaiInfo.fcmtype intValue]==1) {
                chipTypeText = @"人民币码";
            }
            if ([kaiTaiInfo.fcmtype isEqualToString:@"筹码类型"]) {
                chipTypeText = kaiTaiInfo.fcmtype;
            }
            
            NSString *tableNameStr = kaiTaiInfo.tablename;
            NSString *chipMoney = [NSString stringWithFormat:@"%@",kaiTaiInfo.totalmoney];
            NRAddOrMinusCell *newCell = (NRAddOrMinusCell *)cell;
            [newCell configureWithTableNameText:tableNameStr
                                   ChipTypeText:chipTypeText
                               DenominationText:chipMoney
                                       TimeText:kaiTaiInfo.fadd_time];
        }
    }else{
        NRZhangFangInfo *zhangfangInfo = self.chipList[indexPath.row];
        if ([cell.reuseIdentifier isEqualToString:@"addOrMinusCell"]){
            NSString *chipTypeText = @"美金码";
            if ([zhangfangInfo.fcmtype intValue]==1) {
                chipTypeText = @"人民币码";
            }
            if ([zhangfangInfo.fcmtype isEqualToString:@"筹码类型"]) {
                chipTypeText = zhangfangInfo.fcmtype;
            }
            
            NSString *tableNameStr = zhangfangInfo.applyname;
            NSString *chipMoney = [NSString stringWithFormat:@"%@",zhangfangInfo.totalmoney];
            NRAddOrMinusCell *newCell = (NRAddOrMinusCell *)cell;
            [newCell configureWithTableNameText:tableNameStr
                                   ChipTypeText:chipTypeText
                               DenominationText:chipMoney
                                       TimeText:zhangfangInfo.addtime];
        }
    }
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chipList.count;
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
    return [NRAddOrMinusCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"addOrMinusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([PublicHttpTool shareInstance].operationType==0) {//开台
//        NRKaiTaiInfo *kaiTaiInfo = self.chipList[indexPath.row];
//        [self getChipDetailInfoWithDict:kaiTaiInfo.fid];
//    }else if ([PublicHttpTool shareInstance].operationType==1||[PublicHttpTool shareInstance].operationType==2){
//        NRZhangFangInfo *zhangfangInfo = self.chipList[indexPath.row];
//        [self getAccountChipDetailInfoWithDict:zhangfangInfo.fid SumerId:zhangfangInfo.snumber];
//    }else if ([PublicHttpTool shareInstance].operationType==3||[PublicHttpTool shareInstance].operationType==4){
//        NRAddOrChipInfo *chipInfo = self.chipList[indexPath.row];
//        [self getChipDetailInfoWithDict:chipInfo.fid];
//    }
    
    if (self.addOrMinusBlock) {
        self.addOrMinusBlock(indexPath.row);
    }
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
            [self.chipInfoList removeAllObjects];
            [self.chipInfoList addObjectsFromArray:(NSArray *)data];
            [self showChipDetailInfoShowView];
        }
    }];
}
#pragma mark - 获取柜台筹码详情
- (void)getAccountChipDetailInfoWithDict:(NSString *)tableID SumerId:(NSString *)sumerId{
    [PublicHttpTool showWaitingView];
    NSDictionary * param = @{
            @"access_token":[PublicHttpTool shareInstance].access_token,
            @"fid":tableID
    };
    [PublicHttpTool account_operate_detailWithParams:param Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [PublicHttpTool hideWaitingView];
        if (success) {
            [self.chipInfoList removeAllObjects];
            [self.chipInfoList addObject:(NSDictionary *)data];
            [self showChipDetailInfoShowView];
        }
    }];
}

#pragma mark - 弹出筹码详细信息界面
- (void)showChipDetailInfoShowView{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chipInfoView = [[AppDelegate shareInstance]chipInfoView];
        [self.chipInfoView fellChipViewDetailWithChipList:self.chipInfoList];
        [[MJPopTool sharedInstance] popView:self.chipInfoView animated:YES];
    });
}

@end
