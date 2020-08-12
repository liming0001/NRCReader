//
//  NRTableChooseViewModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "RVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class NRBaccaratViewModel,NRDealerManagerViewModel,NRLoginInfo,NRTigerViewModel,NRCowViewModel,NRTableInfo,NRGameInfo,NRBaccarat_workersViewModel,NRThreeFairsViewModel;
@interface NRTableChooseViewModel : RVMViewModel

@property (nonatomic, strong) NSMutableArray *tableList;
@property (nonatomic, strong) NRLoginInfo *loginInfo;
@property (nonatomic, strong) NRTableInfo *selectTableInfo;
@property (nonatomic, strong) NRGameInfo *gameInfo;
@property (nonatomic, strong) NSString  *tableRijieDate;
@property (nonatomic, strong) NSMutableArray *chipFmeList;//筹码面额

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo;

#pragma mark - 用户退出登录
- (void)employee_logoutplusWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 获取台桌列表数据
- (void)tableListWithBlock:(EPFeedbackWithErrorCodeBlock)block;
- (void)getChipTypeWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 选桌
- (void)chooseTableWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 获取当前台桌日结日期
- (void)Tablerec_getRjdateWithBlock:(EPFeedbackWithErrorCodeBlock)block;
- (NRBaccaratViewModel *)baccaratViewModel;
- (NRTigerViewModel *)tigerViewModel;
- (NRCowViewModel *)cowViewModel;
- (NRBaccarat_workersViewModel *)baccarat_workersViewModel;
- (NRThreeFairsViewModel *)ThreeFairsViewModel;

@end

NS_ASSUME_NONNULL_END
