//
//  NRCowViewModel.m
//  NFCReader
//
//  Created by 李黎明 on 2019/5/8.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRCowViewModel.h"
#import "NRLoginInfo.h"
#import "NRTableInfo.h"
#import "NRUpdateInfo.h"
#import "NRGameInfo.h"

@implementation NRCowViewModel

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo WithTableInfo:(NRTableInfo*)tableInfo WithNRGameInfo:(NRGameInfo *)gameInfo{
    self = [super init];
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
                             @"ftbrec_id":self.curTableInfo.fid,//桌子ID
                             @"ftable_id":self.curTableInfo.fid,//桌子ID
                             @"fxueci":self.curupdateInfo.cp_xueci,//靴次
                             @"fpuci":self.curupdateInfo.cp_puci,//铺次
                             @"frjdate":[NRCommand getCurrentDate],//日期
                             @"fkpresult":@"",//结果
                             @"fpcls":[self.curupdateInfo.cp_Serialnumber NullToBlankString],//铺次流水号，长度不超过20位，要求全局唯一
                             @"fxmh":[self.curupdateInfo.cp_washNumber NullToBlankString],//客人洗码号
                             @"fxz_cmtype":[self.curupdateInfo.cp_chipType NullToBlankString],//客人下注的筹码类型
                             @"fxz_money":[self.curupdateInfo.cp_benjin NullToBlankString],//客人下注的本金
                             @"fxz_name":[self.curupdateInfo.cp_name NullToBlankString],//下注名称，如庄、闲、庄对子…
                             @"fbeishu":[self.curupdateInfo.cp_beishu NullToBlankString],//倍数，如果杀注50%填0.5
                             @"fdianshu":self.curupdateInfo.cp_dianshu,//牛牛点数，非牛牛游戏传0
                             @"fsy":[self.curupdateInfo.cp_result NullToBlankString],//判断客人的输赢：1为赢，-1为输，0为不杀不赔
                             @"fxf":self.curupdateInfo.cp_result,//判断客人的输赢：1为赢，-1为输，0为不杀不赔
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

#pragma mark - 提交小费
- (void)commitTipResultWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSArray *chipList = [NSArray array];
    if (self.curupdateInfo.cp_xiaofeiList.count!=0) {
        chipList = self.curupdateInfo.cp_xiaofeiList;
    }
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"fhardlist":chipList,//实付筹码，硬件ID值数组
                             @"fid":[self.cp_fidString NullToBlankString]//结果
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

@end
