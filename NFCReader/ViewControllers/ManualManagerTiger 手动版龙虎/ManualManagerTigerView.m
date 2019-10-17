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
#import "JhPageItemModel.h"

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
@property (nonatomic, strong) UIView *dragonBorderV;
@property (nonatomic, strong) UIButton *dragonInfoBtn;
@property (nonatomic, strong) UILabel *dragonInfoLab;
@property (nonatomic, strong) UIView *tigerBorderV;
@property (nonatomic, strong) UIButton *tigerInfoBtn;
@property (nonatomic, strong) UILabel *tigerInfoLab;
@property (nonatomic, strong) UIView *heBorderV;
@property (nonatomic, strong) UIButton *heInfoBtn;
@property (nonatomic, strong) UILabel *heInfoLab;

//结算台
@property (nonatomic, strong) UIImageView *settlementImgV;
@property (nonatomic, strong) UILabel *settlementLab;
@property (nonatomic, strong) UIView *settlementV;
@property (nonatomic, strong) UIButton *dragonBtn;
@property (nonatomic, strong) UIButton *tigerBtn;
@property (nonatomic, strong) UIButton *heBtn;
@property (nonatomic, strong) UIButton *setmentOKBtn;
@property (nonatomic, strong) NSString *result_string;

//客人信息
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, assign) CGRect ViewFrame;
@property (nonatomic, strong) UICollectionViewLayout *layout;
@property (nonatomic, strong) NSMutableArray *customerInfoList;
@property (nonatomic, assign) BOOL isBeganMove;
@property (nonatomic, assign) int dragonCount;//龙赢次数
@property (nonatomic, assign) int tigerCount;//虎赢次数
@property (nonatomic, assign) int heCount;//和赢次数
@property (nonatomic, assign) BOOL isEntryBox;

//提交参数
@property (nonatomic, strong) NSString *curLoginToken;
@property (nonatomic, strong) NSString *curTableID;
@property (nonatomic, strong) NSString *curSerialnumber;
@property (nonatomic, strong) NSArray *curXz_setting;

@property (nonatomic,strong) NSMutableArray *fxz_cmtype_list;

@end

@implementation ManualManagerTigerView

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
        [self.customerInfoList addObject:[self modelCustomerInfo]];
        [self _setup];
        [self luzhuList];
    }
    return self;
}

- (void)luzhuList{
    for (int i=0; i<100; i++) {
        JhPageItemModel *model = [[JhPageItemModel alloc]init];
        model.img = @"";
        model.text = @"";
        model.luzhuType = 0;
        model.colorString = @"#ffffff";
        [self.luzhuInfoList addObject:model];
    }
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
        CGRect Collectionframe =CGRectMake(0,285, kScreenWidth, self.frame.size.height-285-10);
        _collectionView = [[UICollectionView alloc] initWithFrame:Collectionframe collectionViewLayout:self.layout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TigerCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TigerAddMoreCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:moreReuseIdentifier];
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
        CGRect femwe =  CGRectMake(0, 0, kScreenWidth-30-156-249, 231);
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
    self.settlementLab.textAlignment = NSTextAlignmentCenter;
    self.settlementLab.text = @"结算台Settlement Desk";
    [self addSubview:self.settlementLab];
    [self.settlementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_top).offset(3);
        make.left.equalTo(self.settlementImgV.mas_left).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_offset(249);
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
    self.tableInfoLab.textAlignment = NSTextAlignmentCenter;
    self.tableInfoLab.text = @"台桌信息Table information";
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
    self.puciLab.text = @"铺次:0";
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
    self.dragonInfoLab.text = @"0";
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
    self.luzhuInfoLab.textAlignment = NSTextAlignmentCenter;
    self.luzhuInfoLab.text = @"露珠信息Dew information";
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
    [self luzhuList];
    [self.solidView fellLuzhuListWithDataList:self.luzhuInfoList];
    self.dragonCount=0;//龙赢次数
    self.tigerCount=0;//虎赢次数
    self.heCount=0;//和赢次数
    self.dragonInfoLab.text = [NSString stringWithFormat:@"%d",self.dragonCount];
    self.tigerInfoLab.text = [NSString stringWithFormat:@"%d",self.tigerCount];
    self.heInfoLab.text = [NSString stringWithFormat:@"%d",self.heCount];
}

- (void)showWaitingView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.layer.zPosition = 100;
}

- (void)hideWaitingView {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)resultAction:(UIButton *)btn{
    if (btn.tag==1) {//龙
        [self.dragonBtn setSelected:YES];
        [self.tigerBtn setSelected:NO];
        [self.heBtn setSelected:NO];
        self.result_string = @"龙";
    }else if (btn.tag==2){//虎
        [self.dragonBtn setSelected:NO];
        [self.tigerBtn setSelected:YES];
        [self.heBtn setSelected:NO];
        self.result_string = @"虎";
    }else if (btn.tag==3){//和
        [self.dragonBtn setSelected:NO];
        [self.tigerBtn setSelected:NO];
        [self.heBtn setSelected:YES];
        self.result_string = @"和";
    }
}

- (void)resultEntryAction:(UIButton *)btn{
    if (self.puciCount != self.prePuciCount) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    if (self.result_string.length==0) {
        [[EPToast makeText:@"请选择开牌结果"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    [self showWaitingView];
    [self commitCustomerRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            [self getLUzhuINfo];
            [[EPToast makeText:@"提交开牌结果成功" WithError:NO]showWithType:ShortTime];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
            [self resertResultBtnStatus];
            self.prePuciCount +=1;
            [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *customerInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                customerInfo.zhuangValue = @"";
                customerInfo.zhuangDuiValue = @"";
                customerInfo.heValue = @"";
                customerInfo.cashType = 1;
            }];
            [self.collectionView reloadData];
        }else{
            [self hideWaitingView];
            [[EPToast makeText:@"提交开牌结果失败" WithError:YES]showWithType:ShortTime];
            //响警告声音
            [EPSound playWithSoundName:@"wram_sound"];
            
        }
    }];
}

- (void)resertResultBtnStatus{
    [self.dragonBtn setSelected:NO];
    [self.tigerBtn setSelected:NO];
    [self.heBtn setSelected:NO];
    self.result_string = @"";
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
        TigerAddMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreReuseIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        TigerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
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
        cell.number_lab.text = number_s;
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
        if (self.isEntryBox) {
            return;
        }
        self.isEntryBox = YES;
        CustomerInfo *info = self.customerInfoList[indexPath.row];
        TigerEditInfoView *custerEntryInfoV = [[[NSBundle mainBundle]loadNibNamed:@"TigerEditInfoView" owner:nil options:nil]lastObject];
        custerEntryInfoV.frame = self.bounds;
        [custerEntryInfoV editLoginInfoWithLoginID:self.curLoginToken];
        custerEntryInfoV.editTapCustomer = ^(CustomerInfo * _Nonnull curCustomer, BOOL hasEntry) {
            self.isEntryBox = NO;
            if (hasEntry) {
                [self.customerInfoList replaceObjectAtIndex:indexPath.row withObject:curCustomer];
                [collectionView reloadData];
            }
        };
        [custerEntryInfoV editCurCustomerWithCustomerInfo:info];
        [[MJPopTool sharedInstance] popView:custerEntryInfoV animated:YES];
    }
}

- (CustomerInfo *)modelCustomerInfo{
    CustomerInfo *customer = [[CustomerInfo alloc]init];
    customer.headUrlString = @"addIcon_headImg";
    customer.washNumberValue = @"";
    customer.zhuangValue = @"";
    customer.zhuangDuiValue = @"";
    customer.heValue = @"";
    customer.cashType = 1;
    customer.headbgImgName = @"customer_VIP_bg";
    return customer;
}

- (void)transLoginInfoWithLoginID:(NSString *)loginID TableID:(NSString *)tableID Serialnumber:(NSString *)serialnumber Peilv:(NSArray *)xz_setting TableName:(NSString *)tableName{
    NSNumber *xueciNumber = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@_Xueci",tableID]];
    if (xueciNumber.intValue!=0) {
        self.xueciCount = xueciNumber.intValue;
    }
    self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
    self.curLoginToken = loginID;
    self.curTableID = tableID;
    self.curSerialnumber = serialnumber;
    self.curXz_setting = xz_setting;
    self.stableIDLab.text = [NSString stringWithFormat:@"台桌ID:%@",tableName];
    
    [self getLUzhuINfo];
}

- (void)getLUzhuINfo{
    [self getLuzhuWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.solidView fellLuzhuListWithDataList:self.luzhuInfoList];
                self.dragonInfoLab.text = [NSString stringWithFormat:@"%d",self.dragonCount];
                self.tigerInfoLab.text = [NSString stringWithFormat:@"%d",self.tigerCount];
                self.heInfoLab.text = [NSString stringWithFormat:@"%d",self.heCount];
            });
        }
    }];
}

#pragma mark - 获取露珠
- (void)getLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"ftable_id":self.curTableID,//桌子ID
                             @"rjdate":[NRCommand getCurrentDate],//日期
                             @"fxueci":[NSString stringWithFormat:@"%d",self.xueciCount]//靴次
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"tablerec_luzhu",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_Public_ListWithParamter:Realparam block:^(NSArray *list, NSString *msg, EPSreviceError error, BOOL suc) {
        [self hideWaitingView];
        if (suc) {
            self.realLuzhuList = list;
            NSDictionary *lastLuzhuDict = list.lastObject;
            self.puciCount = [[NSString stringWithFormat:@"%@",lastLuzhuDict[@"fpuci"]]intValue];
            self.prePuciCount = self.puciCount+1;
            self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
            NSMutableArray *luzhuList = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(NSDictionary *luzhiDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *resultS =  luzhiDict[@"fkpresult"];
                NSString *text = @"";
                NSString *img = @"";
                if ([resultS isEqualToString:@"龙"]) {
                    img = @"1";
                    text = @"龙";
                    JhPageItemModel *model = [[JhPageItemModel alloc]init];
                    model.img = img;
                    model.text = text;
                    model.colorString = @"#ffffff";
                    model.luzhuType = 1;
                    [luzhuList addObject:model];
                    self.dragonCount +=1;
                }else if ([resultS isEqualToString:@"虎"]){
                    img = @"7";
                    text = @"虎";
                    JhPageItemModel *model = [[JhPageItemModel alloc]init];
                    model.img = img;
                    model.text = text;
                    model.colorString = @"#ffffff";
                    model.luzhuType = 1;
                    [luzhuList addObject:model];
                    self.tigerCount +=1;
                }else if ([resultS isEqualToString:@"和"]){
                    img = @"0";
                    text = @"和";
                    JhPageItemModel *model = [[JhPageItemModel alloc]init];
                    model.img = img;
                    model.text = text;
                    model.luzhuType = 1;
                    model.colorString = @"#ffffff";
                    [luzhuList addObject:model];
                    self.heCount +=1;
                }
            }];
            
            for (int i=(int)list.count; i<100; i++) {
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

#pragma mark - 提交客人输赢记录和台桌流水记录
- (void)commitCustomerRecordWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    //洗码号
    NSMutableArray *fxmh_list = [NSMutableArray array];
    //筹码类型
    self.fxz_cmtype_list = [NSMutableArray array];
    //下注本金
    NSMutableArray *fxz_money_list = [NSMutableArray array];
    //下注名称
    NSMutableArray *fxz_name_list = [NSMutableArray array];
    //输赢
    NSMutableArray *fsy_list = [NSMutableArray array];
    //总码
    NSMutableArray *fresult_list = [NSMutableArray array];
    //佣金
    NSMutableArray *fyj_list = [NSMutableArray array];
    
    [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *curCustomer, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([curCustomer.zhuangValue integerValue]==0&&[curCustomer.zhuangDuiValue integerValue]==0&&[curCustomer.heValue integerValue]==0&&[[curCustomer.washNumberValue NullToBlankString]length]==0) {
        }else{
            //龙
            if ([curCustomer.zhuangValue integerValue]!=0) {
                [fyj_list addObject:@"0"];
                if ([[curCustomer.washNumberValue NullToBlankString]length]==0) {
                    [fxmh_list addObject:@" "];
                }else{
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                }
                [fxz_money_list addObject:curCustomer.zhuangValue];
                [fxz_name_list addObject:@"龙"];
                //赔率
                CGFloat odds = 0;
                CGFloat yj = 0;
                NSArray *xz_array = self.curXz_setting;
                if (xz_array.count>0) {
                    odds = [xz_array[0][@"fpl"] floatValue];
                    yj = [xz_array[0][@"fyj"] floatValue];
                }
                if ([self.result_string isEqualToString:@"龙"]) {
                    [fsy_list addObject:[NSNumber numberWithInt:1]];
                    CGFloat resultValue = (1+odds-yj)*[curCustomer.zhuangValue integerValue];
                    [fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
                }else if ([self.result_string isEqualToString:@"虎"]){
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:curCustomer.zhuangValue];
                }else{//和
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    CGFloat resultValue = 0.5*[curCustomer.zhuangValue integerValue];
                    [fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
                }
                [self fengzhuangChipTypeWith:curCustomer];
            }
            if ([curCustomer.zhuangDuiValue integerValue]!=0){
                [fyj_list addObject:@"0"];
                if ([[curCustomer.washNumberValue NullToBlankString]length]==0) {
                    [fxmh_list addObject:@" "];
                }else{
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                }
                [fxz_money_list addObject:curCustomer.zhuangDuiValue];
                [fxz_name_list addObject:@"虎"];
                //赔率
                CGFloat odds = 0;
                CGFloat yj = 0;
                NSArray *xz_array = self.curXz_setting;
                if (xz_array.count>1) {
                    odds = [xz_array[1][@"fpl"] floatValue];
                    yj = [xz_array[1][@"fyj"] floatValue];
                }
                if ([self.result_string isEqualToString:@"龙"]) {
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:curCustomer.zhuangDuiValue];
                }else if ([self.result_string isEqualToString:@"虎"]){
                    [fsy_list addObject:[NSNumber numberWithInt:1]];
                    CGFloat resultValue = (1+odds-yj)*[curCustomer.zhuangDuiValue integerValue];
                    [fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
                }else{
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    CGFloat resultValue = 0.5*[curCustomer.zhuangDuiValue integerValue];
                    [fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
                }
                [self fengzhuangChipTypeWith:curCustomer];
            }
            if([curCustomer.heValue integerValue]!=0){
                [fyj_list addObject:@"0"];
                if ([[curCustomer.washNumberValue NullToBlankString]length]==0) {
                    [fxmh_list addObject:@" "];
                }else{
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                }
                [fxz_money_list addObject:curCustomer.heValue];
                [fxz_name_list addObject:@"和"];
                //赔率
                CGFloat odds = 0;
                CGFloat yj = 0;
                NSArray *xz_array = self.curXz_setting;
                if (xz_array.count>2) {
                    odds = [xz_array[2][@"fpl"] floatValue];
                    yj = [xz_array[2][@"fyj"] floatValue];
                }
                if ([self.result_string isEqualToString:@"龙"]) {
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:curCustomer.heValue];
                }else if ([self.result_string isEqualToString:@"虎"]){
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:curCustomer.heValue];
                }else{
                    [fsy_list addObject:[NSNumber numberWithInt:1]];
                    CGFloat resultValue = (1+odds-yj)*[curCustomer.heValue integerValue];
                    [fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
                }
                [self fengzhuangChipTypeWith:curCustomer];
            }
        }
    }];
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"ftable_id":self.curTableID,//桌子ID
                             @"fpcls":self.curSerialnumber,//铺次流水号，长度不超过20位，要求全局唯一
                             @"fkpresult":self.result_string,//开牌结果
                             @"frjdate":[NRCommand getCurrentDate],//日结日期
                             @"fxueci":[NSString stringWithFormat:@"%d",self.xueciCount],//靴次
                             @"fpuci":[NSString stringWithFormat:@"%d",self.puciCount],//铺次
                             @"fxmh_list":fxmh_list,//客人洗码号
                             @"fxz_cmtype_list":self.fxz_cmtype_list,//客人下注的筹码类型
                             @"fxz_money_list":fxz_money_list,//客人下注的本金
                             @"fxz_name_list":fxz_name_list,//下注名称，如庄、闲、庄对子…
                             @"fsy_list":fsy_list,//输赢
                             @"fresult_list":fresult_list,//总码
                             @"fyj_list":fyj_list,//佣金
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
