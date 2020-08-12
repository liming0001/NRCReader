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
    
    NSMutableArray *reslutNameList = [NSMutableArray array];
    for (int i=0; i<[PublicHttpTool shareInstance].resultList.count; i++) {
        NSInteger tagResult = [[PublicHttpTool shareInstance].resultList[i]integerValue];
        if (tagResult==1) {
            [reslutNameList addObject:@"庄"];
        }else if (tagResult==2){
            [reslutNameList addObject:@"庄对"];
        }else if (tagResult==3){
            [reslutNameList addObject:@"6点赢"];
        }else if (tagResult==4){
            [reslutNameList addObject:@"闲"];
        }else if (tagResult==5){
            [reslutNameList addObject:@"闲对"];
        }else if (tagResult==6){
            [reslutNameList addObject:@"和"];
        }
    }
    [PublicHttpTool shareInstance].curupdateInfo.cp_name = [reslutNameList componentsJoinedByString:@","];
    
    [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *curCustomer, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([curCustomer.zhuangValue integerValue]==0&&[curCustomer.zhuangDuiValue integerValue]==0&&[curCustomer.xianValue integerValue]==0&&[curCustomer.xianDuiValue integerValue]==0&&[curCustomer.heValue integerValue]==0&&[curCustomer.sixWinValue integerValue]==0&&[curCustomer.baoxianValue integerValue]==0&&[curCustomer.luckyValue integerValue]==0&&[[curCustomer.washNumberValue NullToBlankString]length]==0) {
        }else{
            //赔率
            CGFloat odds = 0;
            CGFloat yj = 0;
            NSArray *xz_array = [PublicHttpTool shareInstance].curXz_setting;
            if ([curCustomer.zhuangValue integerValue]!=0) {//庄
                [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                [fxz_money_list addObject:curCustomer.zhuangValue];
                [fxz_name_list addObject:@"庄"];
                if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
                    [fsy_list addObject:[NSNumber numberWithInt:0]];
                    [fresult_list addObject:[NSNumber numberWithInt:0]];
                    [fyj_list addObject:[NSNumber numberWithDouble:0]];
                }else{
                    if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:1]]) {//庄
                        if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:3]]) {//6点赢
                            if (xz_array.count>6) {
                                odds = [xz_array[6][@"fpl"] floatValue];
                                yj = [xz_array[6][@"fyj"] intValue]/100.0;
                            }
                            [fsy_list addObject:[NSNumber numberWithInt:1]];
                            CGFloat resultValue = (1+odds-yj)*[curCustomer.zhuangValue integerValue];
                            if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                                [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                            }else{
                                [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                            }
                            CGFloat yjValue = yj*[curCustomer.zhuangValue integerValue];
                            [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                        }else {
                            if (xz_array.count>0) {
                                odds = [xz_array[0][@"fpl"] floatValue];
                                yj = [xz_array[0][@"fyj"] intValue]/100.0;
                            }
                            [fsy_list addObject:[NSNumber numberWithInt:1]];
                            CGFloat resultValue = (1+odds-yj)*[curCustomer.zhuangValue integerValue];
                            if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                                [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                            }else{
                                [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                            }
                            CGFloat yjValue = yj*[curCustomer.zhuangValue integerValue];
                            [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                        }
                    }else {
                        [fsy_list addObject:[NSNumber numberWithInt:-1]];
                        [fresult_list addObject:curCustomer.zhuangValue];
                        [fyj_list addObject:[NSNumber numberWithDouble:0]];
                    }
                }
                [self fengzhuangChipTypeWith:curCustomer];
            }
            if ([curCustomer.zhuangDuiValue integerValue]!=0) {//庄对
                [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                [fxz_money_list addObject:curCustomer.zhuangDuiValue];
                [fxz_name_list addObject:@"庄对"];
                if (xz_array.count>2) {
                    odds = [xz_array[2][@"fpl"] floatValue];
                    yj = [xz_array[2][@"fyj"] intValue]/100.0;
                }
                if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:2]]) {//庄对
                    [fsy_list addObject:[NSNumber numberWithInt:1]];
                    CGFloat resultValue = (1+odds-yj)*[curCustomer.zhuangDuiValue integerValue];
                    if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                        [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                    }else{
                        [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                    }
                    CGFloat yjValue = yj*[curCustomer.zhuangDuiValue integerValue];
                    [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                }else {
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:curCustomer.zhuangDuiValue];
                    [fyj_list addObject:[NSNumber numberWithDouble:0]];
                }
                [self fengzhuangChipTypeWith:curCustomer];
            }
            
            if ([curCustomer.luckyValue integerValue]!=0) {//幸运6点
                [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                [fxz_money_list addObject:curCustomer.luckyValue];
                [fxz_name_list addObject:@"Lucky6"];
                if (curCustomer.sixValueType==1) {
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
                    if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:3]]) {//Lucky6
                        [fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[curCustomer.luckyValue integerValue];
                        if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                            [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                        }else{
                            [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                        }
                        CGFloat yjValue = yj*[curCustomer.luckyValue integerValue];
                        [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                    }else {
                        [fsy_list addObject:[NSNumber numberWithInt:-1]];
                        [fresult_list addObject:curCustomer.luckyValue];
                        [fyj_list addObject:[NSNumber numberWithDouble:0]];
                    }
                }
                [self fengzhuangChipTypeWith:curCustomer];
            }
            if ([curCustomer.xianValue integerValue]!=0) {//闲
                if ([[curCustomer.washNumberValue NullToBlankString]length]==0) {
                    [fxmh_list addObject:@" "];
                }else{
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                }
                [fxz_money_list addObject:curCustomer.xianValue];
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
                        CGFloat resultValue = (1+odds-yj)*[curCustomer.xianValue integerValue];
                        if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                            [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                        }else{
                            [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                        }
                        CGFloat yjValue = yj*[curCustomer.xianValue integerValue];
                        [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                    }else {
                        [fsy_list addObject:[NSNumber numberWithInt:-1]];
                        [fresult_list addObject:curCustomer.xianValue];
                        [fyj_list addObject:[NSNumber numberWithDouble:0]];
                    }
                }
                [self fengzhuangChipTypeWith:curCustomer];
            }
            if ([curCustomer.xianDuiValue integerValue]!=0) {//闲对
                if ([[curCustomer.washNumberValue NullToBlankString]length]==0) {
                    [fxmh_list addObject:@" "];
                }else{
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                }
                [fxz_money_list addObject:curCustomer.xianDuiValue];
                [fxz_name_list addObject:@"闲对"];
                if (xz_array.count>3) {
                    odds = [xz_array[3][@"fpl"] floatValue];
                    yj = [xz_array[3][@"fyj"] intValue]/100.0;
                }
                if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:5]]) {//闲对
                    [fsy_list addObject:[NSNumber numberWithInt:1]];
                    CGFloat resultValue = (1+odds-yj)*[curCustomer.xianDuiValue integerValue];
                    if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                        [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                    }else{
                        [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                    }
                    CGFloat yjValue = yj*[curCustomer.xianDuiValue integerValue];
                    [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                }else {
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:curCustomer.xianDuiValue];
                    [fyj_list addObject:[NSNumber numberWithDouble:0]];
                }
                [self fengzhuangChipTypeWith:curCustomer];
            }
            
            if ([curCustomer.heValue integerValue]!=0) {//和
                if ([[curCustomer.washNumberValue NullToBlankString]length]==0) {
                    [fxmh_list addObject:@" "];
                }else{
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                }
                [fxz_money_list addObject:curCustomer.heValue];
                [fxz_name_list addObject:@"和"];
                if (xz_array.count>4) {
                    odds = [xz_array[4][@"fpl"] floatValue];
                    yj = [xz_array[4][@"fyj"] intValue]/100.0;
                }
                if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:6]]) {//和
                    [fsy_list addObject:[NSNumber numberWithInt:1]];
                    CGFloat resultValue = (1+odds-yj)*[curCustomer.heValue integerValue];
                    if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                        [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                    }else{
                        [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                    }
                    CGFloat yjValue = yj*[curCustomer.heValue integerValue];
                    [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                }else {
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:curCustomer.heValue];
                    [fyj_list addObject:[NSNumber numberWithDouble:0]];
                }
                [self fengzhuangChipTypeWith:curCustomer];
            }
            
            if ([curCustomer.baoxianValue integerValue]!=0) {//保险
                if ([[curCustomer.washNumberValue NullToBlankString]length]==0) {
                    [fxmh_list addObject:@" "];
                }else{
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                }
                [fxz_money_list addObject:curCustomer.baoxianValue];
                [fxz_name_list addObject:@"保险"];
                if ([[PublicHttpTool shareInstance].resultList containsObject:[NSNumber numberWithInteger:7]]) {//和
                    [fsy_list addObject:[NSNumber numberWithInt:1]];
                    CGFloat resultValue = [curCustomer.baoxianValue integerValue];
                    [fresult_list addObject:[NSNumber numberWithInt:resultValue]];
                    [fyj_list addObject:[NSNumber numberWithInt:0]];
                }else {
                    [fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [fresult_list addObject:curCustomer.baoxianValue];
                    [fyj_list addObject:[NSNumber numberWithDouble:0]];
                }
                [self fengzhuangChipTypeWith:curCustomer];
            }
        }
    }];
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
