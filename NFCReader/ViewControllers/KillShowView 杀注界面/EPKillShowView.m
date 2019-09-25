//
//  EPKillShowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "EPKillShowView.h"
#import "EPKillShowTableViewCell.h"

static NSString * const killReuseIdentifier = @"KillCell";

@interface EPKillShowView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation EPKillShowView

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(16, 71, 310, 290) style:UITableViewStylePlain];
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

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell.reuseIdentifier isEqualToString:killReuseIdentifier]) {
        EPKillShowTableViewCell *newCell = (EPKillShowTableViewCell *)cell;
        newCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NRChipManagerInfo *managerInfo = self.chipIssueList[indexPath.row];
//        [newCell configureWithSerialNumberText:managerInfo.serialNumber
//                                  ChipTypeText:managerInfo.chipType
//                              DenominationText:managerInfo.denomination
//                                     BatchText:managerInfo.batch
//                                    StatusText:managerInfo.status];
    }
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
    [self removeFromSuperview];
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

@end
