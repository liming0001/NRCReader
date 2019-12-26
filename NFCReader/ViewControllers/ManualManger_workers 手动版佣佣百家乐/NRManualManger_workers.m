//
//  NRManualMangerView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/8/26.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRManualManger_workers.h"
#import "SFLabel.h"
#import "JhPageItemView.h"
#import "CustomerInfo_workersCollectionViewCell.h"
#import "AddMoreCustomer_workersCollectionViewCell.h"
#import "CustomerEntryInfoView_workers.h"
#import "CustomerInfo.h"
#import "EPPopView.h"
#import "EPToast.h"
#import "JhPageItemModel.h"
#import "EPPayKillInfoView.h"

static NSString * const reuseIdentifier = @"CustomerCell";
static NSString * const moreReuseIdentifier = @"MoreCustomerCell";

@interface NRManualManger_workers ()<UICollectionViewDelegate,UICollectionViewDataSource>

//露珠信息
@property (nonatomic, strong) UIImageView *luzhuImgV;
@property (nonatomic, strong) UILabel *luzhuInfoLab;
@property (nonatomic, strong) UIView *luzhuCollectionView;
@property (nonatomic, strong) JhPageItemView *solidView;
@property (nonatomic, strong) NSMutableArray *luzhuInfoList;

//台桌信息
@property (nonatomic, strong) UIImageView *tableInfoImgV;
@property (nonatomic, strong) UILabel *tableInfoLab;
@property (nonatomic, strong) UIView *tableInfoV;
@property (nonatomic, strong) SFLabel *stableIDLab;
@property (nonatomic, strong) UIView *zhuangBorderV;
@property (nonatomic, strong) UIButton *zhuangInfoBtn;
@property (nonatomic, strong) UILabel *zhuangInfoLab;
@property (nonatomic, strong) UIView *zhuangDuiBorderV;
@property (nonatomic, strong) UIButton *zhuangDuiInfoBtn;
@property (nonatomic, strong) UILabel *zhuangDuiInfoLab;
@property (nonatomic, strong) UIView *sixWinBorderV;
@property (nonatomic, strong) UIButton *sixWinInfoBtn;
@property (nonatomic, strong) UILabel *sixWinInfoLab;
@property (nonatomic, strong) UIView *xianBorderV;
@property (nonatomic, strong) UIButton *xianInfoBtn;
@property (nonatomic, strong) UILabel *xianInfoLab;
@property (nonatomic, strong) UIView *xianDuiBorderV;
@property (nonatomic, strong) UIButton *xianDuiInfoBtn;
@property (nonatomic, strong) UILabel *xianDuiInfoLab;
@property (nonatomic, strong) UIView *heBorderV;
@property (nonatomic, strong) UIButton *heInfoBtn;
@property (nonatomic, strong) UILabel *heInfoLab;

//结算台
@property (nonatomic, strong) UIImageView *settlementImgV;
@property (nonatomic, strong) UILabel *settlementLab;
@property (nonatomic, strong) UIView *settlementV;
@property (nonatomic, strong) UIButton *zhuangBtn;
@property (nonatomic, strong) UIButton *zhuangDuiBtn;
@property (nonatomic, strong) UIButton *sixWinBtn;
@property (nonatomic, strong) UIButton *xianBtn;
@property (nonatomic, strong) UIButton *xianDuiBtn;
@property (nonatomic, strong) UIButton *heBtn;
@property (nonatomic, strong) UIButton *baoxianBtn;
@property (nonatomic, strong) UIButton *setmentOKBtn;
@property (nonatomic, strong) NSString *result_string;

//客人信息
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, assign) CGRect ViewFrame;
@property (nonatomic, strong) UICollectionViewLayout *layout;
@property (nonatomic, strong) NSMutableArray *customerInfoList;
@property (nonatomic, assign) BOOL isBeganMove;
@property (nonatomic, strong) NSMutableArray *resultList;
@property (nonatomic, strong) NSMutableArray *resultInfoList;

//提交参数
@property (nonatomic, strong) NSString *curLoginToken;
@property (nonatomic, strong) NSString *curTableID;
@property (nonatomic, strong) NSString *curTableName;
@property (nonatomic, strong) NSString *curSerialnumber;
@property (nonatomic, strong) NSString *cp_tableRijieDate;
@property (nonatomic, strong) NSString *cp_tableIDString;
@property (nonatomic, strong) NSArray *curXz_setting;

@property (nonatomic, assign) int zhuangCount;//庄赢次数
@property (nonatomic, assign) int zhuangDuiCount;//庄对赢次数
@property (nonatomic, assign) int sixCount;//6点赢次数
@property (nonatomic, assign) int xianCount;//闲赢次数
@property (nonatomic, assign) int xianDuiCount;//闲对赢次数
@property (nonatomic, assign) int heCount;//和赢次数
@property (nonatomic, assign) int baoXianCount;//保险赢次数
@property (nonatomic, assign) BOOL isEntryBox;

@property (nonatomic, strong) CustomerInfo *curSelectCustomer;
@property (nonatomic, strong) NSDictionary *curResultDict;

@property (nonatomic, assign) BOOL isFirstEntryGame;
@property (nonatomic, strong) NSDictionary *lastTableInfoDict;

@property (nonatomic,strong) NSMutableArray *fxmh_list;//洗码号
@property (nonatomic,strong) NSMutableArray *fxz_cmtype_list;//筹码类型
@property (nonatomic,strong) NSMutableArray *fxz_money_list;//下注本金
@property (nonatomic,strong) NSMutableArray *fxz_name_list;//下注名称
@property (nonatomic,strong) NSMutableArray *fsy_list;//输赢
@property (nonatomic,strong) NSMutableArray *fresult_list;//总码
@property (nonatomic,strong) NSMutableArray *fyj_list;//佣金
@property (nonatomic,strong) NSMutableArray *payKillResultInfo_list;//杀赔信息
@property (nonatomic, assign) CGFloat payKillResultValue;//杀赔金额


@property (nonatomic, strong) EPPayKillInfoView *payKillInfoView;

@end

@implementation NRManualManger_workers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.xueciCount = 1;
        self.puciCount = 0;
        self.prePuciCount = 1;
        self.luzhuInfoList = [NSMutableArray array];
        self.customerInfoList = [NSMutableArray array];
        
        self.resultList = [NSMutableArray array];
        self.resultInfoList = [NSMutableArray array];
        [self _setup];
    }
    return self;
}

-(UICollectionViewLayout *)layout{
    if (!_layout) {
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
        //设置水平滚动
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每个cell的尺寸
        layout.itemSize = CGSizeMake(135, 300);
        //cell之间的水平间距  行间距
        layout.minimumLineSpacing = 5;
        //cell之间的垂直间距 cell间距
        layout.minimumInteritemSpacing = 5;
        //设置四周边距
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        self.layout =layout;
        
    }
    return _layout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGRect Collectionframe =CGRectMake(0,305, kScreenWidth, self.frame.size.height-305-10);
        _collectionView = [[UICollectionView alloc] initWithFrame:Collectionframe collectionViewLayout:self.layout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomerInfo_workersCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AddMoreCustomer_workersCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:moreReuseIdentifier];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //隐藏滚动条
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.bounces = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        
    }
    return _collectionView;
}

-(JhPageItemView *)solidView{
    if (!_solidView) {
        CGRect femwe =  CGRectMake(0, 0, kScreenWidth-30-156-249, 232);
        JhPageItemView *view =  [[JhPageItemView alloc]initWithFrame:femwe];
        view.backgroundColor = [UIColor whiteColor];
        self.solidView = view;
    }
    return _solidView;
}

- (void)_setup{
    self.backgroundColor = [UIColor clearColor];
    //结算台
    self.settlementImgV = [UIImageView new];
    self.settlementImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self addSubview:self.settlementImgV];
    [self.settlementImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_offset(240);
    }];
    
    self.settlementLab = [UILabel new];
    self.settlementLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.settlementLab.font = [UIFont systemFontOfSize:14];
    self.settlementLab.text = @"结算台Settlement Desk";
    self.settlementLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.settlementLab];
    [self.settlementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_top).offset(3);
        make.left.equalTo(self.settlementImgV.mas_left).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_offset(240);
    }];
    
    self.settlementV = [UIView new];
    self.settlementV.layer.cornerRadius = 2;
    self.settlementV.backgroundColor = [UIColor colorWithHexString:@"#3e565d"];
    [self addSubview:self.settlementV];
    [self.settlementV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_bottom).offset(0);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(232);
        make.width.mas_offset(240);
    }];
    
    CGFloat setBtn_w = (240-30)/3;
    CGFloat setBtn_h = 50;
    self.zhuangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.zhuangBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.zhuangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.zhuangBtn setTitle:@"B.庄" forState:UIControlStateNormal];
    self.zhuangBtn.tag = 1;
    [self.zhuangBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.zhuangBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuangdui_p"] forState:UIControlStateSelected];
    [self.zhuangBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.zhuangBtn];
    [self.zhuangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(27);
        make.left.equalTo(self.settlementV).offset(10);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.zhuangDuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangDuiBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.zhuangDuiBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.zhuangDuiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.zhuangDuiBtn setTitle:@"BP.庄对" forState:UIControlStateNormal];
    self.zhuangDuiBtn.tag = 2;
    [self.zhuangDuiBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.zhuangDuiBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuangdui_p"] forState:UIControlStateSelected];
    [self.zhuangDuiBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.zhuangDuiBtn];
    [self.zhuangDuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(27);
        make.left.equalTo(self.zhuangBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.sixWinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sixWinBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.sixWinBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.sixWinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sixWinBtn setTitle:@"L.Lucky6" forState:UIControlStateNormal];
    self.sixWinBtn.tag = 3;
    [self.sixWinBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.sixWinBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuangdui_p"] forState:UIControlStateSelected];
    [self.sixWinBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.sixWinBtn];
    [self.sixWinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(27);
        make.left.equalTo(self.zhuangDuiBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.xianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianBtn setTitleColor:[UIColor colorWithHexString:@"#2749f5"] forState:UIControlStateNormal];
    [self.xianBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.xianBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.xianBtn setTitle:@"P.闲" forState:UIControlStateNormal];
    self.xianBtn.tag = 4;
    [self.xianBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.xianBtn setBackgroundImage:[UIImage imageNamed:@"settlement_xian_p"] forState:UIControlStateSelected];
    [self.xianBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.xianBtn];
    [self.xianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBtn.mas_bottom).offset(20);
        make.left.equalTo(self.settlementV).offset(10);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.xianDuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianDuiBtn setTitleColor:[UIColor colorWithHexString:@"#2749f5"] forState:UIControlStateNormal];
    [self.xianDuiBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.xianDuiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.xianDuiBtn setTitle:@"PP.闲对" forState:UIControlStateNormal];
    self.xianDuiBtn.tag = 5;
    [self.xianDuiBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.xianDuiBtn setBackgroundImage:[UIImage imageNamed:@"settlement_xian_p"] forState:UIControlStateSelected];
    [self.xianDuiBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.xianDuiBtn];
    [self.xianDuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBtn.mas_bottom).offset(20);
        make.left.equalTo(self.xianBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.heBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.heBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.heBtn setTitle:@"T.和" forState:UIControlStateNormal];
    self.heBtn.tag = 6;
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_n"] forState:UIControlStateNormal];
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"settlement_Tbtn_n"] forState:UIControlStateSelected];
    [self.heBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.heBtn];
    [self.heBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBtn.mas_bottom).offset(20);
        make.left.equalTo(self.xianDuiBtn.mas_right).offset(5);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.setmentOKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setmentOKBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.setmentOKBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.setmentOKBtn setTitle:@"OK.录入开牌结果" forState:UIControlStateNormal];
    [self.setmentOKBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateNormal];
    [self.setmentOKBtn addTarget:self action:@selector(resultEntryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.setmentOKBtn];
    [self.setmentOKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.settlementV).offset(-5);
        make.left.equalTo(self.settlementV).offset(10);
        make.centerX.equalTo(self.settlementV);
        make.height.mas_equalTo(41);
    }];
    
    //台桌信息
    self.tableInfoImgV = [UIImageView new];
    self.tableInfoImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self addSubview:self.self.tableInfoImgV];
    [self.tableInfoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self.settlementV.mas_left).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_offset(156);
    }];
    
    self.tableInfoLab = [UILabel new];
    self.tableInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tableInfoLab.font = [UIFont systemFontOfSize:12];
    self.tableInfoLab.text = @"台桌信息Table information";
    self.tableInfoLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tableInfoLab];
    [self.tableInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoImgV.mas_top).offset(3);
        make.left.equalTo(self.tableInfoImgV.mas_left).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_offset(156);
    }];
    
    self.tableInfoV = [UIView new];
    self.tableInfoV.layer.cornerRadius = 2;
    self.tableInfoV.backgroundColor = [UIColor colorWithHexString:@"#3e565d"];
    [self addSubview:self.tableInfoV];
    [self.tableInfoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoImgV.mas_bottom).offset(0);
        make.left.equalTo(self.tableInfoImgV.mas_left).offset(0);
        make.height.mas_equalTo(232);
        make.width.mas_offset(156);
    }];
    
    self.stableIDLab = [SFLabel new];
    self.stableIDLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.stableIDLab.font = [UIFont systemFontOfSize:10];
    self.stableIDLab.layer.cornerRadius = 5;
    self.stableIDLab.backgroundColor = [UIColor colorWithHexString:@"#201f24"];
    [self.tableInfoV addSubview:self.stableIDLab];
    [self.stableIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoV).offset(5);
        make.left.equalTo(self.tableInfoV).offset(15);
    }];
    
    self.xueciLab = [UILabel new];
    self.xueciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xueciLab.font = [UIFont systemFontOfSize:12];
    self.xueciLab.text = @"靴次:1";
    [self.tableInfoV addSubview:self.xueciLab];
    [self.xueciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stableIDLab.mas_bottom).offset(2);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.puciLab = [UILabel new];
    self.puciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.puciLab.font = [UIFont systemFontOfSize:12];
    self.puciLab.text = @"铺次:0";
    [self.tableInfoV addSubview:self.puciLab];
    [self.puciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(2);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.zhuangBorderV = [UIView new];
    self.zhuangBorderV.layer.cornerRadius = 2;
    self.zhuangBorderV.backgroundColor = [UIColor clearColor];
    self.zhuangBorderV.layer.borderWidth = 0.5;
    self.zhuangBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.zhuangBorderV];
    [self.zhuangBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.puciLab.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    CGFloat item_w = (156-40)/2+20;
    CGFloat item_w_lab = (156-40)/2-20;
    CGFloat item_result_h = 24;
    self.zhuangInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.zhuangInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.zhuangInfoBtn setTitle:@"B.庄" forState:UIControlStateNormal];
    [self.zhuangInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateNormal];
    [self.zhuangInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateHighlighted];
    [self.zhuangBorderV addSubview:self.zhuangInfoBtn];
    [self.zhuangInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.zhuangBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.zhuangInfoLab = [UILabel new];
    self.zhuangInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.zhuangInfoLab.font = [UIFont systemFontOfSize:12];
    self.zhuangInfoLab.text = @"6";
    self.zhuangInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.zhuangBorderV addSubview:self.zhuangInfoLab];
    [self.zhuangInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zhuangInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.zhuangBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    self.zhuangDuiBorderV = [UIView new];
    self.zhuangDuiBorderV.layer.cornerRadius = 2;
    self.zhuangDuiBorderV.backgroundColor = [UIColor clearColor];
    self.zhuangDuiBorderV.layer.borderWidth = 0.5;
    self.zhuangDuiBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.zhuangDuiBorderV];
    [self.zhuangDuiBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangBorderV.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(item_result_h);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.zhuangDuiInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhuangDuiInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.zhuangDuiInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.zhuangDuiInfoBtn setTitle:@"BP.庄对" forState:UIControlStateNormal];
    [self.zhuangDuiInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateNormal];
    [self.zhuangDuiInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateHighlighted];
    [self.zhuangDuiBorderV addSubview:self.zhuangDuiInfoBtn];
    [self.zhuangDuiInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.zhuangDuiBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.zhuangDuiInfoLab = [UILabel new];
    self.zhuangDuiInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.zhuangDuiInfoLab.font = [UIFont systemFontOfSize:12];
    self.zhuangDuiInfoLab.text = @"0";
    self.zhuangDuiInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.zhuangDuiBorderV addSubview:self.zhuangDuiInfoLab];
    [self.zhuangDuiInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zhuangDuiInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.zhuangDuiBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    self.sixWinBorderV = [UIView new];
    self.sixWinBorderV.layer.cornerRadius = 2;
    self.sixWinBorderV.backgroundColor = [UIColor clearColor];
    self.sixWinBorderV.layer.borderWidth = 0.5;
    self.sixWinBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.sixWinBorderV];
    [self.sixWinBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhuangDuiBorderV.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(item_result_h);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.sixWinInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sixWinInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.sixWinInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.sixWinInfoBtn setTitle:@"L.Lucky6" forState:UIControlStateNormal];
    [self.sixWinInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateNormal];
    [self.sixWinInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_zhuang_bg"] forState:UIControlStateHighlighted];
    [self.sixWinBorderV addSubview:self.sixWinInfoBtn];
    [self.sixWinInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.sixWinBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.sixWinInfoLab = [UILabel new];
    self.sixWinInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.sixWinInfoLab.font = [UIFont systemFontOfSize:12];
    self.sixWinInfoLab.text = @"0";
    self.sixWinInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.sixWinBorderV addSubview:self.sixWinInfoLab];
    [self.sixWinInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sixWinInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.sixWinBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    self.xianBorderV = [UIView new];
    self.xianBorderV.layer.cornerRadius = 2;
    self.xianBorderV.backgroundColor = [UIColor clearColor];
    self.xianBorderV.layer.borderWidth = 0.5;
    self.xianBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.xianBorderV];
    [self.xianBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sixWinBorderV.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(item_result_h);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.xianInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.xianInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.xianInfoBtn setTitle:@"P.闲" forState:UIControlStateNormal];
    [self.xianInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_xian_bg"] forState:UIControlStateNormal];
    [self.xianInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_xian_bg"] forState:UIControlStateHighlighted];
    [self.xianBorderV addSubview:self.xianInfoBtn];
    [self.xianInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.xianBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.xianInfoLab = [UILabel new];
    self.xianInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xianInfoLab.font = [UIFont systemFontOfSize:12];
    self.xianInfoLab.text = @"0";
    self.xianInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.xianBorderV addSubview:self.xianInfoLab];
    [self.xianInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xianInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.xianBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    self.xianDuiBorderV = [UIView new];
    self.xianDuiBorderV.layer.cornerRadius = 2;
    self.xianDuiBorderV.backgroundColor = [UIColor clearColor];
    self.xianDuiBorderV.layer.borderWidth = 0.5;
    self.xianDuiBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.xianDuiBorderV];
    [self.xianDuiBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xianBorderV.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(item_result_h);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.xianDuiInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xianDuiInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.xianDuiInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.xianDuiInfoBtn setTitle:@"PP.闲对" forState:UIControlStateNormal];
    [self.xianDuiInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_xian_bg"] forState:UIControlStateNormal];
    [self.xianDuiInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_xian_bg"] forState:UIControlStateHighlighted];
    [self.xianDuiBorderV addSubview:self.xianDuiInfoBtn];
    [self.xianDuiInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.xianDuiBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.xianDuiInfoLab = [UILabel new];
    self.xianDuiInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xianDuiInfoLab.font = [UIFont systemFontOfSize:12];
    self.xianDuiInfoLab.text = @"0";
    self.xianDuiInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.xianDuiBorderV addSubview:self.xianDuiInfoLab];
    [self.xianDuiInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xianDuiInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.xianDuiBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    self.heBorderV = [UIView new];
    self.heBorderV.layer.cornerRadius = 2;
    self.heBorderV.backgroundColor = [UIColor clearColor];
    self.heBorderV.layer.borderWidth = 0.5;
    self.heBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.heBorderV];
    [self.heBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xianDuiBorderV.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(item_result_h);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    
    self.heInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.heInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.heInfoBtn setTitle:@"T.和" forState:UIControlStateNormal];
    [self.heInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_he_bg"] forState:UIControlStateNormal];
    [self.heInfoBtn setBackgroundImage:[UIImage imageNamed:@"talbe_he_bg"] forState:UIControlStateHighlighted];
    [self.heBorderV addSubview:self.heInfoBtn];
    [self.heInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(self.heBorderV).offset(0);
        make.width.mas_equalTo(item_w);
    }];
    
    self.heInfoLab = [UILabel new];
    self.heInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.heInfoLab.font = [UIFont systemFontOfSize:12];
    self.heInfoLab.text = @"0";
    self.heInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.heBorderV addSubview:self.heInfoLab];
    [self.heInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heInfoBtn.mas_right).offset(0);
        make.centerY.equalTo(self.heBorderV);
        make.width.mas_equalTo(item_w_lab);
    }];
    
    //露珠信息
    self.luzhuImgV = [UIImageView new];
    self.luzhuImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self addSubview:self.self.luzhuImgV];
    [self.luzhuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self.tableInfoImgV.mas_left).offset(-5);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    self.luzhuInfoLab = [UILabel new];
    self.luzhuInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.luzhuInfoLab.font = [UIFont systemFontOfSize:14];
    self.luzhuInfoLab.text = @"露珠信息Dew information";
    self.luzhuInfoLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.luzhuInfoLab];
    [self.luzhuInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luzhuImgV.mas_top).offset(3);
        make.left.equalTo(self.luzhuImgV.mas_left).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_offset(kScreenWidth-30-156-249);
    }];
    
    self.luzhuCollectionView = [UIView new];
    self.luzhuCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.luzhuCollectionView];
    [self.luzhuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luzhuImgV.mas_bottom).offset(0);
        make.left.right.equalTo(self.luzhuImgV).offset(0);
        make.height.mas_equalTo(232);
    }];
    
    [self.luzhuCollectionView addSubview:self.solidView];
    [self.solidView fellLuzhuListWithDataList:self.luzhuInfoList];
    [self addSubview:self.collectionView];
}

- (void)restartChangeStatus{
    [self.luzhuInfoList removeAllObjects];
    [self.solidView fellLuzhuListWithDataList:self.luzhuInfoList];
    [self resetCountStatus];
}

- (void)resetCountStatus{
    self.zhuangCount=0;//庄赢次数
    self.zhuangDuiCount=0;//庄对赢次数
    self.sixCount=0;//6点赢次数
    self.xianCount=0;//闲赢次数
    self.xianDuiCount=0;//闲对赢次数
    self.heCount=0;//和赢次数
    self.baoXianCount=0;//保险赢次数
    self.zhuangInfoLab.text = [NSString stringWithFormat:@"%d",self.zhuangCount];
    self.zhuangDuiInfoLab.text = [NSString stringWithFormat:@"%d",self.zhuangDuiCount];
    self.sixWinInfoLab.text = [NSString stringWithFormat:@"%d",self.sixCount];
    self.xianInfoLab.text = [NSString stringWithFormat:@"%d",self.xianCount];
    self.xianDuiInfoLab.text = [NSString stringWithFormat:@"%d",self.xianDuiCount];
    self.heInfoLab.text = [NSString stringWithFormat:@"%d",self.heCount];
}

- (void)menuAction:(UIButton *)btn{
    int winType = (int)btn.tag;
    if (winType==1) {//庄
        if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//是否包含“闲，和”
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
            return;
        }else{
            self.zhuangBtn.selected = !self.zhuangBtn.selected;
            if (self.zhuangBtn.selected) {
                if (![self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
                    [self.resultList addObject:[NSNumber numberWithInteger:1]];
                }
            }else{
                if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {//庄对
                    [self.zhuangDuiBtn setSelected:NO];
                    [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                }
                if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {//6点赢
                    [self.sixWinBtn setSelected:NO];
                    [self.resultList removeObject:[NSNumber numberWithInteger:3]];
                }
                if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {//闲对
                    [self.xianDuiBtn setSelected:NO];
                    [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                }
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
                    [self.resultList removeObject:[NSNumber numberWithInteger:1]];
                }
            }
        }
    }else if (winType==2){//庄对
        if (!([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]])) {
            [[EPToast makeText:@"请先选择庄或闲或和"]showWithType:ShortTime];
            return;
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]) {//已经选择了庄
                if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                    [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                    return;
                }else{
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        if (![self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                            [self.resultList addObject:[NSNumber numberWithInteger:2]];
                        }
                    }else{
                        if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                            [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                        }
                    }
                }
            }else if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]){//已经选择了闲
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                    [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                    return;
                }else{
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        if (![self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                            [self.resultList addObject:[NSNumber numberWithInteger:2]];
                        }
                    }else{
                        if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                            [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                        }
                    }
                }
            }else if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]){//已经选择了和
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                    [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                    return;
                }else{
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        if (![self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                            [self.resultList addObject:[NSNumber numberWithInteger:2]];
                        }
                    }else{
                        if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                            [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                        }
                    }
                }
            }
        }
    }else if (winType==3){//幸运6点
        if (![self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
            [[EPToast makeText:@"请先选择庄"]showWithType:ShortTime];
            return;
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                return;
            }else{
                btn.selected = !btn.selected;
                if (btn.selected) {
                    if (![self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                        [self.resultList addObject:[NSNumber numberWithInteger:3]];
                    }
                }else{
                    if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                        [self.resultList removeObject:[NSNumber numberWithInteger:3]];
                    }
                }
                
            }
        }
    }else if (winType==4){//闲
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//是否包含“庄，和”
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
            return;
        }else{
            btn.selected = !btn.selected;
            if (btn.selected) {
                if (![self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                    [self.resultList addObject:[NSNumber numberWithInteger:4]];
                }
            }else{
                if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {//庄对
                    [self.zhuangDuiBtn setSelected:NO];
                    [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                }
                if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {//闲对
                    [self.xianDuiBtn setSelected:NO];
                    [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                }
                if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                    [self.resultList removeObject:[NSNumber numberWithInteger:4]];
                }
            }
        }
    }else if (winType==5){//闲对
        if (!([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]])) {
            [[EPToast makeText:@"请先选择庄或闲或和"]showWithType:ShortTime];
            return;
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]) {//已经选择了庄
                if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                    [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                    return;
                }else{
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        if (![self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                            [self.resultList addObject:[NSNumber numberWithInteger:5]];
                        }
                    }else{
                        if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                            [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                        }
                    }
                }
            }else if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]){//已经选择了闲
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]||[self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                    [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                    return;
                }else{
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        if (![self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                            [self.resultList addObject:[NSNumber numberWithInteger:5]];
                        }
                    }else{
                        if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                            [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                        }
                    }
                }
            }else if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]){//已经选择了和
                if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                    [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                    return;
                }else{
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        if (![self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                            [self.resultList addObject:[NSNumber numberWithInteger:5]];
                        }
                    }else{
                        if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                            [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                        }
                    }
                }
            }
        }
    }else if (winType==6){//和
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]) {//是否包含“闲，和”
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
            return;
        }else{
            self.heBtn.selected = !self.heBtn.selected;
            if (self.heBtn.selected) {
                if (![self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                    [self.resultList addObject:[NSNumber numberWithInteger:6]];
                }
            }else{
                if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {//庄对
                    [self.zhuangDuiBtn setSelected:NO];
                    [self.resultList removeObject:[NSNumber numberWithInteger:2]];
                }
                if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {//闲对
                    [self.xianDuiBtn setSelected:NO];
                    [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                }
                if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                    [self.resultList removeObject:[NSNumber numberWithInteger:6]];
                }
            }
        }
    }
}

- (void)reloadLuzhuInfoWithLuzhuList:(NSArray *)luzhuList{
    [self.luzhuInfoList removeAllObjects];
    [self.luzhuInfoList addObjectsFromArray:luzhuList];
    self.solidView.dataArray = self.luzhuInfoList;
}

#pragma mark - 手势事件
-(void)moveCollectionViewCell:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (!self.isBeganMove) {
                self.isBeganMove = YES;
                //获取点击的cell的indexPath
                NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
                
                //开始移动对应的cell
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            //移动cell
            [self.collectionView updateInteractiveMovementTargetPosition:[gesture locationInView:self.collectionView]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            self.isBeganMove = false;
            //结束移动
            [self.collectionView endInteractiveMovement];
            break;
        }
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.customerInfoList.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==self.customerInfoList.count) {
        AddMoreCustomer_workersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreReuseIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        CustomerInfo_workersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.cellIndex = indexPath.row;
        NSInteger curIndex = indexPath.row+1;
        NSString *number_s = @"";
        if (curIndex<10) {
            number_s = [NSString stringWithFormat:@"NO.00%d",(int)curIndex];
        }else if (curIndex<100&&curIndex>=10){
            number_s = [NSString stringWithFormat:@"NO.0%d",(int)curIndex];
        }else{
            number_s = [NSString stringWithFormat:@"NO.%d",(int)curIndex];
        }
        cell.number_customer.text = number_s;
        [cell fellCellWithCustomerInfo:self.customerInfoList[indexPath.row]];
        @weakify(self);
        cell.deleteCustomer = ^(NSInteger curCellIndex) {
            @strongify(self);
            [self.customerInfoList removeObjectAtIndex:curCellIndex];
            [collectionView reloadData];
        };
        //添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveCollectionViewCell:)];
        [cell addGestureRecognizer:longPress];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //处理数据（删除之前的位置数据，插入到新的位置）
    CustomerInfo *selectModel = self.customerInfoList[sourceIndexPath.item];
    [self.customerInfoList removeObjectAtIndex:sourceIndexPath.item];
    [self.customerInfoList insertObject:selectModel atIndex:destinationIndexPath.item];
    [collectionView reloadData];
    //此处可以根据需要，上传给后台目前数据的顺序
}

#pragma mark - 点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.customerInfoList.count) {
        [self.customerInfoList addObject:[self modelCustomerInfo]];
        [collectionView reloadData];
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }else{
        if ([self canResultBtnAciontNextStep]) {
            if (self.isEntryBox) {
                return;
            }
            self.isEntryBox = YES;
            CustomerInfo *info = self.customerInfoList[indexPath.row];
            CustomerEntryInfoView_workers *custerEntryInfoV = [[[NSBundle mainBundle]loadNibNamed:@"CustomerEntryInfoView_workers" owner:nil options:nil]lastObject];
            custerEntryInfoV.frame = self.bounds;
            [custerEntryInfoV editLoginInfoWithLoginID:self.curLoginToken];
            @weakify(self);
            custerEntryInfoV.editTapCustomer = ^(CustomerInfo * _Nonnull curCustomer, BOOL hasEntry) {
                @strongify(self);
                self.isEntryBox = NO;
                if (hasEntry) {
                    self.curSelectCustomer = curCustomer;
                    [self.customerInfoList replaceObjectAtIndex:indexPath.row withObject:curCustomer];
                    [collectionView reloadData];
                    [self fengzhuangCustomerInfo];
                    self.payKillInfoView = [EPPayKillInfoView showInWindowWithNRCustomerInfo:self.curSelectCustomer handler:^(int buttonType) {
                        @strongify(self);
                        if (buttonType==1) {
                            [self.payKillInfoView _hide];
                            [self showWaitingView];
                            [self commitCustomerRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                                @strongify(self);
                                if (success) {
                                    [[EPToast makeText:@"结果录入成功" WithError:NO]showWithType:ShortTime];
                                    //响警告声音
                                    [EPSound playWithSoundName:@"succeed_sound"];
                                }else{
                                    [[EPToast makeText:@"结果录入失败" WithError:YES]showWithType:ShortTime];
                                    //响警告声音
                                    [EPSound playWithSoundName:@"wram_sound"];
                                }
                                [self hideWaitingView];
                            }];
                        }
                    }];
                }
            };
            [custerEntryInfoV editCurCustomerWithCustomerInfo:info];
            [[MJPopTool sharedInstance] popView:custerEntryInfoV animated:YES];
        }
    }
}

#pragma mark --清除金额
- (void)clearMoney{
//    [self.customerInfoList removeAllObjects];
//    [self.customerInfoList addObject:[self modelCustomerInfo]];
    [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *customerInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        customerInfo.zhuangValue = @"";
        customerInfo.zhuangDuiValue = @"";
        customerInfo.xianValue = @"";
        customerInfo.xianDuiValue = @"";
        customerInfo.sixWinValue = @"";
        customerInfo.heValue = @"";
        customerInfo.baoxianValue = @"";
        customerInfo.cashType = 1;
    }];
    [self.collectionView reloadData];
}

#pragma mark -- 是否能进行结果选择按钮
- (BOOL)canResultBtnAciontNextStep{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.puciCount==0) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return NO;
    }
    if (self.prePuciCount==self.puciCount) {
        [[EPToast makeText:@"请先提交开牌结果"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return NO;
    }
    return YES;
}

- (CustomerInfo *)modelCustomerInfo{
    CustomerInfo *customer = [[CustomerInfo alloc]init];
    customer.headUrlString = @"addIcon_headImg";
    customer.washNumberValue = @"";
    customer.zhuangValue = @"";
    customer.zhuangDuiValue = @"";
    customer.sixWinValue = @"";
    customer.xianValue = @"";
    customer.xianDuiValue = @"";
    customer.heValue = @"";
    customer.baoxianValue = @"";
    customer.cashType = 1;
    customer.headbgImgName = @"customer_VIP_bg";
    customer.isYouYong = YES;
    customer.sixValueType = 1;
    return customer;
}

- (void)resultEntryAction:(UIButton *)btn{
    if (self.puciCount!=self.prePuciCount) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        return;
    }
    if (self.resultList.count==0) {
        [[EPToast makeText:@"请选择开牌结果"]showWithType:ShortTime];
        return;
    }
    [self showWaitingView];
    @weakify(self);
    [self commitkpResultWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        [self hideWaitingView];
        if (success) {
            self.prePuciCount = self.puciCount+1;
            [[EPToast makeText:@"提交开牌结果成功" WithError:NO]showWithType:ShortTime];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
            [self getLUzhuINfo];
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

- (void)resertResultBtnStatus{
    [self.zhuangBtn setSelected:NO];
    [self.zhuangDuiBtn setSelected:NO];
    [self.xianBtn setSelected:NO];
    [self.xianDuiBtn setSelected:NO];
    [self.sixWinBtn setSelected:NO];
    [self.heBtn setSelected:NO];
    [self.baoxianBtn setSelected:NO];
    [self.resultList removeAllObjects];
    self.result_string = @"";
}

- (void)transLoginInfoWithLoginID:(NSString *)loginID TableID:(NSString *)tableID Serialnumber:(NSString *)serialnumber Peilv:(NSArray *)xz_setting TableName:(NSString *)tableName RijieData:(NSString *)curRijieDate{
    self.cp_tableRijieDate = curRijieDate;
    self.curLoginToken = loginID;
    self.curTableID = tableID;
    self.curTableName = tableName;
    self.curSerialnumber = serialnumber;
    self.curXz_setting = xz_setting;
    self.stableIDLab.text = [NSString stringWithFormat:@"台桌ID:%@",self.curTableName];
    [self.customerInfoList addObject:[self modelCustomerInfo]];
    [self.collectionView reloadData];
}

- (void)fellXueCiWithXueCi:(int)curXueci PuCi:(int)curPuCi{
    self.xueciCount = curXueci;
    self.puciCount = curPuCi;
    self.prePuciCount = self.puciCount +1;
    self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
    self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
}

- (void)getManualBaseTableInfoAndLuzhuInfo{
    self.isFirstEntryGame = YES;
    [self getLastXueCiInfoWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        NSDictionary *tableInfo = self.lastTableInfoDict;
        if (tableInfo&&tableInfo.count!=0) {
            NSString *fnew_xueci = tableInfo[@"fnew_xueci"];
            if(![fnew_xueci isEqual:[NSNull null]]) {
                //result是从服务器返回的数据
                //在这里进行操作
                int curNewXueci = [fnew_xueci intValue];
                self.xueciCount = curNewXueci;
            }else{
                int fXueci = [tableInfo[@"fxueci"]intValue];
                self.xueciCount = fXueci;
            }
        }
        self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
        [self getLUzhuINfo];
    }];
}

- (void)getLUzhuINfo{
    [self getLuzhuWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self hideWaitingView];
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.solidView fellLuzhuListWithDataList:self.luzhuInfoList];
                self.zhuangInfoLab.text = [NSString stringWithFormat:@"%d",self.zhuangCount];
                self.zhuangDuiInfoLab.text = [NSString stringWithFormat:@"%d",self.zhuangDuiCount];
                self.sixWinInfoLab.text = [NSString stringWithFormat:@"%d",self.sixCount];
                self.xianInfoLab.text = [NSString stringWithFormat:@"%d",self.xianCount];
                self.xianDuiInfoLab.text = [NSString stringWithFormat:@"%d",self.xianDuiCount];
                self.heInfoLab.text = [NSString stringWithFormat:@"%d",self.heCount];
            });
            if (self.isFirstEntryGame) {
                self.isFirstEntryGame = NO;
                if (self.lastTableInfoDict&&self.lastTableInfoDict.count!=0) {
                    //判断结果
                    NSString *cp_result = self.lastTableInfoDict[@"fkpresult"];
                    [self.resultList removeAllObjects];
                    [self resertResultBtnStatus];
                    NSArray *resultList = [cp_result componentsSeparatedByString:@","];
                    if ([resultList containsObject:@"庄"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:1]];
                        [self.zhuangBtn setSelected:YES];
                    }
                    if ([resultList containsObject:@"庄对"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:2]];
                        [self.zhuangDuiBtn setSelected:YES];
                    }
                    if ([resultList containsObject:@"6点赢"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:3]];
                        [self.sixWinBtn setSelected:YES];
                    }
                    if ([resultList containsObject:@"闲"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:4]];
                        [self.xianBtn setSelected:YES];
                    }
                    if ([resultList containsObject:@"闲对"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:5]];
                        [self.xianDuiBtn setSelected:YES];
                    }
                    if ([resultList containsObject:@"和"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:6]];
                        [self.heBtn setSelected:YES];
                    }
                    self.puciCount = [self.lastTableInfoDict[@"fpuci"]intValue];
                    self.prePuciCount = self.puciCount+1;
                    self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
                    self.cp_tableIDString = self.lastTableInfoDict[@"fid"];
                }
            }
        }
    }];
}

- (void)showWaitingView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.layer.zPosition = 100;
}

- (void)hideWaitingView {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

#pragma mark - 获取当前台桌的靴次
- (void)getLastXueCiInfoWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"table_id":self.curTableID,
                             @"date":self.cp_tableRijieDate,//日期
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_getXueci",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        DLOG(@"responseDict===%@",responseDict);
        if (![responseDict[@"table"]isEqual:[NSNull null]]) {
            self.lastTableInfoDict = responseDict[@"table"];
            self.cp_tableIDString = self.lastTableInfoDict[@"fid"];
        }
        block(suc, msg,error);
        
    }];
}

#pragma mark - 获取露珠
- (void)getLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"ftable_id":self.curTableID,//桌子ID
                             @"rjdate":self.cp_tableRijieDate,//日期
                             @"fxueci":[NSString stringWithFormat:@"%d",self.xueciCount]//靴次
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"tablerec_luzhu",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_Public_ListWithParamter:Realparam block:^(NSArray *list, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            [self resetCountStatus];
            self.realLuzhuList = list;
            NSMutableArray *luzhuList = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(NSDictionary *luzhiDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *resultS =  luzhiDict[@"fkpresult"];
                NSArray *resultList = [resultS componentsSeparatedByString:@","];
                NSString *text = @"";
                NSString *img = @"";
                if (resultList.count==1) {
                    NSString *resultName = resultList[0];
                    if ([resultName isEqualToString:@"庄"]) {
                        if ([resultName isEqualToString:@"庄"]) {
                            self.zhuangCount +=1;
                        }
                        img = @"1";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 1;
                        [luzhuList addObject:model];
                    }else if ([resultName isEqualToString:@"闲"]){
                        if ([resultName isEqualToString:@"闲"]) {
                            self.xianCount +=1;
                        }
                        img = @"7";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 1;
                        [luzhuList addObject:model];
                    }else if ([resultName isEqualToString:@"和"]){
                        self.heCount +=1;
                        img = @"0";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 1;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }
                }else if (resultList.count==2){
                    if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]) {
                        self.zhuangCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"2";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 2;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"闲对"]){
                        self.zhuangCount+=1;
                        self.xianDuiCount+=1;
                        img = @"3";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 3;
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"Lucky6"]){
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"1";
                        text = @"6";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 3;
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"闲对"]){
                        self.xianCount+=1;
                        self.xianDuiCount+=1;
                        img = @"6";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 4;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"庄对"]){
                        self.xianCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"5";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 5;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"庄对"]){
                        self.heCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"22";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 5;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"闲对"]){
                        self.heCount+=1;
                        self.xianDuiCount+=1;
                        img = @"21";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 5;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }
                }else if (resultList.count==3){
                    if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"闲对"]) {
                        self.zhuangDuiCount+=1;
                        self.zhuangCount+=1;
                        self.xianDuiCount+=1;
                        img = @"4";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 6;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"Lucky6"]){
                        self.zhuangDuiCount+=1;
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"2";
                        text = @"6";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"Lucky6"]){
                        self.xianDuiCount+=1;
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"3";
                        text = @"6";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"庄对"]){
                        self.xianDuiCount+=1;
                        self.zhuangDuiCount+=1;
                        self.xianCount+=1;
                        img = @"8";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"庄对"]){
                        self.xianDuiCount+=1;
                        self.zhuangDuiCount+=1;
                        self.heCount+=1;
                        img = @"23";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }
                }else if (resultList.count==4){
                    if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"Lucky6"]) {
                        self.zhuangDuiCount+=1;
                        self.zhuangCount+=1;
                        self.xianDuiCount+=1;
                        self.sixCount+=1;
                        img = @"4";
                        text = @"6";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 6;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }
                }
            }];
            for (int i=(int)list.count; i<luzhuMaxCount; i++) {
                NSString *text = @"";
                NSString *img = @"";
                JhPageItemModel *model = [[JhPageItemModel alloc]init];
                model.img = img;
                model.text = text;
                model.luzhuType = 0;
                model.colorString = @"#ffffff";
                [luzhuList addObject:model];
            }
            [self.luzhuInfoList removeAllObjects];
            [self.luzhuInfoList addObjectsFromArray:luzhuList];
        }
        block(suc, msg,error);
        
    }];
}

- (void)fengzhuangChipTypeWith:(CustomerInfo *)curCustomer{
    if (curCustomer.cashType==0) {//美金筹码
        [self.fxz_cmtype_list addObject:[NSNumber numberWithInt:9]];
    }else if (curCustomer.cashType==1){//美金现金
        [self.fxz_cmtype_list addObject:[NSNumber numberWithInt:7]];
    }else if (curCustomer.cashType==2){//人民币筹码
        [self.fxz_cmtype_list addObject:[NSNumber numberWithInt:8]];
    }else if (curCustomer.cashType==3){//人民币现金
        [self.fxz_cmtype_list addObject:[NSNumber numberWithInt:6]];
    }
}

#pragma mark - 提交开牌结果
- (void)commitkpResultWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSMutableArray *reslutNameList = [NSMutableArray array];
    for (int i=0; i<self.resultList.count; i++) {
        NSInteger tagResult = [self.resultList[i]integerValue];
        if (tagResult==1) {
            [reslutNameList addObject:@"庄"];
        }else if (tagResult==2){
            [reslutNameList addObject:@"庄对"];
        }else if (tagResult==3){
            [reslutNameList addObject:@"Lucky6"];
        }else if (tagResult==4){
            [reslutNameList addObject:@"闲"];
        }else if (tagResult==5){
            [reslutNameList addObject:@"闲对"];
        }else if (tagResult==6){
            [reslutNameList addObject:@"和"];
        }
    }
    self.result_string = [reslutNameList componentsJoinedByString:@","];
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"ftable_id":self.curTableID,//桌子ID
                             @"fxueci":[NSString stringWithFormat:@"%d",self.xueciCount],//靴次
                             @"fpuci":[NSString stringWithFormat:@"%d",self.puciCount],//铺次
                             @"fpcls":self.curSerialnumber,//铺次流水号，长度不超过20位，要求全局唯一
                             @"fkpresult":self.result_string,//结果
                             @"frjdate":self.cp_tableRijieDate//日期
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_kpResult",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            self.cp_tableIDString = responseString;
        }
        block(suc, msg,error);
    }];
}

- (void)fengzhuangCustomerInfo{
    //洗码号
    self.fxmh_list = [NSMutableArray array];
    //筹码类型
    self.fxz_cmtype_list = [NSMutableArray array];
    //下注本金
    self.fxz_money_list = [NSMutableArray array];
    //下注名称
    self.fxz_name_list = [NSMutableArray array];
    //输赢
    self.fsy_list = [NSMutableArray array];
    //总码
    self.fresult_list = [NSMutableArray array];
    //佣金
    self.fyj_list = [NSMutableArray array];
    
    self.payKillResultInfo_list = [NSMutableArray arrayWithCapacity:0];
    self.payKillResultValue  = 0;
    
    if ([self.curSelectCustomer.zhuangValue integerValue]!=0) {//庄
        NSString *zhuangRealValue = [NSString stringWithFormat:@"庄:%@",self.curSelectCustomer.zhuangValue];
        [self.payKillResultInfo_list addObject:zhuangRealValue];
        [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        [self.fxz_money_list addObject:self.curSelectCustomer.zhuangValue];
        [self.fxz_name_list addObject:@"庄"];
        //赔率
        CGFloat odds = 0;
        CGFloat yj = 0;
        NSArray *xz_array = self.curXz_setting;
        if (xz_array.count>0) {
            odds = [xz_array[0][@"fpl"] floatValue];
            yj = [xz_array[0][@"fyj"] floatValue]/100;
        }
        if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
            [self.fsy_list addObject:[NSNumber numberWithInt:0]];
            [self.fresult_list addObject:[NSNumber numberWithInt:0]];
            [self.fyj_list addObject:[NSNumber numberWithDouble:0]];
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]) {//庄
                [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.zhuangValue integerValue];
                [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
                CGFloat yjValue = yj*[self.curSelectCustomer.zhuangValue integerValue];
                [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
                CGFloat payValue = (odds-yj)*[self.curSelectCustomer.zhuangValue integerValue];
                self.payKillResultValue+= payValue;
            }else {
                [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                [self.fresult_list addObject:self.curSelectCustomer.zhuangValue];
                [self.fyj_list addObject:[NSNumber numberWithDouble:0]];
                self.payKillResultValue-= [self.curSelectCustomer.zhuangValue floatValue];
            }
        }
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    if ([self.curSelectCustomer.zhuangDuiValue integerValue]!=0) {//庄对
        NSString *zhuangDuiRealValue = [NSString stringWithFormat:@"庄对:%@",self.curSelectCustomer.zhuangDuiValue];
        [self.payKillResultInfo_list addObject:zhuangDuiRealValue];
        [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        [self.fxz_money_list addObject:self.curSelectCustomer.zhuangDuiValue];
        [self.fxz_name_list addObject:@"庄对"];
        //赔率
        CGFloat odds = 0;
        CGFloat yj = 0;
        NSArray *xz_array = self.curXz_setting;
        if (xz_array.count>2) {
            odds = [xz_array[2][@"fpl"] floatValue];
            yj = [xz_array[2][@"fyj"] floatValue]/100;
        }
        if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {//庄对
            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
            CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.zhuangDuiValue integerValue];
            [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
            CGFloat yjValue = yj*[self.curSelectCustomer.zhuangDuiValue integerValue];
            [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
            CGFloat payValue = (odds-yj)*[self.curSelectCustomer.zhuangDuiValue integerValue];
            self.payKillResultValue+= payValue;
        }else {
            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
            [self.fresult_list addObject:self.curSelectCustomer.zhuangDuiValue];
            [self.fyj_list addObject:[NSNumber numberWithDouble:0]];
            self.payKillResultValue-= [self.curSelectCustomer.zhuangDuiValue floatValue];
        }
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    if ([self.curSelectCustomer.sixWinValue integerValue]!=0) {//六点赢
        NSString *luckyRealValue = [NSString stringWithFormat:@"庄6点:%@",self.curSelectCustomer.luckyValue];
        [self.payKillResultInfo_list addObject:luckyRealValue];
        [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        [self.fxz_money_list addObject:self.curSelectCustomer.sixWinValue];
        [self.fxz_name_list addObject:@"Lucky6"];
        //赔率
        CGFloat odds = 0;
        CGFloat yj = 0;
        NSArray *xz_array = self.curXz_setting;
        if (self.curSelectCustomer.sixValueType==1) {
            if (xz_array.count>6) {
                odds = [xz_array[6][@"fpl"] floatValue];
                yj = [xz_array[6][@"fyj"] floatValue]/100;
            }
        }else{
            if (xz_array.count>7) {
                odds = [xz_array[7][@"fpl"] floatValue];
                yj = [xz_array[7][@"fyj"] floatValue]/100;
            }
        }
        if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
            [self.fsy_list addObject:[NSNumber numberWithInt:0]];
            [self.fresult_list addObject:[NSNumber numberWithInt:0]];
            [self.fyj_list addObject:[NSNumber numberWithDouble:0]];
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {//6点赢
                [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.sixWinValue integerValue];
                [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
                CGFloat yjValue = yj*[self.curSelectCustomer.sixWinValue integerValue];
                [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
                CGFloat payValue = (odds-yj)*[self.curSelectCustomer.sixWinValue integerValue];
                self.payKillResultValue+= payValue;
            }else {
                [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                [self.fresult_list addObject:self.curSelectCustomer.sixWinValue];
                [self.fyj_list addObject:[NSNumber numberWithDouble:0]];
                self.payKillResultValue-= [self.curSelectCustomer.sixWinValue floatValue];
            }
        }
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    if ([self.curSelectCustomer.xianValue integerValue]!=0) {//闲
        NSString *xianRealValue = [NSString stringWithFormat:@"闲:%@",self.curSelectCustomer.xianValue];
        [self.payKillResultInfo_list addObject:xianRealValue];
        [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        [self.fxz_money_list addObject:self.curSelectCustomer.xianValue];
        [self.fxz_name_list addObject:@"闲"];
        //赔率
        CGFloat odds = 0;
        CGFloat yj = 0;
        NSArray *xz_array = self.curXz_setting;
        if (xz_array.count>1) {
            odds = [xz_array[1][@"fpl"] floatValue];
            yj = [xz_array[1][@"fyj"] floatValue]/100;
        }
        if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
            [self.fsy_list addObject:[NSNumber numberWithInt:0]];
            [self.fresult_list addObject:[NSNumber numberWithInt:0]];
            [self.fyj_list addObject:[NSNumber numberWithDouble:0]];
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]) {//闲
                [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.xianValue integerValue];
                [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
                CGFloat yjValue = yj*[self.curSelectCustomer.xianValue integerValue];
                [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
                CGFloat payValue = (odds-yj)*[self.curSelectCustomer.xianValue integerValue];
                self.payKillResultValue+= payValue;
            }else {
                [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                [self.fresult_list addObject:self.curSelectCustomer.xianValue];
                [self.fyj_list addObject:[NSNumber numberWithDouble:0]];
                self.payKillResultValue-= [self.curSelectCustomer.xianValue floatValue];
            }
        }
        
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    
    if ([self.curSelectCustomer.xianDuiValue integerValue]!=0) {//闲对
        NSString *xianDuiRealValue = [NSString stringWithFormat:@"闲对:%@",self.curSelectCustomer.xianDuiValue];
        [self.payKillResultInfo_list addObject:xianDuiRealValue];
        [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        [self.fxz_money_list addObject:self.curSelectCustomer.xianDuiValue];
        [self.fxz_name_list addObject:@"闲对"];
        //赔率
        CGFloat odds = 0;
        CGFloat yj = 0;
        NSArray *xz_array = self.curXz_setting;
        if (xz_array.count>3) {
            odds = [xz_array[3][@"fpl"] floatValue];
            yj = [xz_array[3][@"fyj"] floatValue]/100;
        }
        if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {//闲对
            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
            CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.xianDuiValue integerValue];
            [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
            CGFloat yjValue = yj*[self.curSelectCustomer.xianDuiValue integerValue];
            [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
            CGFloat payValue = (odds-yj)*[self.curSelectCustomer.xianDuiValue integerValue];
            self.payKillResultValue+= payValue;
        }else {
            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
            [self.fresult_list addObject:self.curSelectCustomer.xianDuiValue];
            [self.fyj_list addObject:[NSNumber numberWithDouble:0]];
            
            self.payKillResultValue-= [self.curSelectCustomer.xianDuiValue floatValue];
        }
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    
    if ([self.curSelectCustomer.heValue integerValue]!=0) {//和
        NSString *heRealValue = [NSString stringWithFormat:@"和:%@",self.curSelectCustomer.heValue];
        [self.payKillResultInfo_list addObject:heRealValue];
        [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        [self.fxz_money_list addObject:self.curSelectCustomer.heValue];
        [self.fxz_name_list addObject:@"和"];
        //赔率
        CGFloat odds = 0;
        CGFloat yj = 0;
        NSArray *xz_array = self.curXz_setting;
        if (xz_array.count>4) {
            odds = [xz_array[4][@"fpl"] floatValue];
            yj = [xz_array[4][@"fyj"] floatValue]/100;
        }
        if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
            CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.heValue integerValue];
            [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
            CGFloat yjValue = yj*[self.curSelectCustomer.heValue integerValue];
            [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
            CGFloat payValue = (odds-yj)*[self.curSelectCustomer.heValue integerValue];
            self.payKillResultValue+= payValue;
        }else {
            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
            [self.fresult_list addObject:self.curSelectCustomer.heValue];
            [self.fyj_list addObject:[NSNumber numberWithDouble:0]];
            self.payKillResultValue-= [self.curSelectCustomer.heValue floatValue];
        }
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    
    if ([self.curSelectCustomer.baoxianValue integerValue]!=0) {//保险
        NSString *baoxianRealValue = [NSString stringWithFormat:@"保险:%@",self.curSelectCustomer.baoxianValue];
        [self.payKillResultInfo_list addObject:baoxianRealValue];
        [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        [self.fxz_money_list addObject:self.curSelectCustomer.baoxianValue];
        [self.fxz_name_list addObject:@"保险"];
        CGFloat resultValue = [self.curSelectCustomer.baoxianValue integerValue];
        [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
        [self.fyj_list addObject:[NSNumber numberWithDouble:0]];
        if (resultValue>0) {
            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
            self.payKillResultValue+= resultValue;
        }else{
            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
            self.payKillResultValue-= resultValue;
        }
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    self.curSelectCustomer.resultString = [self.payKillResultInfo_list componentsJoinedByString:@","];
    self.curSelectCustomer.resultValue = self.payKillResultValue;
    self.curSelectCustomer.kaiPaiResult = self.result_string;
}

#pragma mark - 提交客人输赢记录和台桌流水记录
- (void)commitCustomerRecordWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                                @"access_token":self.curLoginToken,
                                @"ftbrec_id":self.cp_tableIDString,//桌子ID
                                @"fxmh_list":self.fxmh_list,//客人洗码号
                                @"fxz_cmtype_list":self.fxz_cmtype_list,//客人下注的筹码类型
                                @"fxz_money_list":self.fxz_money_list,//客人下注的本金
                                @"fxz_name_list":self.fxz_name_list,//下注名称，如庄、闲、庄对子…
                                @"fsy_list":self.fsy_list,//输赢
                                @"fresult_list":self.fresult_list,//总码
                                @"fyj_list":self.fyj_list,//佣金
                                @"fhardlist_list":[NSArray array],//实付筹码，硬件ID值数组
                                @"fdashui_list":[NSArray array],//打水筹码，硬件ID值数组
                                @"fzhaohui_list":[NSArray array]//找回筹码
                            };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_tjsyjl",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
        }
        block(suc, msg,error);
        
    }];
}

@end
