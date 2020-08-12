//
//  NRTableChooseViewModel.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRTableChooseViewModel.h"
#import "NRBaccaratViewModel.h"
#import "NRLoginInfo.h"
#import "NRTigerViewModel.h"
#import "NRCowViewModel.h"
#import "NRTableInfo.h"
#import "NRGameInfo.h"
#import "NRBaccarat_workersViewModel.h"
#import "NRChipInfo.h"
#import "NRChipAllInfo.h"
#import "NRThreeFairsViewModel.h"

@implementation NRTableChooseViewModel

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo{
    self = [super init];
    self.loginInfo = loginInfo;
    self.tableRijieDate = [NRCommand getCurrentDate];
    self.tableList = [NSMutableArray arrayWithCapacity:0];
    self.chipFmeList = [NSMutableArray arrayWithCapacity:0];
    return self;
}

#pragma mark - 用户退出登录
- (void)employee_logoutplusWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                            @"access_token":self.loginInfo.access_token,
                             @"femp_num":self.loginInfo.femp_num
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"employee_logoutplus",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

#pragma mark - 获取台桌列表数据
- (void)tableListWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"limit":@"100",
                             @"page":@"1"
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Table_all",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        [self.tableList removeAllObjects];
        NSArray *list = [NSArray yy_modelArrayWithClass:[NRTableInfo class] json:responseDict[@"data"]];
        [self.tableList addObjectsFromArray:list];
        block(suc, msg,error);
        
    }];
}

#pragma mark - 选桌
- (void)chooseTableWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"fid":self.selectTableInfo.fid,//台桌ID
                             @"fcurxgid":self.loginInfo.fid,//荷官ID
                             @"fcurhgxm":self.loginInfo.femp_xm//荷官姓名
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Table_xuanzhuo",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            self.gameInfo = [NRGameInfo yy_modelWithDictionary:responseDict];
            [PublicHttpTool shareInstance].curXz_setting = self.gameInfo.xz_setting;
        }
        block(suc, msg,error);
    }];
}

#pragma mark - 获取当前台桌日结日期
- (void)Tablerec_getRjdateWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token,
                             @"table_id":self.selectTableInfo.fid//台桌ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_getRjdate",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            self.tableRijieDate = responseDict[@"frjdate"];
            [PublicHttpTool shareInstance].cp_tableRijieDate = self.tableRijieDate;
        }
        block(suc, msg,error);
    }];
}

- (void)getChipTypeWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.loginInfo.access_token
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
            [self.chipFmeList removeAllObjects];
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
                [self.chipFmeList addObject:allInfo];
            }];
        }
        block(suc, msg,error);
    }];
}

- (NRBaccaratViewModel *)baccaratViewModel{
    NRBaccaratViewModel *viewModel = [[NRBaccaratViewModel alloc]init];
    return viewModel;
}

- (NRBaccarat_workersViewModel *)baccarat_workersViewModel{
    NRBaccarat_workersViewModel *viewModel = [[NRBaccarat_workersViewModel alloc]init];
    return viewModel;
}

- (NRTigerViewModel *)tigerViewModel{
    NRTigerViewModel *viewModel = [[NRTigerViewModel alloc]init];
    return viewModel;
}

- (NRCowViewModel *)cowViewModel{
    NRCowViewModel *viewModel = [[NRCowViewModel alloc]init];
    return viewModel;
}

- (NRThreeFairsViewModel *)ThreeFairsViewModel{
    NRThreeFairsViewModel *viewModel = [[NRThreeFairsViewModel alloc]init];
    return viewModel;
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
