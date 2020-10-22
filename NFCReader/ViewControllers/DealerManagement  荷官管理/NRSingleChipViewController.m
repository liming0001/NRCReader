//
//  NRSingleChipViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2020/9/20.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRSingleChipViewController.h"
#import "BLEIToll.h"
#import "EPService.h"
#import "NRChipSingleCell.h"
#import "NRSingleChipHeade.h"
#import "NRSingleBtnFooter.h"

@interface NRSingleChipViewController ()<UITableViewDelegate,UITableViewDataSource,SGSocketManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *chipInfoList;

@property (nonatomic, assign) BOOL isReadChip;//是否读取筹码
@property (nonatomic, assign) BOOL isSetUpDeviceModel;//设置读写器模式
@property (nonatomic, strong) NSMutableData *chipUIDData;
@property (nonatomic, assign) NSInteger chipCount;
@property (nonatomic, strong) NSArray *chipUIDList;
@property (nonatomic, strong) NSMutableArray *addOtherUIDList;//继续加码
@property (nonatomic, assign) BOOL isAddChipAgain;//是否继续
@property (nonatomic, assign) int lastCacheMoney;
@property (nonatomic, strong) NRSingleChipHeade *singleHeader;
@property (nonatomic, strong) NRSingleBtnFooter *singleFooter;

@property (nonatomic, strong) NSMutableArray *chipTempInfoList;
 
@end

@implementation NRSingleChipViewController

- (NRSingleChipHeade *)singleHeader{
    if (!_singleHeader) {
        _singleHeader = [[NRSingleChipHeade alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    }
    return _singleHeader;
}

- (NRSingleBtnFooter *)singleFooter{
    if (!_singleFooter) {
        _singleFooter = [[NRSingleBtnFooter alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    }
    return _singleFooter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addOtherUIDList = [NSMutableArray arrayWithCapacity:0];
    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    self.chipTempInfoList = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#393939"];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(0);
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    [self.tableView registerClass:[NRChipSingleCell class] forCellReuseIdentifier:@"NRChipSingleCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSArray *list = self.infoDict[@"chipList"];
    self.singleHeader.height = (list.count +1)*61+60+10+60;
    [self.singleHeader fellHeaderWithInfoDict:self.infoDict];
    self.tableView.tableHeaderView = self.singleHeader;
    self.tableView.tableFooterView = self.singleFooter;
    //连接Socket
    [self openOrCloseSocket];
    
    @weakify(self);
    self.singleFooter.btnActionBlock = ^(int btnTag) {
        @strongify(self);
        if (btnTag==1) {//继续加彩
            [self _resetAllOpretionConditions];
            [self readCurDeviceChipNumbers];
        }else{
            if (self.tranChipUIDListBlock) {
                self.tranChipUIDListBlock(self.addOtherUIDList);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#393939"];
    [self.titleBar setTitle:@"VM娱乐筹码管理"];
    [self setLeftItemForGoBack];
    self.titleBar.showBottomLine = YES;
    [self configureTitleBarToBlack];
}

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell.reuseIdentifier isEqualToString:@"NRChipSingleCell"]){
        NSDictionary *chipDict = self.chipInfoList[indexPath.row];
        NSString *chipTypeText = @"筹码类型";
        if ([chipDict[@"fcmtype_id"] intValue]==1) {//人民币码
            chipTypeText = @"人民币码";
        }else if ([chipDict[@"fcmtype_id"] intValue]==2){//美金码
            chipTypeText = @"美金码";
        }else if ([chipDict[@"fcmtype_id"] intValue]==6){//人民币
            chipTypeText = @"人民币";
        }else if ([chipDict[@"fcmtype_id"] intValue]==7){//美金
            chipTypeText = @"美金";
        }else if ([chipDict[@"fcmtype_id"] intValue]==8){//RMB贵宾码
            chipTypeText = @"RMB贵宾码";
        }else if ([chipDict[@"fcmtype_id"] intValue]==9){//USD贵宾码
            chipTypeText = @"USD贵宾码";
        }
        NSString *chipMoneyText = [NSString stringWithFormat:@"%@",chipDict[@"fme"]];
        if ([chipMoneyText intValue]==0) {
            chipMoneyText = @"筹码金额";
        }
        NSString *chipNumText = [NSString stringWithFormat:@"%@",chipDict[@"fnums"]];
        if ([chipNumText intValue]==0) {
            chipNumText = @"筹码数量";
        }
        NSString *chipMoney = chipMoneyText;
        NSString *chipNum = chipNumText;
        NRChipSingleCell *newCell = (NRChipSingleCell *)cell;
        [newCell configureWithChipTypeLabText:chipTypeText ChipNumsText:chipNum DenominationText:chipMoney];
    }
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chipInfoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01; // ios9 need > 0
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01; // ios9 need > 0
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NRChipSingleCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"NRChipSingleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NRSingleChipViewController *VC = [[NRSingleChipViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -- 开启或者关闭Sockket
- (void)openOrCloseSocket{
    [EPAppData sharedInstance].bind_ip = @"192.168.1.192";
    [EPAppData sharedInstance].bind_port = 6000;
    [SGSocketManager ConnectSocketWithConfigM:[SGSocketConfigM ShareInstance] complation:^(NSError *error) {
        DLOG(@"error===%@",error);
        if (!error) {
            [self closeDeviceWorkModel];
        }
    }];
    [SGSocketManager shareInstance].delegate = self;
    [[SGSocketManager shareInstance] startPingTimer];//开启心跳
}

#pragma mark -- 重置所有操作判断条件
- (void)_resetAllOpretionConditions{
    self.isReadChip = NO;
    self.isSetUpDeviceModel = NO;
}

#pragma mark -- 识别当前筹码个数
- (void)readCurDeviceChipNumbers{
    if (![PublicHttpTool socketNoConnectedShow]) {
        return;
    }
    [PublicHttpTool showWaitingView];
    self.chipUIDList = nil;
    self.chipUIDData = nil;
    self.isReadChip = YES;
    //查询筹码个数
    [SGSocketManager SendDataWithData:[NRCommand nextQueryChipNumbers]];
}

#pragma mark - 读取筹码信息
- (void)readAllChipsInfo{
    self.chipUIDData = nil;
    for (int i = 0; i < self.chipUIDList.count; i++) {
        NSString *chipID = self.chipUIDList[i];
        [SGSocketManager SendDataWithData:[NRCommand readAllSelectNumbersInfoWithChipUID:chipID]];
        usleep((int)self.chipUIDList.count * 10000);
    }
}

#pragma mark -- 判断数据是否正确
- (BOOL)canReadNextWithData:(NSData *)data{
    if (!self.chipUIDData) {
        self.chipUIDData = [NSMutableData data];
    }
    NSString *dataHexStr = [NRCommand hexStringFromData:data];
    if ([dataHexStr isEqualToString:@"050020a04feb"]) {
        return NO;
    }
    if ([dataHexStr isEqualToString:@"040000525a"]&&[SGSocketManager shareInstance].hasKeepLive) {
        [SGSocketManager shareInstance].hasKeepLive = NO;
        return NO;
    }
    return YES;
}

- (BOOL)isWorkModelOrPowerSetWithHex:(NSString *)hex{
    if (self.isSetUpDeviceModel) {
        return NO;
    }
    return YES;
}

- (BOOL)noChipInDeviceWithHex:(NSString *)hex{
    hex = [hex stringByReplacingOccurrencesOfString:@"04000e2cb3" withString:@""];
    hex = [hex stringByReplacingOccurrencesOfString:@"040000525a" withString:@""];
    NSInteger count = [[hex mutableCopy] replaceOccurrencesOfString:@"0d000000" withString:@"0d000000"
       options:NSLiteralSearch
         range:NSMakeRange(0, [hex length])];
    if (count==0) {
        [PublicHttpTool showSoundMessage:@"未检测到筹码"];
        return NO;
    }
    return YES;
}

/**
 收到数据

 @param data <#data description#>
 @param tag <#tag description#>
 */
-(void)socketManagerSuccessToReceiveMsg:(NSData *)data withTag:(long)tag{
    DLOG(@"data = %@",data);
    if (![self canReadNextWithData:data]) {
        return;
    }
    //将数据存入缓存区
    [self.chipUIDData appendData:data];
    NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
    if (![self isWorkModelOrPowerSetWithHex:chipNumberdataHexStr]) {
        return;
    }
    BLEIToll *itool = [[BLEIToll alloc]init];
    if (self.isReadChip) {//正在识别筹码
        if ([chipNumberdataHexStr hasSuffix:@"04000e2cb3"]) {//检测到结束字符,识别筹码UID完毕
            self.isReadChip  = NO;
            if (![self noChipInDeviceWithHex:chipNumberdataHexStr]) {
                return;
            }
            //存贮筹码UID
            self.chipUIDList = [itool getDeviceAllChipUIDWithBLEString:chipNumberdataHexStr];
            [PublicHttpTool shareInstance].chipUIDList = self.chipUIDList;
            self.chipCount = self.chipUIDList.count;
            if (self.chipCount==0) {
                [PublicHttpTool showSoundMessage:@"未检测到筹码"];
                return;
            }
            [self.addOtherUIDList addObjectsFromArray:self.chipUIDList];
            [self readAllChipsInfo];
        }
    }else {
        NSInteger infoByteLength = 60 * self.chipCount;
        NSString *chipNumberdataHexStr = [NRCommand hexStringFromData:self.chipUIDData];
        chipNumberdataHexStr = [chipNumberdataHexStr stringByReplacingOccurrencesOfString:@"040000525a" withString:@""];
        if (infoByteLength>0&&(chipNumberdataHexStr.length==infoByteLength)) {//数据长度相同，筹码信息已经接受完毕
            //解析筹码
            NSArray *chipBleList = [itool chipInfoBaccrarWithBLEString:chipNumberdataHexStr];
            DLOG(@"chipBleList = %@",chipBleList);
            __block BOOL  hasCompanyChip = NO;//判断是否有公司筹码
            NSMutableArray *chipTypeList = [NSMutableArray array];
            [chipBleList enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *chipDict = [NSMutableDictionary dictionary];
                //类型
                NSString *chipType = [infoList[1] NullToBlankString];
                [chipDict setObject:chipType forKey:@"fcmtype_id"];
                if (![chipTypeList containsObject:chipType]) {
                    [chipTypeList addObject:chipType];
                }
                //面额
                NSString * realmoney = [NSString stringWithFormat:@"%lu",strtoul([infoList[2] UTF8String],0,16)];
                [chipDict setObject:realmoney forKey:@"fme"];
                [self.chipTempInfoList addObject:chipDict];
                //洗码号
                NSString *washNumber = [infoList[4] NullToBlankString];
                if (![washNumber isEqualToString:@"0"]) {
                    hasCompanyChip = YES;
                }
            }];
            [PublicHttpTool hideWaitingView];
            if (hasCompanyChip) {
                NSString *messageInfo = @"存在用户筹码，不能减彩!";
                if ([PublicHttpTool shareInstance].operationType==1||[PublicHttpTool shareInstance].operationType==3) {
                    messageInfo = @"存在用户筹码，不能加彩!";
                }else{
                    if ([PublicHttpTool shareInstance].operationType==0) {
                        messageInfo = @"存在用户筹码，不能开台!";
                    }
                }
                [self.chipTempInfoList removeAllObjects];
                [PublicHttpTool showSoundMessage:messageInfo];
                return;
            }
            if (chipTypeList.count>1) {
                [PublicHttpTool showSoundMessage:@"存在多种类型的筹码"];
                return;
            }
            NSArray *tempList = [self sortChipInfoList];
            [self.chipInfoList removeAllObjects];
            [tempList enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *chipInfoDict = [NSMutableDictionary dictionary];
                [chipInfoDict setObject:[NSString stringWithFormat:@"%ld",infoList.count] forKey:@"fnums"];
                [infoList enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                    [chipInfoDict setObject:dict[@"fcmtype_id"] forKey:@"fcmtype_id"];
                    [chipInfoDict setObject:dict[@"fme"] forKey:@"fme"];
                }];
                [self.chipInfoList addObject:chipInfoDict];
            }];
            DLOG(@"self.chipInfoList = %@",self.chipInfoList);
            [self.tableView reloadData];
        }
    }
}

- (NSArray *)sortChipInfoList{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.chipTempInfoList];
    NSMutableArray *dateMutablearray = [@[] mutableCopy];
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = array[i];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:dict];
        for (int j = i+1; j < array.count; j ++) {
            NSDictionary *jDict = array[j];
            if([dict isEqualToDictionary:jDict]){
                [tempArray addObject:jDict];
                [array removeObjectAtIndex:j];
                j -= 1;
                
            }
        }
        [dateMutablearray addObject:tempArray];
    }
    return dateMutablearray;
}

/**
 心跳事件，需实现此代理方法，自己组装心跳报文发送
 */
-(void)socketManagerPingTimerAction{
    [SGSocketManager shareInstance].hasKeepLive = YES;
    [SGSocketManager SendDataWithData:[NRCommand keepDeviceAlive]];
}

#pragma mark - 关闭设备自动感应
- (void)closeDeviceWorkModel{
    //设置感应盘工作模式
    [SGSocketManager SendDataWithData:[NRCommand setDeviceWorkModel]];
}

@end
