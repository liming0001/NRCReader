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
            self.havepayChipLab.hidden = YES;
            self.cowAddMoneyView.hidden = NO;
            self.zhaoHuiBtn.hidden = NO;
            self.cowShouldMoneylab.text = self.curInfo.add_chipMoney;
        }else{
            self.havepayChipLab.hidden = NO;
            self.cowAddMoneyView.hidden = YES;
            self.zhaoHuiBtn.hidden = YES;
        }
    }else{
        self.havepayChipLab.hidden = YES;
        self.cowAddMoneyView.hidden = YES;
        self.zhaoHuiBtn.hidden = YES;
    }
    self.winOrLostStatusLab.text = self.curInfo.winStatus;
    NSArray *chipInfoList = self.curInfo.chipInfoList;
    DLOG(@"chipInfoList = %@",chipInfoList);
    __block NSInteger usdAmount = 0;
    __block NSInteger rmbAmount = 0;
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
                rmbAmount += [realmoney integerValue];
            }else{//美金码
                usdAmount += [realmoney integerValue];
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
    [self.tableView reloadData];
    
    if (self.curInfo.isCow) {
        self.totalUSDValueLab.text = [NSString stringWithFormat:@"%ld",(long)self.curInfo.odds*usdAmount];
        self.totalRMBValueLab.text = [NSString stringWithFormat:@"%ld",(long)self.curInfo.odds*rmbAmount];
    }else{
        self.totalUSDValueLab.text = [NSString stringWithFormat:@"%ld",(long)usdAmount];
        self.totalRMBValueLab.text = [NSString stringWithFormat:@"%ld",(long)rmbAmount];
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
