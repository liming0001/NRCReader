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

//人民币码1
@property (nonatomic,strong) NSMutableArray *RMBChipMoneyList;
@property (nonatomic,strong) NSMutableArray *RMBChipNumberList;
//美金码2
@property (nonatomic,strong) NSMutableArray *USDChipMoneyList;
@property (nonatomic,strong) NSMutableArray *USDChipNumberList;
//人民币现金6
@property (nonatomic,strong) NSMutableArray *RMBMoneyList;
@property (nonatomic,strong) NSMutableArray *RMBNumberList;
//美金现金7
@property (nonatomic,strong) NSMutableArray *USDMoneyList;
@property (nonatomic,strong) NSMutableArray *USDNumberList;
//人民币贵宾码
@property (nonatomic,strong) NSMutableArray *RMBVIPChipMoneyList;
@property (nonatomic,strong) NSMutableArray *RMBVIPChipNumberList;
//美金贵宾码
@property (nonatomic,strong) NSMutableArray *USDVIPChipMoneyList;
@property (nonatomic,strong) NSMutableArray *USDVIPChipNumberList;

@property (nonatomic, strong) BlueToothManager *manager;
@property (nonatomic, strong) NSDictionary *printDict;

@property (nonatomic, strong) NSArray *chip_FmeList;

@end

@implementation TableJiaJiancaiView

- (NSMutableArray *)StatusArray{
    if (!_StatusArray) {
        _StatusArray = [NSMutableArray array];
    }
    return _StatusArray;
    
}

- (NSMutableArray *)RMBChipMoneyList{
    if (!_RMBChipMoneyList) {
        _RMBChipMoneyList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _RMBChipMoneyList;
    
}

- (NSMutableArray *)RMBChipNumberList{
    if (!_RMBChipNumberList) {
        _RMBChipNumberList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _RMBChipNumberList;
    
}

- (NSMutableArray *)USDChipMoneyList{
    if (!_USDChipMoneyList) {
        _USDChipMoneyList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _USDChipMoneyList;
    
}

- (NSMutableArray *)USDChipNumberList{
    if (!_USDChipNumberList) {
        _USDChipNumberList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _USDChipNumberList;
    
}

- (NSMutableArray *)RMBMoneyList{
    if (!_RMBMoneyList) {
        _RMBMoneyList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _RMBMoneyList;
    
}

- (NSMutableArray *)RMBNumberList{
    if (!_RMBNumberList) {
        _RMBNumberList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _RMBNumberList;
    
}

- (NSMutableArray *)USDMoneyList{
    if (!_USDMoneyList) {
        _USDMoneyList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _USDMoneyList;
    
}

- (NSMutableArray *)USDNumberList{
    if (!_USDNumberList) {
        _USDNumberList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _USDNumberList;
    
}

- (NSMutableArray *)RMBVIPChipMoneyList{
    if (!_RMBVIPChipMoneyList) {
        _RMBVIPChipMoneyList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _RMBVIPChipMoneyList;
    
}

- (NSMutableArray *)RMBVIPChipNumberList{
    if (!_RMBVIPChipNumberList) {
        _RMBVIPChipNumberList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _RMBVIPChipNumberList;
    
}

- (NSMutableArray *)USDVIPChipMoneyList{
    if (!_USDVIPChipMoneyList) {
        _USDVIPChipMoneyList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _USDVIPChipMoneyList;
    
}

- (NSMutableArray *)USDVIPChipNumberList{
    if (!_USDVIPChipNumberList) {
        _USDVIPChipNumberList = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return _USDVIPChipNumberList;
    
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
        [self.minusBtn setTitle:@"减彩/Reduce" forState:UIControlStateNormal];
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
    [self.printBtn addTarget:self action:@selector(scanBlootooth) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark --搜索并打印数据
- (void)scanBlootooth{
    [PublicHttpTool showWaitingView];
    [self.manager startScan];
    [self.manager getBlueListArray:^(NSMutableArray *blueToothArray) {
        CBPeripheral * per = blueToothArray[0];
        [self.manager connectPeripheralWith:per];
        [self.manager connectInfoReturn:^(CBCentralManager *central, CBPeripheral *peripheral, NSString *stateStr) {
            if ([stateStr isEqualToString:@"SUCCESS"]) {//连接成功--SUCCESS，连接失败--ERROR，断开连接--DISCONNECT
                [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(BlueToothPrint) userInfo:nil repeats:NO];
            }else{
                [PublicHttpTool hideWaitingView];
            }
        }];
    }];
}

-(void)BlueToothPrint{
    NSString *infoStr = @"{\"machineCode\":\"5E799AF4-486A-4EB5-BCFB-4BDE928E4E68\",\"shopname\":\"默认服务中心\",\"date\":\"2016-01-26,10\",\"id\":\"YT4332553551\",\"consignee\":\"上看看\",\"telphone\":\"1800asda221\",\"address\":\"四川四川省成都市金牛区解放路二段\",\"total\":\"552.0\",\"servicephone1\":\"15923564512\",\"servicephone2\":\"028-12345678\",\"zhekou\":\"04544.0\",\"shifu\":\"1151.0\",\"goodsArr\":[{\"spname\":\"现代VK-10（单10）音响-网上易田，省心省钱[功率:200W及以下]\",\"price\":\"550.0\",\"num\":\"11\",\"Amount\":\"1911\"}]}";
    NSData *data = [infoStr dataUsingEncoding:NSUTF8StringEncoding];
    
    self.printDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [self.manager getBluetoothPrintWith:self.printDict andPrintType:1];
    [self.manager stopScan];
    [self.manager getPrintSuccessReturn:^(BOOL sizeValue) {
        [PublicHttpTool showWaitingView];
        if (sizeValue==YES) {
            [[EPToast makeText:@"打印成功"]showWithType:ShortTime];
        }else{
            [[EPToast makeText:@"打印失败!"]showWithType:ShortTime];
        }
    }];
}

- (void)fellViewDataWithLoginID:(NSString *)loginId TableID:(NSString *)tableId ChipFmeList:(NSArray *)chipFmeList{
    self.curLoginToken = loginId;
    self.curTableID = tableId;
    self.chip_FmeList = chipFmeList;
    for (int i=0; i<self.chip_FmeList.count; i++) {
        [self.tableView registerClass:[JiaJIanCaiCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"KReportImgTableViewCell_%d",i+1]];
    }
    [self.tableView reloadData];
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
    [PublicHttpTool showWaitingView];
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
    
    NSMutableArray *fme_num_list_all = [NSMutableArray array];
    NSMutableArray *fme_num_list1 = [NSMutableArray array];
    for (int i=0; i<self.RMBChipMoneyList.count; i++) {
        [fme_num_list1 addObject:[NSString stringWithFormat:@"%@,%@",self.RMBChipMoneyList[i],self.RMBChipNumberList[i]]];
    }
    NSMutableArray *fme_num_list2 = [NSMutableArray array];
    for (int i=0; i<self.USDChipMoneyList.count; i++) {
        [fme_num_list2 addObject:[NSString stringWithFormat:@"%@,%@",self.USDChipMoneyList[i],self.USDChipNumberList[i]]];
    }
    NSMutableArray *fme_num_list3 = [NSMutableArray array];
    for (int i=0; i<self.RMBMoneyList.count; i++) {
        [fme_num_list3 addObject:[NSString stringWithFormat:@"%@,%@",self.RMBMoneyList[i],self.RMBNumberList[i]]];
    }
    NSMutableArray *fme_num_list4 = [NSMutableArray array];
    for (int i=0; i<self.USDMoneyList.count; i++) {
        [fme_num_list4 addObject:[NSString stringWithFormat:@"%@,%@",self.USDMoneyList[i],self.USDNumberList[i]]];
    }
    NSMutableArray *fme_num_list5 = [NSMutableArray array];
    for (int i=0; i<self.RMBVIPChipMoneyList.count; i++) {
        [fme_num_list5 addObject:[NSString stringWithFormat:@"%@,%@",self.RMBVIPChipMoneyList[i],self.RMBVIPChipNumberList[i]]];
    }
    NSMutableArray *fme_num_list6 = [NSMutableArray array];
    for (int i=0; i<self.RMBVIPChipMoneyList.count; i++) {
        [fme_num_list6 addObject:[NSString stringWithFormat:@"%@,%@",self.USDVIPChipMoneyList[i],self.USDVIPChipNumberList[i]]];
    }
    [fme_num_list_all addObject:[fme_num_list1 componentsJoinedByString:@";"]];
    [fme_num_list_all addObject:[fme_num_list2 componentsJoinedByString:@";"]];
    [fme_num_list_all addObject:[fme_num_list3 componentsJoinedByString:@";"]];
    [fme_num_list_all addObject:[fme_num_list4 componentsJoinedByString:@";"]];
    [fme_num_list_all addObject:[fme_num_list5 componentsJoinedByString:@";"]];
    [fme_num_list_all addObject:[fme_num_list6 componentsJoinedByString:@";"]];
    NSMutableArray *coinList = [NSMutableArray arrayWithCapacity:0];
    NSArray *chipTypeList = [NSArray arrayWithObjects:@"1",@"2",@"6",@"7",@"8",@"9", nil];
    for (int i=0; i<chipTypeList.count; i++) {
        [coinList addObject:[NSString stringWithFormat:@"%@:%@",chipTypeList[i],fme_num_list_all[i]]];
    }
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"ftable_id":self.curTableID,
                             @"ftype":fTypeS,
                             @"coinlist":coinList
                             };
    if ([fTypeS isEqualToString:@"4"]) {
        param = @{
                    @"access_token":self.curLoginToken,
                    @"ftable_id":self.curTableID,
                    @"ftype":fTypeS,
                    @"fcmtype_list":coinList
                };
    }else if ([fTypeS isEqualToString:@"3"]||[fTypeS isEqualToString:@"5"]){
        NSMutableArray *fme_list = [NSMutableArray array];
        [fme_list addObject:self.RMBChipMoneyList];
        [fme_list addObject:self.USDChipMoneyList];
        [fme_list addObject:self.RMBMoneyList];
        [fme_list addObject:self.USDMoneyList];
        [fme_list addObject:self.RMBVIPChipMoneyList];
        [fme_list addObject:self.USDVIPChipMoneyList];
        
        NSMutableArray *fnums_list = [NSMutableArray array];
        [fnums_list addObject:self.RMBChipNumberList];
        [fnums_list addObject:self.USDChipNumberList];
        [fnums_list addObject:self.RMBNumberList];
        [fnums_list addObject:self.USDNumberList];
        [fnums_list addObject:self.RMBVIPChipNumberList];
        [fnums_list addObject:self.USDVIPChipNumberList];
        
        param = @{
                     @"access_token":self.curLoginToken,
                     @"ftable_id":self.curTableID,
                     @"ftype":fTypeS,
                     @"fcmtype_list":[NSArray arrayWithObjects:@"1",@"2",@"6",@"7",@"8",@"9", nil],
                     @"fme_list":fme_list,//面额
                     @"fnums_list":fnums_list,//数量
                 };
    }
    [PublicHttpTool Table_operateChipWithParams:param Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [PublicHttpTool hideWaitingView];
        if (success) {
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
                    if (self.kaiShoutaiBock) {
                        self.kaiShoutaiBock(2);
                    }
                }else if (self.headType==2){
                    [[EPToast makeText:@"收台成功" WithError:NO]showWithType:ShortTime];
                    if (self.kaiShoutaiBock) {
                        self.kaiShoutaiBock(1);
                    }
                }
            }
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
            self.RMBChipMoneyList = nil;
            self.USDChipMoneyList = nil;
            self.RMBMoneyList = nil;
            self.USDMoneyList = nil;
            self.RMBVIPChipMoneyList = nil;
            self.USDVIPChipMoneyList = nil;
            
            self.RMBChipNumberList = nil;
            self.USDChipNumberList = nil;
            self.RMBNumberList = nil;
            self.USDNumberList = nil;
            self.RMBVIPChipNumberList = nil;
            self.USDVIPChipNumberList = nil;
        }else{
            [PublicHttpTool showSoundMessage:msg];
        }
    }];
}

- (void)closeAction{
    [self removeFromSuperview];
}


#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.chip_FmeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"KReportImgTableViewCell_%ld",indexPath.section+1];
    JiaJIanCaiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[JiaJIanCaiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cellIndex = indexPath.section;
    NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    //是用来判断有没用被打开// YES (BOOL)1// NO  (BOOL)0
    BOOL isbool = [self.StatusArray containsObject: row];
    [cell fellCellWithOpen:isbool Type:self.headType WithNRChipAllInfo:self.chip_FmeList[indexPath.section]];
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
        }else if (cellId==4){
            self.bottomView.VIPCashValueLab.text = totalMonney;
        }else if (cellId==5){
            self.bottomView.VIPChipValueLab.text = totalMonney;
        }
    };
    cell.refrashSigleValueBlock = ^(int cellId, NSString * _Nonnull numberValue, NSString * _Nonnull moneyValue,int type) {
        @strongify(self);
        if (cellId==0) {//人民币码
            [self.RMBChipMoneyList replaceObjectAtIndex:type withObject:moneyValue];
            [self.RMBChipNumberList replaceObjectAtIndex:type withObject:numberValue];
        }else if (cellId==1){//人民币
            [self.RMBMoneyList replaceObjectAtIndex:type withObject:moneyValue];
            [self.RMBNumberList replaceObjectAtIndex:type withObject:numberValue];
        }else if (cellId==2){//美金码
            [self.USDChipMoneyList replaceObjectAtIndex:type withObject:moneyValue];
            [self.USDChipNumberList replaceObjectAtIndex:type withObject:numberValue];
        }else if (cellId==3){//美金现金
            [self.USDMoneyList replaceObjectAtIndex:type withObject:moneyValue];
            [self.USDNumberList replaceObjectAtIndex:type withObject:numberValue];
        }else if (cellId==4){//RMB贵宾码
            [self.RMBVIPChipMoneyList replaceObjectAtIndex:type withObject:moneyValue];
            [self.RMBVIPChipNumberList replaceObjectAtIndex:type withObject:numberValue];
        }else if (cellId==5){//USD贵宾码
            [self.USDVIPChipMoneyList replaceObjectAtIndex:type withObject:moneyValue];
            [self.USDVIPChipNumberList replaceObjectAtIndex:type withObject:numberValue];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    BOOL isbool = [self.StatusArray containsObject: row];
    return [JiaJIanCaiCell cellHeightWithOpen:isbool WithNRChipAllInfo:self.chip_FmeList[indexPath.section]];
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
