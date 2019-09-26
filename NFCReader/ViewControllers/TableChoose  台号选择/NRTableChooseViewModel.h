//
//  NRTableChooseViewModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "RVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class NRBaccaratViewModel,NRDealerManagerViewModel,NRLoginInfo,NRTigerViewModel,NRCowViewModel,NRTableInfo,NRGameInfo,NRBaccarat_workersViewModel;
@interface NRTableChooseViewModel : RVMViewModel

@property (nonatomic, strong) NSMutableArray *tableList;
@property (nonatomic, strong) NRLoginInfo *loginInfo;
@property (nonatomic, strong) NRTableInfo *selectTableInfo;
@property (nonatomic, strong) NRGameInfo *gameInfo;

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo;

#pragma mark - 获取台桌列表数据
- (void)tableListWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 选桌
- (void)chooseTableWithBlock:(EPFeedbackWithErrorCodeBlock)block;
- (NRBaccaratViewModel *)baccaratViewModelWithLoginInfo:(NRLoginInfo*)loginInfo;
- (NRTigerViewModel *)tigerViewModelWithLoginInfo:(NRLoginInfo*)loginInfo;
- (NRCowViewModel *)cowViewModelWithLoginInfo:(NRLoginInfo*)loginInfo;
- (NRBaccarat_workersViewModel *)baccarat_workersViewModelWithLoginInfo:(NRLoginInfo*)loginInfo;


@end

NS_ASSUME_NONNULL_END
