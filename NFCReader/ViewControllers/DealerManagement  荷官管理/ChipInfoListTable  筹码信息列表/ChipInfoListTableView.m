//
//  ChipInfoListTableView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/7/27.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "ChipInfoListTableView.h"
#import "NRChipManagerTableViewCell.h"
#import "NRChipDestrutTableViewCell.h"
#import "NRCashExchangeTableViewCell.h"
#import "NRChipManagerInfo.h"
#import "CustomerInfoFooter.h"
#import "ChipInfoHeader.h"
#import "ChipBtnFooter.h"

@interface ChipInfoListTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *chipList;
@property (nonatomic, strong) NSArray *chipInfoList;
@property (nonatomic, assign) int curType;

@property (nonatomic, strong) ChipInfoHeader *chipInfoHeader;
@property (nonatomic, strong) ChipBtnFooter *chipBtnFooter;

@end

@implementation ChipInfoListTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self).offset(0);
    }];
    [self.tableView registerClass:[NRChipManagerTableViewCell class] forCellReuseIdentifier:@"issueListCell"];
    [self.tableView registerClass:[NRCashExchangeTableViewCell class] forCellReuseIdentifier:@"normalCashCell"];
    [self.tableView registerClass:[NRChipDestrutTableViewCell class] forCellReuseIdentifier:@"destrutCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.chipInfoHeader = [[ChipInfoHeader alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-210, 110)];
    self.customerFooter = [[CustomerInfoFooter alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-200, 600)];
    self.chipBtnFooter = [[ChipBtnFooter alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-200, 120)];
    
    @weakify(self);
    self.chipBtnFooter.footerBtnBlock = ^(NSInteger tag) {
        @strongify(self);
        if (self.chipTableBlock) {
            self.chipTableBlock(tag);
        }
    };
    self.customerFooter.customerBtnBlock = ^(NSInteger tag) {
        @strongify(self);
        if (self.chipTableBlock) {
            self.chipTableBlock(tag);
        }
    };
    self.customerFooter.refrashBlock = ^(BOOL refrash) {
        @strongify(self);
        [self.chipInfoHeader fellTakeOutMoney];
    };
}

- (void)fellWithInfoList:(NSArray *)infoList WithType:(int)type{
    if (type==2) {
        self.tableView.tableHeaderView = [UIView new];
        self.tableView.tableFooterView = self.chipBtnFooter;
        [self.chipInfoHeader _setUpChipHeaderWithType:2];
        [self.chipBtnFooter _setUpFooterBtnWithType:2];
    }else if (type==3) {
        self.tableView.tableHeaderView = self.chipInfoHeader;
        self.tableView.tableFooterView = self.customerFooter;
        [self.chipInfoHeader _setUpChipHeaderWithType:3];
        [self.customerFooter _setUpCustomerInfoWithType:3];
    }else if (type==4){
        self.tableView.tableHeaderView = self.chipInfoHeader;
        self.tableView.tableFooterView = self.chipBtnFooter;
        [self.chipInfoHeader _setUpChipHeaderWithType:4];
        [self.chipBtnFooter _setUpFooterBtnWithType:4];
    }else if (type==5){
        self.tableView.tableHeaderView = self.chipInfoHeader;
        self.tableView.tableFooterView = self.chipBtnFooter;
        [self.chipInfoHeader _setUpChipHeaderWithType:5];
        [self.chipBtnFooter _setUpFooterBtnWithType:5];
    }else if (type==6){
        self.tableView.tableHeaderView = self.chipInfoHeader;
        self.tableView.tableFooterView = self.customerFooter;
        [self.chipInfoHeader _setUpChipHeaderWithType:6];
        [self.customerFooter _setUpCustomerInfoWithType:6];
    }else{
        self.tableView.tableFooterView = [UIView new];
        self.tableView.tableHeaderView = [UIView new];
    }
    self.chipList = infoList;
    self.curType = type;
    self.chipInfoList = [PublicHttpTool shareInstance].chipTypeList;
    [self.tableView reloadData];
}

- (void)clearCustomerFooterInfo{
    [self.customerFooter clearCustomerInfo];
}

- (void)fellHeaderInfoWithDict:(NSDictionary *)dict{
    [self.chipInfoHeader fellInfoWithDict:dict];
}

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NRChipManagerInfo *managerInfo = self.chipList[indexPath.row];
    if ([cell.reuseIdentifier isEqualToString:@"issueListCell"]) {
        NRChipManagerTableViewCell *newCell = (NRChipManagerTableViewCell *)cell;
        NRChipManagerInfo *managerInfo = self.chipList[indexPath.row];
        [newCell configureWithSerialNumberText:managerInfo.serialNumber
                                  ChipTypeText:managerInfo.chipType
                              DenominationText:managerInfo.denomination
                                     BatchText:managerInfo.batch
                                    StatusText:managerInfo.status
                                  chipTypeList:self.chipInfoList];
    }else if ([cell.reuseIdentifier isEqualToString:@"destrutCell"]){
        NRChipDestrutTableViewCell *newCell = (NRChipDestrutTableViewCell *)cell;
        [newCell configureWithSerialNumberText:managerInfo.serialNumber
                                ChipTypeText:managerInfo.chipType
                            DenominationText:managerInfo.denomination
                                   BatchText:managerInfo.batch
                                   StatusText:managerInfo.status
                                 chipTypeList:self.chipInfoList];
    }else{
        NRCashExchangeTableViewCell *newCell = (NRCashExchangeTableViewCell *)cell;
        [newCell configureWithBatchText:managerInfo.batch
                    SerialNumberText:managerInfo.serialNumber
                        ChipTypeText:managerInfo.chipType
                    DenominationText:managerInfo.denomination
                      WashNumberText:managerInfo.washNumber
                          StatusText:managerInfo.status
                        chipTypeList:self.chipInfoList];
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
    return [NRChipManagerTableViewCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"normalCashCell";
    if (self.curType==0) {
        cellId = @"issueListCell";
    }else if (self.curType==2){
        cellId = @"destrutCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

@end
