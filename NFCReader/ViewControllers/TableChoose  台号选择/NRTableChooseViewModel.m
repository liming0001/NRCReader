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

@implementation NRTableChooseViewModel

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo{
    self = [super init];
    self.loginInfo = loginInfo;
    self.tableList = [NSMutableArray arrayWithCapacity:0];
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

- (NRBaccaratViewModel *)baccaratViewModelWithLoginInfo:(NRLoginInfo*)loginInfo{
    NRBaccaratViewModel *viewModel = [[NRBaccaratViewModel alloc]initWithLoginInfo:self.loginInfo WithTableInfo:self.selectTableInfo WithNRGameInfo:self.gameInfo];
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

@end
