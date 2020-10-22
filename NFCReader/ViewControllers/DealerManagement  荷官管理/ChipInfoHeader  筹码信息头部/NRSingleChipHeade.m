//
//  NRSingleChipHeade.m
//  NFCReader
//
//  Created by 李黎明 on 2020/9/20.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRSingleChipHeade.h"
#import "NRChipSingleCell.h"

@interface NRSingleChipHeade ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *exchangNumberLab;
@property (nonatomic, strong) UILabel *exchangTotalMoneyLab;
@property (nonatomic, strong) NSMutableArray *chipInfoList;

@property (nonatomic, strong) UILabel *tipsInfoLab;

@end

@implementation NRSingleChipHeade

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    self.backgroundColor = [UIColor colorWithHexString:@"#666666"];
    self.exchangNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 20)];
    self.exchangNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.exchangNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.exchangNumberLab.numberOfLines = 0;
    self.exchangNumberLab.text = @"筹码总数量:0枚";
    [self addSubview:self.exchangNumberLab];
    
    self.exchangTotalMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.exchangNumberLab.frame), 20, 400, 20)];
    self.exchangTotalMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:30];
    self.exchangTotalMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.exchangTotalMoneyLab.numberOfLines = 0;
    self.exchangTotalMoneyLab.text = @"筹码总金额:0";
    [self addSubview:self.exchangTotalMoneyLab];
    
    self.tipsInfoLab = [UILabel new];
    self.tipsInfoLab.font = [UIFont fontWithName:@"PingFang SC" size:30];
    self.tipsInfoLab.textColor = [UIColor redColor];
    self.tipsInfoLab.numberOfLines = 0;
    self.tipsInfoLab.text = @"请按照上面列表中的信息一一对照加码";
    self.tipsInfoLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipsInfoLab];
    [self.tipsInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.right.equalTo(self).offset(0);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(60);
        make.left.right.equalTo(self).offset(0);
        make.bottom.equalTo(self.tipsInfoLab.mas_top).offset(-10);
    }];
    [self.tableView registerClass:[NRChipSingleCell class] forCellReuseIdentifier:@"SingleCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)fellHeaderWithInfoDict:(NSDictionary *)infDict{
    self.exchangNumberLab.text = [NSString stringWithFormat:@"筹码总数量:%@枚",infDict[@"fnums"]];
    self.exchangTotalMoneyLab.text = [NSString stringWithFormat:@"筹码总金额:%@",infDict[@"totalmoney"]];
    NSDictionary *topDict = @{@"fcmtype_id":@"0",@"fnums":@"0",@"fme":@"0"};
    [self.chipInfoList addObject:topDict];
    [self.chipInfoList addObjectsFromArray:infDict[@"chipList"]];
    [self.tableView reloadData];
}

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell.reuseIdentifier isEqualToString:@"SingleCell"]){
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
        NSString *chipMoneyText = [NSString stringWithFormat:@"%@",chipDict[@"fme"]];
        if ([chipMoneyText intValue]==0) {
            chipMoneyText = @"筹码金额";
        }
        NSString *chipNumText = [NSString stringWithFormat:@"%@",chipDict[@"fnums"]];
        if ([chipNumText intValue]==0) {
            chipNumText = @"筹码数量";
        }
        NSString *chipMoney = chipMoneyText;
        NSString *chipNum = chipNumText;
        NRChipSingleCell *newCell = (NRChipSingleCell *)cell;
        [newCell configureWithChipTypeLabText:chipTypeText ChipNumsText:chipNum DenominationText:chipMoney];
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
    return [NRChipSingleCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"SingleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
