//
//  EPKillShowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "EPKillShowView.h"
#import "EPKillShowTableViewCell.h"
#import "NRCustomerInfo.h"

static NSString * const killReuseIdentifier = @"KillCell";

@interface EPKillShowView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NRCustomerInfo *curInfo;
@property (nonatomic, strong) NSMutableArray *killShowList;
@property (nonatomic, assign) __block NSInteger usdAmount;
@property (nonatomic, assign) __block NSInteger rmbAmount;

@end
@implementation EPKillShowView

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(16, 71, 310, 260) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EPKillShowTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:killReuseIdentifier];
    }
    return _tableView;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.midView addSubview:self.tableView];
}
- (IBAction)zhaoHuiAction:(id)sender {
    if (_sureActionBlock) {
        _sureActionBlock(3);
    }
}

- (void)fellViewDataNRCustomerInfo:(NRCustomerInfo *)customerInfo{
    self.killShowList = [NSMutableArray arrayWithCapacity:0];
    self.curInfo = customerInfo;
    if (self.curInfo.isTiger||self.curInfo.isCow) {
        if (self.curInfo.isCow) {
            self.zhaoHuiBtn.hidden = YES;
            self.cowAddMoneyView.hidden = NO;
            self.havepayChipLab.hidden = YES;
            self.cowZhaohuiMoneyLab.hidden = YES;
            self.cowShouldZhaoHuiValueLab.hidden = YES;
            self.cowShouldMoneylab.text = [NSString stringWithFormat:@"应加赔:%@",self.curInfo.add_chipMoney];
        }else{
            self.zhaoHuiBtn.hidden = NO;
            self.cowAddMoneyView.hidden = YES;
            self.havepayChipLab.hidden = NO;
        }
    }else{
        self.cowAddMoneyView.hidden = YES;
        self.havepayChipLab.hidden = YES;
        self.zhaoHuiBtn.hidden = YES;
    }
    self.winOrLostStatusLab.text = self.curInfo.winStatus;
    [self calculateAmountValue];
}

#pragma mark -- 计算金额
- (void)calculateAmountValue{
    NSArray *chipInfoList = self.curInfo.chipInfoList;
    DLOG(@"chipInfoList = %@",chipInfoList);
    self.usdAmount = 0;
    self.rmbAmount = 0;
    for (int i=0; i<chipInfoList.count; i++) {
        __block NSMutableDictionary *chipInfoDict = [NSMutableDictionary dictionary];
        __block NSInteger chipAmount = 0;
        NSArray *chipListA = chipInfoList[i];
        NSArray *infoList = chipListA.firstObject;
        [chipInfoDict setValue:infoList[1] forKey:@"chipType"];
        [chipInfoDict setValue:infoList[4] forKey:@"chipWashNumber"];
        [chipListA enumerateObjectsUsingBlock:^(NSArray *list, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([list[2] UTF8String],0,16)];
            if ([list[1] intValue]==1) {//人民币码
                self.rmbAmount += [realmoney integerValue];
            }else{//美金码
                self.usdAmount += [realmoney integerValue];
            }
            chipAmount += [realmoney integerValue];
        }];
        [chipInfoDict setValue:[NSString stringWithFormat:@"%ld",(long)chipAmount] forKey:@"chipAmount"];
        int shoudPayValue = (int)chipAmount;
        if (self.curInfo.isTiger||self.curInfo.isCow) {
            shoudPayValue = self.curInfo.odds*shoudPayValue;
        }
        [chipInfoDict setValue:[NSString stringWithFormat:@"%d",shoudPayValue] forKey:@"shoudPayValue"];
        [self.killShowList addObject:chipInfoDict];
    }
    [self calculateTotalMoneyWithJiapei_UsdValue:0 jiaPei_rmbValue:0];
    [self.tableView reloadData];
}

#pragma mark--根据找回筹码计算总码金额
- (void)calculateTotalMoneyWithJiapei_UsdValue:(int)Jiapei_UsdValue jiaPei_rmbValue:(int)jiaPei_rmbValue{
    if (self.curInfo.isCow) {
        self.totalUSDValueLab.text = [NSString stringWithFormat:@"%ld",(long)self.curInfo.odds*self.usdAmount+Jiapei_UsdValue];
        self.totalRMBValueLab.text = [NSString stringWithFormat:@"%ld",(long)self.curInfo.odds*self.rmbAmount+jiaPei_rmbValue];
    }else{
        self.totalUSDValueLab.text = [NSString stringWithFormat:@"%ld",(long)self.usdAmount+Jiapei_UsdValue];
        self.totalRMBValueLab.text = [NSString stringWithFormat:@"%ld",(long)self.rmbAmount+jiaPei_rmbValue];
    }
}

- (int)calculateZhaoHuiMoneyWithRealJaiPeiMoney:(int)jiaPeiMoney{
    int zhaohuiValue = jiaPeiMoney-[self.curInfo.add_chipMoney intValue];
    [PublicHttpTool shareInstance].shouldZhaoHuiValue = zhaohuiValue;
    if (zhaohuiValue>0) {//需要显示找回筹码信息
        self.zhaoHuiBtn.hidden = NO;
        self.cowZhaohuiMoneyLab.hidden = NO;
        self.cowShouldZhaoHuiValueLab.hidden = NO;
        self.cowShouldZhaoHuiValueLab.text = [NSString stringWithFormat:@"应找回:%d",zhaohuiValue];
        return -1;
    }else{
        self.zhaoHuiBtn.hidden = YES;
        self.cowZhaohuiMoneyLab.hidden = YES;
        self.cowShouldZhaoHuiValueLab.hidden = YES;
        if (jiaPeiMoney == [self.curInfo.add_chipMoney intValue]) {
            return 1;
        }else{
            return 0;
        }
    }
}

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell.reuseIdentifier isEqualToString:killReuseIdentifier]) {
        EPKillShowTableViewCell *newCell = (EPKillShowTableViewCell *)cell;
        newCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [newCell fellCellWithChipDict:self.killShowList[indexPath.row]];
    }
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.killShowList.count;
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
    return 29;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = killReuseIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (IBAction)confirmAction:(id)sender {
    if (_sureActionBlock) {
        _sureActionBlock(1);
    }
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
    if (_sureActionBlock) {
        _sureActionBlock(2);
    }
}

- (void)clearKillShowView{
    self.cowHadMoneyLab.text = [NSString stringWithFormat:@"%@:0",@"已加赔"];
    self.cowZhaohuiMoneyLab.text = [NSString stringWithFormat:@"%@:%d",@"已找回",0];
    [self.killShowList removeAllObjects];
    [self.tableView reloadData];
}

@end
