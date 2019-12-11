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
@property (nonatomic, strong) NSArray *luzhuInfoList;
@property (nonatomic, strong) NSArray *realLuzhuList;
@property (nonatomic, assign) int curXueci;
@property (nonatomic, strong) NSDictionary *tableDataDict;
@property (nonatomic, assign) int zhuangCount;//庄赢次数
@property (nonatomic, assign) int zhuangDuiCount;//庄对赢次数
@property (nonatomic, assign) int sixCount;//6点赢次数
@property (nonatomic, assign) int xianCount;//闲赢次数
@property (nonatomic, assign) int xianDuiCount;//闲对赢次数
@property (nonatomic, assign) int heCount;//和赢次数
@property (nonatomic, strong) NSDictionary *lastTableInfoDict;

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo WithTableInfo:(NRTableInfo*)tableInfo WithNRGameInfo:(NRGameInfo *)gameInfo;

#pragma mark - 换桌
- (void)otherTableWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 提交客人输赢记录和台桌流水记录
- (void)commitCustomerRecordWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 提交客人输赢记录和台桌流水记录(杀注)
- (void)commitCustomerRecord_ShaZhuWithWashNumberList:(NSArray *)washNumberArray Block:(EPFeedbackWithErrorCodeBlock)block;
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
#pragma mark - 查看台面数据
- (void)queryTableDataWithBlock:(EPFeedbackWithErrorCodeBlock)block;

#pragma mark - 台面操作记录列表
- (void)queryOperate_listWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 修改客人洗码号
- (void)updateCustomerWashNumberWithChipList:(NSArray *)chipList CurWashNumber:(NSString *)washNumber AdminName:(NSString *)adminName Block:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 获取当前台桌的靴次
- (void)getLastXueCiInfoWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 打散筹码
- (void)changeChipWashNumberWithChipList:(NSArray *)chipList WashNumber:(NSString *)washNumber ChangChipList:(NSArray *)changeChipList Block:(EPFeedbackWithErrorCodeBlock)block;

@end

NS_ASSUME_NONNULL_END
