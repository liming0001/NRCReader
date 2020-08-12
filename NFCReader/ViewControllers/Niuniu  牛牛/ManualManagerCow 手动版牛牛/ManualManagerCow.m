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
#import "EPToast.h"
#import "CustomerEntryInfoCowView.h"
#import "JhPageItemModel.h"
#import "EPPayKillInfoView.h"
#import "EPCowPointChooseShowView.h"
#import "EPINSShowView.h"
#import "EPHeadInfo.h"
#import "EPHeadInfoShowView.h"

static NSString * const reuseIdentifier = @"CustomerCell";
static NSString * const moreReuseIdentifier = @"MoreCustomerCell";

@interface ManualManagerCow ()<UICollectionViewDelegate,UICollectionViewDataSource>

//客人信息
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UICollectionViewLayout *layout;
@property (nonatomic, strong) NSMutableArray *customerInfoList;
@property (nonatomic, assign) BOOL isBeganMove;
@property (nonatomic, assign) BOOL isEntryBox;

@property (nonatomic, strong) CustomerInfo *curSelectCustomer;

@property (nonatomic,strong) NSMutableArray *fxz_cmtype_list;//筹码类型
@property (nonatomic,strong) NSMutableArray *param_list;//参数
@property (nonatomic, strong) EPHeadInfoShowView *headInfoShowView;//头部信息

@end

@implementation ManualManagerCow

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
        layout.itemSize = CGSizeMake(228, 280);
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
        cell.pointChooseBlock = ^(NSInteger curCellIndex) {
            @strongify(self);
            [self CalcuteCowWithPointForIndex:curCellIndex];
        };
        cell.headInfoBlock = ^(NSInteger curCellIndex) {
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

#pragma mark - 点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
            CustomerEntryInfoCowView *custerEntryInfoV = [[[NSBundle mainBundle]loadNibNamed:@"CustomerEntryInfoCowView" owner:nil options:nil]lastObject];
            custerEntryInfoV.frame = self.bounds;
            custerEntryInfoV.editTapCustomer = ^(CustomerInfo * _Nonnull curCustomer, BOOL hasEntry) {
                self.isEntryBox = NO;
                if (hasEntry) {
                    if (curCustomer.cowPoint!=99) {
                        //赔率
                        NSArray *xz_array = [PublicHttpTool shareInstance].curXz_setting;
                        //超级翻倍
                        NSDictionary *fplDict = xz_array[2][@"fpl"];
                        NSDictionary *fyjDict = xz_array[2][@"fyj"];
                        
                        //翻倍
                        NSDictionary *fplDict1 = xz_array[1][@"fpl"];
                        NSDictionary *fyjDict1 = xz_array[1][@"fyj"];
                        
                        //平倍
                        NSDictionary *fplDict2 = xz_array[0][@"fpl"];
                        NSDictionary *fyjDict2 = xz_array[0][@"fyj"];
                        int customerPoint = curCustomer.cowPoint;
                        if ([PublicHttpTool shareInstance].cowPoint==customerPoint) {//点数相同
                            if (curCustomer.isCow_customerWin) {
                                CGFloat realZhuangValue = (1-[[fyjDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangValue floatValue];
                                //翻倍
                                CGFloat realDoubleValue = (1-[[fyjDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangDuiValue floatValue];
                                
                                //平倍
                                CGFloat realNormalValue = (1-[[fyjDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.xianValue floatValue];
                                
                                if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                                    curCustomer.superValue = [NSString stringWithFormat:@"%d",(int)realZhuangValue];
                                    curCustomer.doubleValue = [NSString stringWithFormat:@"%d",(int)realDoubleValue];
                                    curCustomer.normalValue = [NSString stringWithFormat:@"%d",(int)realNormalValue];
                                }else{
                                    curCustomer.superValue = [NSString stringWithFormat:@"%.2f",realZhuangValue];
                                    curCustomer.doubleValue = [NSString stringWithFormat:@"%.2f",realDoubleValue];
                                    curCustomer.normalValue = [NSString stringWithFormat:@"%.2f",realNormalValue];
                                }
                            }else{
                                CGFloat realZhuangValue = [[fplDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangValue floatValue];
                                if (realZhuangValue>0) {
                                    curCustomer.superValue = [NSString stringWithFormat:@"-%.f",realZhuangValue];
                                }else{
                                    curCustomer.superValue = @"0";
                                }
                                //翻倍
                                CGFloat realDoubleValue = [[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangDuiValue floatValue];
                                if (realDoubleValue>0) {
                                    curCustomer.doubleValue = [NSString stringWithFormat:@"-%.f",realDoubleValue];
                                }else{
                                    curCustomer.doubleValue = @"0";
                                }
                                
                                //平倍
                                CGFloat realNormalValue = [[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.xianValue floatValue];
                                if (realNormalValue>0) {
                                    curCustomer.normalValue = [NSString stringWithFormat:@"-%.f",realNormalValue];
                                }else{
                                    curCustomer.normalValue = @"0";
                                }
                            }
                        }else{
                            if ([PublicHttpTool shareInstance].cowPoint>customerPoint) {//庄家赢
                                CGFloat realZhuangValue = [[fplDict objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.zhuangValue floatValue];
                                if (realZhuangValue>0) {
                                    curCustomer.superValue = [NSString stringWithFormat:@"-%.f",realZhuangValue];
                                }else{
                                    curCustomer.superValue = @"0";
                                }
                            }else if ([PublicHttpTool shareInstance].cowPoint<customerPoint){//闲家赢,需要减去佣金
                                CGFloat realZhuangValue = (1-[[fyjDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangValue floatValue];
                                if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                                    curCustomer.superValue = [NSString stringWithFormat:@"%d",(int)realZhuangValue];
                                }else{
                                    curCustomer.superValue = [NSString stringWithFormat:@"%.2f",realZhuangValue];
                                }
                            }
                            if ([PublicHttpTool shareInstance].cowPoint>customerPoint) {//庄家赢
                                CGFloat realZhuangDuiValue = [[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.zhuangDuiValue floatValue];
                                if (realZhuangDuiValue>0) {
                                    curCustomer.doubleValue = [NSString stringWithFormat:@"-%.f",realZhuangDuiValue];
                                }else{
                                    curCustomer.doubleValue = @"0";
                                }
                                
                            }else if ([PublicHttpTool shareInstance].cowPoint<customerPoint){//闲家赢,需要减去佣金
                                CGFloat realZhuangDuiValue = (1-[[fyjDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangDuiValue floatValue];
                                curCustomer.doubleValue = [NSString stringWithFormat:@"%.f",realZhuangDuiValue];
                                if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                                    curCustomer.doubleValue = [NSString stringWithFormat:@"%d",(int)realZhuangDuiValue];
                                }else{
                                    curCustomer.doubleValue = [NSString stringWithFormat:@"%.2f",realZhuangDuiValue];
                                }
                            }
                            
                            if ([PublicHttpTool shareInstance].cowPoint>customerPoint) {//庄家赢
                                CGFloat realXianValue = [[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.xianValue floatValue];
                                if (realXianValue>0) {
                                    curCustomer.normalValue = [NSString stringWithFormat:@"-%.f",realXianValue];
                                }else{
                                    curCustomer.normalValue = @"0";
                                }
                            }else if ([PublicHttpTool shareInstance].cowPoint<customerPoint){//闲家赢,需要减去佣金
                                CGFloat realXianValue = (1-[[fyjDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.xianValue floatValue];
                                if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                                    curCustomer.normalValue = [NSString stringWithFormat:@"%d",(int)realXianValue];
                                }else{
                                    curCustomer.normalValue = [NSString stringWithFormat:@"%.2f",realXianValue];
                                }
                            }
                        }
                    }
                    [self.customerInfoList replaceObjectAtIndex:indexPath.row withObject:curCustomer];
                    [collectionView reloadData];
                }
            };
            [custerEntryInfoV editCurCustomerWithCustomerInfo:info];
            [[MJPopTool sharedInstance] popView:custerEntryInfoV animated:YES];
        }
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
    customer.xianValue = @"";
    customer.superValue = @"";
    customer.doubleValue = @"";
    customer.normalValue = @"";
    customer.cashType = 1;
    customer.cowPoint = 99;
    customer.cowPointValue = @"录入点数";
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

#pragma mark -- 根据庄点数重新计算客人输赢
- (void)calculateCustomerMoneyWithZhuangCowPoint{
    [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *curCustomer, NSUInteger idx, BOOL * _Nonnull stop) {
        if (curCustomer.cowPoint!=99) {
            //赔率
            NSArray *xz_array = [PublicHttpTool shareInstance].curXz_setting;
            int customerPoint = curCustomer.cowPoint;
            if ([PublicHttpTool shareInstance].cowPoint==customerPoint) {//点数相同,清除闲家点数
                curCustomer.cowPoint=99;
            }else{
                //超级翻倍
                NSDictionary *fplDict = xz_array[2][@"fpl"];
                NSDictionary *fyjDict = xz_array[2][@"fyj"];
                if ([PublicHttpTool shareInstance].cowPoint>customerPoint) {//庄家赢
                    curCustomer.isCow_customerWin = NO;
                    CGFloat realZhuangValue = [[fplDict objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.zhuangValue floatValue];
                    if (realZhuangValue>0) {
                        curCustomer.superValue = [NSString stringWithFormat:@"-%.f",realZhuangValue];
                    }else{
                        curCustomer.superValue = @"0";
                    }
                }else if ([PublicHttpTool shareInstance].cowPoint<customerPoint){//闲家赢,需要减去佣金
                    curCustomer.isCow_customerWin = YES;
                    CGFloat realZhuangValue = (1-[[fyjDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangValue floatValue];
                    if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                        curCustomer.superValue = [NSString stringWithFormat:@"%d",(int)realZhuangValue];
                    }else{
                        curCustomer.superValue = [NSString stringWithFormat:@"%.2f",realZhuangValue];
                    }
                }
                
                //翻倍
                NSDictionary *fplDict1 = xz_array[1][@"fpl"];
                NSDictionary *fyjDict1 = xz_array[1][@"fyj"];
                if ([PublicHttpTool shareInstance].cowPoint>customerPoint) {//庄家赢
                    curCustomer.isCow_customerWin = NO;
                    CGFloat realZhuangDuiValue = [[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.zhuangDuiValue floatValue];
                    if (realZhuangDuiValue>0) {
                        curCustomer.doubleValue = [NSString stringWithFormat:@"-%.f",realZhuangDuiValue];
                    }else{
                        curCustomer.doubleValue = @"0";
                    }
                    
                }else if ([PublicHttpTool shareInstance].cowPoint<customerPoint){//闲家赢,需要减去佣金
                    curCustomer.isCow_customerWin = YES;
                    CGFloat realZhuangDuiValue = (1-[[fyjDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangDuiValue floatValue];
                    if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                        curCustomer.doubleValue = [NSString stringWithFormat:@"%d",(int)realZhuangDuiValue];
                    }else{
                        curCustomer.doubleValue = [NSString stringWithFormat:@"%.2f",realZhuangDuiValue];
                    }
                }
                
                //平倍
                NSDictionary *fplDict2 = xz_array[0][@"fpl"];
                NSDictionary *fyjDict2 = xz_array[0][@"fyj"];
                if ([PublicHttpTool shareInstance].cowPoint>customerPoint) {//庄家赢
                    curCustomer.isCow_customerWin = NO;
                    CGFloat realXianValue = [[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.xianValue floatValue];
                    if (realXianValue>0) {
                        curCustomer.normalValue = [NSString stringWithFormat:@"-%.f",realXianValue];
                    }else{
                        curCustomer.normalValue = @"0";
                    }
                }else if ([PublicHttpTool shareInstance].cowPoint<customerPoint){//闲家赢,需要减去佣金
                    curCustomer.isCow_customerWin = YES;
                    CGFloat realXianValue = (1-[[fyjDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.xianValue floatValue];
                    if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                        curCustomer.normalValue = [NSString stringWithFormat:@"%d",(int)realXianValue];
                    }else{
                        curCustomer.normalValue = [NSString stringWithFormat:@"%.2f",realXianValue];
                    }
                }
            }
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark--牛牛输赢选择弹出
- (void)cowResultShowWithCustomer:(CustomerInfo *)curCustomer{
    EPINSShowView *cowResultShowView = [[AppDelegate shareInstance]cowResultShowView];
    [[MJPopTool sharedInstance] popView:cowResultShowView animated:YES];
    @weakify(self);
    cowResultShowView.INSResultBlock = ^(BOOL isWin) {
        @strongify(self);
        int customerPoint = curCustomer.cowPoint;
        //赔率
        NSArray *xz_array = [PublicHttpTool shareInstance].curXz_setting;
        //超级翻倍
        NSDictionary *fplDict = xz_array[2][@"fpl"];
        NSDictionary *fyjDict = xz_array[2][@"fyj"];
        
        //翻倍
        NSDictionary *fplDict1 = xz_array[1][@"fpl"];
        NSDictionary *fyjDict1 = xz_array[1][@"fyj"];
        
        //平倍
        NSDictionary *fplDict2 = xz_array[0][@"fpl"];
        NSDictionary *fyjDict2 = xz_array[0][@"fyj"];
        curCustomer.isCow_customerWin = isWin;
        if (isWin) {
            CGFloat realZhuangValue = (1-[[fyjDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangValue floatValue];
            if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                curCustomer.superValue = [NSString stringWithFormat:@"%d",(int)realZhuangValue];
            }else{
                curCustomer.superValue = [NSString stringWithFormat:@"%.2f",realZhuangValue];
            }
            //翻倍
            CGFloat realDoubleValue = (1-[[fyjDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangDuiValue floatValue];
            if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                curCustomer.doubleValue = [NSString stringWithFormat:@"%d",(int)realDoubleValue];
            }else{
                curCustomer.doubleValue = [NSString stringWithFormat:@"%.2f",realDoubleValue];
            }
            
            //平倍
            CGFloat realNormalValue = (1-[[fyjDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.xianValue floatValue];
            if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                curCustomer.normalValue = [NSString stringWithFormat:@"%d",(int)realNormalValue];
            }else{
                curCustomer.normalValue = [NSString stringWithFormat:@"%.2f",realNormalValue];
            }
        }else{
            CGFloat realZhuangValue = [[fplDict objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.zhuangValue floatValue];
            if (realZhuangValue>0) {
                curCustomer.superValue = [NSString stringWithFormat:@"-%.f",realZhuangValue];
            }else{
                curCustomer.superValue = @"0";
            }
            //翻倍
            CGFloat realDoubleValue = [[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.zhuangDuiValue floatValue];
            if (realDoubleValue>0) {
                curCustomer.doubleValue = [NSString stringWithFormat:@"-%.f",realDoubleValue];
            }else{
                curCustomer.doubleValue = @"0";
            }
            
            //平倍
            CGFloat realNormalValue = [[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.xianValue floatValue];
            if (realNormalValue>0) {
                curCustomer.normalValue = [NSString stringWithFormat:@"-%.f",realNormalValue];
            }else{
                curCustomer.normalValue = @"0";
            }
        }
         [self.collectionView reloadData];
    };
}

#pragma mark - 根据点数计算赔率
- (void)CalcuteCowWithPointForIndex:(NSInteger)indexRow{
    if ([PublicHttpTool shareInstance].cowPoint==99) {
        [[EPToast makeText:@"请先选择庄家点数"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return;
    }
    EPCowPointChooseShowView *cowPointShowView = [[AppDelegate shareInstance]cowPointShowView];
    [[MJPopTool sharedInstance] popView:cowPointShowView animated:YES];
    @weakify(self);
    cowPointShowView.pointsResultBlock = ^(int curPoint) {
        @strongify(self);
        int customerPoint = 0;
        if (curPoint!=99) {
            customerPoint = curPoint;
        }
        CustomerInfo *curCustomer = self.customerInfoList[indexRow];
        curCustomer.cowPoint = customerPoint;
        if (curPoint==99) {
            curCustomer.cowPointValue = @"没牛";
        }else if (curPoint==10){
            curCustomer.cowPointValue = @"牛牛";
        }else if (curPoint==11){
            curCustomer.cowPointValue = @"五花牛";
        }else if (curPoint==12){
            curCustomer.cowPointValue = @"炸弹";
        }else if (curPoint==13){
            curCustomer.cowPointValue = @"五小牛";
        }else{
            curCustomer.cowPointValue = [NSString stringWithFormat:@"%d",curPoint];
        }
        
        if ([PublicHttpTool shareInstance].cowPoint==customerPoint) {
            [self cowResultShowWithCustomer:curCustomer];
        }else{
            //赔率
           NSArray *xz_array = [PublicHttpTool shareInstance].curXz_setting;
           //超级翻倍
           NSDictionary *fplDict = xz_array[2][@"fpl"];
           NSDictionary *fyjDict = xz_array[2][@"fyj"];
            
            //翻倍
            NSDictionary *fplDict1 = xz_array[1][@"fpl"];
            NSDictionary *fyjDict1 = xz_array[1][@"fyj"];
            
            //平倍
            NSDictionary *fplDict2 = xz_array[0][@"fpl"];
            NSDictionary *fyjDict2 = xz_array[0][@"fyj"];
            
           if ([PublicHttpTool shareInstance].cowPoint>customerPoint) {//庄家赢
               curCustomer.isCow_customerWin = NO;
               CGFloat superValue = [[fplDict objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.zhuangValue floatValue];
               if (superValue>0) {
                   curCustomer.superValue = [NSString stringWithFormat:@"-%.f",superValue];
               }else{
                   curCustomer.superValue = @"0";
               }
               
               CGFloat doubleValue = [[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.zhuangDuiValue floatValue];
               if (doubleValue>0) {
                   curCustomer.doubleValue = [NSString stringWithFormat:@"-%.f",doubleValue];
               }else{
                   curCustomer.doubleValue = @"0";
               }
               
               CGFloat normalValue = [[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue]*[curCustomer.xianValue floatValue];
               if (normalValue>0) {
                   curCustomer.normalValue = [NSString stringWithFormat:@"-%.f",normalValue];
               }else{
                   curCustomer.normalValue = @"0";
               }
           }else if ([PublicHttpTool shareInstance].cowPoint<customerPoint){//闲家赢,需要减去佣金
               curCustomer.isCow_customerWin = YES;
               CGFloat superValue = (1-[[fyjDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangValue floatValue];
               
               CGFloat doubleValue = (1-[[fyjDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.zhuangDuiValue floatValue];
               
               CGFloat normalValue = (1-[[fyjDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0)*[[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue]*[curCustomer.xianValue floatValue];
               
               if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                   curCustomer.superValue = [NSString stringWithFormat:@"%d",(int)superValue];
                   curCustomer.doubleValue = [NSString stringWithFormat:@"%d",(int)doubleValue];
                   curCustomer.normalValue = [NSString stringWithFormat:@"%d",(int)normalValue];
               }else{
                   curCustomer.superValue = [NSString stringWithFormat:@"%.2f",superValue];
                   curCustomer.doubleValue = [NSString stringWithFormat:@"%.2f",doubleValue];
                   curCustomer.normalValue = [NSString stringWithFormat:@"%.2f",normalValue];
               }
           }
            [self.collectionView reloadData];
        }
    };
}

#pragma mark --清除金额
- (void)clearMoney{
    [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *customerInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        customerInfo.zhuangValue = @"";
        customerInfo.zhuangDuiValue = @"";
        customerInfo.xianValue = @"";
        customerInfo.superValue = @"";
        customerInfo.doubleValue = @"";
        customerInfo.normalValue = @"";
        customerInfo.cowPointValue = @"录入点数";
        customerInfo.cowPoint = 99;
    }];
    [self.collectionView reloadData];
}

#pragma mark - 封装参数
- (BOOL)fengzhuangCustomerInfo{
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
    //点数
    NSMutableArray *fdianshu_list = [NSMutableArray array];
    self.param_list = [NSMutableArray array];
    
    //赔率
      NSArray *xz_array = [PublicHttpTool shareInstance].curXz_setting;
      //超级翻倍
      NSDictionary *fplDict = xz_array[2][@"fpl"];
      NSDictionary *fyjDict = xz_array[2][@"fyj"];
       
       //翻倍
       NSDictionary *fplDict1 = xz_array[1][@"fpl"];
       NSDictionary *fyjDict1 = xz_array[1][@"fyj"];
       
       //平倍
       NSDictionary *fplDict2 = xz_array[0][@"fpl"];
       NSDictionary *fyjDict2 = xz_array[0][@"fyj"];
    
    __block BOOL hasCustomerNOCalu = NO;
    [self.customerInfoList enumerateObjectsUsingBlock:^(CustomerInfo *curCustomer, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([curCustomer.zhuangValue integerValue]==0&&[curCustomer.zhuangDuiValue integerValue]==0&&[curCustomer.xianValue integerValue]==0) {
        }else{
            if (curCustomer.cowPoint==99) {
                hasCustomerNOCalu = YES;
            }else{
                //赔率
                CGFloat odds = 0;
                CGFloat yj = 0;
                int customerPoint = curCustomer.cowPoint;
                if ([curCustomer.zhuangValue integerValue]!=0) {
                    
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                    [fxz_money_list addObject:curCustomer.zhuangValue];
                    [fxz_name_list addObject:@"超级翻倍"];
                    [fdianshu_list addObject:[NSNumber numberWithInt:curCustomer.cowPoint]];
                    if (curCustomer.isCow_customerWin) {//闲家赢
                        [fsy_list addObject:[NSNumber numberWithInt:1]];
                        
                        odds = [[fplDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue];
                        yj = [[fyjDict objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0;
                        CGFloat resultValue = (1+odds-yj*odds)*[curCustomer.zhuangValue integerValue];
                        if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                            [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                        }else{
                            [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                        }
                        CGFloat yjValue = yj*[curCustomer.zhuangValue integerValue];
                        [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                    }else{//庄家赢
                        [fsy_list addObject:[NSNumber numberWithInt:-1]];
                        
                        odds = [[fplDict objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue];
                        CGFloat resultValue = odds*[curCustomer.zhuangValue integerValue];
                        [fresult_list addObject:[NSString stringWithFormat:@"%.f",resultValue]];
                        [fyj_list addObject:[NSNumber numberWithDouble:0]];
                    }
                    [self fengzhuangChipTypeWith:curCustomer];
                }
                
                if ([curCustomer.zhuangDuiValue integerValue]!=0) {
                    
                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                    [fxz_money_list addObject:curCustomer.zhuangDuiValue];
                    [fxz_name_list addObject:@"翻倍"];
                    [fdianshu_list addObject:[NSNumber numberWithInt:curCustomer.cowPoint]];
                    if (curCustomer.isCow_customerWin) {//闲家赢
                        [fsy_list addObject:[NSNumber numberWithInt:1]];
                        
                        odds = [[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue];
                        yj = [[fyjDict1 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0;
                        CGFloat resultValue = (1+odds-yj*odds)*[curCustomer.zhuangDuiValue integerValue];
                        if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                            [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                        }else{
                            [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                        }
                        CGFloat yjValue = yj*[curCustomer.zhuangDuiValue integerValue];
                        [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                    }else{
                        [fsy_list addObject:[NSNumber numberWithInt:-1]];
                        
                        odds = [[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue];
                        CGFloat resultValue = odds*[curCustomer.zhuangDuiValue integerValue];
                        [fresult_list addObject:[NSString stringWithFormat:@"%.f",resultValue]];
                        [fyj_list addObject:[NSNumber numberWithDouble:0]];
                    }
                    [self fengzhuangChipTypeWith:curCustomer];
                }
                
                if ([curCustomer.xianValue integerValue]!=0) {

                    [fxmh_list addObject:[curCustomer.washNumberValue NullToBlankString]];
                    [fxz_money_list addObject:curCustomer.xianValue];
                    [fxz_name_list addObject:@"平倍"];
                    [fdianshu_list addObject:[NSNumber numberWithInt:curCustomer.cowPoint]];
                    if (curCustomer.isCow_customerWin) {//闲家赢
                        [fsy_list addObject:[NSNumber numberWithInt:1]];
                        
                        odds = [[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]floatValue];
                        yj = [[fyjDict2 objectForKey:[NSString stringWithFormat:@"%d",customerPoint]]intValue]/100.0;
                        CGFloat resultValue = (1+odds-yj*odds)*[curCustomer.xianValue integerValue];
                        if (curCustomer.cashType==0||curCustomer.cashType==2||curCustomer.cashType==4||curCustomer.cashType==5) {
                            [fresult_list addObject:[NSString stringWithFormat:@"%d",(int)resultValue]];
                        }else{
                            [fresult_list addObject:[NSString stringWithFormat:@"%.2f",resultValue]];
                        }
                        CGFloat yjValue = yj*[curCustomer.xianValue integerValue];
                        [fyj_list addObject:[NSNumber numberWithInt:ceil(yjValue)]];
                    }else{
                        [fsy_list addObject:[NSNumber numberWithInt:-1]];
                        
                        odds = [[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].cowPoint]]floatValue];
                        CGFloat resultValue = odds*[curCustomer.xianValue integerValue];
                        [fresult_list addObject:[NSString stringWithFormat:@"%.f",resultValue]];
                        [fyj_list addObject:[NSNumber numberWithDouble:0]];
                    }
                    [self fengzhuangChipTypeWith:curCustomer];
                }
            }
        }
    }];
    if (hasCustomerNOCalu) {
        [[EPToast makeText:@"有客人未选择点数计算结果"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return NO;
    }
    if ([PublicHttpTool shareInstance].cowPoint==99) {
        [[EPToast makeText:@"请选择庄家点数"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return NO;
    }
    [self.param_list addObject:fxmh_list];
    [self.param_list addObject:self.fxz_cmtype_list];
    [self.param_list addObject:fxz_money_list];
    [self.param_list addObject:fxz_name_list];
    [self.param_list addObject:fsy_list];
    [self.param_list addObject:fresult_list];
    [self.param_list addObject:fyj_list];
    [self.param_list addObject:fdianshu_list];
    [PublicHttpTool shareInstance].paramList = self.param_list;
    return YES;
}

@end
