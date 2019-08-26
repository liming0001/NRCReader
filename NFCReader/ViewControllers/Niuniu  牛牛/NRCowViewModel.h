//
//  NRCowViewModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/5/8.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "RVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class NRLoginInfo,NRTableInfo,NRUpdateInfo,NRGameInfo;
@interface NRCowViewModel : RVMViewModel

@property (nonatomic, strong) NSString *cp_fidString;
@property (nonatomic, strong) NRLoginInfo *loginInfo;
@property (nonatomic, strong) NRTableInfo *curTableInfo;
@property (nonatomic, strong) NRUpdateInfo *curupdateInfo;
@property (nonatomic, strong) NRGameInfo *gameInfo;
@property (nonatomic, strong) NSString *cp_tableIDString;

- (instancetype)initWithLoginInfo:(NRLoginInfo *)loginInfo WithTableInfo:(NRTableInfo*)tableInfo WithNRGameInfo:(NRGameInfo *)gameInfo;

#pragma mark - 换桌
- (void)otherTableWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 提交客人输赢记录和台桌流水记录
- (void)commitCustomerRecordWithBlock:(EPFeedbackWithErrorCodeBlock)block;
#pragma mark - 提交小费
- (void)commitTipResultWithBlock:(EPFeedbackWithErrorCodeBlock)block;

#pragma mark - 检测筹码是否正确
- (void)checkChipIsTrueWithChipList:(NSArray *)chipList Block:(EPFeedbackWithErrorCodeBlock)block;
@end

NS_ASSUME_NONNULL_END
