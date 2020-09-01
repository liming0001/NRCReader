//
//  NRManualMangerView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/8/26.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRManualMangerView.h"
#import "CustomerInfoCollectionViewCell.h"
#import "AddMoreCustomerCollectionViewCell.h"
#import "CustomerEntryInfoView.h"
#import "CustomerInfo.h"
#import "EPHeadInfo.h"
#import "EPHeadInfoShowView.h"
#import "EPPayKillInfoView.h"

static NSString * const reuseIdentifier = @"CustomerCell";
static NSString * const moreReuseIdentifier = @"MoreCustomerCell";

@interface NRManualMangerView ()<UICollectionViewDelegate,UICollectionViewDataSource>

//客人信息
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UICollectionViewLayout *layout;
@property (nonatomic, strong) NSMutableArray *customerInfoList;
@property (nonatomic, assign) BOOL isBeganMove;

//提交参数
@property (nonatomic,strong) NSMutableArray *param_list;//参数
@property (nonatomic, assign) BOOL isEntryBox;
@property (nonatomic,strong) NSMutableArray *fxz_cmtype_list;//筹码类型
@property (nonatomic, strong) CustomerInfo *curSelectCustomer;
@property (nonatomic, strong) EPHeadInfoShowView *headInfoShowView;//头部信息
@property (nonatomic, strong) EPPayKillInfoView *payKillInfoView;
@property (nonatomic,strong) NSMutableArray *payKillResultInfo_list;//杀赔信息
@property (nonatomic, assign) CGFloat payKillResultValue;//杀赔金额

@end

@implementation NRManualMangerView

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
        layout.itemSize = CGSizeMake(135, 301);
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
        CGRect Collectionframe =CGRectMake(0,0, kScreenWidth, self.frame.size.height-10);
        _collectionView = [[UICollectionView alloc] initWithFrame:Collectionframe collectionViewLayout:self.layout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomerInfoCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AddMoreCustomerCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:moreReuseIdentifier];
        
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
        AddMoreCustomerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreReuseIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        CustomerInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.cellIndex = indexPath.row;
        NSInteger curIndex = indexPath.row+1;
        NSString *number_s = [NSString stringWithFormat:@"NO.%03d",(int)curIndex];
        cell.number_customer.text = number_s;
        [cell fellCellWithCustomerInfo:self.customerInfoList[indexPath.row]];
        @weakify(self);
        cell.deleteCustomer = ^(NSInteger curCellIndex) {
            @strongify(self);
            [EPPopView showInWindowWithMessage:@"确定离场？" handler:^(int buttonType) {
                if (buttonType==0) {
                    [self.customerInfoList removeObjectAtIndex:curCellIndex];
                    [collectionView reloadData];
                }
            }];
        };
        cell.customerHeadInfoBlock = ^(NSInteger curCellIndex) {
            @strongify(self);
            CustomerInfo *customerInfo = self.customerInfoList[curCellIndex];
            if ([[customerInfo.washNumberValue NullToBlankString]length]!=0) {
                [PublicHttpTool showWaitingView];
                [PublicHttpTool Customer_getWinlossWithWashNumber:customerInfo.washNumberValue Block:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                    [PublicHttpTool hideWaitingView];
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
            CustomerInfo *info = self.customerInfoList[indexPath.row];
            CustomerEntryInfoView *custerEntryInfoV = [[[NSBundle mainBundle]loadNibNamed:@"CustomerEntryInfoView" owner:nil options:nil]lastObject];
            custerEntryInfoV.frame = self.bounds;
            @weakify(self);
            custerEntryInfoV.editTapCustomer = ^(CustomerInfo * _Nonnull curCustomer, BOOL hasEntry) {
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
                            [PublicHttpTool showWaitingView];
                            [PublicHttpTool commitCustomerRecordWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                                if (success) {
                                    [self clearMoney];
                                    [PublicHttpTool showSucceedSoundMessage:@"结果录入成功"];
                                }else{
                                    [PublicHttpTool showSoundMessage:@"结果录入失败"];
                                }
                                [PublicHttpTool hideWaitingView];
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
    [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *customerInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        customerInfo.zhuangValue = @"";
        customerInfo.zhuangDuiValue = @"";
        customerInfo.xianValue = @"";
        customerInfo.xianDuiValue = @"";
        customerInfo.sixWinValue = @"";
        customerInfo.heValue = @"";
        customerInfo.luckyValue = @"";
        customerInfo.baoxianValue = @"";
    }];
    [self.collectionView reloadData];
}

- (CustomerInfo *)modelCustomerInfo{
    CustomerInfo *customer = [[CustomerInfo alloc]init];
    customer.headUrlString = @"addIcon_headImg";
    customer.washNumberValue = @"";
    customer.zhuangValue = @"";
    customer.zhuangDuiValue = @"";
    customer.sixWinValue = @"";
    customer.luckyValue = @"";
    customer.xianValue = @"";
    customer.xianDuiValue = @"";
    customer.heValue = @"";
    customer.baoxianValue = @"";
    customer.cashType = 1;
    customer.headbgImgName = @"customer_VIP_bg";
    customer.isYouYong = NO;
    customer.sixValueType = 1;
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

#pragma mark - 提交客人输赢记录和台桌流水记录
- (void)fengzhuangCustomerInfo{
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
    self.param_list = [NSMutableArray array];
    
    self.payKillResultInfo_list = [NSMutableArray arrayWithCapacity:0];
    self.payKillResultValue  = 0;
    
    NSMutableArray *reslutNameList = [NSMutableArray array];
    for (int i=0; i<[PublicHttpTool shareInstance].resultList.count; i++) {
        NSInteger tagResult = [[PublicHttpTool shareInstance].resultList[i]integerValue];
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
    
    [PublicHttpTool shareInstance].curupdateInfo.cp_name = [reslutNameList componentsJoinedByString:@","];
    if ([self.curSelectCustomer.zhuangValue integerValue]==0&&[self.curSelectCustomer.zhuangDuiValue integerValue]==0&&[self.curSelectCustomer.xianValue integerValue]==0&&[self.curSelectCustomer.xianDuiValue integerValue]==0&&[self.curSelectCustomer.heValue integerValue]==0&&[self.curSelectCustomer.sixWinValue integerValue]==0&&[self.curSelectCustomer.baoxianValue integerValue]==0&&[[self.curSelectCustomer.washNumberValue NullToBlankString]length]==0) {
    }else{
        //赔率
        CGFloat odds = 0;
        CGFloat yj = 0;
        NSArray *xz_array = [PublicHttpTool shareInstance].curXz_setting;
        if ([self.curSelectCustomer.zhuangValue integerValue]!=0) {//庄
            NSString *zhuangRealValue = [NSString stringWithFormat:@"庄:%@",self.curSelectCustomer.zhuangValue];
            [self.payKillResultInfo_list addObject:zhuangRealValue];
            [fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
            [fxz_money_list addObject:self.curSelectCustomer.zhuangValue];
            [fxz_name_list addObject:@"庄"];
            if (xz_array.count>0) {
                odds = [xz_array[0][@"fpl"] intValue];
                yj = [xz_array[0][@"fyj"] intValue]/100.0;
            }
            if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
                [fsy_list addObject:[NSNumber numberWithInt:0]];
                [fresult_list addObject:[NSNumber numberWithInt:0]];
                [fyj_list addObject:[NSNumber numberWithDouble:0]];
            }else{
                if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:1]]) {//庄
                    [fsy_list addObject:[NSNumber numberWithInt:1]];
                    CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.zhuangValue integerValue];
                    if (self.curSelectCustomer.cashType==0||self.curSelectCustomer.cashType==2||self.curSelectCustomer.cashType==4||self.curSelectCustomer.cashType==5) {
                        [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                    }else{
                        [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                    }
                    CGFloat yjValue = yj*[self.curSelectCustomer.zhuangValue integerValue];
                    [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                    CGFloat payValue = (odds-yj)*[self.curSelectCustomer.zhuangValue integerValue];
                    self.payKillResultValue+= payValue;
                }else {
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:self.curSelectCustomer.zhuangValue];
                    [fyj_list addObject:[NSNumber numberWithDouble:0]];
                    self.payKillResultValue-= [self.curSelectCustomer.zhuangValue floatValue];
                }
            }
            [self fengzhuangChipTypeWith:self.curSelectCustomer];
        }
        if ([self.curSelectCustomer.zhuangDuiValue integerValue]!=0) {//庄对
            NSString *zhuangDuiRealValue = [NSString stringWithFormat:@"庄对:%@",self.curSelectCustomer.zhuangDuiValue];
            [self.payKillResultInfo_list addObject:zhuangDuiRealValue];
            [fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
            [fxz_money_list addObject:self.curSelectCustomer.zhuangDuiValue];
            [fxz_name_list addObject:@"庄对"];
            if (xz_array.count>2) {
                odds = [xz_array[2][@"fpl"] floatValue];
                yj = [xz_array[2][@"fyj"] intValue]/100.0;
            }
            if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:2]]) {//庄对
                [fsy_list addObject:[NSNumber numberWithInt:1]];
                CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.zhuangDuiValue integerValue];
                if (self.curSelectCustomer.cashType==0||self.curSelectCustomer.cashType==2||self.curSelectCustomer.cashType==4||self.curSelectCustomer.cashType==5) {
                    [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                }else{
                    [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                }
                CGFloat yjValue = yj*[self.curSelectCustomer.zhuangDuiValue integerValue];
                [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                CGFloat payValue = (odds-yj)*[self.curSelectCustomer.zhuangDuiValue integerValue];
                self.payKillResultValue+= payValue;
            }else {
                [fsy_list addObject:[NSNumber numberWithInt:-1]];
                [fresult_list addObject:self.curSelectCustomer.zhuangDuiValue];
                [fyj_list addObject:[NSNumber numberWithDouble:0]];
                self.payKillResultValue-= [self.curSelectCustomer.zhuangDuiValue floatValue];
            }
            [self fengzhuangChipTypeWith:self.curSelectCustomer];
        }
        if ([self.curSelectCustomer.sixWinValue integerValue]!=0) {//幸运6点
            NSString *luckyRealValue = [NSString stringWithFormat:@"Lucky6:%@",self.curSelectCustomer.luckyValue];
            [self.payKillResultInfo_list addObject:luckyRealValue];
            [fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
            [fxz_money_list addObject:self.curSelectCustomer.sixWinValue];
            [fxz_name_list addObject:@"Lucky6"];
            if (self.curSelectCustomer.sixValueType==1) {
                if (xz_array.count>7) {
                    odds = [xz_array[7][@"fpl"] floatValue];
                    yj = [xz_array[7][@"fyj"] intValue]/100.0;
                }
            }else{
                if (xz_array.count>8) {
                    odds = [xz_array[8][@"fpl"] floatValue];
                    yj = [xz_array[8][@"fyj"] intValue]/100.0;
                }
            }
            if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
                [fsy_list addObject:[NSNumber numberWithInt:0]];
                [fresult_list addObject:[NSNumber numberWithInt:0]];
                [fyj_list addObject:[NSNumber numberWithDouble:0]];
            }else{
                if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:3]]) {//6点赢
                    [fsy_list addObject:[NSNumber numberWithInt:1]];
                    CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.sixWinValue integerValue];
                    if (self.curSelectCustomer.cashType==0||self.curSelectCustomer.cashType==2||self.curSelectCustomer.cashType==4||self.curSelectCustomer.cashType==5) {
                        [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                    }else{
                        [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                    }
                    CGFloat yjValue = yj*[self.curSelectCustomer.sixWinValue integerValue];
                    [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                    CGFloat payValue = (odds-yj)*[self.curSelectCustomer.sixWinValue integerValue];
                    self.payKillResultValue+= payValue;
                }else {
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:self.curSelectCustomer.sixWinValue];
                    [fyj_list addObject:[NSNumber numberWithDouble:0]];
                    self.payKillResultValue-= [self.curSelectCustomer.sixWinValue floatValue];
                }
            }
            [self fengzhuangChipTypeWith:self.curSelectCustomer];
        }
        if ([self.curSelectCustomer.xianValue integerValue]!=0) {//闲
            NSString *xianRealValue = [NSString stringWithFormat:@"闲:%@",self.curSelectCustomer.xianValue];
            [self.payKillResultInfo_list addObject:xianRealValue];
            [fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
            [fxz_money_list addObject:self.curSelectCustomer.xianValue];
            [fxz_name_list addObject:@"闲"];
            if (xz_array.count>1) {
                odds = [xz_array[1][@"fpl"] floatValue];
                yj = [xz_array[1][@"fyj"] intValue]/100.0;
            }
            if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
                [fsy_list addObject:[NSNumber numberWithInt:0]];
                [fresult_list addObject:[NSNumber numberWithInt:0]];
                [fyj_list addObject:[NSNumber numberWithDouble:0]];
            }else{
                if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:4]]) {//闲
                    [fsy_list addObject:[NSNumber numberWithInt:1]];
                    CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.xianValue integerValue];
                    if (self.curSelectCustomer.cashType==0||self.curSelectCustomer.cashType==2||self.curSelectCustomer.cashType==4||self.curSelectCustomer.cashType==5) {
                        [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                    }else{
                        [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                    }
                    CGFloat yjValue = yj*[self.curSelectCustomer.xianValue integerValue];
                    [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                    CGFloat payValue = (odds-yj)*[self.curSelectCustomer.xianValue integerValue];
                    self.payKillResultValue+= payValue;
                }else {
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:self.curSelectCustomer.xianValue];
                    [fyj_list addObject:[NSNumber numberWithDouble:0]];
                    self.payKillResultValue-= [self.curSelectCustomer.xianValue floatValue];
                }
            }
            [self fengzhuangChipTypeWith:self.curSelectCustomer];
        }
        if ([self.curSelectCustomer.xianDuiValue integerValue]!=0) {//闲对
            NSString *xianDuiRealValue = [NSString stringWithFormat:@"闲对:%@",self.curSelectCustomer.xianDuiValue];
            [self.payKillResultInfo_list addObject:xianDuiRealValue];
            [fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
            [fxz_money_list addObject:self.curSelectCustomer.xianDuiValue];
            [fxz_name_list addObject:@"闲对"];
            if (xz_array.count>3) {
                odds = [xz_array[3][@"fpl"] floatValue];
                yj = [xz_array[3][@"fyj"] intValue]/100.0;
            }
            if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:5]]) {//闲对
                [fsy_list addObject:[NSNumber numberWithInt:1]];
                CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.xianDuiValue integerValue];
                if (self.curSelectCustomer.cashType==0||self.curSelectCustomer.cashType==2||self.curSelectCustomer.cashType==4||self.curSelectCustomer.cashType==5) {
                    [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                }else{
                    [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                }
                CGFloat yjValue = yj*[self.curSelectCustomer.xianDuiValue integerValue];
                [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                CGFloat payValue = (odds-yj)*[self.curSelectCustomer.xianDuiValue integerValue];
                self.payKillResultValue+= payValue;
            }else {
                [fsy_list addObject:[NSNumber numberWithInt:-1]];
                [fresult_list addObject:self.curSelectCustomer.xianDuiValue];
                [fyj_list addObject:[NSNumber numberWithDouble:0]];
                self.payKillResultValue-= [self.curSelectCustomer.xianDuiValue floatValue];
            }
            [self fengzhuangChipTypeWith:self.curSelectCustomer];
        }
        
        if ([self.curSelectCustomer.heValue integerValue]!=0) {//和
            NSString *heRealValue = [NSString stringWithFormat:@"和:%@",self.curSelectCustomer.heValue];
            [self.payKillResultInfo_list addObject:heRealValue];
            [fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
            [fxz_money_list addObject:self.curSelectCustomer.heValue];
            [fxz_name_list addObject:@"和"];
            if (xz_array.count>4) {
                odds = [xz_array[4][@"fpl"] floatValue];
                yj = [xz_array[4][@"fyj"] intValue]/100.0;
            }
            if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
                [fsy_list addObject:[NSNumber numberWithInt:1]];
                CGFloat resultValue = (1+odds-yj)*[self.curSelectCustomer.heValue integerValue];
                if (self.curSelectCustomer.cashType==0||self.curSelectCustomer.cashType==2||self.curSelectCustomer.cashType==4||self.curSelectCustomer.cashType==5) {
                    [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                }else{
                    [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                }
                CGFloat yjValue = yj*[self.curSelectCustomer.heValue integerValue];
                [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                CGFloat payValue = (odds-yj)*[self.curSelectCustomer.heValue integerValue];
                self.payKillResultValue+= payValue;
            }else {
                [fsy_list addObject:[NSNumber numberWithInt:-1]];
                [fresult_list addObject:self.curSelectCustomer.heValue];
                [fyj_list addObject:[NSNumber numberWithDouble:0]];
                self.payKillResultValue-= [self.curSelectCustomer.heValue floatValue];
            }
            [self fengzhuangChipTypeWith:self.curSelectCustomer];
        }
        
        if ([self.curSelectCustomer.baoxianValue integerValue]!=0) {//保险
            NSString *baoxianRealValue = [NSString stringWithFormat:@"保险:%@",self.curSelectCustomer.baoxianValue];
            [self.payKillResultInfo_list addObject:baoxianRealValue];
            [fxmh_list addObject:[self.curSelectCustomer.washNumberValue NullToBlankString]];
            [fxz_money_list addObject:self.curSelectCustomer.baoxianValue];
            [fxz_name_list addObject:@"保险"];
            CGFloat resultValue = [self.curSelectCustomer.baoxianValue integerValue];
            [fresult_list addObject:[NSNumber numberWithDouble:resultValue]];
            [fyj_list addObject:[NSNumber numberWithDouble:0]];
            if (resultValue>0) {
                [fsy_list addObject:[NSNumber numberWithInt:1]];
                self.payKillResultValue+= resultValue;
            }else{
                [fsy_list addObject:[NSNumber numberWithInt:-1]];
                self.payKillResultValue-= resultValue;
            }
            [self fengzhuangChipTypeWith:self.curSelectCustomer];
        }
    }
    self.curSelectCustomer.resultString = [self.payKillResultInfo_list componentsJoinedByString:@","];
    self.curSelectCustomer.resultValue = self.payKillResultValue;
    self.curSelectCustomer.kaiPaiResult = [PublicHttpTool shareInstance].curupdateInfo.cp_name;
    
    [self.param_list addObject:fxmh_list];
    [self.param_list addObject:self.fxz_cmtype_list];
    [self.param_list addObject:fxz_money_list];
    [self.param_list addObject:fxz_name_list];
    [self.param_list addObject:fsy_list];
    [self.param_list addObject:fresult_list];
    [self.param_list addObject:fyj_list];
    [PublicHttpTool shareInstance].paramList = self.param_list;
}

@end
