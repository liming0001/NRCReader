//
//  ManualManagerCow.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "ManualManagerCow.h"
#import "SFLabel.h"
#import "JhPageItemView.h"
#import "CowCollectionViewCell.h"
#import "CowAddMoreCell.h"
#import "CustomerInfo.h"
#import "EPPopView.h"
#import "EPToast.h"
#import "CustomerEntryInfoCowView.h"
#import "JhPageItemModel.h"

static NSString * const reuseIdentifier = @"CustomerCell";
static NSString * const moreReuseIdentifier = @"MoreCustomerCell";

@interface ManualManagerCow ()<UICollectionViewDelegate,UICollectionViewDataSource>

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

//结算台
@property (nonatomic, strong) UIImageView *settlementImgV;
@property (nonatomic, strong) UILabel *settlementLab;
@property (nonatomic, strong) UIView *settlementV;
@property (nonatomic, strong) UIImageView *cowIcon;
@property (nonatomic, strong) UIButton *setmentOKBtn;

//客人信息
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, assign) CGRect ViewFrame;
@property (nonatomic, strong) UICollectionViewLayout *layout;
@property (nonatomic, strong) NSMutableArray *customerInfoList;
@property (nonatomic, strong) UILabel *noDataInfoLab;
@property (nonatomic, assign) BOOL isBeganMove;
@property (nonatomic, assign) BOOL isEntryBox;

//提交参数
@property (nonatomic, strong) NSString *curLoginToken;
@property (nonatomic, strong) NSString *curTableID;
@property (nonatomic, strong) NSString *curSerialnumber;
@property (nonatomic, strong) NSString *result_string;

@end

@implementation ManualManagerCow

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
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CowCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CowAddMoreCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:moreReuseIdentifier];
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
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_offset(249);
    }];
    
    self.settlementLab = [UILabel new];
    self.settlementLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.settlementLab.font = [UIFont systemFontOfSize:12];
    self.settlementLab.text = @"结算台Settlement Desk";
    self.settlementLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.settlementLab];
    [self.settlementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settlementImgV.mas_top).offset(5);
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
    
    self.cowIcon = [UIImageView new];
    self.cowIcon.image = [UIImage imageNamed:@"结算台-卡通牛"];
    [self.settlementV addSubview:self.cowIcon];
    [self.cowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.setmentOKBtn.mas_top).offset(-15);
        make.centerX.equalTo(self.settlementV).offset(-15);
        make.height.mas_equalTo(154);
        make.width.mas_offset(176);
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
    self.stableIDLab.text = @"台桌ID:VIP0018";
    self.stableIDLab.layer.cornerRadius = 5;
    self.stableIDLab.backgroundColor = [UIColor colorWithHexString:@"#201f24"];
    [self.tableInfoV addSubview:self.stableIDLab];
    [self.stableIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableInfoV).offset(20);
        make.left.equalTo(self.tableInfoV).offset(15);
    }];
    
    self.xueciLab = [UILabel new];
    self.xueciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xueciLab.font = [UIFont systemFontOfSize:10];
    self.xueciLab.text = @"靴次:1";
    [self.tableInfoV addSubview:self.xueciLab];
    [self.xueciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stableIDLab.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.puciLab = [UILabel new];
    self.puciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.puciLab.font = [UIFont systemFontOfSize:10];
    self.puciLab.text = @"铺次:0";
    [self.tableInfoV addSubview:self.puciLab];
    [self.puciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(5);
        make.left.equalTo(self.tableInfoV).offset(20);
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
    self.solidView.collectionView.scrollEnabled = NO;
    
    self.noDataInfoLab = [UILabel new];
    self.noDataInfoLab.textColor = [UIColor colorWithHexString:@"#7b7b7b"];
    self.noDataInfoLab.font = [UIFont systemFontOfSize:23];
    self.noDataInfoLab.text = @"此对局无露珠信息";
    [self.luzhuCollectionView addSubview:self.noDataInfoLab];
    [self.noDataInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.center.equalTo(self.luzhuCollectionView);
    }];
    
    [self addSubview:self.collectionView];
}

- (void)showWaitingView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.layer.zPosition = 100;
}

- (void)hideWaitingView {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)resultEntryAction:(UIButton *)btn{
    if (self.puciCount!=self.prePuciCount) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        return;
    }
    [self showWaitingView];
    [self commitCustomerRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self hideWaitingView];
        if (success) {
            [[EPToast makeText:@"提交开牌结果成功" WithError:NO]showWithType:ShortTime];
            //响警告声音
            [EPSound playWithSoundName:@"succeed_sound"];
            self.prePuciCount +=1;
            [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *customerInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                customerInfo.zhuangValue = @"";
                customerInfo.zhuangDuiValue = @"";
                customerInfo.cashType = 0;
            }];
            [self.collectionView reloadData];
        }else{
            [[EPToast makeText:@"提交开牌结果失败" WithError:YES]showWithType:ShortTime];
            //响警告声音
            [EPSound playWithSoundName:@"wram_sound"];
        }
    }];
}

- (void)transLoginInfoWithLoginID:(NSString *)loginID TableID:(NSString *)tableID Serialnumber:(NSString *)serialnumber{
    self.curLoginToken = loginID;
    self.curTableID = tableID;
    self.curSerialnumber = serialnumber;
    self.stableIDLab.text = [NSString stringWithFormat:@"台桌ID:%@",self.curTableID];
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
        CowAddMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreReuseIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        CowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
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
        CustomerEntryInfoCowView *custerEntryInfoV = [[[NSBundle mainBundle]loadNibNamed:@"CustomerEntryInfoCowView" owner:nil options:nil]lastObject];
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

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //处理数据（删除之前的位置数据，插入到新的位置）
    CustomerInfo *selectModel = self.customerInfoList[sourceIndexPath.item];
    [self.customerInfoList removeObjectAtIndex:sourceIndexPath.item];
    [self.customerInfoList insertObject:selectModel atIndex:destinationIndexPath.item];
    [collectionView reloadData];
    //此处可以根据需要，上传给后台目前数据的顺序
}

- (CustomerInfo *)modelCustomerInfo{
    CustomerInfo *customer = [[CustomerInfo alloc]init];
    customer.headUrlString = @"addIcon_headImg";
    customer.washNumberValue = @"";
    customer.zhuangValue = @"";
    customer.zhuangDuiValue = @"";
    customer.cashType = 0;
    customer.headbgImgName = @"customer_VIP_bg";
    return customer;
}

#pragma mark - 提交客人输赢记录和台桌流水记录
- (void)commitCustomerRecordWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    //洗码号
    NSMutableArray *fxmh_list = [NSMutableArray array];
    //筹码类型
    NSMutableArray *fxz_cmtype_list = [NSMutableArray array];
    //筹码名称
    NSMutableArray *fhardlist_list = [NSMutableArray array];
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
        if ([curCustomer.zhuangValue integerValue]==0&&[curCustomer.zhuangDuiValue integerValue]==0) {
            if ([[curCustomer.washNumberValue NullToBlankString]length]==0) {
                [fxmh_list addObject:@" "];
            }else{
                [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
            }
            self.result_string = @"赢";
            [fxmh_list addObject:@"0"];
            [fxz_name_list addObject:@"赢"];
            [fsy_list addObject:@"1"];
            [fresult_list addObject:@"0"];
        }else{
            NSInteger winRealResultValue = [curCustomer.zhuangValue integerValue]- [curCustomer.zhuangDuiValue integerValue];
            NSInteger loseRealResultValue = [curCustomer.zhuangDuiValue integerValue]- [curCustomer.zhuangValue integerValue];
            if (winRealResultValue > 0) {
                [fyj_list addObject:@"0"];
                if ([[curCustomer.washNumberValue NullToBlankString]length]==0) {
                    [fxmh_list addObject:@" "];
                }else{
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                }
                [fxz_money_list addObject:[NSNumber numberWithInteger:winRealResultValue]];
                [fxz_name_list addObject:@"赢"];
                self.result_string = @"赢";
                [fsy_list addObject:[NSNumber numberWithInt:1]];
                [fresult_list addObject:[NSNumber numberWithInteger:winRealResultValue]];
                if (curCustomer.cashType==0) {//美金筹码
                    [fxz_cmtype_list addObject:[NSNumber numberWithInt:7]];
                    [fhardlist_list addObject:@"美金筹码"];
                }else if (curCustomer.cashType==1){//美金现金
                    [fxz_cmtype_list addObject:[NSNumber numberWithInt:7]];
                    [fhardlist_list addObject:@"美金现金"];
                }else if (curCustomer.cashType==2){//人民币筹码
                    [fxz_cmtype_list addObject:[NSNumber numberWithInt:6]];
                    [fhardlist_list addObject:@"人民币筹码"];
                }else if (curCustomer.cashType==3){//人民币现金
                    [fxz_cmtype_list addObject:[NSNumber numberWithInt:6]];
                    [fhardlist_list addObject:@"人民币现金"];
                }
                
            }
            if (loseRealResultValue > 0){
                [fyj_list addObject:@"0"];
                if ([[curCustomer.washNumberValue NullToBlankString]length]==0) {
                    [fxmh_list addObject:@" "];
                }else{
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                }
                [fxz_money_list addObject:[NSNumber numberWithInteger:loseRealResultValue]];
                [fxz_name_list addObject:@"输"];
                self.result_string = @"输";
                [fsy_list addObject:[NSNumber numberWithInt:-1]];
                [fresult_list addObject:[NSNumber numberWithInteger:loseRealResultValue]];
                if (curCustomer.cashType==0) {//美金筹码
                    [fxz_cmtype_list addObject:[NSNumber numberWithInt:7]];
                    [fhardlist_list addObject:@"美金筹码"];
                }else if (curCustomer.cashType==1){//美金现金
                    [fxz_cmtype_list addObject:[NSNumber numberWithInt:7]];
                    [fhardlist_list addObject:@"美金现金"];
                }else if (curCustomer.cashType==2){//人民币筹码
                    [fxz_cmtype_list addObject:[NSNumber numberWithInt:6]];
                    [fhardlist_list addObject:@"人民币筹码"];
                }else if (curCustomer.cashType==3){//人民币现金
                    [fxz_cmtype_list addObject:[NSNumber numberWithInt:6]];
                    [fhardlist_list addObject:@"人民币现金"];
                }
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
                             @"fxz_cmtype_list":fxz_cmtype_list,//客人下注的筹码类型
                             @"fxz_money_list":fxz_money_list,//客人下注的本金
                             @"fxz_name_list":fxz_name_list,//下注名称，如庄、闲、庄对子…
                             @"fsy_list":fsy_list,//输赢
                             @"fresult_list":fresult_list,//总码
                             @"fyj_list":fyj_list,//佣金
                             @"fhardlist_list":fhardlist_list,//实付筹码，硬件ID值数组
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
