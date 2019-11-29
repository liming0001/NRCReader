//
//  ChipInfoView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/11/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "ChipInfoView.h"
#import "ChipInfoTableViewCell.h"
#import "NRCustomerInfo.h"

static NSString * const chipInfoReuseIdentifier = @"chipInfo";

@interface ChipInfoView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UILabel *totalChipNumbersLab;
@property (nonatomic, strong) NRCustomerInfo *curInfo;
@property (nonatomic, strong) NSMutableArray *chipList;

@end

@implementation ChipInfoView

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(92, 163+20+30, kScreenWidth-92*2, kScreenHeight-163*2-130-30-50) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChipInfoTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:chipInfoReuseIdentifier];
    }
    return _tableView;
}

- (UILabel *)totalChipNumbersLab{
    if (!_totalChipNumbersLab) {
        _totalChipNumbersLab = [[UILabel alloc]initWithFrame:CGRectMake(90, CGRectGetMaxY(self.tableView.frame)+8, kScreenWidth-180, 50)];
        _totalChipNumbersLab.textColor = [UIColor colorWithHexString:@"#ff6666"];
        _totalChipNumbersLab.font = [UIFont systemFontOfSize:30];
        _totalChipNumbersLab.textAlignment = NSTextAlignmentCenter;
        _totalChipNumbersLab.text = @"总筹码个数:0";
    }
    return _totalChipNumbersLab;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addSubview:self.tableView];
    [self addSubview:self.totalChipNumbersLab];
}

- (void)fellChipViewWithChipList:(NSArray *)chipInfoList{
    if (!self.chipList) {
        self.chipList = [NSMutableArray arrayWithCapacity:0];
    }
    [self.chipList removeAllObjects];
    [chipInfoList enumerateObjectsUsingBlock:^(NSArray *list, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *chipInfoDict = [NSMutableDictionary dictionary];
        [chipInfoDict setValue:list[1] forKey:@"chipType"];
        NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([list[2] UTF8String],0,16)];
        [chipInfoDict setValue:realmoney forKey:@"chipAmount"];
        [chipInfoDict setValue:list[4] forKey:@"chipWashNumber"];
        [self.chipList addObject:chipInfoDict];
    }];
    [self.tableView reloadData];
    
    self.totalChipNumbersLab.text = [NSString stringWithFormat:@"总筹码个数:%d",(int)chipInfoList.count];
}

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell.reuseIdentifier isEqualToString:chipInfoReuseIdentifier]) {
        ChipInfoTableViewCell *newCell = (ChipInfoTableViewCell *)cell;
        newCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [newCell fellCellWithChipDict:self.chipList[indexPath.row]];
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = chipInfoReuseIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (IBAction)CloseChipInfoAction:(id)sender {
    [EPSound playWithSoundName:@"click_sound"];
    if (_sureActionBlock) {
        _sureActionBlock(1);
    }
}
- (IBAction)closeChipInfo:(id)sender {
    [EPSound playWithSoundName:@"click_sound"];
    [self removeFromSuperview];
    if (_sureActionBlock) {
        _sureActionBlock(2);
    }
}
- (IBAction)readChipInfoAction:(id)sender {
    [EPSound playWithSoundName:@"click_sound"];
    if (_sureActionBlock) {
        _sureActionBlock(1);
    }
}

- (void)clearCurChipInfos{
    if (!self.chipList) {
        self.chipList = [NSMutableArray arrayWithCapacity:0];
    }
    self.totalChipNumbersLab.text = @"总筹码个数:0";
    [self.chipList removeAllObjects];
    [self.tableView reloadData];
}

@end
