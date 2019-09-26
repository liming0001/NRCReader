//
//  NRBaccaratViewModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "RVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class NRLoginInfo,NRTableInfo,NRUpdateInfo,NRGameInfo;
@interface NRBaccarat_workersViewModel : RVMViewModel

@property (nonatomic, strong) NSString *cp_fidString;
@property (nonatomic, strong) NRLoginInfo *loginInfo;
@property (nonatomic, strong) NRTableInfo *curTableInfo;
@property (nonatomic, strong) NRUpdateInfo *curupdateInfo;
@property (nonatomic, strong) NRGameInfo *gameInfo;
@property (nonatomic, strong) NSString *cp_tableIDString;
@property (nonatomic, strong) NSArray *luzhuUpList;
@property (nonatomic, strong) NSArray *luzhuDownList;

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo WithTableInfo:(NRTableInfo*)tableInfo WithNRGameInfo:(NRGameInfo *)gameInfo;

#pragma mark - 换桌
- (void)otherTableWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 提交客人输赢记录和台桌流水记录
- (void)commitCustomerRecordWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 提交开牌结果
- (void)commitkpResultWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 提交小费
- (void)commitTipResultWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 获取露珠
- (void)getLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 清空露珠
- (void)clearLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 提交日结
- (void)commitDailyWithBlock:(EPFeedbackWithErrorCodeBlock)block;

#pragma mark - 检测筹码是否正确
- (void)checkChipIsTrueWithChipList:(NSArray *)chipList Block:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 验证账号
- (void)authorizationAccountWitAccountName:(NSString *)accountName Password:(NSString *)password Block:(EPFeedbackWithErrorCodeBlock)block;

@end

NS_ASSUME_NONNULL_END
