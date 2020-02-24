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

@implementation NRTableChooseViewModel

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo{
    self = [super init];
    self.loginInfo = loginInfo;
    self.tableList = [NSMutableArray arrayWithCapacity:0];
    self.chipFmeList = [NSMutableArray arrayWithCapacity:0];
    return self;
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

- (NRBaccaratViewModel *)baccaratViewModelWithLoginInfo:(NRLoginInfo*)loginInfo{
    NRBaccaratViewModel *viewModel = [[NRBaccaratViewModel alloc]initWithLoginInfo:self.loginInfo WithTableInfo:self.selectTableInfo WithNRGameInfo:self.gameInfo];
    return viewModel;
}

- (NRBaccarat_workersViewModel *)baccarat_workersViewModelWithLoginInfo:(NRLoginInfo*)loginInfo;{
    NRBaccarat_workersViewModel *viewModel = [[NRBaccarat_workersViewModel alloc]initWithLoginInfo:self.loginInfo WithTableInfo:self.selectTableInfo WithNRGameInfo:self.gameInfo];
    return viewModel;
}

- (NRTigerViewModel *)tigerViewModelWithLoginInfo:(NRLoginInfo*)loginInfo{
    NRTigerViewModel *viewModel = [[NRTigerViewModel alloc]initWithLoginInfo:self.loginInfo WithTableInfo:self.selectTableInfo WithNRGameInfo:self.gameInfo];
    return viewModel;
}

- (NRCowViewModel *)cowViewModelWithLoginInfo:(NRLoginInfo*)loginInfo{
    NRCowViewModel *viewModel = [[NRCowViewModel alloc]initWithLoginInfo:self.loginInfo WithTableInfo:self.selectTableInfo WithNRGameInfo:self.gameInfo];
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
