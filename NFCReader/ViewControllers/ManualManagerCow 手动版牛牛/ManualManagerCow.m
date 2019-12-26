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
#import "EPPayKillInfoView.h"

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
@property (nonatomic, strong) NSString *cp_tableRijieDate;
@property (nonatomic, strong) NSString *cp_tableIDString;
@property (nonatomic, strong) CustomerInfo *curSelectCustomer;

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

@implementation ManualManagerCow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.xueciCount = 1;
        self.puciCount = 0;
        self.luzhuInfoList = [NSMutableArray array];
        self.customerInfoList = [NSMutableArray array];
        [self.customerInfoList addObject:[self modelCustomerInfo]];
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
        CGRect femwe =  CGRectMake(0, 0, kScreenWidth-30-156, 232);
        JhPageItemView *view =  [[JhPageItemView alloc]initWithFrame:femwe];
        view.backgroundColor = [UIColor whiteColor];
        self.solidView = view;
    }
    return _solidView;
}

- (void)_setup{
    self.backgroundColor = [UIColor clearColor];
    //台桌信息
    self.tableInfoImgV = [UIImageView new];
    self.tableInfoImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self addSubview:self.self.tableInfoImgV];
    [self.tableInfoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-10);
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
        make.top.equalTo(self.tableInfoV).offset(3);
        make.left.equalTo(self.tableInfoV).offset(15);
    }];
    
    self.xueciLab = [UILabel new];
    self.xueciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xueciLab.font = [UIFont systemFontOfSize:10];
    [self.tableInfoV addSubview:self.xueciLab];
    [self.xueciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stableIDLab.mas_bottom).offset(3);
        make.left.equalTo(self.tableInfoV).offset(20);
    }];
    
    self.puciLab = [UILabel new];
    self.puciLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.puciLab.font = [UIFont systemFontOfSize:10];
    [self.tableInfoV addSubview:self.puciLab];
    [self.puciLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xueciLab.mas_bottom).offset(3);
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
        make.width.mas_offset(kScreenWidth-25-156);
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
        make.width.mas_offset(kScreenWidth-25-156);
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

- (void)fellXueCiWithXueCi:(int)curXueci PuCi:(int)curPuCi{
    self.xueciCount = curXueci;
    self.puciCount = curPuCi;
    self.xueciLab.text = [NSString stringWithFormat:@"靴次:%d",self.xueciCount];
    self.puciLab.text = [NSString stringWithFormat:@"铺次:%d",self.puciCount];
}

- (void)transLoginInfoWithLoginID:(NSString *)loginID TableID:(NSString *)tableID Serialnumber:(NSString *)serialnumber Peilv:(NSArray *)xz_setting TableName:(NSString *)tableName RijieData:(NSString *)curRijieDate ResultDict:(NSDictionary *)resultDict{
    self.cp_tableRijieDate = curRijieDate;
    self.curLoginToken = loginID;
    self.curTableID = tableID;
    self.curSerialnumber = serialnumber;
    self.stableIDLab.text = [NSString stringWithFormat:@"台桌ID:%@",tableName];
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
        if (self.puciCount==0) {
            [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
            return;
        }
        if (self.isEntryBox) {
            return;
        }
        self.isEntryBox = YES;
        CustomerInfo *info = self.customerInfoList[indexPath.row];
        CustomerEntryInfoCowView *custerEntryInfoV = [[[NSBundle mainBundle]loadNibNamed:@"CustomerEntryInfoCowView" owner:nil options:nil]lastObject];
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
    customer.cashType = 1;
    customer.headbgImgName = @"customer_VIP_bg";
    return customer;
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

#pragma mark --清除金额
- (void)clearMoney{
//    [self.customerInfoList removeAllObjects];
//    [self.customerInfoList addObject:[self modelCustomerInfo]];
    [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *customerInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        customerInfo.zhuangValue = @"";
        customerInfo.zhuangDuiValue = @"";
        customerInfo.cashType = 1;
    }];
    [self.collectionView reloadData];
}

#pragma mark - 提交开牌结果
- (void)commitkpResultWithBlock:(EPFeedbackWithErrorCodeBlock)block{
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
    
    NSInteger winRealResultValue = [self.curSelectCustomer.zhuangValue integerValue]- [self.curSelectCustomer.zhuangDuiValue integerValue];
    NSInteger loseRealResultValue = [self.curSelectCustomer.zhuangDuiValue integerValue]- [self.curSelectCustomer.zhuangValue integerValue];
    if (winRealResultValue > 0) {
        NSString *longRealValue = [NSString stringWithFormat:@"赢:%ld",winRealResultValue];
        [self.payKillResultInfo_list addObject:longRealValue];
        [self.fyj_list addObject:@"0"];
        [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        [self.fxz_money_list addObject:[NSNumber numberWithInteger:winRealResultValue]];
        [self.fxz_name_list addObject:@"赢"];
        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
        [self.fresult_list addObject:[NSNumber numberWithInteger:2*winRealResultValue]];
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    if (loseRealResultValue > 0){
        NSString *longRealValue = [NSString stringWithFormat:@"输:%ld",winRealResultValue];
        [self.payKillResultInfo_list addObject:longRealValue];
        [self.fyj_list addObject:@"0"];
        [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        [self.fxz_money_list addObject:[NSNumber numberWithInteger:loseRealResultValue]];
        [self.fxz_name_list addObject:@"输"];
        [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
        [self.fresult_list addObject:[NSNumber numberWithInteger:loseRealResultValue]];
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    self.payKillResultValue = winRealResultValue;
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
        block(suc, msg,error);
        
    }];
}

@end
