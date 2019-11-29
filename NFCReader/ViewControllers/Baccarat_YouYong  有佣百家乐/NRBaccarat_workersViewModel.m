//
//  NRBaccaratViewModel.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRBaccarat_workersViewModel.h"
#import "NRLoginInfo.h"
#import "NRTableInfo.h"
#import "NRUpdateInfo.h"
#import "NRGameInfo.h"
#import "JhPageItemModel.h"

@implementation NRBaccarat_workersViewModel

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo WithTableInfo:(NRTableInfo*)tableInfo WithNRGameInfo:(NRGameInfo *)gameInfo{
    self = [super init];
    self.curXueci = 1;
    self.loginInfo = loginInfo;
    self.curTableInfo = tableInfo;
    self.gameInfo = gameInfo;
    self.curupdateInfo = [NRUpdateInfo new];
    self.cp_fidString = @"";
    self.cp_tableIDString = @"";
    return self;
}

#pragma mark - 换桌
- (void)otherTableWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"fid":self.curTableInfo.fid//桌子ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Table_hbhz",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
        
    }];
}

#pragma mark - 提交客人输赢记录和台桌流水记录
- (void)commitCustomerRecordWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSArray *dashuiList = [NSArray array];
    NSArray *chipList = [NSArray array];
    if ([self.curupdateInfo.cp_result isEqualToString:@"1"]) {
        if (self.curupdateInfo.cp_DashuiUidList.count!=0) {
            dashuiList = self.curupdateInfo.cp_DashuiUidList;
        }
    }
    if (self.curupdateInfo.cp_ChipUidList.count!=0) {
        chipList = self.curupdateInfo.cp_ChipUidList;
    }
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"ftbrec_id":self.cp_tableIDString,//桌子ID
                             @"fpcls":[self.curupdateInfo.cp_Serialnumber NullToBlankString],//铺次流水号，长度不超过20位，要求全局唯一
                             @"fxmh":[self.curupdateInfo.cp_washNumber NullToBlankString],//客人洗码号
                             @"fxz_cmtype":[self.curupdateInfo.cp_chipType NullToBlankString],//客人下注的筹码类型
                             @"fxz_money":[self.curupdateInfo.cp_benjin NullToBlankString],//客人下注的本金
                             @"fxz_name":[self.curupdateInfo.cp_name NullToBlankString],//下注名称，如庄、闲、庄对子…
                             @"fbeishu":[self.curupdateInfo.cp_beishu NullToBlankString],//倍数，如果杀注50%填0.5
                             @"fdianshu":@"0",//牛牛点数，非牛牛游戏传0
                             @"fsy":[self.curupdateInfo.cp_result NullToBlankString],//判断客人的输赢：1为赢，-1为输，0为不杀不赔
                             @"fxf":@"0",//判断客人的输赢：1为赢，-1为输，0为不杀不赔
                             @"fresult":[self.curupdateInfo.cp_money NullToBlankString],//应付额
                             @"fyj":self.curupdateInfo.cp_commission,//佣金
                             @"fhardlist":chipList,//实付筹码，硬件ID值数组
                             @"fdashui":dashuiList//打水筹码，硬件ID值数组
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_szpf",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            self.cp_fidString = responseString;
        }
        block(suc, msg,error);
    }];
}

#pragma mark - 提交客人输赢记录和台桌流水记录(杀注)
- (void)commitCustomerRecord_ShaZhuWithWashNumberList:(NSArray *)washNumberArray Block:(EPFeedbackWithErrorCodeBlock)block{
    NSArray *chipList = [NSArray array];
    NSArray *washNumberList = [NSArray array];
    if (self.curupdateInfo.cp_ChipUidList.count!=0) {
        chipList = self.curupdateInfo.cp_ChipUidList;
    }
    if (washNumberArray.count!=0) {
        washNumberList = washNumberArray;
    }
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"ftbrec_id":self.cp_tableIDString,//桌子ID
                             @"fxueci":self.curupdateInfo.cp_xueci,//靴次
                             @"fpuci":self.curupdateInfo.cp_puci,//铺次
                             @"fpcls":self.curupdateInfo.cp_Serialnumber,//铺次流水号，长度不超过20位，要求全局唯一
                             @"fxmh_list":washNumberList,//客人洗码号
                             @"fxz_name":self.curupdateInfo.cp_Result_name,//客人下注名称，如庄、闲、庄对子…
                             @"fbeishu":self.curupdateInfo.cp_beishu,//倍数，如果杀注50%填0.5
                             @"fresult":self.curupdateInfo.cp_money,//应付额
                             @"fdianshu":@"0",//牛牛点数，非牛牛游戏传0
                             @"fhardlist":chipList,//实付筹码，硬件ID值数组
                             @"fzhaohuilist":[NSArray array]//找回筹码，硬件ID值数组
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_kill",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

#pragma mark - 提交开牌结果
- (void)commitkpResultWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"ftable_id":self.curTableInfo.fid,//桌子ID
                             @"fxueci":self.curupdateInfo.cp_xueci,//靴次
                             @"fpuci":self.curupdateInfo.cp_puci,//铺次
                             @"fpcls":[self.curupdateInfo.cp_Serialnumber NullToBlankString],//铺次流水号，长度不超过20位，要求全局唯一
                             @"fkpresult":[self.curupdateInfo.cp_name NullToBlankString],//结果
                             @"frjdate":[NRCommand getCurrentDate]//日期
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

#pragma mark - 获取当前台桌的靴次
- (void)getLastXueCiInfoWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"table_id":self.curTableInfo.fid,
                             @"date":[NRCommand getCurrentDate],//日期
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_getXueci",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        DLOG(@"responseDict===%@",responseDict);
        if (![responseDict[@"table"]isEqual:[NSNull null]]) {
            self.lastTableInfoDict = responseDict[@"table"];
            self.cp_tableIDString = self.lastTableInfoDict[@"fid"];
        }
        block(suc, msg,error);
        
    }];
}

#pragma mark - 检测筹码是否正确
- (void)checkChipIsTrueWithChipList:(NSArray *)chipList Block:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"fhardlist":chipList
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Table_cmReadAmount",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
        
    }];
}

#pragma mark - 修改客人洗码号
- (void)updateCustomerWashNumberWithChipList:(NSArray *)chipList CurWashNumber:(NSString *)washNumber Block:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"hard_id_list":chipList,
                             @"table_name":self.curTableInfo.ftbname,
                             @"table_id":self.curTableInfo.fid,
                             @"new_xmh":washNumber
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_editXmh",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
        
    }];
}

#pragma mark - 提交小费
- (void)commitTipResultWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSArray *chipList = [NSArray array];
    if (self.curupdateInfo.cp_xiaofeiList.count!=0) {
        chipList = self.curupdateInfo.cp_xiaofeiList;
    }
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"fhardlist":chipList,//实付筹码，硬件ID值数组
                             @"fid":[self.loginInfo.fid NullToBlankString]//结果
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_xf",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            self.cp_fidString = @"";
        }
        block(suc, msg,error);
        
    }];
}

#pragma mark - 清空露珠
- (void)clearLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSArray *chipList = [NSArray array];
    if (self.curupdateInfo.cp_xiaofeiList.count!=0) {
        chipList = self.curupdateInfo.cp_xiaofeiList;
    }
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"ftable_id":self.curTableInfo.fid//桌子ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"tablerec_luzhu_clean",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
        
    }];
}

- (void)resetCountStatus{
    self.zhuangCount=0;//庄赢次数
    self.zhuangDuiCount=0;//庄对赢次数
    self.sixCount=0;//6点赢次数
    self.xianCount=0;//闲赢次数
    self.xianDuiCount=0;//闲对赢次数
    self.heCount=0;//和赢次数
}

#pragma mark - 获取露珠
- (void)getLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSArray *chipList = [NSArray array];
    if (self.curupdateInfo.cp_xiaofeiList.count!=0) {
        chipList = self.curupdateInfo.cp_xiaofeiList;
    }
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"ftable_id":self.curTableInfo.fid,//桌子ID
                             @"rjdate":[NRCommand getCurrentDate],//日期
                             @"fxueci":self.curupdateInfo.cp_xueci//靴次
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"tablerec_luzhu",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_Public_ListWithParamter:Realparam block:^(NSArray *list, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            [self resetCountStatus];
            self.realLuzhuList = list;
            NSMutableArray *luzhuList = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(NSDictionary *luzhiDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *resultS =  luzhiDict[@"fkpresult"];
                NSArray *resultList = [resultS componentsSeparatedByString:@","];
                NSString *text = @"";
                NSString *img = @"";
                if (resultList.count==1) {
                    NSString *resultName = resultList[0];
                    if ([resultName isEqualToString:@"庄"]||[resultName isEqualToString:@"庄赢"]) {
                        if ([resultName isEqualToString:@"庄"]) {
                            self.zhuangCount +=1;
                        }
                        img = @"1";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 1;
                        [luzhuList addObject:model];
                    }else if ([resultName isEqualToString:@"闲"]||[resultName isEqualToString:@"闲赢"]){
                        if ([resultName isEqualToString:@"闲"]) {
                            self.xianCount +=1;
                        }
                        img = @"7";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 1;
                        [luzhuList addObject:model];
                    }else if ([resultName isEqualToString:@"和"]||[resultName isEqualToString:@"和局"]){
                        self.heCount +=1;
                        img = @"0";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 1;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }
                }else if (resultList.count==2){
                    if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]) {
                        self.zhuangCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"2";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 2;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"闲对"]){
                        self.zhuangCount+=1;
                        self.xianDuiCount+=1;
                        img = @"3";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 3;
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"6点赢"]){
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"1";
                        text = @"6";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 3;
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"闲对"]){
                        self.xianCount+=1;
                        self.xianDuiCount+=1;
                        img = @"6";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 4;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"庄对"]){
                        self.xianCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"5";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 5;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"庄对"]){
                        self.heCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"22";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 5;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"闲对"]){
                        self.heCount+=1;
                        self.xianDuiCount+=1;
                        img = @"21";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 5;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }
                }else if (resultList.count==3){
                    if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"闲对"]) {
                        self.zhuangDuiCount+=1;
                        self.zhuangCount+=1;
                        self.xianDuiCount+=1;
                        img = @"4";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 6;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"6点赢"]){
                        self.zhuangDuiCount+=1;
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"2";
                        text = @"6";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"6点赢"]){
                        self.xianDuiCount+=1;
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"3";
                        text = @"6";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"庄对"]){
                        self.xianDuiCount+=1;
                        self.zhuangDuiCount+=1;
                        self.xianCount+=1;
                        img = @"8";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"庄对"]){
                        self.xianDuiCount+=1;
                        self.zhuangDuiCount+=1;
                        self.heCount+=1;
                        img = @"23";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }
                }else if (resultList.count==4){
                     if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"6点赢"]){
                         self.zhuangDuiCount+=1;
                         self.zhuangCount+=1;
                         self.xianDuiCount+=1;
                         self.sixCount+=1;
                         img = @"4";
                         text = @"6";
                         JhPageItemModel *model = [[JhPageItemModel alloc]init];
                         model.img = img;
                         model.text = text;
                         model.luzhuType = 6;
                         model.colorString = @"#ffffff";
                         [luzhuList addObject:model];
                     }
                }
            }];
            int normalInt = 0;
            if (list&&list.count!=0) {
                normalInt = (int)list.count;
            }
            for (int i=normalInt; i<100; i++) {
                NSString *text = @"";
                NSString *img = @"";
                JhPageItemModel *model = [[JhPageItemModel alloc]init];
                model.img = img;
                model.text = text;
                model.luzhuType = 0;
                model.colorString = @"#ffffff";
                [luzhuList addObject:model];
            }
            self.luzhuInfoList = luzhuList;
        }
        block(suc, msg,error);
        
    }];
}

#pragma mark - 打散筹码
- (void)changeChipWashNumberWithChipList:(NSArray *)chipList WashNumber:(NSString *)washNumber ChangChipList:(NSArray *)changeChipList Block:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
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
        block(suc, msg,error);
        
    }];
}


#pragma mark - 提交日结
- (void)commitDailyWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSArray *chipList = [NSArray array];
    if (self.curupdateInfo.cp_xiaofeiList.count!=0) {
        chipList = self.curupdateInfo.cp_xiaofeiList;
    }
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"ftable_id":self.curTableInfo.fid,//桌子ID
                             @"frjdate":[NRCommand getCurrentDate],//日期
                             @"femp_num":self.curupdateInfo.femp_num,//管理员登录账号
                             @"femp_pwd":self.curupdateInfo.femp_pwd,//登录密码
                             @"fhg_id":self.curupdateInfo.fhg_id//荷官ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"tablerec_rijie",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            self.cp_fidString = @"";
        }
        block(suc, msg,error);
        
    }];
}

#pragma mark - 验证账号
- (void)authorizationAccountWitAccountName:(NSString *)accountName Password:(NSString *)password Block:(EPFeedbackWithErrorCodeBlock)block{
    NSArray *chipList = [NSArray array];
    if (self.curupdateInfo.cp_xiaofeiList.count!=0) {
        chipList = self.curupdateInfo.cp_xiaofeiList;
    }
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"femp_num":accountName,
                             @"femp_pwd":password
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"employee_chkadmin",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            self.cp_fidString = @"";
        }
        block(suc, msg,error);
    }];
}

#pragma mark - 查看台面数据
- (void)queryTableDataWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"ftable_id":self.curTableInfo.fid,//桌子ID
                             @"fxueci":[NSString stringWithFormat:@"%d",self.curXueci],
                             @"frjdate":[NRCommand getCurrentDate],//日期
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"table_tmsj",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        self.tableDataDict = responseDict;
        block(suc, msg,error);
    }];
}

#pragma mark - 台面操作记录列表
- (void)queryOperate_listWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"ftable_id":self.curTableInfo.fid//桌子ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"table_operate_list",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

@end
