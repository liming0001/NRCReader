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
#import "DenominationView.h"
#import "BlueToothManager.h"

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
@property (nonatomic, assign) int bottomType;

@property (nonatomic, strong) UILabel *topTitleLab;

@property (nonatomic, strong) NSString *curLoginToken;
@property (nonatomic, strong) NSString *curTableID;

@property (nonatomic,strong) NSMutableArray *firstMoneyList;
@property (nonatomic,strong) NSMutableArray *firstNumberList;

@property (nonatomic,strong) NSMutableArray *secondMoneyList;
@property (nonatomic,strong) NSMutableArray *secondNumberList;

@property (nonatomic,strong) NSMutableArray *thridMoneyList;
@property (nonatomic,strong) NSMutableArray *thridNumberList;

@property (nonatomic,strong) NSMutableArray *forthMoneyList;
@property (nonatomic,strong) NSMutableArray *forthNumberList;

@property (nonatomic, strong) BlueToothManager *manager;

@end

@implementation TableJiaJiancaiView

- (NSMutableArray *)StatusArray{
    if (!_StatusArray) {
        _StatusArray = [NSMutableArray array];
    }
    return _StatusArray;
    
}

- (NSMutableArray *)firstMoneyList{
    if (!_firstMoneyList) {
        _firstMoneyList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _firstMoneyList;
    
}

- (NSMutableArray *)firstNumberList{
    if (!_firstNumberList) {
        _firstNumberList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _firstNumberList;
    
}

- (NSMutableArray *)secondMoneyList{
    if (!_secondMoneyList) {
        _secondMoneyList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _secondMoneyList;
    
}

- (NSMutableArray *)secondNumberList{
    if (!_secondNumberList) {
        _secondNumberList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _secondNumberList;
    
}

- (NSMutableArray *)thridMoneyList{
    if (!_thridMoneyList) {
        _thridMoneyList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _thridMoneyList;
    
}

- (NSMutableArray *)thridNumberList{
    if (!_thridNumberList) {
        _thridNumberList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _thridNumberList;
    
}

- (NSMutableArray *)forthMoneyList{
    if (!_forthMoneyList) {
        _forthMoneyList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _forthMoneyList;
    
}

- (NSMutableArray *)forthNumberList{
    if (!_forthNumberList) {
        _forthNumberList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _forthNumberList;
    
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
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"topBar_unselectIcon"] forState:UIControlStateNormal];
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"add_topBar_icon"] forState:UIControlStateSelected];
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
        [self.minusBtn setBackgroundImage:[UIImage imageNamed:@"topBar_unselectIcon"] forState:UIControlStateNormal];
        [self.minusBtn setBackgroundImage:[UIImage imageNamed:@"minus_topBar_icon"] forState:UIControlStateSelected];
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
        [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"topBar_unselectIcon"] forState:UIControlStateNormal];
        [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"add_record_selectIcon"] forState:UIControlStateSelected];
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
    self.bottomType = type;
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
        self.topTitleLab.text = @"开台";
        [self.addBtn setTitle:@"开台" forState:UIControlStateNormal];
        [self.addJiaBtn setTitle:@"开台" forState:UIControlStateNormal];
        [self.printBtn setTitle:@"开台并打印" forState:UIControlStateNormal];
        self.minusBtn.hidden = NO;
        self.recordBtn.hidden = YES;
        [self.minusBtn setTitle:@"收台" forState:UIControlStateNormal];
        
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
    [self.tableView registerClass:[JiaJIanCaiCell class] forCellReuseIdentifier:@"KReportImgTableViewCell_1"];
    [self.tableView registerClass:[JiaJIanCaiCell class] forCellReuseIdentifier:@"KReportImgTableViewCell_2"];
    [self.tableView registerClass:[JiaJIanCaiCell class] forCellReuseIdentifier:@"KReportImgTableViewCell_3"];
    [self.tableView registerClass:[JiaJIanCaiCell class] forCellReuseIdentifier:@"KReportImgTableViewCell_4"];
    //不要分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = self.bottomView;
    
    self.addJiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addJiaBtn setTitle:@"加彩" forState:UIControlStateNormal];
    self.addJiaBtn.titleLabel.font = [UIFont systemFontOfSize:23];
    [self.addJiaBtn addTarget:self action:@selector(addJiacaiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addJiaBtn setBackgroundImage:[UIImage imageNamed:@"VM_puclicbtn_icon"] forState:UIControlStateNormal];
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
    [self.printBtn setBackgroundImage:[UIImage imageNamed:@"VM_PrintBtn_icon"] forState:UIControlStateNormal];
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
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"VM_CloseBtn_icon"] forState:UIControlStateNormal];
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
    [self.otherCloseBtn setBackgroundImage:[UIImage imageNamed:@"VM_CloseBtn_icon"] forState:UIControlStateNormal];
    [self.otherCloseBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.otherCloseBtn];
    [self.otherCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-37);
        make.centerX.equalTo(self).offset(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    self.manager = [BlueToothManager getInstance];
}

- (void)scanBlootooth{
    [self showWaitingViewInWindow];
    [self.manager startScan];
    [self.manager getBlueListArray:^(NSMutableArray *blueToothArray) {
        CBPeripheral * per = blueToothArray[0];
        [self.manager connectPeripheralWith:per];
        [self.manager connectInfoReturn:^(CBCentralManager *central, CBPeripheral *peripheral, NSString *stateStr) {
            if ([stateStr isEqualToString:@"SUCCESS"]) {//连接成功--SUCCESS，连接失败--ERROR，断开连接--DISCONNECT
                [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(BlueToothPrint) userInfo:nil repeats:NO];
            }else if([stateStr isEqualToString:@"ERROR"]){
            }else if([stateStr isEqualToString:@"BLUEDISS"]){
            }else{
            }
        }];
    }];
}

- (void)showWaitingViewInWindow {
    UIView *window = [self findWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.layer.zPosition = 100;
}

- (UIView *)findWindow {
    UIView *window = [[UIApplication sharedApplication] keyWindow];
    if (!window) {
        window = self;
    }
    return window;
}

- (void)hideWaitingViewInWindow {
    UIView *window = [self findWindow];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

-(void)BlueToothPrint{
//    [self.manager getBluetoothPrintWith:self.jsonDic andPrintType:self.printNum];
    [self.manager stopScan];
    [self.manager getPrintSuccessReturn:^(BOOL sizeValue) {
        if (sizeValue==YES) {
            [self hideWaitingViewInWindow];
            [[EPToast makeText:@"打印成功"]showWithType:ShortTime];
        }else{
            [[EPToast makeText:@"打印失败!"]showWithType:ShortTime];
        }
    }];
}

- (void)fellViewDataWithLoginID:(NSString *)loginId TableID:(NSString *)tableId{
    self.curLoginToken = loginId;
    self.curTableID = tableId;
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
        if (self.bottomType==0) {
            [self.addJiaBtn setTitle:@"加彩" forState:UIControlStateNormal];
            [self.printBtn setTitle:@"加彩并打印" forState:UIControlStateNormal];
        }else{
            [self.addJiaBtn setTitle:@"开台" forState:UIControlStateNormal];
            [self.printBtn setTitle:@"开台并打印" forState:UIControlStateNormal];
        }
    }else{
        if (self.bottomType==0) {
            [self.addJiaBtn setTitle:@"减彩" forState:UIControlStateNormal];
            [self.printBtn setTitle:@"减彩并打印" forState:UIControlStateNormal];
        }else{
            [self.addJiaBtn setTitle:@"收台" forState:UIControlStateNormal];
            [self.printBtn setTitle:@"收台并打印" forState:UIControlStateNormal];
        }
    }
}

- (void)addJiacaiAction{
    [self showWaitingViewInWindow];
    NSString *fTypeS = @"1";
    if (self.bottomType==0) {//加减彩
        if (self.headType==1) {
            fTypeS = @"1";
        }else if (self.headType==2){
            fTypeS = @"2";
        }
    }else if (self.bottomType==1){//点码
        fTypeS = @"3";
    }else if (self.bottomType==2){//开台
        if (self.headType==1) {
            fTypeS = @"4";
        }else if (self.headType==2){
            fTypeS = @"5";
        }
    }
    
    
    NSMutableArray *fme_list = [NSMutableArray array];
    [fme_list addObject:self.firstMoneyList];
    [fme_list addObject:self.secondMoneyList];
    [fme_list addObject:self.thridMoneyList];
    [fme_list addObject:self.forthMoneyList];
    
    NSMutableArray *fnums_list = [NSMutableArray array];
    [fnums_list addObject:self.firstNumberList];
    [fnums_list addObject:self.secondNumberList];
    [fnums_list addObject:self.thridNumberList];
    [fnums_list addObject:self.forthNumberList];
    
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"ftable_id":self.curTableID,
                             @"ftype":fTypeS,
                             @"fcmtype_list":[NSArray arrayWithObjects:@"1",@"6",@"2",@"7", nil],
                             @"fme_list":fme_list,//面额
                             @"fnums_list":fnums_list,//数量
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Table_operate",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        [self hideWaitingViewInWindow];
        if (suc) {
            [self closeAction];
            if (self.bottomType==0) {//加减彩
                if (self.headType==1) {
                    [[EPToast makeText:@"加彩成功" WithError:NO]showWithType:ShortTime];
                }else if (self.headType==2){
                    [[EPToast makeText:@"减彩成功" WithError:NO]showWithType:ShortTime];
                }
            }else if (self.bottomType==1){//点码
                [[EPToast makeText:@"点码成功" WithError:NO]showWithType:ShortTime];
            }else if (self.bottomType==2){//开台
                if (self.headType==1) {
                    [[EPToast makeText:@"开台成功" WithError:NO]showWithType:ShortTime];
                }else if (self.headType==2){
                    [[EPToast makeText:@"收台成功" WithError:NO]showWithType:ShortTime];
                }
            }
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
            self.firstMoneyList = nil;
            self.secondMoneyList = nil;
            self.thridMoneyList = nil;
            self.forthMoneyList = nil;
            
            self.firstNumberList = nil;
            self.secondNumberList = nil;
            self.thridNumberList = nil;
            self.forthNumberList = nil;
        }else{
            NSString *messgae = [msg NullToBlankString];
            if (messgae.length == 0) {
                messgae = @"网络异常";
            }
            [[EPToast makeText:messgae WithError:YES]showWithType:ShortTime];
            //响警告声音
            [EPSound playWithSoundName:@"wram_sound"];
        }
    }];
}

- (void)closeAction{
    [self removeFromSuperview];
}


#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"KReportImgTableViewCell_%d",indexPath.section+1];
    
    JiaJIanCaiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[JiaJIanCaiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cellIndex = indexPath.section;
    NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    //是用来判断有没用被打开// YES (BOOL)1// NO  (BOOL)0
    BOOL isbool = [self.StatusArray containsObject: row];
    [cell fellCellWithOpen:isbool Type:self.headType];
    @weakify(self);
    cell.openOrCloseBock = ^(BOOL isOpen, NSInteger curIndex) {
        @strongify(self);
        NSString *index_tow = [NSString stringWithFormat:@"%ld",(long)curIndex];
        if (isOpen) {
            [self.StatusArray addObject:index_tow];
        }else{
            [self.StatusArray removeObject:index_tow];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    cell.refrashBottomMoneyBlock = ^(int cellId, NSString *totalMonney) {
        @strongify(self);
        if (cellId==0) {
            self.bottomView.RMBChipValueLab.text = totalMonney;
        }else if (cellId==1){
            self.bottomView.RMBCashValueLab.text = totalMonney;
        }else if (cellId==2){
            self.bottomView.USDChipValueLav.text = totalMonney;
        }else if (cellId==3){
            self.bottomView.USDCashValueLab.text = totalMonney;
        }
    };
    
    cell.refrashSigleValueBlock = ^(int cellId, NSString * _Nonnull numberValue, NSString * _Nonnull moneyValue,int type) {
        @strongify(self);
        if (cellId==0) {
            [self.firstMoneyList replaceObjectAtIndex:type withObject:moneyValue];
            [self.firstNumberList replaceObjectAtIndex:type withObject:numberValue];
        }else if (cellId==1){
            [self.secondMoneyList replaceObjectAtIndex:type withObject:moneyValue];
            [self.secondNumberList replaceObjectAtIndex:type withObject:numberValue];
        }else if (cellId==2){
            [self.thridMoneyList replaceObjectAtIndex:type withObject:moneyValue];
            [self.thridNumberList replaceObjectAtIndex:type withObject:numberValue];
        }else if (cellId==3){
            [self.forthMoneyList replaceObjectAtIndex:type withObject:moneyValue];
            [self.forthNumberList replaceObjectAtIndex:type withObject:numberValue];
        }
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
