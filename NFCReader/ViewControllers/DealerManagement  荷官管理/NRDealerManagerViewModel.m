//
//  NRDealerManagerViewModel.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/18.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRDealerManagerViewModel.h"
#import "NRLoginInfo.h"
#import "NRChipInfo.h"
#import "NRChipAllInfo.h"
#import "NRChipInfoModel.h"

@implementation NRDealerManagerViewModel

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo{
    self = [super init];
    self.loginInfo = loginInfo;
    self.chipModel = [[NRChipInfoModel alloc]init];
    return self;
}

#pragma mark - 发行筹码
- (void)IssueChipsWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fbatch":self.chipModel.chipBatch,
                             @"forder":self.chipModel.chipSerialNumber,
                             @"fcmtype":self.chipModel.chipType,
                             @"fme":self.chipModel.chipDenomination,
                             @"fhardlist":self.chipModel.chipsUIDs
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmpublish_publish",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

#pragma mark - 检测筹码
- (void)Cmpublish_checkStateWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fhardlist":self.chipModel.chipsUIDs
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmpublish_checkState",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        self.checkChipDict = responseDict;
        block(suc, msg,error);
    }];
}

#pragma mark - 根据批次号获取最新批次序号
- (void)getOrderByBatchWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fbatch":self.chipModel.chipBatch
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmpublish_getOrderByBatch",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

#pragma mark - 现金兑换筹码
- (void)CashExchangeChipWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSString *notes = [PublicHttpTool shareInstance].notes;
    if (notes.length==0) {
        notes = @"0";
    }
    NSDictionary * param = @{
        @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fxmh":[PublicHttpTool shareInstance].exchangeWashNumber,
                             @"fcredit":@"0",
                             @"fsq_name":[[PublicHttpTool shareInstance].authorName NullToBlankString],
                             @"fdesc":notes,
                             @"fhardlist":self.chipModel.chipsUIDs
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmpublish_cmChangeOut",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

#pragma mark - 筹码兑换现金
- (void)ChipExchangeCashWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fxmh":[PublicHttpTool shareInstance].exchangeWashNumber,
                             @"fhardlist":self.chipModel.chipsUIDs
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmpublish_cmChangeIn",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

#pragma mark - 小费结算
- (void)TipSettlementWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fhard_list":self.chipModel.chipsUIDs
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_tipSettle",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

#pragma mark - 存取筹码
- (void)AccessChipWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                            @"access_token":[PublicHttpTool shareInstance].access_token,
                            @"fxmh":[PublicHttpTool shareInstance].exchangeWashNumber,
                            @"fmoney":[PublicHttpTool shareInstance].userAllMoney,
                            @"fhardlist":self.chipModel.chipsUIDs
    };
    NSMutableDictionary *m_param = [NSMutableDictionary dictionaryWithDictionary:param];
    if ([[PublicHttpTool shareInstance].userAllMoney intValue]<0) {
        [m_param setObject:[PublicHttpTool shareInstance].takeOutPsd forKey:@"fpassword"];
    }
    NSArray *paramList = @[m_param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmpublish_depositWithdraw",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

#pragma mark - 筹码销毁
- (void)cmDestoryWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fhardlist":self.chipModel.chipsUIDs
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmpublish_cmDestory",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

@end
