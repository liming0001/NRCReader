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
    
    self.chipInfo = loginInfo;
    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    return self;
}

- (void)getChipTypeWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.chipInfo.access_token
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmtypeme_getAllMe",
                                 @"p":[paramList JSONString]
                                 };
    @weakify(self);
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        @strongify(self);
        if (suc) {
            [self.chipInfoList removeAllObjects];
            NSArray *list = [NSArray yy_modelArrayWithClass:[NRChipInfo class] json:responseDict];
            NSArray *sortList = [self shaiXuanWithList:list];
            
            [sortList enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                NRChipAllInfo *allInfo = [[NRChipAllInfo alloc]init];
                if (infoList.count!=0) {
                    NRChipInfo *info = infoList.firstObject;
                    allInfo.fcmtype = info.fcmtype;
                    allInfo.fcmtype_name = info.fcmtype_name;
                }
                allInfo.list = infoList;
                [self.chipInfoList addObject:allInfo];
            }];
            DLOG(@"self.chipInfoList = %@",self.chipInfoList);
        }
        block(suc, msg,error);
    }];
}

#pragma mark - 发行筹码
- (void)IssueChipsWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    self.chipModel.chipSerialNumber = @"01";
    NSDictionary * param = @{
                             @"access_token":self.chipInfo.access_token,
                             @"fbatch":self.chipModel.chipBatch,
                             @"forder":self.chipModel.chipSerialNumber,
                             @"fcmtype":self.chipModel.chipType,
                             @"fme":self.chipModel.chipDenomination,
                             @"fhardlist":self.chipInfo.chipsUIDs
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
    self.chipModel.chipSerialNumber = @"01";
    NSDictionary * param = @{
                             @"access_token":self.chipInfo.access_token,
                             @"fhardlist":self.chipInfo.chipsUIDs
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
                             @"access_token":self.chipInfo.access_token,
                             @"fbatch":self.chipModel.chipBatch
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmpublish_getOrderByBatch",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            self.lastNumber = responseString;
        }
        block(suc, msg,error);
    }];
}

#pragma mark - 现金兑换筹码
- (void)CashExchangeChipWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.chipInfo.access_token,
                             @"fxmh":self.chipModel.guestWashesNumber,
                             @"fcredit":self.chipModel.fcredit,
                             @"fsq_name":self.chipModel.authorName,
                             @"fdesc":self.chipModel.notes,
                             @"fhardlist":self.chipInfo.chipsUIDs
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
                             @"access_token":self.chipInfo.access_token,
                             @"fxmh":self.chipModel.guestWashesNumber,
                             @"fhardlist":self.chipInfo.chipsUIDs
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

#pragma mark - 根据洗码号获取用户信息
- (void)getInfoByXmhWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.chipInfo.access_token,
                             @"fxmh":self.chipModel.guestWashesNumber
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Customer_getInfoByXmh",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            if (responseDict&&responseDict.count>0) {
                NSString *fxm_s = responseDict[@"fxm"];
                self.customName = fxm_s;
            }
        }
        block(suc, msg,error);
    }];
}

#pragma mark - 筹码销毁
- (void)cmDestoryWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.chipInfo.access_token,
                             @"fhardlist":self.chipInfo.chipsUIDs
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

- (NSArray *)shaiXuanWithList:(NSArray *)list{
    NSMutableArray *array = [NSMutableArray arrayWithArray:list];
    NSMutableArray *dateMutablearray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i ++) {
        
        NRChipInfo *chipInfo = array[i];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        
        [tempArray addObject:chipInfo];
        
        for (int j = i+1; j < array.count; j ++) {
            
            NRChipInfo *jChipInfo = array[j];
            
            if([chipInfo.fcmtype isEqualToString:jChipInfo.fcmtype]){
                
                [tempArray addObject:jChipInfo];
                [array removeObjectAtIndex:j];
                j -= 1;
                
            }
            
        }
        
        [dateMutablearray addObject:tempArray];
        
    }
    return dateMutablearray;
}

@end
