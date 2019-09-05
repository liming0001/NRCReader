//
//  ManualManagerTigerView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "ManualManagerTigerView.h"
#import "SFLabel.h"
#import "JhPageItemView.h"
#import "TigerCollectionViewCell.h"
#import "TigerAddMoreCell.h"
#import "TigerEditInfoView.h"
#import "CustomerInfo.h"
#import "EPPopView.h"
#import "EPToast.h"

static NSString * const reuseIdentifier = @"CustomerCell";
static NSString * const moreReuseIdentifier = @"MoreCustomerCell";

@interface ManualManagerTigerView ()<UICollectionViewDelegate,UICollectionViewDataSource>

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
@property (nonatomic, strong) UILabel *xueciLab;
@property (nonatomic, strong) UILabel *puciLab;
@property (nonatomic, strong) UIView *dragonBorderV;
@property (nonatomic, strong) UIButton *dragonInfoBtn;
@property (nonatomic, strong) UILabel *dragonInfoLab;
@property (nonatomic, strong) UIView *tigerBorderV;
@property (nonatomic, strong) UIButton *tigerInfoBtn;
@property (nonatomic, strong) UILabel *tigerInfoLab;
@property (nonatomic, strong) UIView *heBorderV;
@property (nonatomic, strong) UIButton *heInfoBtn;
@property (nonatomic, strong) UILabel *heInfoLab;
@property (nonatomic, assign) int xueciCount;//靴次
@property (nonatomic, assign) int puciCount;//铺次

//结算台
@property (nonatomic, strong) UIImageView *settlementImgV;
@property (nonatomic, strong) UILabel *settlementLab;
@property (nonatomic, strong) UIView *settlementV;
@property (nonatomic, strong) UIButton *dragonBtn;
@property (nonatomic, strong) UIButton *tigerBtn;
@property (nonatomic, strong) UIButton *heBtn;
@property (nonatomic, strong) UIButton *setmentOKBtn;

//客人信息
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, assign) CGRect ViewFrame;
@property (nonatomic, strong) UICollectionViewLayout *layout;
@property (nonatomic, strong) NSMutableArray *customerInfoList;

@end

@implementation ManualManagerTigerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.xueciCount = 1;
        self.puciCount = 0;
        self.luzhuInfoList = [NSMutableArray array];
        self.customerInfoList = [NSMutableArray array];
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
        layout.itemSize = CGSizeMake(135, 200);
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
        CGRect Collectionframe =CGRectMake(0,285, kScreenWidth, kScreenHeight-285);
        _collectionView = [[UICollectionView alloc] initWithFrame:Collectionframe collectionViewLayout:self.layout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TigerCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TigerAddMoreCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:moreReuseIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //隐藏滚动条
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
    }
    return _collectionView;
}

-(JhPageItemView *)solidView{
    if (!_solidView) {
        CGRect femwe =  CGRectMake(0, 0, kScreenWidth-30-200-240, 232);
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
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_offset(249);
    }];
    
    self.settlementLab = [UILabel new];
    self.settlementLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.settlementLab.font = [UIFont systemFontOfSize:12];
    self.settlementLab.text = @"结算台Settlement Desk";
    [self addSubview:self.settlementLab];
    [self.settlementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_top).offset(8);
        make.left.equalTo(self.settlementImgV.mas_left).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.settlementV = [UIView new];
    self.settlementV.layer.cornerRadius = 2;
    self.settlementV.backgroundColor = [UIColor colorWithHexString:@"#3e565d"];
    [self addSubview:self.settlementV];
    [self.settlementV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_bottom).offset(0);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(232);
        make.width.mas_offset(249);
    }];
    
    CGFloat setBtn_w = 249-42*2;
    CGFloat setBtn_h = 35;
    self.dragonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dragonBtn setTitleColor:[UIColor colorWithHexString:@"#df4139"] forState:UIControlStateNormal];
    [self.dragonBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.dragonBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dragonBtn setTitle:@"  龙 Dragon" forState:UIControlStateNormal];
    self.dragonBtn.tag = 1;
    [self.dragonBtn setImage:[UIImage imageNamed:@"结算台-龙ICON-未选中"] forState:UIControlStateNormal];
    [self.dragonBtn setImage:[UIImage imageNamed:@"结算台-龙ICON-选中"] forState:UIControlStateSelected];
    [self.dragonBtn setBackgroundImage:[UIImage imageNamed:@"结算台-龙虎和-未选中底色"] forState:UIControlStateNormal];
    [self.dragonBtn setBackgroundImage:[UIImage imageNamed:@"结算台-龙-已选中底色"] forState:UIControlStateSelected];
    [self.dragonBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.dragonBtn];
    [self.dragonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementV).offset(20);
        make.centerX.equalTo(self.settlementV).offset(0);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.tigerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tigerBtn setTitleColor:[UIColor colorWithHexString:@"#1d3edd"] forState:UIControlStateNormal];
    [self.tigerBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.tigerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.tigerBtn setTitle:@"  虎 Tiger" forState:UIControlStateNormal];
    self.tigerBtn.tag = 2;
    [self.tigerBtn setImage:[UIImage imageNamed:@"结算台-虎ICON-未选中"] forState:UIControlStateNormal];
    [self.tigerBtn setImage:[UIImage imageNamed:@"结算台-虎ICON-选中"] forState:UIControlStateSelected];
    [self.tigerBtn setBackgroundImage:[UIImage imageNamed:@"结算台-龙虎和-未选中底色"] forState:UIControlStateNormal];
    [self.tigerBtn setBackgroundImage:[UIImage imageNamed:@"结算台-虎-已选中底色"] forState:UIControlStateSelected];
    [self.tigerBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.tigerBtn];
    [self.tigerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dragonBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.settlementV).offset(0);
        make.height.mas_equalTo(setBtn_h);
        make.width.mas_equalTo(setBtn_w);
    }];
    
    self.heBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#75e65c"] forState:UIControlStateNormal];
    [self.heBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    self.heBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.heBtn setTitle:@"和 Tie" forState:UIControlStateNormal];
    self.heBtn.tag = 3;
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"结算台-龙虎和-未选中底色"] forState:UIControlStateNormal];
    [self.heBtn setBackgroundImage:[UIImage imageNamed:@"结算台-和-已选中底色"] forState:UIControlStateSelected];
    [self.heBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementV addSubview:self.heBtn];
    [self.heBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tigerBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.settlementV).offset(0);
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
        make.top.equalTo(self.heBtn.mas_bottom).offset(23);
        make.left.equalTo(self.settlementV).offset(10);
        make.centerX.equalTo(self.settlementV);
        make.height.mas_equalTo(41);
    }];
    
    //台桌信息
    self.tableInfoImgV = [UIImageView new];
    self.tableInfoImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self addSubview:self.self.tableInfoImgV];
    [self.tableInfoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self.settlementImgV.mas_left).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_offset(156);
    }];
    
    self.tableInfoLab = [UILabel new];
    self.tableInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tableInfoLab.font = [UIFont systemFontOfSize:12];
    self.tableInfoLab.text = @"台桌信息Table information";
    [self addSubview:self.tableInfoLab];
    [self.tableInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoImgV.mas_top).offset(8);
        make.left.equalTo(self.tableInfoImgV.mas_left).offset(5);
        make.height.mas_equalTo(20);
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
    self.stableIDLab.text = @"台桌ID:VIP0018";
    self.stableIDLab.layer.cornerRadius = 5;
    self.stableIDLab.backgroundColor = [UIColor colorWithHexString:@"#201f24"];
    [self.tableInfoV addSubview:self.stableIDLab];
    [self.stableIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoV).offset(3);
        make.left.equalTo(self.tableInfoV).offset(15);
    }];
    
    self.xueciLab = [UILabel new];
    self.xueciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xueciLab.font = [UIFont systemFontOfSize:10];
    self.xueciLab.text = @"靴次:1";
    [self.tableInfoV addSubview:self.xueciLab];
    [self.xueciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stableIDLab.mas_bottom).offset(3);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.puciLab = [UILabel new];
    self.puciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.puciLab.font = [UIFont systemFontOfSize:10];
    self.puciLab.text = @"铺次:10";
    [self.tableInfoV addSubview:self.puciLab];
    [self.puciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(3);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.dragonBorderV = [UIView new];
    self.dragonBorderV.layer.cornerRadius = 2;
    self.dragonBorderV.backgroundColor = [UIColor clearColor];
    self.dragonBorderV.layer.borderWidth = 0.5;
    self.dragonBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.dragonBorderV];
    [self.dragonBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoV).offset(56);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.height.mas_equalTo(82);
        make.width.mas_equalTo(55);
    }];
    
    self.dragonInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dragonInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.dragonInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.dragonInfoBtn.titleLabel.numberOfLines = 0;
    self.dragonInfoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.dragonInfoBtn setTitle:[NSString stringWithFormat:@"龙\n%@",[EPStr getStr:kEPDragon note:@"龙"]] forState:UIControlStateNormal];
    [self.dragonInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-龙Dragonbg"] forState:UIControlStateNormal];
    [self.dragonInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-龙Dragonbg"] forState:UIControlStateHighlighted];
    [self.dragonBorderV addSubview:self.dragonInfoBtn];
    [self.dragonInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.dragonBorderV).offset(0);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(52);
    }];
    
    self.dragonInfoLab = [UILabel new];
    self.dragonInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.dragonInfoLab.font = [UIFont systemFontOfSize:12];
    self.dragonInfoLab.text = @"6";
    self.dragonInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.dragonBorderV addSubview:self.dragonInfoLab];
    [self.dragonInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dragonInfoBtn.mas_bottom).offset(0);
        make.centerX.equalTo(self.dragonBorderV);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(30);
    }];
    
    self.tigerBorderV = [UIView new];
    self.tigerBorderV.layer.cornerRadius = 2;
    self.tigerBorderV.backgroundColor = [UIColor clearColor];
    self.tigerBorderV.layer.borderWidth = 0.5;
    self.tigerBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.tigerBorderV];
    [self.tigerBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoV).offset(56);
        make.left.equalTo(self.dragonBorderV.mas_right).offset(6);
        make.height.mas_equalTo(82);
        make.width.mas_equalTo(55);
    }];
    
    self.tigerInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tigerInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.tigerInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.tigerInfoBtn.titleLabel.numberOfLines = 0;
    self.tigerInfoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.tigerInfoBtn setTitle:[NSString stringWithFormat:@"虎\n%@",[EPStr getStr:kEPTiger note:@"虎"]] forState:UIControlStateNormal];
    [self.tigerInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-虎_bg"] forState:UIControlStateNormal];
    [self.tigerInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-虎_bg"] forState:UIControlStateHighlighted];
    [self.tigerBorderV addSubview:self.tigerInfoBtn];
    [self.tigerInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.tigerBorderV).offset(0);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(52);
    }];
    self.tigerInfoLab = [UILabel new];
    self.tigerInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tigerInfoLab.font = [UIFont systemFontOfSize:12];
    self.tigerInfoLab.text = @"0";
    self.tigerInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.tigerBorderV addSubview:self.tigerInfoLab];
    [self.tigerInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tigerInfoBtn.mas_bottom).offset(0);
        make.centerX.equalTo(self.tigerBorderV);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(30);
    }];
    
    self.heBorderV = [UIView new];
    self.heBorderV.layer.cornerRadius = 2;
    self.heBorderV.backgroundColor = [UIColor clearColor];
    self.heBorderV.layer.borderWidth = 0.5;
    self.heBorderV.layer.borderColor = [UIColor colorWithHexString:@"#587176"].CGColor;
    [self.tableInfoV addSubview:self.heBorderV];
    [self.heBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableInfoV).offset(-6);
        make.left.equalTo(self.tableInfoV).offset(20);
        make.top.equalTo(self.tigerBorderV.mas_bottom).offset(7);
        make.centerX.equalTo(self.tableInfoV).offset(0);
    }];
    self.heInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heInfoBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.heInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.heInfoBtn.titleLabel.numberOfLines = 0;
    self.heInfoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.heInfoBtn setTitle:[NSString stringWithFormat:@"和\n%@",[EPStr getStr:kEPTigerHe note:@"和"]] forState:UIControlStateNormal];
    [self.heInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-和tie_bg"] forState:UIControlStateNormal];
    [self.heInfoBtn setBackgroundImage:[UIImage imageNamed:@"台桌信息-和tie_bg"] forState:UIControlStateHighlighted];
    [self.heBorderV addSubview:self.heInfoBtn];
    [self.heInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.equalTo(self.heBorderV).offset(0);
        make.height.mas_equalTo(52);
    }];
    
    self.heInfoLab = [UILabel new];
    self.heInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.heInfoLab.font = [UIFont systemFontOfSize:12];
    self.heInfoLab.text = @"0";
    self.heInfoLab.textAlignment = NSTextAlignmentCenter;
    [self.heBorderV addSubview:self.heInfoLab];
    [self.heInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heInfoBtn.mas_bottom).offset(0);
        make.centerX.equalTo(self.heBorderV);
        make.width.mas_equalTo(55);
        make.bottom.equalTo(self.heBorderV);
    }];
    
    //露珠信息
    self.luzhuImgV = [UIImageView new];
    self.luzhuImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self addSubview:self.self.luzhuImgV];
    [self.luzhuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self.tableInfoImgV.mas_left).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_offset(kScreenWidth-30-156-249);
    }];
    
    self.luzhuInfoLab = [UILabel new];
    self.luzhuInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.luzhuInfoLab.font = [UIFont systemFontOfSize:14];
    self.luzhuInfoLab.text = @"露珠信息Dew information";
    [self addSubview:self.luzhuInfoLab];
    [self.luzhuInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luzhuImgV.mas_top).offset(8);
        make.left.equalTo(self.luzhuImgV.mas_left).offset(10);
        make.height.mas_equalTo(20);
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
    
    [self addSubview:self.collectionView];
}

- (void)resultAction:(UIButton *)btn{
    
}

- (void)resultEntryAction:(UIButton *)btn{
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.customerInfoList.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==self.customerInfoList.count) {
        TigerAddMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreReuseIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        TigerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.cellIndex = indexPath.row;
        [cell fellCellWithCustomerInfo:self.customerInfoList[indexPath.row]];
        @weakify(self);
        cell.deleteCustomer = ^(NSInteger curCellIndex) {
            @strongify(self);
            [self.customerInfoList removeObjectAtIndex:curCellIndex];
            [collectionView reloadData];
        };
        return cell;
    }
}

#pragma mark - 点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.customerInfoList.count) {
        [self.customerInfoList addObject:[self modelCustomerInfo]];
        [collectionView reloadData];
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.customerInfoList.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }else{
        TigerEditInfoView *custerEntryInfoV = [[[NSBundle mainBundle]loadNibNamed:@"TigerEditInfoView" owner:nil options:nil]lastObject];
        custerEntryInfoV.frame = self.bounds;
        custerEntryInfoV.editTapCustomer = ^(CustomerInfo * _Nonnull curCustomer) {
            [self.customerInfoList replaceObjectAtIndex:indexPath.row withObject:curCustomer];
            [collectionView reloadData];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:custerEntryInfoV];
    }
}

- (CustomerInfo *)modelCustomerInfo{
    CustomerInfo *customer = [[CustomerInfo alloc]init];
    customer.headUrlString = @"addIcon_headImg";
    customer.washNumberValue = @"";
    customer.zhuangValue = @"";
    customer.zhuangDuiValue = @"";
    customer.heValue = @"";
    customer.cashType = 0;
    customer.headbgImgName = @"customer_VIP_bg";
    return customer;
}

@end
