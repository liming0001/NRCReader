//
//  PublicHttpTool.m
//  NFCReader
//
//  Created by 李黎明 on 2020/6/10.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "PublicHttpTool.h"
#import "NRUpdateInfo.h"

static PublicHttpTool * _instance = nil;

@interface PublicHttpTool ()

@property(nonatomic ,strong)NSTimer  * pingTimer;///心跳定时器

@end

@implementation PublicHttpTool

#pragma mark - 对象实例化
+ (instancetype)shareInstance{
    if(_instance){///之所以多次一举是觉得每次都调用allocWithZone方法会浪费时间
        return _instance;
    }else{
        return  [[self alloc]init];
    }
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            _instance.curupdateInfo = [[NRUpdateInfo alloc]init];
            _instance.xueciCount = 1;
            _instance.puciCount = 0;
            _instance.prePuciCount = 1;
            _instance.authorName = @"";
            _instance.guestName = @"";
            _instance.fcredit = @"";
        }
    });
    return _instance;
}

+ (void)showWaitingView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate shareInstance].window animated:YES];
    hud.layer.zPosition = 100;
    [hud hideAnimated:YES afterDelay:10];
}

+ (void)hideWaitingView {
    [MBProgressHUD hideHUDForView:[AppDelegate shareInstance].window animated:YES];
}

+ (void)showSoundMessage:(NSString *)message {
    NSString *messgae = [message NullToBlankString];
    if (messgae.length == 0) {
        messgae = @"网络异常";
    }
    [[EPToast makeText:messgae WithError:YES]showWithType:ShortTime];
    //响警告声音
    [EPSound playWithSoundName:@"wram_sound"];
    [self hideWaitingView];
}

+ (void)showSucceedSoundMessage:(NSString *)message {
    NSString *messgae = [message NullToBlankString];
    [[EPToast makeText:messgae WithError:NO]showWithType:ShortTime];
    //响警告声音
    [EPSound playWithSoundName:@"succeed_sound"];
    [self hideWaitingView];
}

#pragma mark -- 清除所有判断条件
- (void)clearAllCheckConditions{
    self.isShaZhuOperation = NO;
    self.recordTips = NO;
    self.exchangeMoneyFirstStep = NO;
    self.detectionChip = NO;
}

#pragma  mark - 心跳定时器
- (void)startPingTimer{
    if (_instance) {
        _instance.pingTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(pingTimerAction) userInfo:nil repeats:true];
        /** 防止强引用 */
        [[NSRunLoop currentRunLoop] addTimer:_instance.pingTimer forMode:NSRunLoopCommonModes];
        [_instance.pingTimer fire];
    }
}

- (void)stopPingTimer{
    [_pingTimer invalidate];
    _pingTimer = nil;
}

- (void)pingTimerAction{
    [self heartRateComd];
}

#pragma mark - 心跳包
- (void)heartRateComd{
    NSDictionary * param = @{
            @"access_token":[PublicHttpTool shareInstance].access_token,
            @"femp_num":[PublicHttpTool shareInstance].femp_num//用户ID
    };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"employee_heartbeat",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
    }];
}

#pragma mark -- 是否开启了新一局
+ (BOOL)canStepToNextStep{
    DLOG(@"[PublicHttpTool shareInstance].puciCount==%d,[PublicHttpTool shareInstance].prePuciCount==%d",[PublicHttpTool shareInstance].puciCount,[PublicHttpTool shareInstance].prePuciCount);
    if (([PublicHttpTool shareInstance].puciCount != [PublicHttpTool shareInstance].prePuciCount)||[PublicHttpTool shareInstance].puciCount==0) {
        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark -- 选择开结果
+ (BOOL)chooseKaipaiResult{
    if ([PublicHttpTool shareInstance].curupdateInfo.cp_name.length==0) {
        [[EPToast makeText:@"请选择开牌结果"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark -- 提交开牌结果
+ (BOOL)commitKaipaiResult{
    if ([PublicHttpTool shareInstance].cp_tableIDString.length==0) {
        [[EPToast makeText:@"请先提交开牌结果"]showWithType:ShortTime];
        //响警告声音
        [EPSound playWithSoundName:@"wram_sound"];
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)socketNoConnectedShow{
    [EPSound playWithSoundName:@"click_sound"];
    if ([SGSocketManager SocketConnectState]!=SGSocketConnectState_ConnectSuccess&&![PublicHttpTool shareInstance].isAutoOrManual) {
        [[EPToast makeText:@"未连接上设备，请检查设备网络或IP地址是否对应" WithError:YES] showWithType:ShortTime];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 换桌
+ (void)otherTableWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fid":[PublicHttpTool shareInstance].fid//桌子ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Table_hbhz",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 获取当前台桌状态
+ (void)tableStateWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftableid":[PublicHttpTool shareInstance].fid//桌子ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Table_getTableState",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 上传最新靴次
+ (void)postNewxueciWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"new_xueci":[PublicHttpTool shareInstance].curupdateInfo.cp_xueci,
                             @"table_id":[PublicHttpTool shareInstance].fid//桌子ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_postNewxueci",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 提交日结
+ (void)commitDailyWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftable_id":[PublicHttpTool shareInstance].fid,//桌子ID
                             @"frjdate":[PublicHttpTool shareInstance].cp_tableRijieDate,//日期
                             @"femp_num":[PublicHttpTool shareInstance].curupdateInfo.femp_num,//管理员登录账号
                             @"femp_pwd":[PublicHttpTool shareInstance].curupdateInfo.femp_pwd,//登录密码
                             @"fhg_id":[PublicHttpTool shareInstance].curupdateInfo.fhg_id//荷官ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"tablerec_rijie",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 获取当前台桌的靴次
+ (void)getLastXueCiInfoWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"table_id":[PublicHttpTool shareInstance].fid,
                             @"date":[PublicHttpTool shareInstance].cp_tableRijieDate//日期
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_getXueci",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 获取露珠
+ (void)getLuzhuWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftable_id":[PublicHttpTool shareInstance].fid,//桌子ID
                             @"rjdate":[PublicHttpTool shareInstance].cp_tableRijieDate,//日期
                             @"fxueci":[PublicHttpTool shareInstance].curupdateInfo.cp_xueci//靴次
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"tablerec_luzhu",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_Public_ListWithParamter:Realparam block:^(NSArray *list, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, list,msg);
    }];
}

#pragma mark - 提交开牌结果
+ (void)commitkpResultWithBlock:(PublicHttpResponseBlock)block{
    
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftable_id":[PublicHttpTool shareInstance].fid,//桌子ID
                             @"fxueci":[PublicHttpTool shareInstance].curupdateInfo.cp_xueci,//靴次
                             @"fpuci":[PublicHttpTool shareInstance].curupdateInfo.cp_puci,//铺次
                             @"fpcls":[PublicHttpTool shareInstance].cp_Serialnumber,//铺次流水号，长度不超过20位，要求全局唯一
                             @"fkpresult":[PublicHttpTool shareInstance].curupdateInfo.cp_name,//结果
                             @"frjdate":[PublicHttpTool shareInstance].cp_tableRijieDate
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_kpResult",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            [PublicHttpTool shareInstance].cp_tableIDString = responseString;
        }
        block(suc, responseString,msg);
    }];
}

#pragma mark - 检测筹码是否正确
+ (void)checkChipIsTrueWithChipList:(NSArray *)chipList Block:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fhardlist":chipList
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Table_cmReadAmount",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 打散筹码
+ (void)changeChipWashNumberWithChipList:(NSArray *)chipList WashNumber:(NSString *)washNumber ChangChipList:(NSArray *)changeChipList Block:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fxmh":washNumber,
                             @"fhardid":chipList,
                             @"fhardid_list":changeChipList
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_change",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 台面操作记录列表
+ (void)queryOperate_listWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftable_id":[PublicHttpTool shareInstance].fid//桌子ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"table_operate_list",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 查看台面数据
+ (void)queryTableDataWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftable_id":[PublicHttpTool shareInstance].fid,//桌子ID
                             @"fxueci":[PublicHttpTool shareInstance].curupdateInfo.cp_xueci,
                             @"frjdate":[PublicHttpTool shareInstance].cp_tableRijieDate,//日期
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"table_tmsj",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 验证账号
+ (void)authorizationAccountWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"femp_num":[PublicHttpTool shareInstance].curupdateInfo.femp_num,
                             @"femp_pwd":[PublicHttpTool shareInstance].curupdateInfo.femp_pwd
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"employee_chkadmin",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 清空露珠
+ (void)clearLuzhuWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftable_id":[PublicHttpTool shareInstance].fid//桌子ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"tablerec_luzhu_clean",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 提交小费
+ (void)commitTipResultWithBlock:(PublicHttpResponseBlock)block{
    NSArray *chipList = [NSArray array];
    if ([PublicHttpTool shareInstance].curupdateInfo.cp_xiaofeiList.count!=0) {
        chipList = [PublicHttpTool shareInstance].curupdateInfo.cp_xiaofeiList;
    }
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fhardlist":chipList,//实付筹码，硬件ID值数组
                             @"fid":[PublicHttpTool shareInstance].curupdateInfo.fhg_id//结果
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_xf",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 获取客人输赢
+ (void)Customer_getWinlossWithWashNumber:(NSString *)washNumber Block:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fxmh":washNumber
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Customer_getWinloss",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict,NSString *msg,EPSreviceError error,BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 提交客人输赢记录和台桌流水记录(手动版)
+ (void)commitCustomerRecordWithBlock:(PublicHttpResponseBlock)block{
    NSArray *list = [PublicHttpTool shareInstance].paramList;
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftbrec_id":[PublicHttpTool shareInstance].cp_tableIDString,//桌子ID
                             @"fxmh_list":list[0],//客人洗码号
                             @"fxz_cmtype_list":list[1],//客人下注的筹码类型
                             @"fxz_money_list":list[2],//客人下注的本金
                             @"fxz_name_list":list[3],//下注名称，如庄、闲、庄对子…
                             @"fsy_list":list[4],//输赢
                             @"fresult_list":list[5],//总码
                             @"fyj_list":list[6]//佣金
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_tjsyjl",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, responseString,msg);
    }];
}

#pragma mark - 修改客人洗码号
+ (void)updateCustomerWashNumberWithChipList:(NSArray *)chipList CurWashNumber:(NSString *)washNumber Block:(PublicHttpResponseBlock)block{
NSDictionary * param = @{
                         @"access_token":[PublicHttpTool shareInstance].access_token,
                         @"hard_id_list":chipList,
                         @"table_name":[PublicHttpTool shareInstance].tableName,
                         @"table_id":[PublicHttpTool shareInstance].fid,
                         @"femp_num":[PublicHttpTool shareInstance].curupdateInfo.femp_num,
                         @"new_xmh":washNumber
                         };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_editXmh",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 提交客人输赢记录和台桌流水记录(自动)
+ (void)commitCustomerRecord_AutoWithBlock:(PublicHttpResponseBlock)block{
    NSArray *dashuiList = [NSArray array];
    NSArray *chipList = [NSArray array];
    NSArray *zhaohuiList = [NSArray array];
    if ([PublicHttpTool shareInstance].curupdateInfo.cp_ChipUidList.count!=0) {
        chipList = [PublicHttpTool shareInstance].curupdateInfo.cp_ChipUidList;
    }
    if ([PublicHttpTool shareInstance].curupdateInfo.cp_zhaohuiList.count!=0) {
        zhaohuiList = [PublicHttpTool shareInstance].curupdateInfo.cp_zhaohuiList;
    }
    if ([[PublicHttpTool shareInstance].curupdateInfo.cp_result isEqualToString:@"1"]) {
        if ([PublicHttpTool shareInstance].curupdateInfo.cp_DashuiUidList.count!=0) {
            dashuiList = [PublicHttpTool shareInstance].curupdateInfo.cp_DashuiUidList;
        }
    }
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftbrec_id":[PublicHttpTool shareInstance].fid,//桌子ID
                             @"fxmh":[PublicHttpTool shareInstance].curupdateInfo.cp_washNumber,//客人洗码号
                             @"fxz_cmtype":[PublicHttpTool shareInstance].curupdateInfo.cp_chipType,//客人下注的筹码类型
                             @"fxz_money":[PublicHttpTool shareInstance].curupdateInfo.cp_benjin,//客人下注的本金
                             @"fxz_name":[PublicHttpTool shareInstance].curupdateInfo.cp_Result_name,//下注名称，如庄、闲、庄对子…
                             @"fbeishu":[PublicHttpTool shareInstance].curupdateInfo.cp_beishu,//倍数，如果杀注50%填0.5
                             @"fdianshu":[PublicHttpTool shareInstance].curupdateInfo.cp_dianshu,//牛牛点数，非牛牛游戏传-1
                             @"fsy":[PublicHttpTool shareInstance].curupdateInfo.cp_result,//判断客人的输赢：1为赢，-1为输，0为不杀不赔
                             @"fresult":[PublicHttpTool shareInstance].curupdateInfo.cp_money,//应付额
                             @"fzhaohui":zhaohuiList,//找回z筹码
                             @"fyj":@"0",//佣金
                             @"fhardlist":chipList,//实付筹码，硬件ID值数组
                             @"fdashui":dashuiList//打水筹码，硬件ID值数组
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_szpf",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, responseString,msg);
    }];
}

#pragma mark - 提交客人输赢记录和台桌流水记录(杀注,自动)
+ (void)commitCustomerRecord_ShaZhuWithWashNumberList:(NSArray *)washNumberArray Block:(PublicHttpResponseBlock)block{
    NSArray *chipList = [NSArray array];
    NSArray *zhaohuiList = [NSArray array];
    NSArray *washNumberList = [NSArray array];
    if ([PublicHttpTool shareInstance].curupdateInfo.cp_ChipUidList.count!=0) {
        chipList = [PublicHttpTool shareInstance].curupdateInfo.cp_ChipUidList;
    }
    if ([PublicHttpTool shareInstance].curupdateInfo.cp_zhaohuiList.count!=0) {
        zhaohuiList = [PublicHttpTool shareInstance].curupdateInfo.cp_zhaohuiList;
    }
    if (washNumberArray.count!=0) {
        washNumberList = washNumberArray;
    }
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftbrec_id":[PublicHttpTool shareInstance].fid,//桌子ID
                             @"fxmh_list":washNumberList,//客人洗码号
                             @"fxz_name":[PublicHttpTool shareInstance].curupdateInfo.cp_Result_name,//客人下注名称，如庄、闲、庄对子…
                             @"fbeishu":[PublicHttpTool shareInstance].curupdateInfo.cp_beishu,//倍数，如果杀注50%填0.5
                             @"fdianshu":@"0",//牛牛点数，非牛牛游戏传-1
                             @"fhardlist":chipList,//实付筹码，硬件ID值数组
                             @"fresult":[PublicHttpTool shareInstance].curupdateInfo.cp_money,//应付额
                             @"fzhaohuilist":zhaohuiList//打水筹码，硬件ID值数组
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_kill",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, responseString,msg);
    }];
}

#pragma mark - 根据洗码号获取用户信息
+ (void)getInfoByXmh:(NSString *)washNumber WithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{
        @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fxmh":washNumber
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Customer_getInfoByXmh",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

#pragma mark - 修改露珠
+ (void)updateLuzhuInfoRecordWithBlock:(PublicHttpResponseBlock)block{
    NSArray *paramList = @[[PublicHttpTool shareInstance].updateParam];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_luzhu_edit",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, responseString,msg);
    }];
}

#pragma mark -- 获取筹码面额
+ (void)getChipTypeWithBlock:(PublicHttpResponseBlock)block{
    NSDictionary * param = @{@"access_token":[PublicHttpTool shareInstance].access_token};
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmtypeme_getAllMe",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, [NSDictionary changeType:responseDict],msg);
    }];
}

@end
