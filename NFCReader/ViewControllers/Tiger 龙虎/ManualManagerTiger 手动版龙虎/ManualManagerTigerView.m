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
#import "EPToast.h"
#import "JhPageItemModel.h"
#import "EPPayKillInfoView.h"
#import "EPHeadInfo.h"
#import "EPHeadInfoShowView.h"

static NSString * const reuseIdentifier = @"CustomerCell";
static NSString * const moreReuseIdentifier = @"MoreCustomerCell";

@interface ManualManagerTigerView ()<UICollectionViewDelegate,UICollectionViewDataSource>

//客人信息
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, assign) CGRect ViewFrame;
@property (nonatomic, strong) UICollectionViewLayout *layout;
@property (nonatomic, strong) NSMutableArray *customerInfoList;
@property (nonatomic, assign) BOOL isBeganMove;
@property (nonatomic, assign) BOOL isEntryBox;

@property (nonatomic,strong) NSMutableArray *fxmh_list;//洗码号
@property (nonatomic,strong) NSMutableArray *fxz_cmtype_list;//筹码类型
@property (nonatomic,strong) NSMutableArray *fxz_money_list;//下注本金
@property (nonatomic,strong) NSMutableArray *fxz_name_list;//下注名称
@property (nonatomic,strong) NSMutableArray *fsy_list;//输赢
@property (nonatomic,strong) NSMutableArray *fresult_list;//总码
@property (nonatomic,strong) NSMutableArray *fyj_list;//佣金
@property (nonatomic,strong) NSMutableArray *param_list;//参数

@property (nonatomic,strong) NSMutableArray *payKillResultInfo_list;//杀赔信息
@property (nonatomic, assign) CGFloat payKillResultValue;//杀赔金额
@property (nonatomic, strong) EPPayKillInfoView *payKillInfoView;

@property (nonatomic, strong) CustomerInfo *curSelectCustomer;
@property (nonatomic, assign) BOOL isFirstEntryGame;
@property (nonatomic, strong) NSDictionary *lastTableInfoDict;

@property (nonatomic, strong) EPHeadInfoShowView *headInfoShowView;//头部信息

@end

@implementation ManualManagerTigerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.customerInfoList = [NSMutableArray array];
        [self.customerInfoList addObject:[self modelCustomerInfo]];
        [self addSubview:self.collectionView];
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
        CGRect Collectionframe =CGRectMake(0,0, kScreenWidth, self.frame.size.height);
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

- (void)showWaitingView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.layer.zPosition = 100;
    [hud hideAnimated:YES afterDelay:10];
}

- (void)hideWaitingView {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

#pragma mark --清除金额
- (void)clearMoney{
    [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *customerInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        customerInfo.zhuangValue = @"";
        customerInfo.zhuangDuiValue = @"";
        customerInfo.heValue = @"";
    }];
    [self.collectionView reloadData];
}

#pragma mark - 手势事件
-(void)moveCollectionViewCell:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (!self.isBeganMove) {
                self.isBeganMove = YES;
                //获取点击的cell的indexPath
                NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
                if (selectedIndexPath) {
                    //开始移动对应的cell
                    [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
                }
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
        NSString *number_s = [NSString stringWithFormat:@"NO.%03d",(int)curIndex];
        cell.number_lab.text = number_s;
        [cell fellCellWithCustomerInfo:self.customerInfoList[indexPath.row]];
        @weakify(self);
        cell.deleteCustomer = ^(NSInteger curCellIndex) {
            @strongify(self);
            [self.customerInfoList removeObjectAtIndex:curCellIndex];
            [collectionView reloadData];
        };
        cell.headInfoBlock = ^(NSInteger curCellIndex) {
            @strongify(self);
            CustomerInfo *customerInfo = self.customerInfoList[curCellIndex];
            if ([[customerInfo.washNumberValue NullToBlankString]length]!=0) {
                [self showWaitingView];
                [PublicHttpTool Customer_getWinlossWithWashNumber:customerInfo.washNumberValue Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                    [self hideWaitingView];
                    if (success) {
                        EPHeadInfo *headInfo = [EPHeadInfo yy_modelWithDictionary:(NSDictionary *)data];
                        self.headInfoShowView = [EPHeadInfoShowView showInWindowWithEPHeadInfo:headInfo];
                    }
                }];
            }
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.customerInfoList.count) {
        [self.customerInfoList addObject:[self modelCustomerInfo]];
        [collectionView reloadData];
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }else{
        if ([PublicHttpTool commitKaipaiResult]) {
            if (self.isEntryBox) {
                return;
            }
            self.isEntryBox = YES;
            [self clearMoney];
            CustomerInfo *info = self.customerInfoList[indexPath.row];
            TigerEditInfoView *custerEntryInfoV = [[[NSBundle mainBundle]loadNibNamed:@"TigerEditInfoView" owner:nil options:nil]lastObject];
            custerEntryInfoV.frame = self.bounds;
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
                            [PublicHttpTool commitCustomerRecordWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                                if (success) {
                                    [self clearMoney];
                                    [PublicHttpTool showSucceedSoundMessage:@"结果录入成功"];
                                }else{
                                    [PublicHttpTool showSoundMessage:@"结果录入失败"];
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

- (void)fengzhuangChipTypeWith:(CustomerInfo *)curCustomer{
    if (curCustomer.cashType==0) {//美金筹码
        [self.fxz_cmtype_list addObject:[NSNumber numberWithInt:2]];
    }else if (curCustomer.cashType==1){//美金现金
        [self.fxz_cmtype_list addObject:[NSNumber numberWithInt:7]];
    }else if (curCustomer.cashType==2){//人民币筹码
        [self.fxz_cmtype_list addObject:[NSNumber numberWithInt:1]];
    }else if (curCustomer.cashType==3){//人民币现金
        [self.fxz_cmtype_list addObject:[NSNumber numberWithInt:6]];
    }else if (curCustomer.cashType==4){//美金泥码
        [self.fxz_cmtype_list addObject:[NSNumber numberWithInt:9]];
    }else if (curCustomer.cashType==5){//人民币泥码
        [self.fxz_cmtype_list addObject:[NSNumber numberWithInt:8]];
    }
}

- (void)fengzhuangCustomerInfo{
    self.param_list = [NSMutableArray array];
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
    //赔率
    CGFloat odds = 0;
    CGFloat yj = 0;
    NSArray *xz_array = [PublicHttpTool shareInstance].curXz_setting;
    //龙
    if ([self.curSelectCustomer.zhuangValue integerValue]!=0) {
        NSString *longRealValue = [NSString stringWithFormat:@"龙:%@",self.curSelectCustomer.zhuangValue];
        [self.payKillResultInfo_list addObject:longRealValue];
        [self.fyj_list addObject:@"0"];
        if ([[self.curSelectCustomer.washNumberValue NullToBlankString]length]==0) {
            [self.fxmh_list addObject:@" "];
        }else{
            [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        }
        [self.fxz_money_list addObject:self.curSelectCustomer.zhuangValue];
        [self.fxz_name_list addObject:@"龙"];
        if (xz_array.count>0) {
            odds = [xz_array[0][@"fpl"] floatValue];
            yj = [xz_array[0][@"fyj"] floatValue];
        }
        if ([[PublicHttpTool shareInstance].curupdateInfo.cp_name isEqualToString:@"龙"]) {
            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
            CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.zhuangValue integerValue];
            [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
            CGFloat payValue = (odds-yj)*[self.curSelectCustomer.zhuangValue integerValue];
            self.payKillResultValue+= payValue;
        }else if ([[PublicHttpTool shareInstance].curupdateInfo.cp_name isEqualToString:@"虎"]){
            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
            [self.fresult_list addObject:self.curSelectCustomer.zhuangValue];
            self.payKillResultValue-= [self.curSelectCustomer.zhuangValue floatValue];
        }else{//和
            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
            CGFloat resultValue = 0.5*[self.curSelectCustomer.zhuangValue integerValue];
            [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
            self.payKillResultValue-= resultValue;
        }
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    if ([self.curSelectCustomer.zhuangDuiValue integerValue]!=0){
        NSString *tigerRealValue = [NSString stringWithFormat:@"虎:%@",self.curSelectCustomer.zhuangDuiValue];
        [self.payKillResultInfo_list addObject:tigerRealValue];
        [self.fyj_list addObject:@"0"];
        if ([[self.curSelectCustomer.washNumberValue NullToBlankString]length]==0) {
            [self.fxmh_list addObject:@" "];
        }else{
            [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        }
        [self.fxz_money_list addObject:self.curSelectCustomer.zhuangDuiValue];
        [self.fxz_name_list addObject:@"虎"];
        if (xz_array.count>1) {
            odds = [xz_array[1][@"fpl"] floatValue];
            yj = [xz_array[1][@"fyj"] floatValue];
        }
        if ([[PublicHttpTool shareInstance].curupdateInfo.cp_name isEqualToString:@"龙"]) {
            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
            [self.fresult_list addObject:self.curSelectCustomer.zhuangDuiValue];
        }else if ([[PublicHttpTool shareInstance].curupdateInfo.cp_name isEqualToString:@"虎"]){
            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
            CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.zhuangDuiValue integerValue];
            [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
            CGFloat payValue = (odds-yj)*[self.curSelectCustomer.zhuangDuiValue integerValue];
            self.payKillResultValue+= payValue;
        }else{
            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
            CGFloat resultValue = 0.5*[self.curSelectCustomer.zhuangDuiValue integerValue];
            [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
            self.payKillResultValue-= [self.curSelectCustomer.zhuangDuiValue floatValue];
        }
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    if([self.curSelectCustomer.heValue integerValue]!=0){
        NSString *heRealValue = [NSString stringWithFormat:@"和:%@",self.curSelectCustomer.heValue];
        [self.payKillResultInfo_list addObject:heRealValue];
        [self.fyj_list addObject:@"0"];
        if ([[self.curSelectCustomer.washNumberValue NullToBlankString]length]==0) {
            [self.fxmh_list addObject:@" "];
        }else{
            [self.fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
        }
        [self.fxz_money_list addObject:self.curSelectCustomer.heValue];
        [self.fxz_name_list addObject:@"和"];
        if (xz_array.count>2) {
            odds = [xz_array[2][@"fpl"] floatValue];
            yj = [xz_array[2][@"fyj"] floatValue];
        }
        if ([[PublicHttpTool shareInstance].curupdateInfo.cp_name isEqualToString:@"龙"]) {
            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
            [self.fresult_list addObject:self.curSelectCustomer.heValue];
            self.payKillResultValue-= [self.curSelectCustomer.heValue floatValue];
        }else if ([[PublicHttpTool shareInstance].curupdateInfo.cp_name isEqualToString:@"虎"]){
            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
            [self.fresult_list addObject:self.curSelectCustomer.heValue];
            self.payKillResultValue-= [self.curSelectCustomer.heValue floatValue];
        }else{
            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
            CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.heValue integerValue];
            [self.fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
            CGFloat payValue = (odds-yj)*[self.curSelectCustomer.heValue integerValue];
            self.payKillResultValue+= payValue;
        }
        [self fengzhuangChipTypeWith:self.curSelectCustomer];
    }
    self.curSelectCustomer.resultString = [self.payKillResultInfo_list componentsJoinedByString:@","];
    self.curSelectCustomer.resultValue = self.payKillResultValue;
    self.curSelectCustomer.kaiPaiResult = [PublicHttpTool shareInstance].curupdateInfo.cp_name;
    
    [self.param_list addObject:self.fxmh_list];
    [self.param_list addObject:self.fxz_cmtype_list];
    [self.param_list addObject:self.fxz_money_list];
    [self.param_list addObject:self.fxz_name_list];
    [self.param_list addObject:self.fsy_list];
    [self.param_list addObject:self.fresult_list];
    [self.param_list addObject:self.fyj_list];
}

@end
