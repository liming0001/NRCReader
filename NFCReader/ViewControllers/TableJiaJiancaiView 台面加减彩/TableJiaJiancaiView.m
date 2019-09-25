//
//  TableJiaJiancaiView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/4.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "TableJiaJiancaiView.h"
#import "JiaJIanCaiCell.h"
#import "LotteryView.h"

@interface TableJiaJiancaiView ()
@property (nonatomic,strong) NSMutableArray *StatusArray;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) UIButton *addJiaBtn;
@property (nonatomic, strong) UIButton *printBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *otherCloseBtn;

@property (nonatomic, strong) LotteryView *bottomView;
@property (nonatomic, assign) int headType;

@property (nonatomic, strong) UILabel *topTitleLab;
@end

@implementation TableJiaJiancaiView

- (NSMutableArray *)StatusArray{
    if (!_StatusArray) {
        _StatusArray = [NSMutableArray array];
    }
    return _StatusArray;
    
}

- (LotteryView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"LotteryView" owner:nil options:nil]lastObject];
    }
    return _bottomView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        
        self.topTitleLab = [UILabel new];
        self.topTitleLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.topTitleLab.font = [UIFont systemFontOfSize:23];
        self.topTitleLab.text = @"台面加减彩/Data Computing";
        self.topTitleLab.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:self.topTitleLab];
        [self.topTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView).offset(30);
            make.left.equalTo(self.topView).offset(40);
            make.centerX.equalTo(self.topView);
        }];
        
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addBtn setTitle:@"加彩/Add" forState:UIControlStateNormal];
        self.addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.addBtn.tag = 1;
        [self.addBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"选项卡-未选中"] forState:UIControlStateNormal];
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"选项卡-加彩-选中"] forState:UIControlStateSelected];
        [self.addBtn setSelected:YES];
        [self.topView addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topView).offset(0);
            make.left.equalTo(self.topView).offset(0);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(30);
        }];
        
        self.minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.minusBtn setTitle:@"减彩/Reduce" forState:UIControlStateNormal];
        self.minusBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.minusBtn.tag = 2;
        [self.minusBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.minusBtn setBackgroundImage:[UIImage imageNamed:@"选项卡-未选中"] forState:UIControlStateNormal];
        [self.minusBtn setBackgroundImage:[UIImage imageNamed:@"选项卡-减彩-选中"] forState:UIControlStateSelected];
        [self.topView addSubview:self.minusBtn];
        [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topView).offset(0);
            make.left.equalTo(self.addBtn.mas_right).offset(1);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(30);
        }];
        
        self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.recordBtn setTitle:@"加减彩记录" forState:UIControlStateNormal];
        self.recordBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.recordBtn.tag = 3;
        [self.recordBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"选项卡-未选中"] forState:UIControlStateNormal];
        [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"选项卡-加彩记录-选中"] forState:UIControlStateSelected];
        [self.topView addSubview:self.recordBtn];
        [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topView).offset(0);
            make.left.equalTo(self.minusBtn.mas_right).offset(1);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(30);
        }];
    }
    return _topView;
}

- (void)fellListWithType:(int)type{
    if (type==0) {
        self.topTitleLab.text = @"台面加减彩/Data Computing";
        [self.addBtn setTitle:@"加彩/Add" forState:UIControlStateNormal];
        [self.addJiaBtn setTitle:@"加彩" forState:UIControlStateNormal];
        [self.printBtn setTitle:@"加彩并打印" forState:UIControlStateNormal];
        self.minusBtn.hidden = NO;
        self.recordBtn.hidden = NO;
    }else if (type==1) {
        self.topTitleLab.text = @"点码";
        [self.addBtn setTitle:@"点码" forState:UIControlStateNormal];
        [self.addJiaBtn setTitle:@"点码" forState:UIControlStateNormal];
        [self.printBtn setTitle:@"点码并打印" forState:UIControlStateNormal];
        self.minusBtn.hidden = YES;
        self.recordBtn.hidden = YES;
    }else if (type==2){
        self.topTitleLab.text = @"收台";
        [self.addBtn setTitle:@"收台" forState:UIControlStateNormal];
        [self.addJiaBtn setTitle:@"收台" forState:UIControlStateNormal];
        [self.printBtn setTitle:@"收台并打印" forState:UIControlStateNormal];
        self.minusBtn.hidden = YES;
        self.recordBtn.hidden = YES;
    }
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:71/255.0 green:91/255.0 blue:103/255.0 alpha:0.9];
        [self configurnView];
    }
    return self;
}

- (void)configurnView{
    self.headType = 1;
    [self.StatusArray addObject:@"0"];
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 530,kScreenHeight-90) style:UITableViewStyleGrouped];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.centerX = self.centerX;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[JiaJIanCaiCell class] forCellReuseIdentifier:@"KReportImgTableViewCell"];
    //不要分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = self.bottomView;
    
    self.addJiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addJiaBtn setTitle:@"加彩" forState:UIControlStateNormal];
    self.addJiaBtn.titleLabel.font = [UIFont systemFontOfSize:23];
    [self.addJiaBtn setBackgroundImage:[UIImage imageNamed:@"加彩按钮BG"] forState:UIControlStateNormal];
    [self addSubview:self.addJiaBtn];
    [self.addJiaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-37);
        make.left.equalTo(self).offset(155);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    self.printBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.printBtn setTitle:@"加彩并打印" forState:UIControlStateNormal];
    self.printBtn.titleLabel.font = [UIFont systemFontOfSize:23];
    [self.printBtn setBackgroundImage:[UIImage imageNamed:@"加彩并打印BG"] forState:UIControlStateNormal];
    [self addSubview:self.printBtn];
    [self.printBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-37);
        make.left.equalTo(self.addJiaBtn.mas_right).offset(4);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:23];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭按钮BG"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-37);
        make.left.equalTo(self.printBtn.mas_right).offset(4);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    self.otherCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.otherCloseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    self.otherCloseBtn.titleLabel.font = [UIFont systemFontOfSize:23];
    self.otherCloseBtn.hidden = YES;
    [self.otherCloseBtn setBackgroundImage:[UIImage imageNamed:@"关闭按钮BG"] forState:UIControlStateNormal];
    [self.otherCloseBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.otherCloseBtn];
    [self.otherCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-37);
        make.centerX.equalTo(self).offset(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
}

- (void)topBtnAction:(UIButton *)btn{
    if (btn.tag==1) {
        if (self.addBtn.isSelected) {
            return;
        }else{
            self.headType = 1;
            [self.addBtn setSelected:YES];
            [self.minusBtn setSelected:NO];
            [self.recordBtn setSelected:NO];
            
            self.otherCloseBtn.hidden = YES;
            self.addJiaBtn.hidden = NO;
            self.printBtn.hidden = NO;
            self.closeBtn.hidden = NO;
        }
        [self changeBtnsBackColor:YES];
    }else if (btn.tag==2){
        if (self.minusBtn.isSelected) {
            return;
        }else{
            self.headType = 2;
            [self.addBtn setSelected:NO];
            [self.minusBtn setSelected:YES];
            [self.recordBtn setSelected:NO];
            
            self.otherCloseBtn.hidden = YES;
            self.addJiaBtn.hidden = NO;
            self.printBtn.hidden = NO;
            self.closeBtn.hidden = NO;
        }
        [self changeBtnsBackColor:NO];
    }else if (btn.tag==3){
        if (self.recordBtn.isSelected) {
            return;
        }else{
            self.headType = 3;
            [self.addBtn setSelected:NO];
            [self.minusBtn setSelected:NO];
            [self.recordBtn setSelected:YES];
            
            self.otherCloseBtn.hidden = NO;
            self.addJiaBtn.hidden = YES;
            self.printBtn.hidden = YES;
            self.closeBtn.hidden = YES;
        }
    }
    [self.tableView reloadData];
}

- (void)changeBtnsBackColor:(BOOL)isAdd{
    if (isAdd) {
        [self.addJiaBtn setTitle:@"加彩" forState:UIControlStateNormal];
        [self.printBtn setTitle:@"加彩并打印" forState:UIControlStateNormal];
    }else{
        [self.addJiaBtn setTitle:@"减彩" forState:UIControlStateNormal];
        [self.printBtn setTitle:@"减彩并打印" forState:UIControlStateNormal];
    }
    
}

- (void)closeAction{
    [self removeFromSuperview];
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JiaJIanCaiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KReportImgTableViewCell"];
    if (!cell) {
        cell = [[JiaJIanCaiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KReportImgTableViewCell"];
    }
    cell.cellIndex = indexPath.section;
    NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    //是用来判断有没用被打开// YES (BOOL)1// NO  (BOOL)0
    BOOL isbool = [self.StatusArray containsObject: row];
    [cell fellCellWithOpen:isbool Type:self.headType];
    cell.openOrCloseBock = ^(BOOL isOpen, NSInteger curIndex) {
        NSString *index_tow = [NSString stringWithFormat:@"%ld",(long)curIndex];
        if (isOpen) {
            [self.StatusArray addObject:index_tow];
        }else{
            [self.StatusArray removeObject:index_tow];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    BOOL isbool = [self.StatusArray containsObject: row];
    return [JiaJIanCaiCell cellHeightWithOpen:isbool];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

@end
