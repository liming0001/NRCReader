//
//  NRDealerManagerViewModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/18.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "RVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class NRLoginInfo,NRChipInfoModel;
@interface NRDealerManagerViewModel : RVMViewModel

@property (nonatomic, strong) NRLoginInfo *chipInfo;
@property (nonatomic, strong) NRChipInfoModel *chipModel;
@property (nonatomic, strong) NSMutableArray *chipInfoList;
@property (nonatomic, strong) NSString *customName;
@property (nonatomic, strong) NSString *lastNumber;
@property (nonatomic, strong) NSDictionary *checkChipDict;

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo;

- (void)getChipTypeWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 发行筹码
- (void)IssueChipsWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 根据批次号获取最新批次序号
- (void)getOrderByBatchWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 现金兑换筹码
- (void)CashExchangeChipWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 筹码兑换现金
- (void)ChipExchangeCashWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 根据洗码号获取用户信息
- (void)getInfoByXmhWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 筹码销毁
- (void)cmDestoryWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 检测筹码
- (void)Cmpublish_checkStateWithBlock:(EPFeedbackWithErrorCodeBlock)block;

@end

NS_ASSUME_NONNULL_END
